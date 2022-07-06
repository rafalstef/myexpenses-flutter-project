import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle titleX(Color color) {
    return TextStyle(
      color: color,
      fontSize: 64,
      height: 1.25,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle title1(Color color) {
    return TextStyle(
      color: color,
      fontSize: 32,
      height: 1.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle title2(Color color) {
    return TextStyle(
      color: color,
      fontSize: 24.0,
      height: 1.2,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle title3(Color color) {
    return TextStyle(
      color: color,
      fontSize: 18.0,
      height: 1.2,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle regular(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16.0,
      height: 1.2,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle regularMedium(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16.0,
      height: 1.2,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle regularSemiBold(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16.0,
      height: 1.2,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle regularBold(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16.0,
      height: 1.2,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle small(Color color) {
    return TextStyle(
      color: color,
      fontSize: 14.0,
      height: 1.2,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle smallMedium(Color color) {
    return TextStyle(
      color: color,
      fontSize: 14.0,
      height: 1.2,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle smallSemiBold(Color color) {
    return TextStyle(
      color: color,
      fontSize: 14.0,
      height: 1.2,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle smallBold(Color color) {
    return TextStyle(
      color: color,
      fontSize: 14.0,
      height: 1.2,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle tiny(Color color) {
    return TextStyle(
      color: color,
      fontSize: 12.0,
      height: 1.0,
      fontWeight: FontWeight.normal,
    );
  }
}
