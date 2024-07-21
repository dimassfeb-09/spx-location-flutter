import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/SearchPage.dart';

class GetSearchController extends GetxController {
  var isSearch = false.obs;
  final TextEditingController searchController = TextEditingController();

  void toggleSearch() {
    isSearch.value = !isSearch.value;
  }

  void onSubmitted(String value) {
    Get.to(() => SearchPage(), arguments: value);
    searchController.clear();
    isSearch.value = false;
  }
}
