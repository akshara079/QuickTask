import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const appId = "y2Hdb20eeRXAor2A1JVj8NUCrFacJkkrMuhENuM1";
  const clientKey = "3NjUjXf9A4nP621IHIlCVnBjt1rKqXiAzdyjytqY";
  const parseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    appId,
    parseServerUrl,
    clientKey: clientKey,
    autoSendSessionId: true,
  );

  final user = await ParseUser.currentUser();

  runApp(
    MaterialApp(
      title: 'Task App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: user == null ? LoginScreen() : HomeScreen(),
    ),
  );
}
