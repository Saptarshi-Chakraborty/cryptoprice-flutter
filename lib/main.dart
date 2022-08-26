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
        'https://production.api.coindesk.com/v2/tb/price/ticker?assets=AAVE,ALGO,AMP,ANKR,ANT,REP,AVAX,AXS,BAND,BAT,BCH,BNT,BSV,BTC,BTG,BTT,ADA,ATOM,CELO,CHZ,COMP,COTI,CRV,CVC,LINK,DAI,DASH,DCR,MANA,DNT,DOGE,ENJ,EOS,ETC,ETH,MLN,FET,FIL,ICP,ICX,IOTA,IOTX,KAVA,KEEP,KNC,KSM,LPT,LRC,LSK,LTC,MKR,XMR,NANO,NEO,NKN,NMR,NU,OMG,OXT,PAXG,DOT,MATIC,QTUM,REN,RLC,SAND,SC,SHIB,SKL,SNGLS,SNX,SOL,XLM,STORJ,SUSHI,TRX,GRT,LUNA,XTZ,UMA,UNI,USDC,USDT,UST,WAVES,WBTC,XEM,XRP,XYO,YFI,ZEC,ZRX'));
    // Response response = await get(Uri.parse(
    //     'https://production.api.coindesk.com/v2/tb/price/ticker?assets=BTC,ETH,XRP,BCH,ADA,XLM,NEO,LTC,EOS,XEM,IOTA,DASH,XMR,TRX,ICX,ETC,QTUM,BTG,VET,LSK,USDT,OMG,STEEM,ZEC,SC,BNB,XVG,ZRX,REP,WAVES,MKR,DCR,BAT,DGB,LRC,KNC,SYS,BNT,REQ,LINK,QSP,CVC,RLC,ENJ,STORJ,ANT,SNGLS,THETA,MANA,MLN,DNT,AMP,NMR,STX,POLIS,DOT,DAI,UNI,ATOM,GRT,LUNA,SCRT,IMX,ZIL,XTZ,FIL,OP,NANO,WBTC,BSV,DOGE,USDC,OXT,ALGO,BAND,BTT,FET,KAVA,USDP,PAXG,REN,AAVE,YFI,NU,MATIC,ICP,SOL,SUSHI,UMA,SNX,CRV,COMP,CELO,KSM,NKN,SHIB,SKL,SAND,UST,AVAX,IOTX,AXS,XYO,ANKR,CHZ,LPT,COTI,KEEP,GALA,CRO,ACHP,JASMY,SLP,APE,BUSD,CAKE,EGLD,ENS,FTM,FTT,HBAR,MBOX,MINA,MOVR,NEAR,NEXO,POLS,QNT,QUICK,RUNE,RVN,WAXP,WRX,XEC,CEL,ALPACA,AUDIO,AVA,CHR,CKB,CLV,FARM,FLOW,GLMR,IDEX,INJ,JOE,MIR,POLY,PYR,RARE,RAY,ROSE,SFP,SRM,STMX,SUN,SXP,VGX,WOO,YGG,LUNC,DLCS,MTVS,DFX,SCPX,SCPXX,DIGS,CCYS,CCYX,CPUS,CNES,CMI,CMIX,SMT,CCY,CCX,DTZ,DCF,CPU,CNE'));

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
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(logoPath[_isoCode]!),
                    radius: 34.0,
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
                            // color: Color.fromARGB(255, 0, 68, 87),
                            color: Colors.pinkAccent[400],
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
                                // color: Colors.pinkAccent[400],
                                color: Colors.grey[900],
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Ubuntu',
                                letterSpacing: 0.0,
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
