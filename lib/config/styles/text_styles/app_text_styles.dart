import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle titleX(Color color) {
    return TextStyle(
      color: color,
      fontSize: 64,
      height: 1.25,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle title1(Color color) {
    return TextStyle(
      color: color,
      fontSize: 32,
      height: 1.0,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle title2(Color color) {
    return TextStyle(
      color: color,
      fontSize: 24.0,
      height: 1.0,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle title3(Color color) {
    return TextStyle(
      color: color,
      fontSize: 18.0,
      height: 1.2,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle regular(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16.0,
      height: 1.2,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle regularMedium(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16.0,
      height: 1.2,
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle regularSemiBold(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16.0,
      height: 1.2,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle regularBold(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16.0,
      height: 1.2,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle small(Color color) {
    return TextStyle(
      color: color,
      fontSize: 14.0,
      height: 1.2,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle smallMedium(Color color) {
    return TextStyle(
      color: color,
      fontSize: 14.0,
      height: 1.2,
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle smallBold(Color color) {
    return TextStyle(
      color: color,
      fontSize: 14.0,
      height: 1.2,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle tiny(Color color) {
    return TextStyle(
      color: color,
      fontSize: 12.0,
      height: 1.0,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }
}
