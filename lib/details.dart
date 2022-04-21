import 'dart:convert';

import 'package:flutter/material.dart';
import 'coin_logos.dart';
import 'package:http/http.dart';

class CoinDetails extends StatefulWidget {
  @override
  State<CoinDetails> createState() => _CoinDetailsState();
}

class _CoinDetailsState extends State<CoinDetails> {
  var data;
  late String name = '';
  double change = 0.0;
  dynamic price = 0, highestPrice = 0, lowestPrice = 0, marketCapital = 0;

  Future getCoinDetails(String iso) async {
    // print('getCoinDetails ($iso)\n');
    Response response = await get(Uri.parse(
        'https://production.api.coindesk.com/v2/tb/price/ticker?assets=$iso'));
    var responseBody = await jsonDecode(response.body);
    if (responseBody == null) return;
    var data = responseBody['data'][iso];

    // print('iso [$iso]');
    // print("name [${data['name']}]");

    setState(() {
      name = data['name'];
      price = data['ohlc']['c'];
      highestPrice = data['ohlc']['h'];
      lowestPrice = data['ohlc']['l'];
      change = data['change']['percent'];
      marketCapital = data['marketCap'];
    });
  }

  @override
  void didChangeDependencies() {
    data = ModalRoute.of(context)?.settings.arguments;
    // print(data['iso']);
    getCoinDetails(data['iso']);

    super.didChangeDependencies();
  }

  void MyCallback() {
    // print('Mycallback() Called');
    getCoinDetails(data['iso']);
  }

  @override
  Widget build(BuildContext context) {
    // print('\nBUILD START\n');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
        title: Text(
          '(${data['iso']}) Price Details',
          style: TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.w500,
            fontFamily: 'Ubuntu',
            // fontSize: 20.0,
          ),
        ),
      ),
      body: DetailsCard(
        iso: data['iso'],
        name: name,
        price: double.parse((price).toStringAsFixed(6)),
        highestPrice: double.parse((highestPrice).toStringAsFixed(3)),
        lowestPrice: double.parse((lowestPrice).toStringAsFixed(3)),
        change: double.parse((change).toStringAsFixed(2)),
        marketCapital: marketCapital,
        callback: MyCallback,
        // iso: 'BTC',
        // name: 'Bitcoin',
        // price: 41066.05,
        // highestPrice: 41378.3,
        // lowestPrice: 39275.8,
        // change: double.parse((change).toStringAsFixed(2)),
        // // change: 2.3192858139488677,
        // marketCapital: 780663236090.3649,
      ),
    );
  }
}

class DetailsCard extends StatelessWidget {
  final String name, iso;
  final dynamic price, highestPrice, lowestPrice, marketCapital, change;
  final VoidCallback callback;

  const DetailsCard({
    Key? key,
    required this.iso,
    required this.name,
    this.price,
    this.highestPrice,
    this.lowestPrice,
    this.change,
    this.marketCapital,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imgPath = '';
    imgPath = logoPath[iso];
    var priceColor =
        (change > 0) ? Colors.greenAccent[400] : Colors.redAccent[400];
    var changeColor = (change > 0) ? Colors.green[700] : Colors.redAccent[700];
    var changeIcon = (change > 0) ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    // String priceChange = (change > 0) ? 'Large' : 'Small';
    // print('pricechange percent $change');
    // print('priceChange is = $priceChange');
    String marketCap = '';
    double a;
    if (marketCapital > 1000000000) {
      a = double.parse((marketCapital / 1000000000).toStringAsFixed(2));
      marketCap = '$a B';
    } else if (marketCapital > 1000000) {
      a = double.parse((marketCapital / 1000000).toStringAsFixed(2));
      marketCap = '$a M';
    } else if (marketCapital > 1000) {
      a = double.parse((marketCapital / 1000).toStringAsFixed(2));
      marketCap = '$a K';
    } else {
      a = double.parse((marketCapital).toStringAsFixed(2));
      marketCap = '$a';
    }

    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coin Details Container
          Container(
            // color: Colors.blueGrey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(imgPath!),
                  radius: 32.0,
                  // child: CircleAvatar(
                  //   radius: 30.0,
                  //   backgroundImage: AssetImage('images/logo/default.png'),
                  // ),
                ),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '($iso)',
                      style: TextStyle(
                        color: Colors.amber[300],
                        fontWeight: FontWeight.w500,
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      name,
                      // 'Basic Attention Token',
                      style: TextStyle(
                        color: Colors.amber[400],
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 15.0),

          // Coin Price
          Text(
            '\$$price',
            style: TextStyle(
              // color: Colors.redAccent[400],
              color: priceColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 40.0,
            ),
          ),

          // Price Change Box
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Change in 24Hr : ',
                style: TextStyle(color: Colors.grey[500]),
              ),
              Icon(
                changeIcon,
                color: changeColor,
                size: 30.0,
              ),
              Text(
                '${change}%',
                style: TextStyle(
                  color: changeColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10.0),

          const Divider(
            height: 30.0,
            thickness: 2.0,
            color: Colors.white,
          ),

          // Highest Price
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Highest(24Hr)',
                style: TextStyle(
                  color: Colors.blue[100],
                  fontSize: 18.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 6, 0),
                child: Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: Colors.blue[100],
                ),
              ),
              Text(
                '\$$highestPrice',
                style: TextStyle(
                  color: Colors.amber[300],
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10.0),

          // Lowest Price
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$$lowestPrice',
                style: TextStyle(
                  color: Colors.amber[300],
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(6, 0, 2, 0),
                child: Icon(Icons.keyboard_double_arrow_left_rounded,
                    color: Colors.blue[100]),
              ),
              Text(
                'Lowest(24Hr)',
                style: TextStyle(
                  color: Colors.blue[100],
                  fontSize: 18.0,
                ),
              ),
            ],
          ),

          // Last
          const SizedBox(height: 20.0),

          const Center(
            child: Text(
              'Market Capital (approx.)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),

          SizedBox(height: 3.0),

          Center(
            child: Text(
              '\$$marketCap',
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: 30.0,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Divider(height: 30.0, thickness: 2.0, color: Colors.white),

          // The Refresh button
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.tealAccent),
                        // fixedSize: MaterialStateProperty.all(),
                      ),
                      onPressed: () {
                        // print('Refresh Price');
                        callback();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 25.0,
                            color: Colors.brown[800],
                          ),
                          SizedBox(width: 2.0),
                          Text(
                            'Refresh',
                            style: TextStyle(
                              color: Colors.brown[800],
                              fontSize: 20.0,
                              fontFamily: 'Ubuntu',
                              // letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
