import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late Location location;
  GoogleMapController? googleMapController;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        target: LatLng(30.576898115101887, 31.503215076642572), zoom: 10);
    location = Location();
    updatamylocation();
    super.initState();
  }

  void updatamylocation() async {
    await chechAndRequestLocationService();
    var haspermission = await chechAndRequestLocationpermission();
    if (haspermission) {
      getlocationData();
    }
  }

  Future<void> chechAndRequestLocationService() async {
    bool isserviceenabled = await location.serviceEnabled();
    if (!isserviceenabled) {
      isserviceenabled = await location.requestService();
      if (!isserviceenabled) {
        //  ScaffoldMessenger(child: )
      }
    }
    chechAndRequestLocationpermission();
  }

  Future<bool> chechAndRequestLocationpermission() async {
    var permissoinstatus1 = await location.hasPermission();
    if (permissoinstatus1 == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissoinstatus1 == PermissionStatus.denied) {
      permissoinstatus1 = await location.requestPermission();
      if (permissoinstatus1 != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void getlocationData() {
    location.onLocationChanged.listen(
      (locationData) {
        var cameraposition = CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),zoom: 18);
        googleMapController
            ?.animateCamera(CameraUpdate.newCameraPosition(cameraposition));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (controller) {
        googleMapController = controller;
      },
    );
  }
}

// inquire about location service 
// request permission 
// get location
// display 