import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;

import 'package:huawei_iap/HmsIapLibrary.dart';

class Consumables extends StatefulWidget {
  const Consumables({Key? key}) : super(key: key);

  @override
  _ConsumablesState createState() => _ConsumablesState();
}

class _ConsumablesState extends State<Consumables> {
  List<ProductInfo> available = [];
  List<InAppPurchaseData> purchased = [];
  List<InAppPurchaseData> purchasedRecord = [];

  int? price = 0;

  @override
  void initState() {
    super.initState();
    loadProducts();
    ownedPurchases();
  }

  loadProducts() async {
    try {
      ProductInfoResult result = await IapClient.obtainProductInfo(
        ProductInfoReq(
          priceType: IapClient.IN_APP_CONSUMABLE,
          //Make sure that the product IDs are the same as those defined in AppGallery Connect.
          skuIds: ["balance_1", "balance_2", "balance_3"],
        ),
      );
      setState(() {
        available.clear();
        if (result.productInfoList != null) {
          for (int i = 0; i < result.productInfoList!.length; i++) {
            available.add(result.productInfoList![i]);
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == HmsIapResults.ORDER_HWID_NOT_LOGIN.resultCode) {
        log(HmsIapResults.ORDER_HWID_NOT_LOGIN.resultMessage!);
      } else {
        log(e.toString());
      }
    }
  }

  buyProduct(String productID) async {
    try {
      PurchaseResultInfo result =
          await IapClient.createPurchaseIntent(PurchaseIntentReq(
        priceType: IapClient.IN_APP_CONSUMABLE,
        productId: productID,
        signatureAlgorithm:
            SignAlgorithmConstants.SIGNATURE_ALGORITHM_SHA256WITHRSA_PSS,
      ));
      if (result.returnCode == HmsIapResults.ORDER_STATE_SUCCESS.resultCode) {
        loadProducts();
        ownedPurchases();
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: const Text("Balance added to your account."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK',
                    style: TextStyle(color: Color.fromARGB(204, 8, 138, 77))),
              ),
            ],
          ),
        );
      } else {
        if (result.errMsg != null) {
          log(result.errMsg!);
        } else {
          log(result.rawValue);
        }
      }
    } on PlatformException catch (e) {
      if (e.code == HmsIapResults.ORDER_HWID_NOT_LOGIN.resultCode) {
        log(HmsIapResults.ORDER_HWID_NOT_LOGIN.resultMessage!);
      } else {
        log(e.toString());
      }
    }
  }

  ownedPurchases() async {
    try {
      OwnedPurchasesResult result =
          await IapClient.obtainOwnedPurchases(OwnedPurchasesReq(
        priceType: IapClient.IN_APP_CONSUMABLE,
        signatureAlgorithm:
            SignAlgorithmConstants.SIGNATURE_ALGORITHM_SHA256WITHRSA_PSS,
      ));
      setState(() {
        purchased.clear();
        if (result.inAppPurchaseDataList != null) {
          for (int i = 0; i < result.inAppPurchaseDataList!.length; i++) {
            purchased.add(result.inAppPurchaseDataList![i]);
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == HmsIapResults.ORDER_HWID_NOT_LOGIN.resultCode) {
        log(HmsIapResults.ORDER_HWID_NOT_LOGIN.resultMessage!);
      } else {
        log(e.toString());
      }
    }
  }

  consumeItem(String purchaseToken) async {
    try {
      ConsumeOwnedPurchaseResult result =
          await IapClient.consumeOwnedPurchase(ConsumeOwnedPurchaseReq(
        purchaseToken: purchaseToken,
        signatureAlgorithm:
            SignAlgorithmConstants.SIGNATURE_ALGORITHM_SHA256WITHRSA_PSS,
      ));
      if (result.returnCode == HmsIapResults.ORDER_STATE_SUCCESS.resultCode) {
        ownedPurchases();
      } else {
        if (result.errMsg != null) {
          log(result.errMsg!);
        } else {
          log(result.rawValue);
        }
      }
    } on PlatformException catch (e) {
      if (e.code == HmsIapResults.ORDER_HWID_NOT_LOGIN.resultCode) {
        log(HmsIapResults.ORDER_HWID_NOT_LOGIN.resultMessage!);
      } else {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          AlertDialog(
            title: const Text('Amount'),
            content: Column(
              children: [
                const Text("Please select the amount you want to add",
                    style: TextStyle(color: Colors.grey, fontSize: 13.0)),
                const Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: available.length,
                    itemBuilder: (BuildContext ctxt, int i) {
                      return InkWell(
                        onTap: () {
                          buyProduct(available[i].productId ?? "");
                        },
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(available[i].price ?? ""),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          Row(
            children: const <Widget>[
              Text(
                "Added balance history",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )
            ],
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: purchased.length,
              itemBuilder: (BuildContext ctxt, int i) {
                return InkWell(
                  onTap: () {
                    if (purchased[i].purchaseToken != null) {
                      consumeItem(purchased[i].purchaseToken!);
                    } else {
                      log("Please provide valid product id.");
                    }
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            purchased[i].productName ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
