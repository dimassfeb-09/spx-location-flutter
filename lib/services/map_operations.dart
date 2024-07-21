import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

class MapOperations {
  HereMapController? _hereMapController;

  Future<void> onMapCreated(HereMapController hereMapController) async {
    _hereMapController = hereMapController;

    try {
      Position currentPosition = await _getCurrentPosition();
      _hereMapController?.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError? error) {
        if (error != null) {
          print('Map scene not loaded. MapError: ${error.toString()}');
          return;
        }
        _updateMap(currentPosition.latitude, currentPosition.longitude);
      });
    } catch (e) {
      print('Error initializing map: $e');
    }
  }

  Future<void> onLocationButtonPressed() async {
    if (_hereMapController == null) return;

    try {
      Position currentPosition = await _getCurrentPosition();
      _updateMap(currentPosition.latitude, currentPosition.longitude);
    } catch (e) {
      print('Error getting current position: $e');
    }
  }

  void addMarkerToMap(double latitude, double longitude) {
    if (_hereMapController == null) return;

    GeoCoordinates markerCoordinates = GeoCoordinates(latitude, longitude);
    MapImage markerImage = MapImage.withFilePathAndWidthAndHeight(
      "assets/coodinate_shopee.png",
      80,
      80,
    );

    MapMarker marker = MapMarker(markerCoordinates, markerImage);
    _hereMapController!.mapScene.addMapMarker(marker);
  }

  void _lookAtPointWithMeasure({
    required double latitude,
    required double longitude,
    double mapMeasureZoom = 8000.0,
  }) {
    if (_hereMapController == null) return;

    MapMeasure mapMeasure = MapMeasure(MapMeasureKind.distance, mapMeasureZoom);
    _hereMapController!.camera.lookAtPointWithMeasure(GeoCoordinates(latitude, longitude), mapMeasure);
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    await _checkAndRequestPermission();

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  void _updateMap(double latitude, double longitude) {
    if (_hereMapController != null) {
      _animateToLocation(
        latitude: latitude,
        longitude: longitude,
        mapMeasureZoom: 1000,
      );
      _lookAtPointWithMeasure(
        latitude: latitude,
        longitude: longitude,
        mapMeasureZoom: 1000.0,
      );
    }
  }

  void _animateToLocation({
    required double latitude,
    required double longitude,
    required double mapMeasureZoom,
  }) {
    GeoCoordinatesUpdate targetCoordinates = GeoCoordinatesUpdate(latitude, longitude);
    MapMeasure mapMeasure = MapMeasure(MapMeasureKind.distance, mapMeasureZoom);
    MapCameraAnimation mapCameraAnimation = MapCameraAnimationFactory.flyToWithZoom(
      targetCoordinates,
      mapMeasure,
      2,
      Duration(seconds: 5),
    );
    _hereMapController?.camera.startAnimation(mapCameraAnimation);
  }
}
