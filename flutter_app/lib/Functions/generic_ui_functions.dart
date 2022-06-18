import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GenericUIFunctions {
  static SnackBar snackBar(String text) {
    return SnackBar(
      content: Text(text),
    );
  }

  static void countInputModalBottomSheetRam(
      BuildContext context, Function(int input) onSubmitFunction) {
    TextEditingController textEditingController =
        TextEditingController(text: "1");
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Input Count:'),
              TextField(
                controller: textEditingController,
                decoration:
                    const InputDecoration(labelText: "Enter your number (1-4)"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  if (int.parse(textEditingController.text) > 0 &&
                      int.parse(textEditingController.text) <= 4) {
                    Navigator.pop(context);
                    onSubmitFunction(int.parse(textEditingController.text));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        GenericUIFunctions.snackBar(
                            "Ram count is between 1 and 4"));
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
              ),
            ],
          ),
        );
      },
    );
  }
}
