import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: cryptoList!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(cryptoList![index].name),
              subtitle: Text(cryptoList![index].symbol),
              leading: SizedBox(
                width: 30.0,
                child: Center(
                  child: Text(
                    cryptoList![index].rank.toString(),
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
                      children: [
                        Text(cryptoList![index].priceUsd.toStringAsFixed(2)),
                        Text(
                          cryptoList![index]
                              .changePercent24Hr
                              .toStringAsFixed(2),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50.0,
                      child: Center(
                        child: _getIconChangePercent(
                            cryptoList![index].changePercent24Hr),
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
          },
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(Icons.trending_down, size: 24.0, color: Colors.red)
        : Icon(
            Icons.trending_up,
            size: 24.0,
            color: Colors.green,
          );
  }
}
