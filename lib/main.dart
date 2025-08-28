
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/reactController.dart';
import 'view/interface/principal.dart';

void main(List<String> args) {
  // se inyecta en memoria el controlador con las vbles reactivas
  Get.put(ReactController()); 
  runApp(Principal());
}

// se busca la instancia del controlador
ReactController myReactController = Get.find();

