import 'package:flutter/material.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../domain/enitites/product.dart';
import '../../pages/post_detail_page.dart';

class ProductListItem extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final Function onTap;
  const ProductListItem({
    Key? key,
    required this.product,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  double heightOfMobile = 0.0;

  @override
  Widget build(BuildContext context) {
    heightOfMobile = MediaQuery.of(context).size.height * 0.01;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PostDetailPage.routeName,
            arguments: widget.product);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
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
    );
  }

  renderDescription(String description) {
    return SizedBox(
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
    );
  }

  renderCity(city) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: Text(
        city,
        style: TextStyle(
          color: const Color(0xff11435E),
          fontSize: heightOfMobile * 1.5,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.clip,
      ),
    );
  }

  renderPrice(price) {
    return Container(
      color: const Color(0xffF5FFF8),
      width: MediaQuery.of(context).size.width * 0.45,
      child: Text(
        PriceFormatterUtil.formatToPrice(price) + ' Birr',
        style: TextStyle(
          color: const Color(0xff34A853),
          fontSize: heightOfMobile * 1.8,
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.clip,
      ),
    );
  }

  renderTimerAndFavoriteIcon(Product product) {
    return Row(
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
          child: Text(
            DateFormatterUtil.formatProductCreatedAtTime(product.refreshedAt),
            style: TextStyle(
              color: Colors.grey,
              fontSize: heightOfMobile * 1.6,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: CircleAvatar(
            radius: heightOfMobile * 2,
            backgroundColor: const Color(0xFFE9E1E1),
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
