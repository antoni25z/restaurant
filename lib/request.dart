import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/response/detail_response.dart';
import 'package:restaurant/response/list_response.dart';
import 'package:restaurant/response/search_response.dart';

const String baseUrl = "https://restaurant-api.dicoding.dev/";

Future<ListResponse> fetchAllRestaurants() async {
  final response = await http.get(Uri.parse("${baseUrl}list"));
  final jsonMap = json.decode(response.body);
  return ListResponse.fromJson(jsonMap);
}

Future<DetailResponse> fetchDetailRestaurant(String? id) async {
  final response = await http.get(Uri.parse("${baseUrl}detail/$id"));
  final jsonMap = json.decode(response.body);
  return DetailResponse.fromJson(jsonMap);
}

Future<SearchResponse> searchRestaurant(String nama) async {
  final response = await http.get(Uri.parse("${baseUrl}search?q=$nama"));
  final jsonMap = json.decode(response.body);
  return SearchResponse.fromJson(jsonMap);
}