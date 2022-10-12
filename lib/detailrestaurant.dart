

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider.dart';

class DetailRestaurant extends StatefulWidget {
  const DetailRestaurant({Key? key, required this.restaurantId})
      : super(key: key);

  final String? restaurantId;

  @override
  State<DetailRestaurant> createState() => DetailRestaurantState();
}

class DetailRestaurantState extends State<DetailRestaurant> {
  static const String imageUrl =
      "https://restaurant-api.dicoding.dev/images/large/";

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
    Provider.of<RestaurantProvider>(context, listen: false)
        .getDetailRestaurant(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isOnline
            ? const Center(
                child: Text("No Connection"),
              )
            : Provider.of<RestaurantProvider>(context).isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadiusDirectional.only(
                                bottomStart: Radius.circular(10),
                                bottomEnd: Radius.circular(10)),
                            image: DecorationImage(
                                image: NetworkImage(imageUrl +
                                    Provider.of<RestaurantProvider>(context)
                                        .getDetailResponse()
                                        .restaurant
                                        .pictureId),
                                fit: BoxFit.fill)),
                        child: Stack(
                          children: [
                            Positioned(
                                top: 16,
                                left: 16,
                                width: 50,
                                child: GestureDetector(
                                    onTap: () => {Navigator.pop(context)},
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: SvgPicture.asset(
                                        "assets/images/ic_back.svg",
                                        color: Colors.white,
                                      ),
                                    ))),
                            Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.3)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Provider.of<RestaurantProvider>(context)
                                            .getDetailResponse()
                                            .restaurant
                                            .name,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/ic_location.svg",
                                            width: 15,
                                            height: 15,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Text(
                                              Provider.of<RestaurantProvider>(
                                                      context)
                                                  .getDetailResponse()
                                                  .restaurant
                                                  .city,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                  fontSize: 11),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/ic_star.svg",
                                            width: 15,
                                            height: 15,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, top: 4),
                                            child: Text(
                                              Provider.of<RestaurantProvider>(
                                                      context)
                                                  .getDetailResponse()
                                                  .restaurant
                                                  .rating
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                  fontSize: 11),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 32, top: 16),
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 32, top: 16, right: 32),
                          child: Column(
                            children: [
                              Text(
                                Provider.of<RestaurantProvider>(context)
                                    .getDetailResponse()
                                    .restaurant
                                    .description,
                                style: const TextStyle(
                                    color: Colors.black, fontFamily: 'Poppins'),
                              )
                            ],
                          )),
                      const Padding(
                        padding: EdgeInsets.only(left: 32, top: 32),
                        child: Text(
                          "Our Menu",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      Container(
                          height: 120,
                          padding: const EdgeInsets.only(left: 30, right: 32),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  Provider.of<RestaurantProvider>(context)
                                      .getDetailResponse()
                                      .restaurant
                                      .menus
                                      .foods
                                      .length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: SizedBox(
                                        width: 91,
                                        height: 120,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/food.jpg',
                                              width: 50,
                                              height: 50,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Text(
                                                Provider.of<RestaurantProvider>(
                                                        context)
                                                    .getDetailResponse()
                                                    .restaurant
                                                    .menus
                                                    .foods[index]
                                                    .name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontFamily: 'Poppins'),
                                              ),
                                            )
                                          ],
                                        ),
                                      )))),
                      Container(
                          height: 120,
                          padding: const EdgeInsets.only(left: 30, right: 32),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  Provider.of<RestaurantProvider>(context)
                                      .getDetailResponse()
                                      .restaurant
                                      .menus
                                      .drinks
                                      .length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 91,
                                        height: 120,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/drink.jpg',
                                              width: 50,
                                              height: 50,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Text(
                                                Provider.of<RestaurantProvider>(
                                                        context)
                                                    .getDetailResponse()
                                                    .restaurant
                                                    .menus
                                                    .drinks[index]
                                                    .name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontFamily: 'Poppins'),
                                              ),
                                            )
                                          ],
                                        ),
                                      )))),
                    ],
                  )));
  }
}
