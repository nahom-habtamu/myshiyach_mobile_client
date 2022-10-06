import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/date_time_formatter.dart';
import '../../data/models/conversation/message_model.dart';
import '../../domain/enitites/conversation.dart';
import '../../domain/enitites/message.dart';
import '../../domain/enitites/user.dart';
import '../bloc/add_message_to_conversation/add_image_message_to_conversation_cubit.dart';
import '../bloc/add_message_to_conversation/add_image_message_to_conversation_state.dart';
import '../bloc/add_message_to_conversation/add_text_message_to_conversation_cubit.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../bloc/mark_messages_as_read/mark_messages_as_read_cubit.dart';
import '../screen_arguments/chat_detail_page_arguments.dart';
import '../widgets/chat_detail/image_container_bubble.dart';
import '../widgets/chat_detail/message_bubble.dart';
import '../widgets/chat_detail/message_sending_tab.dart';
import '../widgets/chat_detail/stanger_user_info.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/edit_post/post_images.dart';

class ChatDetailPage extends StatefulWidget {
  static String routeName = '/chatDetailPage';
  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  User? currentUser;
  String messageContent = "";
  ChatDetailPageArguments? args;
  List<dynamic> pickedFiles = [];
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      args =
          ModalRoute.of(context)!.settings.arguments as ChatDetailPageArguments;
      initializeCurrentUser();
      markAllMessagesAsRead(args!.conversationId);
    });
  }

  void initializeCurrentUser() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      currentUser = authState.currentUser;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).chatDetailAppBarText,
      ),
      body: BlocBuilder<GetConversationByIdCubit, Stream<Conversation>>(
        builder: (context, conversationStream) {
          return buildChatDetail(conversationStream);
        },
      ),
    );
  }

  Widget buildChatDetail(Stream<Conversation> conversationStream) {
    return StreamBuilder<Conversation>(
      stream: conversationStream,
      builder: (BuildContext context, AsyncSnapshot<Conversation> snapshot) {
        if (snapshot.hasError) {
          return Text(AppLocalizations.of(context).chatDetailFetchError);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
          markAllMessagesAsRead(args!.conversationId);
        });

        return renderMainContent(snapshot.data!);
      },
    );
  }

  void markAllMessagesAsRead(String conversationId) {
    context
        .read<MarkMessagesAsReadCubit>()
        .call(currentUser!.id, conversationId);
  }

  renderMainContent(Conversation conversation) {
    return CurvedContainer(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: Column(
        children: [
          renderChatDetailStrangerInfo(),
          Container(
            height: 1,
            color: Colors.black12,
          ),
          renderMessageBubblesAlongWithCreatedDate(conversation),
          renderMessageSendingTab(conversation)
        ],
      ),
    );
  }

  bool compareMessageSentDate(String uniqueDate, String messageCreatedDate) {
    return DateFormatterUtil.compareDates(uniqueDate, messageCreatedDate);
  }

  renderMessageBubblesAlongWithCreatedDate(Conversation conversation) {
    var uniqueDates = buildUniqueDateFromMessages(conversation);
    var generatedWidgets = List<ListTile>.generate(
      uniqueDates.length,
      (index) {
        var messagesWithCurrentDate = conversation.messages
            .where(
              (m) => compareMessageSentDate(uniqueDates[index],
                  DateFormatterUtil.extractDateFromDateTime(m.createdDateTime)),
            )
            .toList();
        return ListTile(
          title: Container(
            height: 23,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              DateFormatterUtil.formatUniqueMessageCreatedDate(
                  uniqueDates[index]),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          subtitle: renderMessageBubbles(messagesWithCurrentDate),
        );
      },
    );

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemBuilder: ((context, index) => generatedWidgets[index]),
        itemCount: generatedWidgets.length,
      ),
    );
  }

  List<String> buildUniqueDateFromMessages(Conversation conversation) {
    return conversation.messages
        .map(
            (e) => DateFormatterUtil.extractDateFromDateTime(e.createdDateTime))
        .toSet()
        .toList();
  }

  renderMessageSendingTab(Conversation conversation) {
    return MessageSendingTab(
      onMessageChanged: (value) => setState(() => messageContent = value),
      onMessageSend: () => handleAddingTextMessage(),
      onFilePickerClicked: () async {
        dynamic pickedImages = await pickImages();
        if (pickedImages != null) {
          setState(() => pickedFiles = pickedImages!);
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return showFileSendingPreview();
            },
          );
        }
      },
    );
  }

  dynamic pickImages() async {
    var pickedImages = await _picker.pickMultiImage(
      maxHeight: 480,
      maxWidth: 600,
      imageQuality: 60,
    );
    return pickedImages;
  }

  showFileSendingPreview() {
    return ImageMessageSendingPreview(
      initiallyPickedFiles: pickedFiles,
      onMessageSend: () => handleAddingImageMessage(),
    );
  }

  void handleAddingTextMessage() async {
    if (messageContent.isNotEmpty) {
      var messageToAdd = MessageModel(
        content: messageContent,
        senderId: currentUser!.id,
        recieverId: args!.strangerUser.id,
        createdDateTime: DateTime.now().toIso8601String(),
        isSeen: false,
        type: "TEXT_MESSAGE",
      );
      context
          .read<AddTextMessageToConversationCubit>()
          .call(args!.conversationId, messageToAdd);
      await handleScrollingToBottom();
    }
  }

  void handleAddingImageMessage() async {
    if (pickedFiles.isNotEmpty) {
      List<MessageModel> fileMessagesToSend = [];

      for (var i = 0; i < pickedFiles.length; i++) {
        var messageToAdd = MessageModel(
          content: '',
          senderId: currentUser!.id,
          recieverId: args!.strangerUser.id,
          createdDateTime: DateTime.now().toIso8601String(),
          isSeen: false,
          type: "IMAGE",
        );
        fileMessagesToSend.add(messageToAdd);
      }
      context.read<AddImageMessageToConversationCubit>().call(
            args!.conversationId,
            fileMessagesToSend,
            pickedFiles,
          );
      await handleScrollingToBottom();
    }
  }

  Future<void> handleScrollingToBottom() async {
    await Future.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  renderChatDetailStrangerInfo() {
    return StrangerUserInfo(strangerUser: args!.strangerUser);
  }

  renderMessageBubbles(List<Message> messages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (messages[index].type == "IMAGE") {
            return ImageMessageContainer(
              message: messages[index],
              strangerId: args!.strangerUser.id,
              isSentByCurrentUser:
                  messages[index].senderId == args!.strangerUser.id,
            );
          } else {
            return MessageBubble(
              message: messages[index],
              strangerId: args!.strangerUser.id,
              isSentByCurrentUser:
                  messages[index].senderId == args!.strangerUser.id,
            );
          }
        },
        itemCount: messages.length,
      ),
    );
  }
}

class ImageMessageSendingPreview extends StatefulWidget {
  final dynamic initiallyPickedFiles;
  final Function onMessageSend;
  const ImageMessageSendingPreview({
    Key? key,
    required this.initiallyPickedFiles,
    required this.onMessageSend,
  }) : super(key: key);

  @override
  State<ImageMessageSendingPreview> createState() =>
      _ImageMessageSendingPreviewState();
}

class _ImageMessageSendingPreviewState
    extends State<ImageMessageSendingPreview> {
  dynamic pickedFiles = [];

  @override
  void initState() {
    super.initState();
    pickedFiles = [...widget.initiallyPickedFiles];
  }

  dynamic pickImages() async {
    var pickedImages = await ImagePicker().pickMultiImage(
      maxHeight: 480,
      maxWidth: 600,
      imageQuality: 60,
    );
    return pickedImages;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Picked Files',
                style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 25),
              PostImages(
                pickedImages: pickedFiles,
                imagesAlreadyInProduct: const [],
                onStateChange: (updatedPostImages, updatedPickedImages) {
                  setState(() {
                    pickedFiles = [...updatedPickedImages];
                  });
                },
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: const Text('Add'),
                    onPressed: () async {
                      var pickedImages = await pickImages();
                      if (pickedImages != null) {
                        setState(() {
                          pickedFiles = [...pickedFiles, ...pickedImages];
                        });
                      }
                    },
                  ),
                  Row(
                    children: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      BlocBuilder<AddImageMessageToConversationCubit,
                              AddImageMessageToConversationState>(
                          builder: (context, state) {
                        if (state is AddImageMessageToConversationSuccessfull) {
                          SchedulerBinding.instance!
                              .addPostFrameCallback((timeStamp) {
                            Navigator.pop(context);
                          });
                        } else if (state
                            is AddImageMessageToConversationError) {
                          SchedulerBinding.instance!
                              .addPostFrameCallback((timeStamp) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  state.message,
                                ),
                              ),
                            );
                          });
                        } else if (state
                            is AddImageMessageToConversationLoading) {
                          return const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return TextButton(
                          child: const Text('Send Files'),
                          onPressed: () => widget.onMessageSend(),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
