import 'package:doors/core/services/permission_handler_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorServices{
static Position? locationPosition;

  static Future<Position?> fetchCurrentLocation() async{
    try{
        if(await PermissionHandlerServices.checkLocationPermission()) {
          final serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            await Geolocator.openLocationSettings();
            return null;
          }
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
          locationPosition = position;
          return position;
        }
        return null;
    }catch (ex){
      debugPrint("Exception occurred while fetching current location $ex");
      return null;
    }
  }
}