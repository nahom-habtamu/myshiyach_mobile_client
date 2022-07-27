import 'package:flutter/material.dart';

class SaveToFavoritesButton extends StatelessWidget {
  const SaveToFavoritesButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: OutlinedButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xFFE6E2E2),
                child: Icon(
                  Icons.favorite_outline,
                  color: Color.fromARGB(255, 255, 0, 1),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Add To Favorites',
                style: TextStyle(fontSize: 16),
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
