import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';
import '../CRUD/editRequest.dart';
import '../CRUD/viewRequest.dart';

class ArchivedRequests extends StatefulWidget {
  const ArchivedRequests({super.key});

  @override
  State<ArchivedRequests> createState() => _ArchivedRequestsState();
}

class _ArchivedRequestsState extends State<ArchivedRequests> {
  final ReactController controller = Get.find<ReactController>();

  @override
  void initState() {
    super.initState();
    fetchArchivedRequests();
  }

  Color parseApiColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.black;
    }
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Future<void> _showRequestMenu(BuildContext context, Map<String, dynamic> request, RelativeRect position) async {
    final result = await showMenu<String>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          value: "view",
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Row(
            children: [
              Icon(Icons.visibility, size: 18, color: Colors.black54),
              SizedBox(width: 6),
              Text("Ver", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: "edit",
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Row(
            children: [
              Icon(Icons.edit, size: 18, color: Colors.blue),
              SizedBox(width: 6),
              Text("Editar", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: "unarchive",
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Row(
            children: [
              Icon(Icons.unarchive, size: 18, color: Colors.blue),
              SizedBox(width: 6),
              Text("Desarchivar", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: "delete",
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 6),
              Text("Eliminar", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );

    if (result != null) {
      switch (result) {
        case "view":
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ViewRequestFormModal(requestId: request['id']);
            },
          );
          break;
        case "edit":
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return RequestFormModal(
                requestId: request['id'],
                initialData: request,
              );
            },
          );
          break;
        case "unarchive":
          try {
            Map<String, dynamic> unarchiveData = {
              'archive_status': 0,
            };

            await updateRequest(request['id'], unarchiveData);
            
            await fetchArchivedRequests();
            await fetchRequest();

            Get.snackbar(
              'Éxito',
              'Solicitud desarchivada correctamente',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } catch (e) {
            Get.snackbar(
              'Error',
              'No se pudo desarchivar la solicitud: ${e.toString()}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
          break;
        case "delete":
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmar eliminación'),
                content: const Text('¿Está seguro que desea eliminar esta solicitud? Esta acción no se puede deshacer.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        Navigator.of(context).pop();
                        await deleteRequest(request['id']);
                        await fetchArchivedRequests();
                        
                        Get.snackbar(
                          'Éxito',
                          'Solicitud eliminada correctamente',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'No se pudo eliminar la solicitud: ${e.toString()}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Eliminar'),
                  ),
                ],
              );
            },
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes Archivadas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() {
                final requests = controller.getArchivedRequests;

                if (requests.isEmpty) {
                  return const Center(
                    child: Text('No hay solicitudes archivadas'),
                  );
                }

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final createdAt = request['createdAt'] ?? '';

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12.0),
                        title: Text(
                          request['Client']?['NameClient'] ?? 'Cliente no disponible',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Creado: ${createdAt.substring(0, 10)}'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Chip(
                                  label: Text(
                                    request['State']?['State'] ?? 'Sin estado',
                                    style: TextStyle(
                                      color: parseApiColor(request['State']?['color']),
                                    ),
                                  ),
                                  backgroundColor: parseApiColor(request['State']?['color'])
                                      .withOpacity(0.1),
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(
                                    request['serviceType']?['service']?['service'] ??
                                        'Sin servicio',
                                    style: TextStyle(
                                      color: parseApiColor(
                                        request['serviceType']?['service']?['color'],
                                      ),
                                    ),
                                  ),
                                  backgroundColor: parseApiColor(
                                    request['serviceType']?['service']?['color'],
                                  ).withOpacity(0.1),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Builder(
                          builder: (BuildContext context) => IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              final RenderBox button = context.findRenderObject() as RenderBox;
                              final Offset offset = button.localToGlobal(Offset.zero);
                              _showRequestMenu(
                                context,
                                request,
                                RelativeRect.fromLTRB(
                                  offset.dx,
                                  offset.dy,
                                  offset.dx + 40,
                                  offset.dy + 40,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}