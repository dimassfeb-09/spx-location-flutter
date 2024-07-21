import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/SellerLocation.dart';
import '../services/seller_location.dart';

class SearchPage extends StatelessWidget {
  final String searchQuery = Get.arguments as String;
  final RxBool _isLoading = true.obs;
  final RxList<SellerLocation?> _sellerLocation = <SellerLocation>[].obs;

  @override
  Widget build(BuildContext context) {
    _fetchSellerByQuery();

    return Scaffold(
      appBar: AppBar(
        title: Text.rich(TextSpan(text: "Pencarian ", children: [
          TextSpan(text: searchQuery, style: const TextStyle(fontWeight: FontWeight.bold)),
        ])),
      ),
      body: Obx(
        () {
          if (_isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (_sellerLocation.isEmpty) {
            return Center(
              child: Text("Data seller di $searchQuery tidak ditemukan."),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                final seller = _sellerLocation[index];
                return Container(
                  height: 140,
                  width: Size.infinite.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 2,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/coodinate_shopee.png", height: 20, width: 20),
                          const SizedBox(width: 5),
                          Text(seller!.sellerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(seller.address, style: const TextStyle(fontSize: 10)),
                      const SizedBox(height: 5),
                      Text("Titik Koordinat: ${seller.latitude},${seller.longitude}", style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              },
              itemCount: _sellerLocation.length,
            );
          }
        },
      ),
    );
  }

  void _fetchSellerByQuery() async {
    _isLoading.value = true;
    final seller = await fetchSellerLocationsByQuery(searchQuery);
    if (seller != null) {
      _sellerLocation.value = seller;
    } else {
      _sellerLocation.clear();
    }
    _isLoading.value = false;
  }
}
