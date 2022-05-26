import 'package:flutter/material.dart';

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
      width: MediaQuery.of(context).size.width * 0.45,
      height: 32,
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

  SizedBox renderDescription(description) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 10,
      child: Text(
        description,
        style: const TextStyle(
          color: Color(0xff888888),
          fontSize: 8,
          letterSpacing: 0.2,
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
        child: Text(
          '\$${price.toString()}',
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

  Row renderTimerAndFavoriteIcon(Product product) {
    return Row(
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
            product.createdAt,
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
            radius: 14,
            backgroundColor: const Color.fromRGBO(233, 225, 225, 1),
            child: Icon(
              widget.isFavorite ? Icons.favorite_border : Icons.favorite,
              size: 20,
              color: Colors.red,
            ),
          ),
        ),
      ],
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
