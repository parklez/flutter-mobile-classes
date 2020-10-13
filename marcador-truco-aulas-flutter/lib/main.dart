import 'package:flutter/material.dart';
import 'package:marcador_truco/views/home_page.dart';
import 'package:screen/screen.dart';


void main() {
  Screen.keepOn(true);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marcador de Truco',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    ),
  );
}
