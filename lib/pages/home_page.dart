import 'package:crypto_app/components/crypto_list_tile.dart';
import 'package:crypto_app/models/crypto_listing_model.dart';
import 'package:crypto_app/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<CryptoListingModel>> cryptoListingFuture;

  @override
  void initState() {
    super.initState();
    cryptoListingFuture = dowloadCryptoData();
  }

  Future<List<CryptoListingModel>> dowloadCryptoData() async {
    final url = Uri.parse(
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest");
    final response = await http.get(url,
        headers: {"X-CMC_PRO_API_KEY": "267c82df-8400-4b5f-8385-d72750866405"});

    final jsonData = jsonDecode(response.body);
    final cryptoListings =
        (jsonData["data"] as List<dynamic>).map((cryptoData) {
      return CryptoListingModel.fromData(cryptoData);
    }).toList();

    return cryptoListings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBackgroundColor,
      appBar: appBar(),
      body: body(),
    );
  }

  AppBar appBar() => AppBar(
        backgroundColor: ThemeColors.cardBackgroundColor,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.refresh),
        ),
        title: Text(
          "BINANCE",
          style: TextStyle(
            letterSpacing: 5,
            color: Colors.yellow,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1669058665299-d6f81125dce7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Il mio saldo",
                        style: TextStyle(color: Colors.white54)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "£ 7540.00",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget body() => Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: ThemeColors.cardBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -2),
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            bodyHeader(),
            Divider(),
            bodyContent(),
          ],
        ),
      );

  Widget bodyHeader() => Container(
        child: ListTile(
          title: Text(
            "Lista Crypto",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Basato sulle top 100"),
          trailing: Text("Mostra tutte"),
        ),
      );

  Widget bodyContent() => Expanded(
          child: FutureBuilder<List<CryptoListingModel>>(
        future: cryptoListingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => CryptoListTile(
                symbol: snapshot.data![index].symbol,
                name: snapshot.data![index].name,
                price: snapshot.data![index].price,
                variation24Hours: snapshot.data![index].variantionLast24Hours,
              ),
              separatorBuilder: (context, index) => Divider(),
            );
          }
        },
      ));
}
