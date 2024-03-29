import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveToFavoritesButton extends StatelessWidget {
  final bool isFavorite;
  final Function onPressed;
  const SaveToFavoritesButton({
    Key? key,
    required this.onPressed,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: OutlinedButton(
          onPressed: () => onPressed(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFFE6E2E2),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: const Color.fromARGB(255, 255, 0, 1),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                isFavorite
                    ? AppLocalizations.of(context)
                        .postDetailRemoveFromFavoriteButton
                    : AppLocalizations.of(context)
                        .postDetailAddToFavoriteButton,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Color(0xff11435E),
              width: 1,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            primary: const Color(0xff11435E),
            textStyle: const TextStyle(
              color: Color(0xff11435E),
            ),
          ),
        ),
      ),
    );
  }
}
