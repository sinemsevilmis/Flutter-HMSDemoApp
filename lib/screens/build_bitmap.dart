import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:huawei_scan/HmsScanLibrary.dart';

import 'balance.dart';

class BuildBitmap extends StatefulWidget {
  const BuildBitmap({Key? key}) : super(key: key);

  @override
  _BuildBitmapState createState() => _BuildBitmapState();
}

class _BuildBitmapState extends State<BuildBitmap> {
  Image? _qrImg;
  String? bitmapColor = 'Black';
  String? backgroundColor = 'White';
  int scanTypeValue = HmsScanTypes.QRCode;
  Color bitmapColorValue = Colors.black;
  Color backgroundColorValue = Colors.white;

  @override
  void initState() {
    buildBitmap();
    super.initState();
  }

  buildBitmap() async {
    BuildBitmapRequest request = BuildBitmapRequest(
      content:
          "https://developer.huawei.com/consumer/en/doc/development/HMS-Plugin-References/flutter-overview-0000001054390809",
    );

    request.width = 250;
    request.height = 250;
    request.type = scanTypeValue;
    request.margin = 1;
    request.bitmapColor = bitmapColorValue;
    request.backgroundColor = backgroundColorValue;

    Image? image;

    try {
      image = await HmsScanUtils.buildBitmap(request);
    } on PlatformException catch (err) {
      if (err.code == HmsScanErrors.buildBitmap.errorCode) {
        debugPrint(HmsScanErrors.buildBitmap.errorMessage);
        debugPrint(err.details);
      }
    }

    setState(() {
      _qrImg = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(204, 85, 72, 72),
        title: const Text('Pay'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/card.jpg",
                    height: 200,
                    width: 200,
                  ),
                  Column(
                    children: [
                      const Text("₺100,00",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Balance()),
                          );
                        },
                        label: const Text("Add Money"),
                        backgroundColor: const Color.fromARGB(204, 85, 72, 72),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Text("1"),
                          Icon(Icons.coffee),
                          Text("Reward Drink"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _qrImg ?? const SizedBox(height: 20),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
