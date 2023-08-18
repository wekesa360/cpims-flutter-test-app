import 'package:cpims_flutter_test_app/pages/login.dart';
import 'package:cpims_flutter_test_app/tokenProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: ChangeNotifierProvider(
        create: (_) => TokenProvider(),
        child: const MaterialApp(
          home: Login(),
        ),
      ),
    );
  }
}
