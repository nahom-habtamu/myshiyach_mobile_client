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
      child: Row(
        children: [...buildOtherDetail()],
      ),
    );
  }

  IntrinsicHeight renderCreatorInformation(context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              subtitle: Text(postCreator?.fullName ?? ""),
              title: Text(AppLocalizations.of(context).postDetailOwnerNameText),
            ),
          ),
          Expanded(
            child: ListTile(
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
            child: ListTile(
              subtitle: renderTimeContent(product.createdAt),
              title: Text(AppLocalizations.of(context).postDetailCreatedAtText),
            ),
          ),
          Expanded(
            child: ListTile(
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
            child: ListTile(
              subtitle: Text(product.title),
              title: Text(AppLocalizations.of(context).postDetailTitleText),
            ),
          ),
          Expanded(
            child: ListTile(
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
      child: ListTile(
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

  buildOtherDetail() {
    if (product.productDetail == null || product.productDetail!.isEmpty) {
      return [];
    }
    return product.productDetail!.entries
        .toList()
        .map(
          (e) => Expanded(
            child: ListTile(
              title: Text(e.key),
              subtitle: Text(e.value),
            ),
          ),
        )
        .toList();
  }

  renderPostDetailButtonSection() {
    return SendMessageButton(
      currentUser: currentUser,
      product: product,
      authToken: authToken,
    );
  }
}
