import 'dart:async';

import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/rive/getting_started/getting_started_rive.dart';
import 'package:bonfire_crash_course/presentation/widgets/glass_button.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals/signals_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:bonfire_crash_course/presentation/rive/getting_started/getting_started_rive.dart'
    show GettingStartedScene;

part 'animated_hero_card.dart';
part 'command_box.dart';
part 'one_line_tip.dart';
part 'open_link_button.dart';
part 'quick_step_tile.dart';
part 'quick_steps.dart';

/// The lime accent of the Getting Started module.
const onboardingAccent = Colors.lightGreenAccent;

/// The card colour used across the course.
const onboardingCard = Color(0xFF1E1E2C);
