import 'package:flutter/material.dart';
import 'package:purchase_order/src/utils/fonts.dart';

class FinalConsumerCheckBox extends StatefulWidget {
  const FinalConsumerCheckBox({Key? key}) : super(key: key);

  @override
  State<FinalConsumerCheckBox> createState() => FinalConsumerCheckBoxState();
}

class FinalConsumerCheckBoxState extends State<FinalConsumerCheckBox> {
  final ValueNotifier<bool> checkboxValue = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: checkboxValue,
        builder: (context, bool value, child) {
          return Row(
            children: [
              Checkbox(
                  value: checkboxValue.value,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (bool? value) {
                    checkboxValue.value = value ?? !checkboxValue.value;
                  }),
              Text(
                "Consumidor final",
                style: Fonts.normal,
              ),
            ],
          );
        });
  }
}
