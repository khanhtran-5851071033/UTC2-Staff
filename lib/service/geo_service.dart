
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GeoService {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Future<Position> getCurrentLocation() async {
    var isEnabled = await geolocator.isLocationServiceEnabled();
    var permission = await geolocator.checkGeolocationPermissionStatus();
    if (permission == GeolocationStatus.denied ||
        permission == GeolocationStatus.denied)
      await Permission.location.request();
    Position curLocation;
   

    if (permission == GeolocationStatus.granted) {
      if (isEnabled) {
        
        curLocation = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        return curLocation;
      } else
        return null;
    } else
      return null;
  }
}
