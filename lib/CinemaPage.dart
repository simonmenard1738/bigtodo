import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;


class CinemaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CinemaScreen(),
    );
  }
}

class CinemaScreen extends StatefulWidget {
  @override
  _CinemaScreenState createState() => _CinemaScreenState();
}

class _CinemaScreenState extends State<CinemaScreen> {
  GoogleMapController? mapController; // Initialize to null
  Location location = Location();
  LocationData? currentLocation; // Initialize to null

  Set<Marker> cinemaMarkers = Set();

  void _updateCinemaMarkers(LatLng userLocation) async {
    List<LatLng> cinemaLocations = await _searchCinemas(userLocation);
    setState(() {
      cinemaMarkers = Set.from(cinemaLocations.map((location) {
        return Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(title: "Cinema"),
        );
      }));
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _getLocation() async {
    try {
      LocationData locationResult = await location.getLocation();
      setState(() {
        currentLocation = locationResult;
      });

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                currentLocation?.latitude ?? 0.0,
                currentLocation?.longitude ?? 0.0,
              ),
              zoom: 15.0,
            ),
          ),
        );
        _updateCinemaMarkers(LatLng(
          currentLocation?.latitude ?? 0.0,
          currentLocation?.longitude ?? 0.0,
        ));
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<List<LatLng>> _searchCinemas(LatLng userLocation) async {
    final String apiKey = 'AIzaSyCH37RaTHRj4hZRwNAXIhC_yKIFykPhhNo';
    final String baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

    final String location = '${userLocation.latitude},${userLocation.longitude}';
    final int radius = 500;
    final String types = 'movie_theater';

    final String url = '$baseUrl?location=$location&radius=$radius&type=$types&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        List<dynamic> results = data['results'];
        List<LatLng> cinemaLocations = results.map((result) {
          double lat = result['geometry']['location']['lat'];
          double lng = result['geometry']['location']['lng'];
          return LatLng(lat, lng);
        }).toList();

        return cinemaLocations;
      } else {
        print('Failed to fetch nearby places. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in API request: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map screen'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: currentLocation != null
            ? CameraPosition(
          target: LatLng(
            currentLocation!.latitude?? 0.0,
            currentLocation!.longitude?? 0.0,
          ),
          zoom: 15.0,
        )
            : CameraPosition(
          target: LatLng(0.0, 0.0),
          zoom: 2.0,
        ),
        myLocationEnabled: true,
        mapType: MapType.normal,
        markers: currentLocation != null
            ? Set.from([
          Marker(
            markerId: MarkerId("userLocation"),
            position: LatLng(
              currentLocation!.latitude ?? 0.0,
              currentLocation!.longitude ?? 0.0,
            ),
            infoWindow: InfoWindow(title: "Your Location"),
          ),
        ])
            : Set(),
      ),
    );
  }
}
