import 'package:flutter/material.dart';

import '../../../domain/enitites/product.dart';
import '../../pages/post_detail_page.dart';

class PostCardListItem extends StatelessWidget {
  final Product product;
  final Function onDissmissed;
  const PostCardListItem({
    Key? key,
    required this.product,
    required this.onDissmissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
      onDismissed: (DismissDirection direction) {
        onDissmissed();
      },
      key: ValueKey<String>(product.id),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            PostDetailPage.routeName,
            arguments: product,
          );
        },
        child: Card(
          color: Colors.white.withOpacity(0.9),
          elevation: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            height: 100,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.teal,
                    backgroundImage: NetworkImage(product.productImages.first),
                    radius: 45,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(product.title),
                    subtitle: SizedBox(
                      width: MediaQuery.of(context).size.width * 60,
                      height: 40,
                      child: Text(
                        product.description,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}