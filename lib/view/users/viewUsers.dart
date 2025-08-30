import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/apiBienestar.dart';
import '../../main.dart';
import 'viewItemUser.dart';

class ViewUsers extends StatefulWidget {
  const ViewUsers({super.key});

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // ===== Eliminar usuario =====
  deleteUserById(int id) async {
    try {
      await deleteUser(id);
      Get.snackbar("Usuario eliminado", "ID: $id");
      fetchUsers();
    } catch (e) {
      Get.snackbar("Error", "No se pudo eliminar el usuario");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.builder(
            itemCount: myReactController.getListUsers.length,
            itemBuilder: (BuildContext context, int index) {
              final user = myReactController.getListUsers[index];
              return Card(
                color: Colors.teal[50],
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==== Parte de arriba ====
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person),
                              Text(user["id"].toString()),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user["userName"] ?? "Sin nombre",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text("Correo: ${user["email"] ?? "Sin correo"}"),
                                Text("Rol: ${user["rol"] ?? "Sin rol"}"),
                              ],
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
                            onPressed: () => viewItemUser(context, user),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.edit,
                                color: Colors.teal[600], size: 22),
                            onPressed: () => viewItemUser(context, user),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 22),
                            onPressed: () => deleteUserById(user["id"]),
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
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        onPressed: () {
          Get.snackbar("Botón", "Aquí irá agregar usuario en el futuro");
        },
        
        child: const Icon(Icons.add,),
      ),
    );
  }
}
