import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prayer_times_al_adhan/src/model/prayer_times_by_city_model.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const String baseUrl = 'http://api.aladhan.com/v1/';

  late Future<PrayerTimesByCityModel> prayerTimesByCity;

  String city = 'Bandung';
  String country = 'Indonesia';
  String method = '8';

  @override
  void initState() {
    prayerTimesByCity = fetchPrayerTimesByCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              fetchPrayerTimesByCity();
              _refresh();
            },
            icon: const Icon(Icons.refresh_outlined),
          )
        ],
      ),
      body: FutureBuilder<PrayerTimesByCityModel>(
        future: prayerTimesByCity,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTimingsListTile(
                      'Imsak', snapshot.data!.data!.timings!.imsak!),
                  _buildTimingsListTile(
                      'Fajr', snapshot.data!.data!.timings!.fajr!),
                  _buildTimingsListTile(
                      'Sunrise', snapshot.data!.data!.timings!.sunrise!),
                  _buildTimingsListTile(
                      'Dhuhr', snapshot.data!.data!.timings!.dhuhr!),
                  _buildTimingsListTile(
                      'Asr', snapshot.data!.data!.timings!.asr!),
                  _buildTimingsListTile(
                      'Maghrib', snapshot.data!.data!.timings!.maghrib!),
                  _buildTimingsListTile(
                      'Isha', snapshot.data!.data!.timings!.isha!),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<PrayerTimesByCityModel> fetchPrayerTimesByCity() async {
    String url = 'timingsByCity?city=$city&country=$country&method=$method';

    final response = await http.get(
      Uri.parse(baseUrl + url),
    );

    if (kDebugMode) {
      print('Status: ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      return PrayerTimesByCityModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to load');
    }
  }

  Widget _buildTimingsListTile(String title, String timing) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              timing,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }

  void _refresh() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshed'),
      ),
    );
  }
}
