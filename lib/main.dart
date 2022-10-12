import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/detailrestaurant.dart';
import 'package:restaurant/provider.dart';
import 'package:restaurant/response/list_response.dart';
import 'package:restaurant/search_restaurant.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => RestaurantProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Restaurant'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isOnline = true;

  Future check() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        isOnline = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    check();
    Provider.of<RestaurantProvider>(context, listen: false).getAllRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 12, right: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) =>
                                  const SearchRestaurant(),
                              transitionsBuilder: (c, anim, a2, child) =>
                                  FadeTransition(opacity: anim, child: child),
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ));
                      },
                      splashColor: Colors.white10,
                      child: SvgPicture.asset(
                        "assets/images/search.svg",
                        width: 24,
                        height: 24,
                        color: Colors.black38,
                      ),
                    ))
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Text(
                "Recomendation restaurant for you!",
                style: TextStyle(
                    fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
              ),
            ),
            !isOnline
                ? const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text("No Connection"),
                    ),
                  )
                : Provider.of<RestaurantProvider>(context).isLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: Provider.of<RestaurantProvider>(context)
                                .getListResponse()
                                .restaurants
                                .length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (c, a1, a2) =>
                                            DetailRestaurant(
                                          restaurantId:
                                              Provider.of<RestaurantProvider>(
                                                      context)
                                                  .getListResponse()
                                                  .restaurants[index]
                                                  .id,
                                        ),
                                        transitionsBuilder:
                                            (c, anim, a2, child) =>
                                                FadeTransition(
                                                    opacity: anim,
                                                    child: child),
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                      )),
                                },
                                child: RestaurantLayout(
                                    restaurants:
                                        Provider.of<RestaurantProvider>(context)
                                            .getListResponse()
                                            .restaurants,
                                    position: index),
                              );
                            }))
          ],
        ));
  }
}

class RestaurantLayout extends StatelessWidget {
  final int position;
  final List<Restaurant>? restaurants;

  static const String imageUrl =
      "https://restaurant-api.dicoding.dev/images/small/";

  const RestaurantLayout(
      {Key? key, required this.restaurants, required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      height: 130,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        imageUrl + restaurants![position].pictureId,
                        fit: BoxFit.cover,
                      ),
                    )),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurants![position].name,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color.fromRGBO(34, 34, 34, 1)),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/ic_location.svg",
                            width: 15,
                            height: 15,
                            color: Colors.black38,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              restaurants![position].city,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black38,
                                  fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(207, 75, 0, 1),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, bottom: 8),
                              child: SvgPicture.asset(
                                "assets/images/ic_star.svg",
                                width: 15,
                                height: 15,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                restaurants![position].rating.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
