import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  CoinData coinData = CoinData();
  Map<String, String> parsedCoinMap;

  DropdownButton<String> getDropDownButton() {
    List<DropdownMenuItem<String>> dropDownMenuItems = [];
    for (String currency in currenciesList) {
      var item = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownMenuItems.add(item);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownMenuItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker getCupertinoPicker() {
    List<Text> items = [];
    for (String currency in currenciesList) {
      var newItem = Text(
        currency,
        style: TextStyle(color: Colors.white),
      );
      items.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 34.0,
      onSelectedItemChanged: (value) {
        selectedCurrency = currenciesList[value];
        getData();
      },
      children: items,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var parsedCoinData = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;
      print(parsedCoinData);
      setState(() {
        parsedCoinMap = parsedCoinData;
      });
    } catch (e) {
      print(e);
    }
  }

  Column makeCardsColumn() {
    List<CryptoCardWidget> cardList = [];
    for (String crypto in cryptoList) {
      var newItem = CryptoCardWidget(
        rate: isWaiting ? '???' : parsedCoinMap[crypto],
        selectedCurrency: selectedCurrency,
        cryptoCurrency: crypto,
      );
      cardList.add(newItem);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cardList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCardsColumn(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getDropDownButton(),
          ),
        ],
      ),
    );
  }
}

class CryptoCardWidget extends StatelessWidget {
  const CryptoCardWidget(
      {@required this.rate,
      @required this.cryptoCurrency,
      @required this.selectedCurrency});

  final String rate;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
