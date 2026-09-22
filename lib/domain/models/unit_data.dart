import 'package:flutter/material.dart';
import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';

class UnitData {
  final String headline;
  final String subtitle;
  final String badgeText;
  final IconData badgeIcon;
  final Color accentColor;
  final List<MilestoneAchievement> achievements;
  final String nextUnitTitle;
  final String nextUnitDescription;

  const UnitData({
    required this.headline,
    required this.subtitle,
    required this.badgeText,
    required this.badgeIcon,
    required this.accentColor,
    required this.achievements,
    required this.nextUnitTitle,
    required this.nextUnitDescription,
  });
}
