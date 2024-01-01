import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccstorage/ui/api_widget.dart';
import 'package:ccstorage/ui/pages/connect.dart';
import 'package:ccstorage/ui/pages/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'io/api.dart' as api;
import 'dart:developer' as developer;

import 'io/api.dart';

late final CameraDescription firstCamera;

late final SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  api.app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  api.auth = FirebaseAuth.instanceFor(app: api.app);

  if (api.auth.currentUser == null) {
    api.auth.signInAnonymously();
  }

  sharedPreferences = await SharedPreferences.getInstance();

  try {
    final cameras = await availableCameras();
    firstCamera = cameras.first;
  } on CameraException catch (e) {
    developer.log(e.toString(), name: 'runApp');
  }

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  Timer? reconnectTimer;
  late Api api;

  void startTimer() {
    if(reconnectTimer?.isActive ?? false) return;

    api.connect();
    reconnectTimer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      if (!api.connected) {
        api.connect();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    api = Api(
      onUpdate: () => setState(() {}),
    );
    startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    reconnectTimer?.cancel();
    api.disconnect();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      api.disconnect();
      reconnectTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ApiWidget(
        api: api,
        child: MaterialApp(
          title: 'CCStorage',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: {
            '/': (context) => (sharedPreferences.getBool("hasRobots") ?? false)
                ? const IndexPage()
                : const ConnectPage(),
            '/robots': (context) => const IndexPage()
          },
        ));
  }
}
