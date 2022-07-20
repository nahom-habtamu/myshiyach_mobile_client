import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PriceRangeInputDialog extends StatefulWidget {
  final double initialMin;
  final double initialMax;
  final Function(double, double) onChanged;
  const PriceRangeInputDialog({
    Key? key,
    required this.initialMin,
    required this.initialMax,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PriceRangeInputDialog> createState() => _PriceRangeInputDialogState();
}

class _PriceRangeInputDialogState extends State<PriceRangeInputDialog> {
  double minPriceFromDialog = 0;
  double maxPriceFromDialog = 0;
  TextEditingController controllerMin = TextEditingController();
  TextEditingController controllerMax = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      minPriceFromDialog = widget.initialMin;
      maxPriceFromDialog = widget.initialMax;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        _displayTextInputDialog();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                '${AppLocalizations.of(context).filterMinPriceText} = $minPriceFromDialog\$',
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const Divider(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                '${AppLocalizations.of(context).filterMaxPriceText} = $maxPriceFromDialog\$',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).filterModalHeaderText),
          content: SizedBox(
            height: 170,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        minPriceFromDialog = double.parse(value);
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).filterMinPriceText,
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        maxPriceFromDialog = double.parse(value);
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).filterMaxPriceText,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    widget.onChanged(minPriceFromDialog, maxPriceFromDialog);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
