import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CinemaPage extends StatefulWidget {
  @override
  _CinemaPageState createState() => _CinemaPageState();
}

class _CinemaPageState extends State<CinemaPage> {
  late Future<List<String>> _cinemas;

  @override
  void initState() {
    super.initState();
    _cinemas = _getNearbyCinemas();
  }

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<List<String>> _getNearbyCinemas() async {
    try {
      final Position position = await _getCurrentLocation();
      final apiKey = 'AIzaSyCH37RaTHRj4hZRwNAXIhC_yKIFykPhhNo';
      final radius = 5000; // in meters

      final response = await http.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
            '?location=${position.latitude},${position.longitude}'
            '&radius=$radius'
            '&type=movie_theater'
            '&key=$apiKey' as Uri,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map<String>((result) => result['name'].toString()).toList();
      } else {
        throw Exception('Failed to load nearby cinemas');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _cinemas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final List<String> cinemas = snapshot.data as List<String>;
              return ListView.builder(
                itemCount: cinemas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(cinemas[index]),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }
}

