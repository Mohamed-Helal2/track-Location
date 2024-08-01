 import 'package:location/location.dart';

class LocationService {
    Location location = Location();


  Future<bool> chechAndRequestLocationService() async {
    bool isserviceenabled = await location.serviceEnabled();
    if (!isserviceenabled) {
      isserviceenabled = await location.requestService();
      if (!isserviceenabled) {
        return false;
      }
    }
    //chechAndRequestLocationpermission();
    return true;
  }

  Future<bool> chechAndRequestLocationpermission() async {
    var permissoinstatus1 = await location.hasPermission();
    if (permissoinstatus1 == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissoinstatus1 == PermissionStatus.denied) {
      permissoinstatus1 = await location.requestPermission();

      return permissoinstatus1 == PermissionStatus.granted;
    }
    return true;
  }

  void getlocationData(
    void Function(LocationData)? onData,
  ) {
    // interval : كل قد ايه يبص ع location
    //location.changeSettings(distanceFilter: 40,);
    location.onLocationChanged.listen(onData);
  }
}
