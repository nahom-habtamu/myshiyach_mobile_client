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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PostDetailPage.routeName,
            arguments: widget.product);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width * 0.45,
        height: 210,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            renderProductListItemImage(widget.product.productImages.first),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    renderTitle(widget.product.title),
                    renderDescription(widget.product.description),
                    renderPrice(widget.product.price),
                    renderCity(widget.product.city),
                    renderTimerAndFavoriteIcon(widget.product)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SizedBox renderTitle(title) {
    return SizedBox(
      height: 15,
      width: MediaQuery.of(context).size.width * 0.45,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  SizedBox renderDescription(String description) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          description,
          style: const TextStyle(
            color: Color(0xff888888),
            fontSize: 8,
            letterSpacing: 0.2,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  SizedBox renderCity(city) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 15,
      child: Text(
        city,
        style: const TextStyle(
          color: Color(0xff11435E),
          fontSize: 8,
          letterSpacing: 0.2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding renderPrice(price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: const Color(0xffF5FFF8),
        width: MediaQuery.of(context).size.width * 0.45,
        height: 18,
        child: Text(
          '\$' + PriceFormatterUtil.formatToPrice(price),
          style: const TextStyle(
            color: Color(0xff34A853),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Expanded renderTimerAndFavoriteIcon(Product product) {
    return Expanded(
      child: Row(
        children: [
          const Icon(
            Icons.access_time_rounded,
            size: 18,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              DateFormatterUtil.call(product.createdAt),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.onTap();
            },
            child: CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFE9E1E1),
              child: Center(
                child: Icon(
                  widget.isFavorite ? Icons.favorite_border : Icons.favorite,
                  size: 20,
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
      height: 100,
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
