import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/apiBienestar.dart';
import '../../main.dart';

class ViewCategories extends StatefulWidget {
  const ViewCategories({super.key});

  @override
  State<ViewCategories> createState() => _ViewCategoriesState();
}

class _ViewCategoriesState extends State<ViewCategories> {
  @override
  void initState() {
    super.initState();
    fetchCategories(); // método del api que trae las categorías
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.builder(
            itemCount: myReactController.getListCategories.length,
            itemBuilder: (BuildContext context, int index) {
              final category = myReactController.getListCategories[index];
              return Card(
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      category["image"] != null && category["image"].toString().isNotEmpty
                          ? Image.network(
                              category["image"],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.category, size: 40),
                      Text(category["id"].toString())
                    ],
                  ),
                  title: Text(category["name"] ?? "Sin nombre"),
                  subtitle: Text(category["description"] ?? "Sin descripción"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Puedes agregar botones de editar/eliminar aquí si lo necesitas
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
