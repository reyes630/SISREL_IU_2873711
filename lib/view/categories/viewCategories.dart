import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/apiBienestar.dart';
import '../../main.dart';
import 'viewItemCategory.dart';

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

  // ===== Eliminar categoría =====
  deleteCategoryById(int id) async {
    try {
      await deleteCategory(id); // <-- asegúrate que exista en tu api
      Get.snackbar("Categoría eliminada", "ID: $id");
      fetchCategories();
    } catch (e) {
      Get.snackbar("Error", "No se pudo eliminar la categoría");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // dos columnas
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: myReactController.getListCategories.length,
          itemBuilder: (BuildContext context, int index) {
            final category = myReactController.getListCategories[index];

            return Card(
              color: Colors.teal[50],
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagen en la parte superior
                  Expanded(
                    flex: 5,
                    child: category["image"] != null &&
                            category["image"].toString().isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              category["image"],
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                            child: const Icon(Icons.category,
                                size: 60, color: Colors.white),
                          ),
                  ),

                  // Texto de nombre, descripción y botones (con scroll)
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category["name"] ?? "Sin nombre",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category["description"] ?? "Sin descripción",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),

                            // Botones CRUD (Wrap evita overflow)
                            Wrap(
                              spacing: 4, // espacio horizontal entre botones
                              runSpacing: 2, // espacio vertical si se bajan
                              alignment: WrapAlignment.end,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.remove_red_eye,
                                      color: Colors.teal, size: 20),
                                  onPressed: () =>
                                      viewItemCategory(context, category),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.edit,
                                      color: Colors.teal, size: 20),
                                  onPressed: () {
                                    Get.snackbar("Editar categoría",
                                        "ID: ${category["id"]}");
                                  },
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 20),
                                  onPressed: () =>
                                      deleteCategoryById(category["id"]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Get.snackbar("Botón", "Aquí irá agregar categoría en el futuro");
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
