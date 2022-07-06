import 'package:flutter/material.dart';
import 'consumables.dart';

class Balance extends StatefulWidget {
  const Balance({Key? key}) : super(key: key);

  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  final TextEditingController barcodeContentController =
      TextEditingController(text: "Huawei");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add money to your card'),
          backgroundColor: const Color.fromARGB(204, 85, 72, 72),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Consumables(),
            ],
          ),
        )));
  }
}
