import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerServices{

  static Future<bool> checkLocationPermission() async {
    final PermissionStatus status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    }
    if (status.isDenied || status.isRestricted) {
      final PermissionStatus newStatus = await Permission.location.request();
      return newStatus.isGranted;
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return false;
  }


}