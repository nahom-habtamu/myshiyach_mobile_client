import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/enitites/product.dart';
import '../../../domain/enitites/user.dart';
import 'post_detail_carousel.dart';
import 'send_message_button.dart';

class PostContentToShow extends StatelessWidget {
  final Product product;
  final User currentUser;
  final User? postCreator;
  final String authToken;
  const PostContentToShow({
    Key? key,
    required this.product,
    required this.currentUser,
    required this.authToken,
    required this.postCreator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostDetailCarousel(
          items: [...product.productImages],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                renderContentOtherThanDescription(context),
                const SizedBox(height: 15),
                renderDescription(context),
                const SizedBox(height: 15),
                renderPostDetailButtonSection(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        )
      ],
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
              renderOtherDetail(),
              renderPrice(context),
              renderCreatorInformation(context),
              renderProductTimes(context),
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
                product.description,
                textAlign: TextAlign.justify,
              ),
            ),
            title: Text(AppLocalizations.of(context).postDetailDescriptionText),
          ),
        ),
      ),
    );
  }

  IntrinsicHeight renderOtherDetail() {
    return IntrinsicHeight(
      child: Column(
        children: buildOtherDetail(),
      ),
    );
  }

  IntrinsicHeight renderCreatorInformation(context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: DetailItem(
              subtitle: Text(postCreator?.fullName ?? ""),
              title: Text(AppLocalizations.of(context).postDetailOwnerNameText),
            ),
          ),
          Expanded(
            child: DetailItem(
              subtitle: Text(postCreator?.phoneNumber ?? ""),
              title: Text(
                  AppLocalizations.of(context).postDetailOwnerPhoneNumberText),
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
              subtitle: renderTimeContent(product.createdAt),
              title: Text(AppLocalizations.of(context).postDetailCreatedAtText),
            ),
          ),
          Expanded(
            child: DetailItem(
              subtitle: renderTimeContent(product.refreshedAt),
              title:
                  Text(AppLocalizations.of(context).postDetailRefreshedAtText),
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
              subtitle: Text(product.title),
              title: Text(AppLocalizations.of(context).postDetailTitleText),
            ),
          ),
          Expanded(
            child: DetailItem(
              subtitle: Text(product.city),
              title: Text(AppLocalizations.of(context).postDetailCityText),
            ),
          ),
        ],
      ),
    );
  }

  renderPrice(context) {
    return IntrinsicHeight(
      child: DetailItem(
        subtitle: Text(
          PriceFormatterUtil.formatToPrice(product.price) + ' Birr',
          style: const TextStyle(
            color: Color(0xff34A853),
            fontSize: 18,
            height: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Text(AppLocalizations.of(context).postDetailPriceText),
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

  List<Widget> buildOtherDetail() {
    if (product.productDetail == null || product.productDetail!.isEmpty) {
      return [];
    }
    List<dynamic> chunks = sliceArrayToDifferentArrays();
    return List<Widget>.generate(
      chunks.length,
      (index) {
        List<Widget> items = buildWidgetListFromMap(chunks[index]);
        return IntrinsicHeight(
          child: Row(
            children: items,
          ),
        );
      },
    );
  }

  List<Widget> buildWidgetListFromMap(dynamic chunk) {
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
    var originalList = product.productDetail!.entries.toList();
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
      currentUser: currentUser,
      product: product,
      authToken: authToken,
    );
  }
}

class DetailItem extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  const DetailItem({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFECE9E9),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
        child: ListTile(
          subtitle: subtitle,
          title: title,
        ),
      ),
    );
  }
}
