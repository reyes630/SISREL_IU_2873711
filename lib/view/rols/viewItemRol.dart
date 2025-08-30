import 'package:flutter/material.dart';

viewItemRol(context, itemRole) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Detalle Rol"),
            backgroundColor: Colors.teal[400],
            foregroundColor: Colors.white,
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.badge),
                title: const Text("ID"),
                subtitle: Text(itemRole["id"].toString()),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text("Nombre"),
                subtitle: Text(itemRole["name"] ?? "Sin nombre"),
              ),
            ],
          ),
        );
      },
    );
  }
