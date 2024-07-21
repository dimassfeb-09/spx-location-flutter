import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/SellerLocation.dart';

Future<List<SellerLocation>> fetchSellerLocations() async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/seller'));
    final List<dynamic> responseJson = jsonDecode(response.body)["data"];
    return SellerLocation.fromJsonList(responseJson);
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<List<SellerLocation>?> fetchSellerLocationsByQuery(String query) async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/seller/search?q=$query'));

    final List<dynamic> seller = [];
    final List<dynamic>? responseJson = jsonDecode(response.body)["data"];

    responseJson?.forEach((value) {
      seller.add(value["seller_info"]);
    });

    return SellerLocation.fromJsonList(seller);
  } catch (e) {
    return null;
  }
}
