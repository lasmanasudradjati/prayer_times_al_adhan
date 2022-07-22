import 'package:flutter/material.dart';
import 'package:prayer_times_al_adhan/src/home/home_view.dart';
import 'package:prayer_times_al_adhan/src/theme/prayer_times_theme.dart';

class PrayerTimesAlAdhan extends StatelessWidget {
  const PrayerTimesAlAdhan({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayer Times Al Adhan',
      theme: PrayerTimesTheme().prayerTimesTheme,
      home: const HomeView(
        title: 'Prayer Times',
      ),
    );
  }
}
