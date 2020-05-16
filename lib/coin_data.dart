import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIurl = 'http://rest.coinapi.io/v1/exchangerate';
const apiKey1 = 'Your_API_KEY_Here';

class CoinData {
  Future<dynamic> getCoinData(String afterCurrency) async {
    String url;

    Map<String, String> rateMap = {};

    for (String cryptoCurrency in cryptoList) {
      url = '$coinAPIurl/$cryptoCurrency/$afterCurrency?apikey=$apiKey1';

      print('Getting Response of $cryptoCurrency');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var coinData = jsonDecode(response.body);
        print(response.body);
        rateMap[cryptoCurrency] = coinData['rate'].toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Unable to get Response';
      }
      sleep(Duration(milliseconds: 50));
    }
    print('Returning RateMap');
    return rateMap;
  }
}
