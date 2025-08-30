import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/apiBienestar.dart';
import '../../main.dart';
import 'viewItemRol.dart';

class ViewRoles extends StatefulWidget {
  const ViewRoles({super.key});

  @override
  State<ViewRoles> createState() => _ViewRolesState();
}

class _ViewRolesState extends State<ViewRoles> {
  @override
  void initState() {
    super.initState();
    fetchRoles(); // método del api que trae los roles
  }

  // ====== Eliminar rol ======
  deleteRoleById(int id) async {
    try {
      await deleteRole(id); // 👈 asegúrate que este método exista en apiBienestar
      Get.snackbar("Rol eliminado", "ID: $id");
      fetchRoles();
    } catch (e) {
      Get.snackbar("Error", "No se pudo eliminar el rol");
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.builder(
            itemCount: myReactController.getListRols.length,
            itemBuilder: (BuildContext context, int index) {
              final itemList = myReactController.getListRols[index];
              return Card(
                color: Colors.teal[50],
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.store),
                              Text(itemList["id"].toString()),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              itemList["name"] ?? "Sin nombre",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      // ==== CRUD abajo ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.remove_red_eye,
                                color: Colors.teal, size: 22),
                            onPressed: () => viewItemRol(context, itemList),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.edit,
                                color: Colors.teal[600], size: 22),
                            onPressed: () {
                              Get.snackbar("Editar", "Funcionalidad pendiente");
                            },
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 22),
                            onPressed: () => deleteRoleById(itemList["id"]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.snackbar("Agregar Rol", "Funcionalidad pendiente");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
