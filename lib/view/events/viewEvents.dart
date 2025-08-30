import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/apiBienestar.dart';
import '../../main.dart';

class ViewEvents extends StatefulWidget {
  const ViewEvents({super.key});

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  @override
  void initState() {
    super.initState();
    fetchEvents(); // método del api que trae los eventos
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
            childAspectRatio: 0.8, // proporción alto/ancho de cada tarjeta
          ),
          itemCount: myReactController.getListEvents.length,
          itemBuilder: (BuildContext context, int index) {
            final event = myReactController.getListEvents[index];

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView( // 🔹 scroll en cada tarjeta
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // fila superior con icono a la izquierda e id a la derecha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.event, size: 20, color: Colors.blueGrey),
                          Text(
                            "ID: ${event["id"] ?? "-"}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Nombre
                      Text(
                        event["name"] ?? "Sin nombre",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      const SizedBox(height: 4),

                      // Categoría (ahora va de tercera)
                      if (event["category"] != null)
                        Text(
                          "Categoría: ${event["category"]["name"]}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.deepPurple,
                          ),
                        ),

                      const SizedBox(height: 4),

                      // Descripción
                      Text(
                        event["description"] ?? "Sin descripción",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54),
                      ),

                      const SizedBox(height: 6),

                      // Fechas
                      Text(
                        "Inicio: ${event["startDate"] ?? "-"}",
                        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                      Text(
                        "Fin: ${event["endDate"] ?? "-"}",
                        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),

                      const SizedBox(height: 6),

                      // Teléfono (si existe en la data)
                      if (event["phone"] != null)
                        Text(
                          "Tel: ${event["phone"]}",
                          style: const TextStyle(fontSize: 12),
                        ),

                      // Capacidad
                      Text(
                        "Capacidad: ${event["maxCapacity"] ?? "-"}",
                        style: const TextStyle(fontSize: 12),
                      ),

                      // Usuario
                      Text(
                        "Usuario ID: ${event["userId"] ?? "-"}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
