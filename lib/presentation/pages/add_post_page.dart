import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  static String routeName = "/addPostPage";
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  int currentInputPageState = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF1F1F1),
        appBar: AppBar(
          title: const Text(
            'Post Information',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xffF1F1F1),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 25,
              left: 25,
              right: 25,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                currentInputPageState == 0
                    ? renderFirstPageInputs()
                    : renderSecondPageInputs(),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ChangeInputButton(
                      text: "Cancel",
                      onTap: () {
                        if (currentInputPageState == 1) {
                          setState(() {
                            currentInputPageState = 0;
                          });
                        } else {
                          // Navigator.of(context).pushNamed()
                        }
                      },
                    ),
                    ChangeInputButton(
                      text: currentInputPageState == 0 ? "Next" : "Post",
                      backgroundColor: const Color(0xFF11435E),
                      textColor: Colors.white,
                      onTap: () {
                        if (currentInputPageState == 0) {
                          setState(() {
                            currentInputPageState = 1;
                          });
                        } else {
                          // Navigator.of(context).pushNamed()
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderSecondPageInputs() {
    return Column(
      children: const [
        AddPostInput(
          hintText: "Sub Category",
        ),
        SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Contact Phone",
        ),
        SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Images",
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  renderFirstPageInputs() {
    return Column(
      children: const [
        AddPostInput(
          hintText: "Item Title",
        ),
        SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Description",
        ),
        SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Price",
        ),
        SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Quantity",
        ),
        SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Category",
        ),
      ],
    );
  }
}

class ChangeInputButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  const ChangeInputButton({
    Key? key,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.grey,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class AddPostInput extends StatelessWidget {
  final String hintText;
  const AddPostInput({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
        onChanged: (value) => {},
        decoration: InputDecoration(
          labelText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            borderSide: BorderSide(
              color: Colors.black26,
              width: 1,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            borderSide: BorderSide(
              color: Colors.black26,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            borderSide: BorderSide(
              color: Colors.black26,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
          filled: true,
          fillColor: Colors.white54,
        ),
      ),
    );
  }
}
