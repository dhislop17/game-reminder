import 'package:flutter/material.dart';

class Themes {
  static Color nhlRed = Color(0xFFCE1126);
  static Color eastRed = Color(0xFFC31432);
  static Color westBlue = Color(0XFF19497C);

  static Map<String, List<Color>> teamColors = {
    'ANA': [Color(0xFFF47A38), Colors.black],
    'ARI': [Color(0xFF8C2633), Color(0xFFE2D6B5)],
    'BOS': [Colors.black, Color(0xFFFFB81C)],
    'BUF': [Color(0xFF002654), Color(0xFFFCB514)],
    'CGY': [Color(0xFFC8102E), Color(0xFFF1BE48)],
    'CAR': [Color(0xFFCC0000), Colors.black],
    'CHI': [Color(0xFFCF0A2C), Colors.black],
    'COL': [Color(0xFF6F263D), Color(0xFF236192)],
    'CBJ': [Color(0xFF002654), Color(0xFFC31126)],
    'DAL': [Color(0xFF006847), Color(0xFF8F8F8C)],
    'DET': [nhlRed, Colors.white],
    'EDM': [Color(0xFF041E42), Color(0xFFFF4C00)],
    'FLA': [Color(0xFF041E42), Color(0xFFC8102E)],
    'LAK': [Colors.black, Color(0XFFA2AAAD)],
    'MIN': [Color(0xFF154734), Color(0xFFA6192E)],
    'MTL': [Color(0xFFAF1E2D), Color(0xFF192168)],
    'NSH': [Color(0xFFFFB81C), Color(0xFF041E42)],
    'NJD': [nhlRed, Colors.black],
    'NYI': [Color(0xFF00539B), Color(0xFFF47D30)],
    'NYR': [Color(0xFF0038A8), nhlRed],
    'OTT': [Color(0xFFC52032), Color(0xFFC2912C)],
    'PHI': [Color(0xFFF74902), Colors.black],
    'PIT': [Colors.black, Color(0xFFCFC493)],
    'SEA': [Color(0xFF001628), Color(0xFF99D9D9)],
    'STL': [Color(0xFF002F87), Color(0xFFFCB514)],
    'SJS': [Color(0xFF006D75), Color(0xFFEA7200)],
    'TBL': [Color(0xFF002868), Colors.white],
    'TOR': [Color(0xFF00205B), Colors.white],
    'VAN': [Color(0xFF002056), Color(0xFF00843D)],
    'VGK': [Color(0xFFB4975A), Color(0xFF333F42)],
    'WSH': [Color(0xFF041E42), Color(0xFFC8102E)],
    'WPG': [Color(0xFF041E42), Color(0xFFAC162C)]
  };

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepOrange,
    textTheme: TextTheme(
        headline6: TextStyle(fontSize: 36),
        subtitle2: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyText2: TextStyle(fontSize: 16),
        bodyText1: TextStyle(fontSize: 15)),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepOrange,
    textTheme: TextTheme(
        headline6: TextStyle(fontSize: 36),
        subtitle2: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyText2: TextStyle(fontSize: 16),
        bodyText1: TextStyle(fontSize: 15)),
  );
}
