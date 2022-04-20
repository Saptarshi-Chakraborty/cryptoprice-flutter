import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'details.dart';
import 'coin_logos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Crypto Price",
      // initialRoute: '/details',
      routes: {'/details': (context) => CoinDetails()},
      scrollBehavior: const ScrollBehavior(
          androidOverscrollIndicator: AndroidOverscrollIndicator.glow),
      // home: Home(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class Coins {
  var item;
  Coins(this.item);
  @override
  String toString() {
    return '{ $item }';
  }
}

class _HomeState extends State<Home> {
  var _data;
  int _noOfItem = 0;

  void getData() async {
    Response response = await get(Uri.parse(
        'https://production.api.coindesk.com/v2/tb/price/ticker?assets=BTC,CHZ,SUSHI,XYO,ENJ,COTI,LPT,ANKR,IOTX,COMP,CELO,NKN,KSM,RLC,SKL,KEEP,ICP,SOL,WBTC,XRP,FIL,DOT,BAT,MATIC,BSV,XLM,MLN,KAVA,XEM,LSK,QTUM,DCR,DNT,DAI,ANT,REP,BAND,NMR,PAX,STORJ,CVC,BNT,NU,LTC,BCH,ADA,UNI,REN,EOS,GRT,IOTA,AAVE,NANO,KNC,USDC,DASH,XTZ,BTT,WAVES,OXT,MKR,ALGO,FET,BTG,ZRX,ZEC,LRC,MANA,OMG,XMR,ICX,ETC,TRX,YFI,NEO,PAXG,DOGE,SC,ATOM,LINK,USDT,LUNA,SHIB,ETH,AVAX,CRV,AXS,AMP,SNX,UMA,SAND,UST,SNGLS'));

    var responseBody = await jsonDecode(response.body);
    var data = responseBody['data'];
    List list = [];
    await data.forEach((key, value) {
      list.add(Coins(value));
    });
    var first = list[1];
    // print('GetData Ran\n');
    setState(() {
      _data = list;
      _noOfItem = list.length;
    });
    // print('No of Item is \n$_noOfItem');
  }

  Future again() async {
    sleep(Duration(seconds: 10));
    // print("Run again");
    getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    again();
  }

  @override
  Widget build(BuildContext context) {
    // Do your Previous Works
    // print('No of Item is \n$_noOfItem');
    // Now Return Result
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          '90+ Crypto Currency Prices',
          style: TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.w400,
            fontFamily: 'Ubuntu',
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: ListView.builder(
          itemCount: _noOfItem,
          itemBuilder: (context, index) {
            return HomeCard(_data[index].item['name'], _data[index].item['iso'],
                _data[index].item['ohlc']['c']);
          },
        ), // child: ListView(
      ),
    );
  }
}

class HomeCard extends StatefulWidget {
  String _coinName = "BitCoin", _isoCode = "BTC";
  var _marketCapital;

  HomeCard(this._coinName, this._isoCode, this._marketCapital);

  @override
  State<HomeCard> createState() =>
      _HomeCardState(_coinName, _isoCode, _marketCapital);
}

class _HomeCardState extends State<HomeCard> {
  String _coinName = "BitCoin", _isoCode = "BTC";
  var _marketCapital;

  // dynamic _indicatorColor = Colors.green[700];
  dynamic _indicatorColor = Colors.redAccent[700];
  // Widget percentage = PriceIncriment(0.075);
  Widget percentage = PriceDecrement(-0.954);

  _HomeCardState(this._coinName, this._isoCode, this._marketCapital);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber[300],
      shadowColor: Colors.amberAccent[400],
      child: InkWell(
        splashColor: Colors.amber[400],
        onTap: () {
          Navigator.pushNamed(
            context,
            '/details',
            arguments: {
              'iso': _isoCode,
              'name': _coinName,
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35.0,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      // backgroundColor: Colors.black,
                      backgroundImage: AssetImage(logoPath[_isoCode]!),
                      radius: 34.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    // color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_coinName ($_isoCode)',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 68, 87),
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$$_marketCapital',
                              style: TextStyle(
                                color: Colors.pinkAccent[400],
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Cabin',
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PriceIncriment extends StatelessWidget {
  final _value;
  PriceIncriment(this._value);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.arrow_drop_up, color: Colors.green[700]),
          Text(
            '${this._value}%',
            style: TextStyle(color: Colors.green[700], fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}

class PriceDecrement extends StatelessWidget {
  final dynamic _value;
  const PriceDecrement(this._value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.arrow_drop_down, color: Colors.redAccent[700]),
        Text(
          '$_value%',
          style: TextStyle(color: Colors.redAccent[700], fontSize: 18.0),
        ),
      ],
    );
  }
}
