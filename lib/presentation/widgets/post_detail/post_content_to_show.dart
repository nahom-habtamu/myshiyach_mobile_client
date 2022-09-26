import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../data/models/product/product_model.dart';
import '../../../domain/enitites/product.dart';
import '../../../domain/enitites/user.dart';
import '../../bloc/get_products_by_category/get_products_by_category_cubit.dart';
import '../../bloc/get_products_by_category/get_products_by_category_state.dart';
import '../../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../../pages/posts_created_by_user_page.dart';
import '../home/product_grid_item.dart';
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
  List<Product> favorites = [];
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: PostDetailCarousel(
            items: [...widget.product.productImages],
          ),
        ),
        Column(
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
      ],
    );
  }

  onDetailItemClicked(context) {
    Navigator.of(context).pushNamed(
      PostsCreatedByUserPage.routeName,
      arguments: widget.product.createdBy,
    );
  }

  renderContentOtherThanDescription(BuildContext context) {
    return Align(
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
              isFavorite: isFavorite,
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                widget.handleSaveToFavorite();
              },
            )
          ],
        ),
      ),
    );
  }

  renderDescription(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100),
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

  renderOtherDetail(context) {
    return Column(
      children: buildOtherDetail(context),
    );
  }

  renderCreatorInformation(context) {
    return SizedBox(
      height: 100,
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

  renderProductTimes(context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: DetailItem(
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

  renderCityAndTitle(context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: DetailItem(
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
    return SizedBox(
      height: 100,
      child: DetailItem(
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
        return SizedBox(
          height: 100,
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
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            setState(() {
              if (favorites.isEmpty) favorites = state.favorites;
            });
          });
          var contentOtherThanCurrentProduct = state.products
              .where((p) =>
                  p.id != widget.product.id && p.title != widget.product.title)
              .toList();
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
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height) *
                        1.47,
                  ),
                  itemCount: contentOtherThanCurrentProduct.length,
                  itemBuilder: (context, index) {
                    var duplicate = favorites
                        .where((element) =>
                            element.id ==
                            contentOtherThanCurrentProduct[index].id)
                        .toList();
                    return ProductGridItem(
                      isFavorite: duplicate.isEmpty,
                      onFavoritesTap: () => updateFavorites(
                          duplicate, contentOtherThanCurrentProduct[index]),
                      product: contentOtherThanCurrentProduct[index],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is Loading) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        return Container();
      },
    );
  }

  void updateFavorites(
    List<Product> duplicate,
    Product product,
  ) {
    if (duplicate.isNotEmpty) {
      favorites.removeWhere((element) => element.id == product.id);
      setState(() {});
    } else {
      setState(() {
        favorites = [...favorites, product];
      });
    }
    List<ProductModel> favoritesToSave = parseListToProductModelList();
    context
        .read<SetFavoriteProductsCubit>()
        .setFavoriteProducts
        .call(favoritesToSave);
  }

  List<ProductModel> parseListToProductModelList() {
    var favoritesToSave =
        favorites.map((e) => ProductModel.fromProduct(e)).toList();
    return favoritesToSave;
  }
}
