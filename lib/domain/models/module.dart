import 'package:bonfire_crash_course/presentation/lotties/i_lottie.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';

/// Encapsulates metadata, progress metrics, and celebration details for a course module.
class Module {
  /// Celebration headline displayed upon completing the module.
  final String completionHeadline;

  /// Summary description shown on the module completion screen.
  final String completionSubtitle;

  /// Total number of lessons or steps contained within this module.
  final int totalSteps;

  /// The display name of the module (e.g. 'Getting Started', 'Map').
  final String moduleName;

  /// Text displayed on the milestone completion badge.
  final String badgeText;

  /// Icon rendered within the completion badge.
  final IconData badgeIcon;

  /// Thematic accent color used for badges, glow effects, and step trackers.
  final Color accentColor;

  /// List of milestone achievements unlocked upon module completion.
  final List<MilestoneAchievement> achievements;

  /// Animated Lottie asset previewing the subsequent module or challenge.
  final ILottie nextLottie;

  /// Title of the next sequential module in the curriculum.
  final String nextModuleTitle;

  /// Overview description of what learners will build in the next module.
  final String nextModuleDescription;

  const Module({
    required this.completionHeadline,
    required this.completionSubtitle,
    required this.totalSteps,
    required this.moduleName,
    required this.badgeText,
    required this.badgeIcon,
    required this.accentColor,
    required this.achievements,
    required this.nextLottie,
    required this.nextModuleTitle,
    required this.nextModuleDescription,
  });
}
