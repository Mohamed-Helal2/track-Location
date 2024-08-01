import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tracklocation/utils/location_service.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late LocationService locationService;
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;
  Set<Marker> markers = {};
  bool isfirstCall = true;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        target: LatLng(30.576898115101887, 31.503215076642572), zoom: 10);
    locationService = LocationService();
    updatamylocation();
    super.initState();
  }

  void updatamylocation() async {
    await locationService.chechAndRequestLocationService();
    var haspermission =
        await locationService.chechAndRequestLocationpermission();
    if (haspermission) {
      locationService.getlocationData(
        (locationData) {
          LatLng latLng =
              LatLng(locationData.latitude!, locationData.longitude!);
          addMarker(latLng);

          setCameraPosition(latLng);
        },
      );
    }
  }

  void setCameraPosition(LatLng latLng) {
    if (isfirstCall) {
      var cameraposition = CameraPosition(target: latLng, zoom: 18);
      googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraposition));
      isfirstCall = false;
    } else {
      googleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    }
  }

  void addMarker(LatLng latLng) {
    Marker mymarker = Marker(
        markerId: const MarkerId("My location Marker "), position: latLng);
    markers.add(mymarker);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
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