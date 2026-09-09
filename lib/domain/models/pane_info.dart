import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

class PaneInfo {
  final Widget? icon;
  final String title;
  final Widget? child;
  final List<PaneInfo> children;

  const PaneInfo({
    this.icon,
    required this.title,
    this.child,
    this.children = const [],
  });

  bool get isParent => children.isNotEmpty;
}
