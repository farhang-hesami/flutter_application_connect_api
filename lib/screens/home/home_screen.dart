import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_connect_api/data/models/crypto.dart';
import 'package:flutter_application_connect_api/screens/cryptoscreen/coin_list_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logo.png'),
            ),
            SizedBox(height: 10.0),
            SpinKitWave(
              color: Colors.white,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data["data"]
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CoinListScreen(cryptos: cryptoList);
        },
      ),
    );
  }
}
