import 'package:flutter/material.dart';
import 'balance.dart';
import 'build_bitmap.dart';

class CoffeeCard extends StatefulWidget {
  const CoffeeCard({Key? key}) : super(key: key);

  @override
  _CoffeeCardState createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(204, 85, 72, 72),
        title: const Text("Coffee Card"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24.0,
              ),
              const Text(
                "Account balance",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                "₺100",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              Image.asset(
                "assets/card.jpg",
                height: 300,
                width: 300,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "btn1",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Balance()),
              );
            },
            label: const Text("Add Money",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: const Color.fromARGB(204, 85, 72, 72),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuildBitmap()),
              );
            },
            label: const Text("Scan QR",
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: const Color.fromARGB(204, 85, 72, 72),
          ),
        ],
      ),
    );
  }
}
