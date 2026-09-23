import 'package:flutter/material.dart';

class ModalService {
  static void showSheet(BuildContext context) async =>
      showDialog(context: context, builder: (_) => const Placeholder());
}
