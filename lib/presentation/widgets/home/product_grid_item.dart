import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/enitites/product.dart';
import '../../bloc/change_language/change_language_cubit.dart';
import '../../pages/post_detail_page.dart';
import '../../screen_arguments/post_detail_page_arguments.dart';

class ProductGridItem extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final Function onFavoritesTap;
  const ProductGridItem({
    Key? key,
    required this.product,
    required this.isFavorite,
    required this.onFavoritesTap,
  }) : super(key: key);

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  double heightOfMobile = 0.0;

  @override
  Widget build(BuildContext context) {
    heightOfMobile = MediaQuery.of(context).size.height * 0.01;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          PostDetailPage.routeName,
          arguments: PostDetalPageArguments(
            product: widget.product,
            isFromDynamicLink: false,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x87DAD3D3),
              blurRadius: 2,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            renderProductListItemImage(widget.product.productImages.first),
            renderTitle(widget.product.title),
            renderPrice(widget.product.price),
            renderCity(widget.product.city),
            renderTimerAndFavoriteIcon(widget.product),
          ],
        ),
      ),
    );
  }

  FittedBox renderTitle(title) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
              fontSize: heightOfMobile * 2,
            ),
            overflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }

  renderDescription(String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: heightOfMobile * 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            description,
            style: const TextStyle(
              color: Color(0xff888888),
              fontSize: 10,
              letterSpacing: 0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  renderCity(String city) {
    return BlocBuilder<ChangeLanguageCubit, String>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Text(
            state == "en" ? city.split(";").first : city.split(";").last,
            style: TextStyle(
              color: const Color(0xff11435E),
              fontSize: heightOfMobile * 1.5,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
          ),
        ),
      );
    });
  }

  renderPrice(price) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Container(
        color: const Color(0xffF5FFF8),
        width: MediaQuery.of(context).size.width * 0.45,
        child: Text(
          PriceFormatterUtil.formatToPrice(price) +
              " " +
              AppLocalizations.of(context).postDetailBirr,
          style: TextStyle(
            color: const Color(0xff34A853),
            fontSize: heightOfMobile * 1.8,
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }

  renderTimerAndFavoriteIcon(Product product) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            size: heightOfMobile * 2,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: BlocBuilder<ChangeLanguageCubit, String>(
                builder: (context, state) {
              return Text(
                DateFormatterUtil.formatProductCreatedAtTime(
                  product.refreshedAt,
                  state,
                ),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: heightOfMobile * 1.6,
                ),
              );
            }),
          ),
          GestureDetector(
            onTap: () {
              widget.onFavoritesTap();
            },
            child: CircleAvatar(
              radius: heightOfMobile * 2,
              backgroundColor: Colors.transparent,
              child: Center(
                child: Icon(
                  widget.isFavorite ? Icons.favorite_border : Icons.favorite,
                  size: heightOfMobile * 3,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox renderProductListItemImage(image) {
    return SizedBox(
      height: heightOfMobile * 15,
      width: MediaQuery.of(context).size.width * 0.45,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: Image.network(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
