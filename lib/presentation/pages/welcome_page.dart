import 'package:bonfire_crash_course/presentation/lotties/bonfire_lottie.dart';
import 'package:bonfire_crash_course/presentation/lotties/flutter_lottie.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_index_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: FlutterLottie()),
            Expanded(child: BonfireLottie()),
          ],
        ),
        Text('Welcome to Bonfire Engine!'),
        PageIndexWidget(),
      ],
    );
  }
}
