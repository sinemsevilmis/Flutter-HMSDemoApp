import 'package:coffee_app/HomePage.dart';
import 'package:coffee_app/screens/coffee_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

import 'package:huawei_scan/HmsScanLibrary.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String permissionState = "Permissions Are Not Granted.";
  int _selectedIndex = 0;

  @override
  void initState() {
    //permissionRequest();
    super.initState();
  }

  permissionRequest() async {
    bool? permissionResult =
        await HmsScanPermissions.hasCameraAndStoragePermission();
    if (permissionResult != true) {
      await HmsScanPermissions.requestCameraAndStoragePermissions();
    } else {
      setState(() {
        permissionState = "All Permissions Are Granted";
      });
    }
  }

  final List _screens = [
    {
      "screen": HomePage(),
    },
    {
      "screen": const CoffeeCard(),
    }
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex]["screen"],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            label: 'Coffee Card',
          ),
        ],
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(204, 8, 138, 77),
        currentIndex: _selectedIndex,
      ),
    );
  }
}
