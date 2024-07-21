import 'package:geolocator/geolocator.dart';

Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  return true;
}

Future<bool> getPermissionLocation() async {
  return await _handleLocationPermission();
}

Future<Position?> getCurrentPosition() async {
  try {
    Position? _currentPosition;
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return _currentPosition;
  } catch (e) {
    return null;
  }
}
