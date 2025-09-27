
import 'package:flutter/material.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../login/singIn.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title:  'SISREL',
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}