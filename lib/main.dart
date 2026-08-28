import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Windows UI for Flutter',
      theme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      home: Center(
        child: AdaptiveButton(
          child: Text('Hello'),
          onPressed: () {
            debugPrint('Button clicked');
          },
        ),
      ),
    );
  }
}
