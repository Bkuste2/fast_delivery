import 'package:flutter/material.dart';

import 'src/routes/app_routes.dart';
import 'src/shared/storage/storage_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageConfig.initHive(); // Inicializa o Hive
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
      theme: ThemeData(),
    );
  }
}
