import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/apiBienestar.dart';
import '../../main.dart';


class ViewUsers extends StatefulWidget {
  const ViewUsers({super.key});

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  @override
  void initState() {
    super.initState();
    fetchUsers(); // método del api que trae los usuarios
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.builder(
            itemCount: myReactController.getListUsers.length,
            itemBuilder: (BuildContext context, int index) {
              final user = myReactController.getListUsers[index];
              return Card(
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      Text(user["id"].toString())
                    ],
                  ),
                  title: Text(user["userName"] ?? "Sin nombre"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Correo: ${user["email"] ?? "Sin correo"}"),
                      Text("Rol: ${user["rol"] ?? "Sin rol"}"),
                    ],
                  ),
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