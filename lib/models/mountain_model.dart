import 'package:flutter/material.dart';
import 'package:flutter_mountain_view/mountain_page/mountain_page.dart';

class MountainModel {
  GlobalKey<MountainPageState> key;
  String name;
  Color backgroundColor;
  String assetPath;
  String height;
  String rank;
  String coordinates;

  MountainModel(
      name, Color backgroundColor, assetPath, height, rank, coordinates) {
    key = new GlobalKey();
    this.name = name;
    this.backgroundColor = backgroundColor;
    this.assetPath = assetPath;
    this.height = height;
    this.rank = rank;
    this.coordinates = coordinates;
  }
}
