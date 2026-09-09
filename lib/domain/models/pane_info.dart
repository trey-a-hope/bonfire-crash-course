import 'package:flutter/material.dart';

class PaneInfo {
  final Widget icon;
  final String title;
  final Widget? child;

  const PaneInfo({required this.icon, required this.title, this.child});
}
