import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/enitites/product.dart';
import '../../pages/post_detail_page.dart';
import 'pop_up_dialog.dart';

class PostCardListItem extends StatelessWidget {
  final Product product;
  final Function? onDissmissed;
  const PostCardListItem({
    Key? key,
    required this.product,
    this.onDissmissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return renderBody(context);
  }

  renderBody(BuildContext context) {
    return onDissmissed != null
        ? renderDismissible(context)
        : renderNonDismissible(context);
  }

  Container renderNonDismissible(BuildContext context) {
    return Container(
      key: ValueKey<String>(product.id),
      child: renderMainContent(context),
    );
  }

  Dismissible renderDismissible(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: dismissibleBackground(),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopupDialog(
              content: AppLocalizations.of(context)
                  .savedPostsDeleteConfirmDialogText,
            );
          },
        );
      },
      onDismissed: (DismissDirection direction) {
        onDissmissed!();
      },
      key: ValueKey<String>(product.id),
      child: renderMainContent(context),
    );
  }

  InkWell renderMainContent(BuildContext context) {
    return InkWell(
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container dismissibleBackground() {
    return Container(
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
    );
  }
}
