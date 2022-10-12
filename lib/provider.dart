
import 'package:flutter/material.dart';
import 'package:restaurant/request.dart';
import 'package:restaurant/response/detail_response.dart';
import 'package:restaurant/response/list_response.dart';
import 'package:restaurant/response/search_response.dart';

class RestaurantProvider extends ChangeNotifier{

  SearchResponse searchResponse = SearchResponse(error: true, founded: 0, restaurants: []);
  ListResponse listResponse = ListResponse(error: true, message: "", count: 0, restaurants: []);
  DetailResponse detailResponse = DetailResponse(error: true, message: "", restaurant: RestaurantDetail(id: "", name: "", description: "", city: "", address: "", pictureId: "", categories: [], menus: Menus(foods: [], drinks: []), rating: 0.0, customerReviews: []));
  bool isLoading = true;

  SearchResponse getSearchResponse() {
    return searchResponse;
  }

  ListResponse getListResponse() {
    return listResponse;
  }

  DetailResponse getDetailResponse() {
    return detailResponse;
  }


  void setLoading(bool load) {
    isLoading = load;
    notifyListeners();
  }

  void search(String searchValue) {
      searchRestaurant(searchValue)
          .then((value) => searchResponse = value)
          .whenComplete(() =>
      {
        isLoading = false,
        notifyListeners()
      });
  }

  void getAllRestaurant() {
    fetchAllRestaurants().then((value) => listResponse = value).whenComplete(() => {
      isLoading = false,
      notifyListeners()
    });
  }

  void getDetailRestaurant(String? id) {
    isLoading = true;
    //notifyListeners();
    fetchDetailRestaurant(id).then((value) => detailResponse = value).whenComplete(() => {
      isLoading = false,
      notifyListeners()
    });
  }
}