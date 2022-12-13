import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/add_message_to_conversation/add_image_message_to_conversation_cubit.dart';
import '../../bloc/add_message_to_conversation/add_image_message_to_conversation_state.dart';
import '../edit_post/post_images.dart';

class ImageMessageSendingPreview extends StatefulWidget {
  final dynamic initiallyPickedFiles;
  final Function onSendButtonClicked;
  final Function onMessageSendIsSuccessfull;
  const ImageMessageSendingPreview({
    Key? key,
    required this.initiallyPickedFiles,
    required this.onSendButtonClicked,
    required this.onMessageSendIsSuccessfull,
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
              Text(
                AppLocalizations.of(context)
                    .commonImageSendingPreviewPickedFiles,
                style: const TextStyle(
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
                    child: Text(
                      AppLocalizations.of(context)
                          .commonImageSendingPreviewAddButton,
                    ),
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
                        child: Text(AppLocalizations.of(context)
                            .commonImageSendingPreviewCloseButton),
                        onPressed: () => Navigator.pop(context),
                      ),
                      BlocBuilder<AddImageMessageToConversationCubit,
                              AddImageMessageToConversationState>(
                          builder: (context, state) {
                        if (state is AddImageMessageToConversationSuccessfull) {
                          SchedulerBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            widget.onMessageSendIsSuccessfull();
                            Navigator.pop(context);
                          });
                        } else if (state
                            is AddImageMessageToConversationError) {
                          SchedulerBinding.instance
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
                          child: Text(
                            AppLocalizations.of(context)
                                .commonImageSendingPreviewSendButton,
                          ),
                          onPressed: () => widget.onSendButtonClicked(),
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
