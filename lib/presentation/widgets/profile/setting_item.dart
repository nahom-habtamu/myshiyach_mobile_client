import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData leadingIcon;
  final String trailingIconType;
  final Function? onPressed;
  final Function? onValueChanged;
  final bool value;

  const SettingItem({
    Key? key,
    required this.title,
    this.subTitle = "",
    required this.leadingIcon,
    this.trailingIconType = "ARROW",
    this.onPressed,
    this.onValueChanged,
    this.value = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xff1B1D21),
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: 0.28,
          ),
        ),
        subtitle: subTitle.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  subTitle,
                  style: const TextStyle(
                    color: Color(0x82000000),
                    fontSize: 14,
                    letterSpacing: 0.28,
                  ),
                ),
              )
            : Container(),
        trailing: trailingIconType == "ARROW"
            ? const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xff1B1D21),
                size: 18,
              )
            : Switch(
                value: value,
                onChanged: (value) {
                  if (onValueChanged != null) {
                    onValueChanged!(value);
                  }
                },
              ),
        leading: Icon(leadingIcon),
        onTap: () {
          onPressed!();
        },
      ),
    );
  }
}
