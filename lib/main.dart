import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:here_sdk/mapview.dart';

import 'services/location_permission_geolocator.dart';
import 'services/initialized_here_map.dart';
import 'services/map_operations.dart';
import 'services/seller_location.dart';
import 'controllers/search_controller.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  String accessKeyId = dotenv.env['ACCESS_KEY_ID'] ?? 'No API Key';
  String accessKeySecret = dotenv.env['ACCESS_KEY_SECRET'] ?? 'No API Key';

  WidgetsFlutterBinding.ensureInitialized();
  getPermissionLocation();
  initializedHERESDK(accessKeyId, accessKeySecret);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MapOperations mapOperations = MapOperations();
  final GetSearchController searchController = Get.put(GetSearchController());

  @override
  Widget build(BuildContext context) {
    fetchSeller();

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Obx(() => searchController.isSearch.value
              ? TextField(
                  controller: searchController.searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Cari berdasarkan kecamatan atau kota',
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                  onSubmitted: searchController.onSubmitted,
                )
              : const Text("Find Your SPX Location")),
          actions: [
            Obx(() => searchController.isSearch.value
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: searchController.toggleSearch,
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: searchController.toggleSearch,
                  )),
            const SizedBox(width: 16),
          ],
        ),
        body: HereMap(onMapCreated: mapOperations.onMapCreated),
        floatingActionButton: FloatingActionButton(
          onPressed: mapOperations.onLocationButtonPressed,
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }

  void fetchSeller() async {
    var sellerLocationResponse = await fetchSellerLocations();
    for (var seller in sellerLocationResponse) {
      double latitude = seller.latitude;
      double longitude = seller.longitude;
      mapOperations.addMarkerToMap(latitude, longitude);
    }
  }
}
