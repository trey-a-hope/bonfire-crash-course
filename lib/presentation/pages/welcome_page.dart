import 'package:bonfire_crash_course/presentation/widgets/page_index_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('Welcome to Bonfire Engine!'), PageIndexWidget()],
    );
  }
}
