import 'package:flutter/material.dart';

viewItemEvent(context, itemEvent) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // para permitir scroll si hay mucha info
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalle evento"),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.tag),
              title: const Text("ID"),
              subtitle: Text(itemEvent["id"].toString()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.title),
              title: const Text("Nombre"),
              subtitle: Text(itemEvent["name"] ?? "Sin nombre"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text("Descripción"),
              subtitle: Text(itemEvent["description"] ?? "Sin descripción"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Fecha inicio"),
              subtitle: Text(itemEvent["startDate"] ?? "-"),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Fecha fin"),
              subtitle: Text(itemEvent["endDate"] ?? "-"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text("Estado"),
              subtitle: Text(itemEvent["state"] ?? "-"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Capacidad máxima"),
              subtitle: Text(itemEvent["maxCapacity"].toString()),
            ),
            const Divider(),
            if (itemEvent["category"] != null)
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text("Categoría"),
                subtitle: Text(itemEvent["category"]["name"] ?? "Sin categoría"),
              ),
            const Divider(),
            if (itemEvent["user"] != null) ...[
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Organizador"),
                subtitle: Text(itemEvent["user"]["userName"] ?? "Sin usuario"),
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Teléfono"),
                subtitle: Text(itemEvent["user"]["phone"] ?? "Sin teléfono"),
              ),
            ],
          ],
        ),
      );
    },
  );
}
