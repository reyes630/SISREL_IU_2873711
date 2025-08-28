import 'package:flutter/material.dart';

viewItemCategory(context, itemCategory) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalle categoría"),
          backgroundColor: Colors.amber[300],
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.tag),
              title: const Text("ID"),
              subtitle: Text(itemCategory["id"].toString()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.title),
              title: const Text("Nombre"),
              subtitle: Text(itemCategory["name"] ?? "Sin nombre"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text("Descripción"),
              subtitle: Text(itemCategory["description"] ?? "Sin descripción"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Imagen"),
              subtitle: Text(itemCategory["image"] ?? "Sin imagen"),
            ),
            const Divider(),
          ],
        ),
      );
    },
  );
}
