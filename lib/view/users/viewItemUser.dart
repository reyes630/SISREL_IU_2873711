import 'package:flutter/material.dart';

viewItemUser(context, itemUser) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalle Usuario"),
          backgroundColor: Colors.teal[400],
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.badge),
              title: const Text("ID"),
              subtitle: Text(itemUser["id"].toString()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Nombre"),
              subtitle: Text(itemUser["userName"] ?? "Sin nombre"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Correo"),
              subtitle: Text(itemUser["email"] ?? "Sin correo"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Teléfono"),
              subtitle: Text(itemUser["phone"] ?? "Sin teléfono"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cake),
              title: const Text("Cumpleaños"),
              subtitle: Text(itemUser["birthday"] ?? "Sin fecha"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text("Documento"),
              subtitle: Text(itemUser["document"] ?? "Sin documento"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Género"),
              subtitle: Text(itemUser["gender"] ?? "Sin género"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Estado"),
              subtitle: Text(itemUser["state"] ?? "Sin estado"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text("Rol ID"),
              subtitle: Text(itemUser["rolId"].toString()),
            ),
            const Divider(),
          ],
        ),
      );
    },
  );
}
