import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

Widget openStreetMap({required List<Map<String, double>> coordinates}) {
  // Check if coordinates list is not empty before accessing it
  if (coordinates.isEmpty) {
    return Center(child: Text('No coordinates available'));
  }

  final List<LatLng> markerPosition = coordinates.map((value) {
    return LatLng(value['lat']!, value['lon']!);
  }).toList();

  // Calculate initial center (you could calculate the center dynamically)
  Rx<LatLng> initialCenter =
      markerPosition.isNotEmpty ? markerPosition[0].obs : LatLng(0.0, 0.0).obs;

  return Obx(
    () => FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter.value, // Set the initial center here
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: markerPosition.map((position) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point: position,
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
