import 'package:flutter/material.dart';

import '../CRUD/editRequest.dart';

class ViewRequests extends StatefulWidget {
  const ViewRequests({super.key});

  @override
  State<ViewRequests> createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests> {
  String? selectedValue; // AQUI ESTA LA VARIABLE DEL SELECTOR DEL FILTRO PARA SOLICITUDES

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector (Dropdown)
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                value: selectedValue,
                hint: const Text(
                  "Seleccionar filtro",
                  style: TextStyle(
                    fontSize: 16
                    ),
                  ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "op1", child: Text("Cliente")),
                  DropdownMenuItem(value: "op2", child: Text("Estado")),
                  DropdownMenuItem(value: "op3", child: Text("Servicio")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 5),

            // Buscador (TextField con icono)
            SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), 
                  hintText: "Buscar...",
                  hintStyle: TextStyle(
                    fontSize: 16
                    ),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
           const SizedBox(height: 16),

            // Lista de items
            Expanded(
              child: ListView(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          // Chips de estado
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Círculo de color
                              Center(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Texto (Cliente + Fecha)
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nombre Cliente",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Fecha de emisión",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              // Chips de estado 👇
                             Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Chip(
                                  label: const Text("Status"),
                                  labelStyle: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: -2), // 👈 Ajuste interno
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 👈 Evita el padding extra
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4), 
                                ),
                                const SizedBox(height: 2),
                                Chip(
                                  label: const Text("Service"),
                                  labelStyle: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                  side: const BorderSide(color: Colors.blue),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: -2), // 👈 Ajuste interno
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 👈 Evita el padding extra
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // 👈 Reduce tamaño total
                                ),
                              ],
                            ),
                         
                            // Menú de opciones (...)
                           
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () async {
                                    final RenderBox button = context.findRenderObject() as RenderBox;
                                    final RenderBox overlay =
                                        Overlay.of(context).context.findRenderObject() as RenderBox;

                                    // Posición: justo debajo y alineado a la derecha del botón
                                    final RelativeRect position = RelativeRect.fromRect(
                                      Rect.fromPoints(
                                        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                                        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                                      ),
                                      Offset.zero & overlay.size,
                                    );

                                    final result = await showMenu<String>(
                                      context: context,
                                      position: position,
                                      items: [
                                        PopupMenuItem(
                                          value: "view",
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0), // menos espacio
                                          child: Row(
                                            children: const [
                                              Icon(Icons.visibility, size: 18, color: Colors.black54),
                                              SizedBox(width: 6),
                                              Text("Ver", style: TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: "edit",
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.edit, size: 18, color: Colors.blue),
                                              SizedBox(width: 6),
                                              Text("Editar", style: TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: "delete",
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.delete, size: 18, color: Colors.red),
                                              SizedBox(width: 6),
                                              Text("Eliminar", style: TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: "archive",
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.archive, size: 18, color: Colors.green),
                                              SizedBox(width: 6),
                                              Text("Archivar", style: TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );

                                    // Manejo de acciones
                                    if (result != null) {
                                      switch (result) {
                                        case "view":
                                           showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const RequestFormModal();
                                              },
                                            );
                                          break;
                                        case "edit":
                                          print("Editar seleccionado");
                                          break;
                                        case "delete":
                                          print("Eliminar seleccionado");
                                          break;
                                        case "archive":
                                          print("Archivar seleccionado");
                                          break;
                                      }
                                    }
                                  },
                                );
                              },
                            ),

                            ],

                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}