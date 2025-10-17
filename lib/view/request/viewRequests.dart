import 'package:app_adso_711_1/view/CRUD/editRequest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';
import '../CRUD/viewRequest.dart';
import 'archiveRequest.dart';
import 'sentRequest.dart';

class ViewRequests extends StatefulWidget {
  const ViewRequests({super.key});

  @override
  State<ViewRequests> createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests> {
  final ReactController controller = Get.find<ReactController>();
  String? selectedValue;

  // Add these variables at the start of _ViewRequestsState class
  String searchText = '';
  List<Map<String, dynamic>> filteredRequests = [];

  @override
  void initState() {
    super.initState();
    fetchRequest();
    fetchStates(); // Add this line to load states
    fetchServices(); // Agregar esta línea
  }

  Color parseApiColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.black; // fallback
    }

    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // añadir opacidad
    }

    return Color(int.parse(hexColor, radix: 16));
  }

  Color getStatusColor(String createdDate, int state) {
    final created = DateTime.parse(createdDate);
    final now = DateTime.now();
    final difference = now.difference(created).inDays;

    // Para solicitudes de 7 días o menos
    if (difference <= 7) {
      switch (state) {
        case 1: // Pendiente
          return Colors.green.withOpacity(0.9); // Verde tenue
        case 3: // Validada
        case 4: // En proceso
          return Colors.green; // Verde normal
        case 5: // Ejecutada
        case 6: // Resuelta
        case 7: // Cerrada
          return Colors.green.shade700; // Verde intenso
        default:
          return Colors.green;
      }
    }
    // Para solicitudes entre 8 y 15 días
    else if (difference <= 15) {
      switch (state) {
        case 1: // Pendiente
          return Colors.orange.shade900; // Naranja oscuro
        case 3: // Validada
        case 4: // En proceso
          return Colors.yellow.shade600; // Amarillo intermedio
        case 5: // Ejecutada
          return Colors.yellow.shade300; // Amarillo claro
        case 6: // Resuelta
        case 7: // Cerrada
          return Colors.green; // Verde
        default:
          return Colors.yellow;
      }
    }
    // Para solicitudes de más de 15 días
    else {
      switch (state) {
        case 1: // Pendiente
          return Colors.red.shade900; // Rojo muy oscuro
        case 3: // Validada
        case 4: // En proceso
          return Colors.orange.shade900; // Naranja fuerte
        case 5: // Ejecutada
          return Colors.yellow.shade900; // Amarillo más oscuro
        case 6: // Resuelta
        case 7: // Cerrada
          return Colors.green; // Verde
        default:
          return Colors.red; // Rojo por defecto
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                // Selector (Dropdown)
                SizedBox(
                  height: 40,
                  child: DropdownButtonFormField<String>(
                    value: selectedValue,
                    hint: const Text(
                      "Seleccionar filtro",
                      style: TextStyle(fontSize: 16),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
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
                        searchText = ''; // Reset search when filter changes
                      });
                    },
                  ),
                ),
                const SizedBox(height: 5),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: selectedValue == "op2"
                            ? // Dropdown para Estados
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Obx(() {
                                  final states = controller.getListStates;
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: searchText.isEmpty ? null : searchText,
                                      isExpanded: true,
                                      hint: const Text("Seleccionar estado"),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      items: states.map((state) {
                                        Color stateColor = Colors.grey;
                                        if (state['color'] != null) {
                                          try {
                                            stateColor = parseApiColor(
                                              state['color'],
                                            );
                                          } catch (e) {
                                            stateColor = Colors.grey;
                                          }
                                        }

                                        return DropdownMenuItem<String>(
                                          value: state['id'].toString(),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                margin: const EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: stateColor.withOpacity(0.7),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Text(state['State']),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          searchText = value ?? '';
                                        });
                                      },
                                    ),
                                  );
                                }),
                              )
                            : selectedValue == "op3"
                                ? // Dropdown para Servicios
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Obx(() {
                                      final services = controller.getListService;
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: searchText.isEmpty ? null : searchText,
                                          isExpanded: true,
                                          hint: const Text("Seleccionar servicio"),
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          items: services.map((service) {
                                            Color serviceColor = Colors.grey;
                                            if (service['color'] != null) {
                                              try {
                                                serviceColor = parseApiColor(service['color']);
                                              } catch (e) {
                                                serviceColor = Colors.grey;
                                              }
                                            }
                                            
                                            return DropdownMenuItem<String>(
                                              value: service['id'].toString(),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 16,
                                                    height: 16,
                                                    margin: const EdgeInsets.only(right: 8),
                                                    decoration: BoxDecoration(
                                                      color: serviceColor.withOpacity(0.7),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  Text(service['service']),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              searchText = value ?? '';
                                            });
                                          },
                                        ),
                                      );
                                    }),
                                  )
                                : // TextField para búsqueda por cliente
                                  TextField(
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      hintText: "Buscar por cliente...",
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        searchText = value;
                                      });
                                    },
                                  ),
                      ),
                    ),
                    if (selectedValue != null || searchText.isNotEmpty) 
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'Limpiar filtros',
                          onPressed: () {
                            setState(() {
                              selectedValue = null;
                              searchText = '';
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Botón de Archivados
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Show 'Enviadas' button only if user is not Administrative
                if (controller.getCurrentUser?['FKroles'] != 1)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SentRequests(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Enviadas'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ArchivedRequests(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.archive),
                  label: const Text('Archivados'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Lista de items
            Expanded(
              child: Obx(() {
                final requests = controller.getListRequest;

                if (requests.isEmpty) {
                  return const Center(
                    child: Text('No hay solicitudes disponibles'),
                  );
                }

                var filteredRequests = requests.where((request) {
                  if (searchText.isEmpty) return true;

                  switch (selectedValue) {
                    case "op1": // Cliente
                      final clientName =
                          request['Client']?['NameClient']
                              ?.toString()
                              .toLowerCase() ??
                          '';
                      return clientName.contains(searchText.toLowerCase());

                    case "op2": // Estado
                      final stateId = request['FKstates']?.toString() ?? '';
                      return stateId == searchText;

                    case "op3": // Servicio
                      final serviceId = request['serviceType']?['service']?['id']?.toString() ?? '';
                      return serviceId == searchText;

                    default:
                      return true;
                  }
                }).toList();

                if (filteredRequests.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron resultados'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = filteredRequests[index];
                    final createdAt = request['createdAt'] ?? '';

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Círculo indicador de tiempo
                                Center(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: getStatusColor(
                                        request['createdAt'],
                                        request['FKstates'], // Pasar el estado actual
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Información de la solicitud
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      request['Client']?['NameClient'] ??
                                          'Cliente no disponible',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      createdAt.isNotEmpty
                                          ? 'Creado: ${createdAt.substring(0, 10)}'
                                          : 'Fecha no disponible',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                // Estado y Servicio
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Chip(
                                      label: Text(
                                        request['State']?['State'] ??
                                            'Sin estado',
                                        style: TextStyle(
                                          color: parseApiColor(
                                            request['State']?['color'],
                                          ),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: parseApiColor(
                                        request['State']?['color'],
                                      ).withOpacity(0.1),
                                      side: BorderSide(
                                        color: parseApiColor(
                                          request['State']?['color'],
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: -2,
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                    ),

                                    const SizedBox(height: 2),
                                    Chip(
                                      label: Text(
                                        request['serviceType']?['service']?['service'] ??
                                            'Sin servicio',
                                        style: TextStyle(
                                          color: parseApiColor(
                                            request['serviceType']?['service']?['color']
                                                ?.toString(),
                                          ),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: parseApiColor(
                                        request['serviceType']?['service']?['color']
                                            ?.toString(),
                                      ).withOpacity(0.1),
                                      side: BorderSide(
                                        color: parseApiColor(
                                          request['serviceType']?['service']?['color']
                                              ?.toString(),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: -2,
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                    ),
                                  ],
                                ),

                                // Menú de opciones (...)
                                Builder(
                                  builder: (context) {
                                    return IconButton(
                                      icon: const Icon(Icons.more_horiz),
                                      onPressed: () async {
                                        final RenderBox button =
                                            context.findRenderObject()
                                                as RenderBox;
                                        final RenderBox overlay =
                                            Overlay.of(
                                                  context,
                                                ).context.findRenderObject()
                                                as RenderBox;
                                        // Posición: justo debajo y alineado a la derecha del botón
                                        final RelativeRect position =
                                            RelativeRect.fromRect(
                                              Rect.fromPoints(
                                                button.localToGlobal(
                                                  button.size.bottomRight(
                                                    Offset.zero,
                                                  ),
                                                  ancestor: overlay,
                                                ),
                                                button.localToGlobal(
                                                  button.size.bottomRight(
                                                    Offset.zero,
                                                  ),
                                                  ancestor: overlay,
                                                ),
                                              ),
                                              Offset.zero & overlay.size,
                                            );

                                        final currentUser = controller.getCurrentUser;
                                        final userRole = currentUser?['FKroles'];
                                        final isAdministrative = userRole == 1;
                                        final canArchive = (request['FKstates'] == 6 || request['FKstates'] == 7);

                                        final result = await showMenu<String>(
                                          context: context,
                                          position: position,
                                          items: [
                                            const PopupMenuItem(
                                              value: "view",
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.visibility,
                                                    size: 18,
                                                    color: Colors.black54,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "Ver",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // No mostrar opción de editar para Administrativo
                                            if (!isAdministrative)
                                              const PopupMenuItem(
                                                value: "edit",
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      size: 18,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "Editar",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            // No mostrar opción de eliminar para Administrativo
                                            if (!isAdministrative && userRole != 5 && userRole != 6)
                                              const PopupMenuItem(
                                                value: "delete",
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      size: 18,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "Eliminar",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            // Mostrar opción de archivar solo para Administrativo y solo si el estado es Resuelto o Cerrado
                                            if (isAdministrative && canArchive)
                                              const PopupMenuItem(
                                                value: "archive",
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.archive,
                                                      size: 18,
                                                      color: Colors.green,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "Archivar",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        );

                                        // Manejo de acciones
                                        if (result != null) {
                                          final request =
                                              controller.getListRequest[index];
                                          switch (result) {
                                            case "view":
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ViewRequestFormModal(
                                                    requestId: request['id'],
                                                  );
                                                },
                                              );
                                              break;
                                            case "edit":
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                      return RequestFormModal(
                                                        requestId:
                                                            request['id'],
                                                        initialData: request,
                                                      );
                                                    },
                                              );
                                              break;
                                            case "delete":
                                              // Mostrar diálogo de confirmación
                                              final confirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Confirmar eliminación',
                                                    ),
                                                    content: const Text(
                                                      '¿Estás seguro de que deseas eliminar esta solicitud? Esta acción no se puede deshacer.',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(false),
                                                        child: const Text(
                                                          'Cancelar',
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(true),
                                                        style:
                                                            TextButton.styleFrom(
                                                              foregroundColor:
                                                                  Colors.red,
                                                            ),
                                                        child: const Text(
                                                          'Eliminar',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              // eliminar
                                              if (confirmed == true) {
                                                try {
                                                  final success =
                                                      await deleteRequest(
                                                        request['id'],
                                                      );

                                                  if (success) {
                                                    Get.snackbar(
                                                      'Éxito',
                                                      'Solicitud eliminada correctamente',
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          Colors.green,
                                                      colorText: Colors.white,
                                                    );
                                                  }
                                                } catch (e) {
                                                  Get.snackbar(
                                                    'Error',
                                                    'No se pudo eliminar la solicitud: ${e.toString()}',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                  );
                                                }
                                              }
                                              break;
                                            case "archive":
                                              try {
                                                // Update request with archive_status = true (1)
                                                Map<String, dynamic>
                                                archiveData = {
                                                  'archive_status': 1,
                                                };

                                                await updateRequest(
                                                  request['id'],
                                                  archiveData,
                                                );

                                                // Refresh the requests list
                                                await fetchRequest();

                                                Get.snackbar(
                                                  'Éxito',
                                                  'Solicitud archivada correctamente',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.green,
                                                  colorText: Colors.white,
                                                );
                                              } catch (e) {
                                                Get.snackbar(
                                                  'Error',
                                                  'No se pudo archivar la solicitud: ${e.toString()}',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                              }
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

  Widget _buildRequestCard(Map<String, dynamic> request, int index) { // Añadir el parámetro index
    final currentUser = controller.getCurrentUser;
    final userRole = currentUser?['FKroles'];
    final bool canDelete = userRole != 5 && userRole != 6;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Círculo indicador de tiempo
                Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getStatusColor(request['createdAt'], request['FKstates']),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Información de la solicitud
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['Client']?['NameClient'] ?? 'Cliente no disponible',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request['createdAt'].isNotEmpty
                          ? 'Creado: ${request['createdAt'].substring(0, 10)}'
                          : 'Fecha no disponible',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Estado y Servicio
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(
                        request['State']?['State'] ?? 'Sin estado',
                        style: TextStyle(
                          color: parseApiColor(
                            request['State']?['color'],
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: parseApiColor(
                        request['State']?['color'],
                      ).withOpacity(0.1),
                      side: BorderSide(
                        color: parseApiColor(
                          request['State']?['color'],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: -2,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                    ),

                    const SizedBox(height: 2),
                    Chip(
                      label: Text(
                        request['serviceType']?['service']?['service'] ?? 'Sin servicio',
                        style: TextStyle(
                          color: parseApiColor(
                            request['serviceType']?['service']?['color']
                                ?.toString(),
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: parseApiColor(
                        request['serviceType']?['service']?['color']
                            ?.toString(),
                      ).withOpacity(0.1),
                      side: BorderSide(
                        color: parseApiColor(
                          request['serviceType']?['service']?['color']
                              ?.toString(),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: -2,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                    ),
                  ],
                ),

                // Menú de opciones (...)
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () async {
                        final RenderBox button =
                            context.findRenderObject() as RenderBox;
                        final RenderBox overlay =
                            Overlay.of(
                                  context,
                                ).context.findRenderObject()
                            as RenderBox;
                        // Posición: justo debajo y alineado a la derecha del botón
                        final RelativeRect position =
                            RelativeRect.fromRect(
                              Rect.fromPoints(
                                button.localToGlobal(
                                  button.size.bottomRight(
                                    Offset.zero,
                                  ),
                                  ancestor: overlay,
                                ),
                                button.localToGlobal(
                                  button.size.bottomRight(
                                    Offset.zero,
                                  ),
                                  ancestor: overlay,
                                ),
                              ),
                              Offset.zero & overlay.size,
                            );

                        final currentUser = controller.getCurrentUser;
                        final userRole = currentUser?['FKroles'];
                        final isAdministrative = userRole == 1;
                        final canArchive = (request['FKstates'] == 6 || request['FKstates'] == 7);

                        final result = await showMenu<String>(
                          context: context,
                          position: position,
                          items: [
                            const PopupMenuItem(
                              value: "view",
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Ver",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // No mostrar opción de editar para Administrativo
                            if (!isAdministrative)
                              const PopupMenuItem(
                                value: "edit",
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 0,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Editar",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // No mostrar opción de eliminar para Administrativo
                            if (!isAdministrative && userRole != 5 && userRole != 6)
                              const PopupMenuItem(
                                value: "delete",
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 0,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Eliminar",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Mostrar opción de archivar solo para Administrativo y solo si el estado es Resuelto o Cerrado
                            if (isAdministrative && canArchive)
                              const PopupMenuItem(
                                value: "archive",
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 0,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.archive,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Archivar",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );

                        // Manejo de acciones
                        if (result != null) {
                          final request =
                              controller.getListRequest[index];
                          switch (result) {
                            case "view":
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ViewRequestFormModal(
                                    requestId: request['id'], // Usar request en lugar de controller.getListRequest[index]
                                  );
                                },
                            );
                            break;
                            case "edit":
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RequestFormModal(
                                    requestId: request['id'], // Usar request en lugar de controller.getListRequest[index]
                                    initialData: request,
                                  );
                                },
                            );
                            break;
                            case "delete":
                              // Mostrar diálogo de confirmación
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Confirmar eliminación',
                                    ),
                                    content: const Text(
                                      '¿Estás seguro de que deseas eliminar esta solicitud? Esta acción no se puede deshacer.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(
                                              context,
                                            ).pop(false),
                                        child: const Text(
                                          'Cancelar',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(
                                              context,
                                            ).pop(true),
                                        style:
                                            TextButton.styleFrom(
                                              foregroundColor:
                                                  Colors.red,
                                            ),
                                        child: const Text(
                                          'Eliminar',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // eliminar
                              if (confirmed == true) {
                                try {
                                  final success =
                                      await deleteRequest(
                                        request['id'],
                                      );

                                  if (success) {
                                    Get.snackbar(
                                      'Éxito',
                                      'Solicitud eliminada correctamente',
                                      snackPosition:
                                          SnackPosition.BOTTOM,
                                      backgroundColor:
                                          Colors.green,
                                      colorText: Colors.white,
                                    );
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'No se pudo eliminar la solicitud: ${e.toString()}',
                                    snackPosition:
                                        SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              }
                              break;
                            case "archive":
                              try {
                                // Update request with archive_status = true (1)
                                Map<String, dynamic>
                                archiveData = {
                                  'archive_status': 1,
                                };

                                await updateRequest(
                                  request['id'],
                                  archiveData,
                                );

                                // Refresh the requests list
                                await fetchRequest();

                                Get.snackbar(
                                  'Éxito',
                                  'Solicitud archivada correctamente',
                                  snackPosition:
                                      SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'No se pudo archivar la solicitud: ${e.toString()}',
                                  snackPosition:
                                      SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
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
    );
  }
}
