import 'package:flutter/material.dart';

abstract class AppRadius {
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 14;
  static const double pill = 24;

  static const BorderRadius input = BorderRadius.all(Radius.circular(md));
  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius pillShape = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius heroBottom = BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );
}
