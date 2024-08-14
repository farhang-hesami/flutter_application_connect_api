import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_connect_api/constants/constants.dart';
import 'package:flutter_application_connect_api/data/models/crypto.dart';

// ignore: must_be_immutable
class CoinListScreen extends StatefulWidget {
  CoinListScreen({super.key, this.cryptos});
  List<Crypto>? cryptos;

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? cryptoList;
  bool isVisibleTextUpdate = false;
  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Coincap',
            style: TextStyle(
              fontFamily: 'MH',
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: blackColor,
          elevation: 0.4,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0.0),
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  _getResultSearch(value);
                },
                cursorColor: greyColor,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: greenColor,
                  prefixIconColor: Colors.white,
                  filled: true,
                  hintText: 'Search ...!',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'MH',
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisibleTextUpdate,
              child: Text(
                'Updating ... ',
                style: TextStyle(
                  fontFamily: 'MH',
                  color: greenColor,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: greenColor,
                color: blackColor,
                displacement: 50.0,
                edgeOffset: 20.0,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  List<Crypto> freshData = await _getData();
                  setState(
                    () {
                      cryptoList = freshData;
                    },
                  );
                },
                child: ListView.builder(
                  itemCount: cryptoList!.length,
                  itemBuilder: (context, index) {
                    return _getListTileItem(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data["data"]
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  Widget _getListTileItem(int index) {
    return ListTile(
      title: Text(
        cryptoList![index].name,
        style: TextStyle(
          color: greenColor,
        ),
      ),
      subtitle: Text(
        cryptoList![index].symbol,
        style: TextStyle(
          color: greyColor,
        ),
      ),
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            cryptoList![index].rank.toString(),
            style: TextStyle(
              color: greyColor,
            ),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cryptoList![index].priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 16.0),
                ),
                Text(
                  cryptoList![index].changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getColorChangePercent24H(
                        cryptoList![index].changePercent24Hr),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50.0,
              child: Center(
                child:
                    _getIconChangePercent(cryptoList![index].changePercent24Hr),
              ),
            ),
          ],
        ),
      ),
      //cryptoList![index].changePercent24Hr > 0
      //     ? Icon(
      //         Icons.trending_up,
      //         color: Colors.green,
      //       )
      //     : Icon(
      //         Icons.trending_down,
      //         color: Colors.red,
      //       ),
    );
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(Icons.trending_down, size: 24.0, color: redColor)
        : Icon(
            Icons.trending_up,
            size: 24.0,
            color: greenColor,
          );
  }

  Color _getColorChangePercent24H(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Future<void> _getResultSearch(String enteredwords) async {
    List<Crypto> resultSearchList = [];
    if (enteredwords.isEmpty) {
      setState(() {
        isVisibleTextUpdate = true;
      });
      var result = await _getData();
      setState(() {
        cryptoList = result;
        isVisibleTextUpdate = false;
      });
      return;
    }
    resultSearchList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredwords.toLowerCase());
    }).toList();

    setState(() {
      cryptoList = resultSearchList;
    });
  }
}
