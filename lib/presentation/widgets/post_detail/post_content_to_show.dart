import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/enitites/product.dart';
import '../../../domain/enitites/user.dart';
import '../../bloc/get_products_by_category/get_products_by_category_cubit.dart';
import '../../bloc/get_products_by_category/get_products_by_category_state.dart';
import '../../pages/posts_created_by_user_page.dart';
import '../common/post_card_list_item.dart';
import 'detail_item.dart';
import 'post_detail_carousel.dart';
import 'save_to_favorite_button.dart';
import 'send_message_button.dart';

class PostContentToShow extends StatefulWidget {
  final Product product;
  final User currentUser;
  final User? postCreator;
  final String authToken;
  final Function handleSaveToFavorite;
  final bool isFavorite;
  const PostContentToShow({
    Key? key,
    required this.product,
    required this.currentUser,
    required this.authToken,
    required this.postCreator,
    required this.handleSaveToFavorite,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<PostContentToShow> createState() => _PostContentToShowState();
}

class _PostContentToShowState extends State<PostContentToShow> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<GetProductsByCategoryCubit>().call(
            widget.product.mainCategory,
            widget.product.subCategory,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostDetailCarousel(
          items: [...widget.product.productImages],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                renderContentOtherThanDescription(context),
                const SizedBox(height: 15),
                renderDescription(context),
                const SizedBox(height: 15),
                renderPostDetailButtonSection(),
                const SizedBox(height: 35),
                renderRecommendedProducts(),
              ],
            ),
          ),
        )
      ],
    );
  }

  onDetailItemClicked(context) {
    Navigator.of(context).pushNamed(
      PostsCreatedByUserPage.routeName,
      arguments: widget.product.createdBy,
    );
  }

  IntrinsicHeight renderContentOtherThanDescription(BuildContext context) {
    return IntrinsicHeight(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFFC7C4C4),
                blurRadius: 15,
                spreadRadius: 1,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              renderCityAndTitle(context),
              renderOtherDetail(context),
              renderPrice(context),
              renderCreatorInformation(context),
              renderProductTimes(context),
              SaveToFavoritesButton(
                isFavorite: widget.isFavorite,
                onPressed: widget.handleSaveToFavorite,
              )
            ],
          ),
        ),
      ),
    );
  }

  IntrinsicHeight renderDescription(BuildContext context) {
    return IntrinsicHeight(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFFC7C4C4),
                blurRadius: 15,
                spreadRadius: 1,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.product.description,
                textAlign: TextAlign.justify,
              ),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.description,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(AppLocalizations.of(context).postDetailDescriptionText),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IntrinsicHeight renderOtherDetail(context) {
    return IntrinsicHeight(
      child: Column(
        children: buildOtherDetail(context),
      ),
    );
  }

  IntrinsicHeight renderCreatorInformation(context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: DetailItem(
              onClick: () => onDetailItemClicked(context),
              subtitle: Text(widget.postCreator?.fullName ?? ""),
              title: Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(AppLocalizations.of(context).postDetailOwnerNameText),
                ],
              ),
            ),
          ),
          Expanded(
            child: DetailItem(
              onClick: () async {
                final _call = 'tel:${widget.product.contactPhone}';
                if (await canLaunchUrl(Uri.parse(_call))) {
                  await launchUrl(Uri.parse(_call));
                }
              },
              subtitle: Text(widget.product.contactPhone),
              title: Row(
                children: [
                  const Icon(
                    Icons.phone,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(AppLocalizations.of(context)
                      .postDetailOwnerPhoneNumberText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IntrinsicHeight renderProductTimes(context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: DetailItem(
              onClick: () => {},
              subtitle: renderTimeContent(widget.product.createdAt),
              title: Row(
                children: [
                  const Icon(
                    Icons.alarm_on_outlined,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(AppLocalizations.of(context).postDetailCreatedAtText),
                ],
              ),
            ),
          ),
          Expanded(
            child: DetailItem(
              onClick: () => {},
              subtitle: renderTimeContent(widget.product.refreshedAt),
              title: Row(
                children: [
                  const Icon(
                    Icons.alarm_on_outlined,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(AppLocalizations.of(context).postDetailRefreshedAtText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IntrinsicHeight renderCityAndTitle(context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: DetailItem(
              onClick: () => {},
              subtitle: Text(widget.product.title),
              title: Row(
                children: [
                  const Icon(
                    Icons.title,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(AppLocalizations.of(context).postDetailTitleText),
                ],
              ),
            ),
          ),
          Expanded(
            child: DetailItem(
              onClick: () => {},
              subtitle: Text(widget.product.city),
              title: Row(
                children: [
                  const Icon(
                    Icons.location_city,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(AppLocalizations.of(context).postDetailCityText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  renderPrice(context) {
    return IntrinsicHeight(
      child: DetailItem(
        onClick: () => {},
        subtitle: Text(
          PriceFormatterUtil.formatToPrice(widget.product.price) + ' Birr',
          style: const TextStyle(
            color: Color(0xff34A853),
            fontSize: 18,
            height: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.monetization_on,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(AppLocalizations.of(context).postDetailPriceText),
          ],
        ),
      ),
    );
  }

  renderTimeContent(String time) {
    return Text(
      DateFormatterUtil.formatProductCreatedAtTime(
        time,
      ),
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
    );
  }

  List<Widget> buildOtherDetail(context) {
    if (widget.product.productDetail == null ||
        widget.product.productDetail!.isEmpty) {
      return [];
    }
    List<dynamic> chunks = sliceArrayToDifferentArrays();
    return List<Widget>.generate(
      chunks.length,
      (index) {
        List<Widget> items = buildWidgetListFromMap(chunks[index], context);
        return IntrinsicHeight(
          child: Row(
            children: items,
          ),
        );
      },
    );
  }

  List<Widget> buildWidgetListFromMap(dynamic chunk, BuildContext context) {
    return List<Widget>.from(
      chunk
          .map(
            (e) => Expanded(
              child: DetailItem(
                onClick: () => {},
                title: Text(e.key),
                subtitle: Text(e.value),
              ),
            ),
          )
          .toList(),
    );
  }

  List<dynamic> sliceArrayToDifferentArrays() {
    var originalList = widget.product.productDetail!.entries.toList();
    var chunks = [];
    int chunkSize = 2;
    for (var i = 0; i < originalList.length; i += chunkSize) {
      chunks.add(
        originalList.sublist(
          i,
          i + chunkSize > originalList.length
              ? originalList.length
              : i + chunkSize,
        ),
      );
    }
    return chunks;
  }

  renderPostDetailButtonSection() {
    return SendMessageButton(
      currentUser: widget.currentUser,
      receiverId: widget.product.createdBy,
      authToken: widget.authToken,
    );
  }

  renderRecommendedProducts() {
    return BlocBuilder<GetProductsByCategoryCubit, GetProductsByCategoryState>(
      builder: (context, state) {
        if (state is Loaded) {
          return Column(
            children: [
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Recommended Items',
                  style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return PostCardListItem(
                      product: state.products[index],
                    );
                  },
                  itemCount: state.products.length,
                ),
              ),
            ],
          );
        } else if (state is Loading) {
          return const CircularProgressIndicator();
        }

        return Container();
      },
    );
  }
}
