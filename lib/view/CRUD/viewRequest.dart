import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';

class ViewRequestFormModal extends StatefulWidget {
  final int requestId;

  const ViewRequestFormModal({super.key, required this.requestId});

  @override
  State<ViewRequestFormModal> createState() => _ViewRequestFormModalState();
}

class _ViewRequestFormModalState extends State<ViewRequestFormModal> {
  final ReactController controller = Get.find<ReactController>();
  Map<String, dynamic>? requestData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadRequestData();
  }

  Future<void> loadRequestData() async {
    try {
      // Cargar datos en paralelo
      await Future.wait([
        fetchAssignableUsers(), // Agregar esta línea
        Future(() async {
          final data = await fetchRequestById(widget.requestId);
          setState(() {
            requestData = data;
          });
        }),
      ]);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return 'No especificada';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Obtener el servicio relacionado con esta solicitud
  Map<String, dynamic>? getServiceForRequest() {
    if (requestData == null) return null;

    final services = controller.getListService;
    final serviceType = requestData?['serviceType'];
    final serviceId = serviceType != null ? serviceType['FKservices'] : null;

    if (serviceId == null) return null;

    try {
      return services.firstWhere(
        (service) => service['id'] == serviceId,
        orElse: () => {},
      );
    } catch (e) {
      print('Error buscando servicio: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Ver Solicitud'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    'Solicitud #${widget.requestId.toString().padLeft(3, '0')}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text('Error: $errorMessage'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadRequestData,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        'Descripción',
                        requestData?['needDescription'] ?? 'Sin descripción',
                      ),
                      const SizedBox(height: 20),

                      _buildSection(
                        'Fecha de Evento',
                        formatDate(requestData?['eventDate']),
                      ),
                      const SizedBox(height: 20),

                      _buildSection(
                        'Fecha de creación',
                        formatDate(requestData?['createdAt']),
                      ),
                      const SizedBox(height: 20),

                      _buildSection(
                        'Cliente',
                        requestData?['Client']?['NameClient']?.toString() ??
                            'No asignado',
                      ),
                      const SizedBox(height: 20),

                      // Servicio - Solo mostrar el servicio relacionado
                      const Text(
                        'Servicio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          // Extraemos el servicio desde el JSON
                          final service =
                              requestData?['serviceType']?['service'];

                          if (service == null || service.isEmpty) {
                            return const Text(
                              'No especificado',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            );
                          }

                          // Determinar color del servicio
                          Color serviceColor = Colors.blue;
                          final colorHex = service['color'];
                          if (colorHex != null &&
                              colorHex.toString().isNotEmpty) {
                            try {
                              serviceColor = Color(
                                int.parse(colorHex.replaceAll('#', '0xFF')),
                              );
                            } catch (e) {
                              serviceColor = Colors.blue;
                            }
                          }

                          // Mostrar chip con nombre y color
                          return Chip(
                            label: Text(
                              service['service'] ?? 'Sin nombre',
                              style: TextStyle(
                                color: serviceColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: serviceColor.withOpacity(0.15),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Tipo de Servicio
                      const Text(
                        'Tipo Servicio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          requestData?['serviceType']?['serviceType'] ??
                              'No especificado',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Estado
                      const Text(
                        'Estado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          final state = requestData?['State'];
                          if (state == null) {
                            return const Text(
                              'No especificado',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            );
                          }

                          Color stateColor = Colors.grey;
                          if (state['color'] != null) {
                            try {
                              stateColor = Color(
                                int.parse(
                                  state['color'].replaceAll('#', '0xFF'),
                                ),
                              );
                            } catch (e) {
                              stateColor = Colors.grey;
                            }
                          }

                          return Chip(
                            label: Text(state['State'] ?? 'Sin estado'),
                            backgroundColor: stateColor.withOpacity(0.2),
                            labelStyle: TextStyle(color: stateColor),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      _buildSection(
                        'Usuario que realizó la solicitud',
                        requestData?['user']?['nameUser']?.toString() ??
                            'No asignado',
                      ),
                      const SizedBox(height: 20),

                      // Responsable Asignado - Buscando en la lista de usuarios asignables
                      _buildSection(
                        'Responsable Asignado',
                        () {
                          final assignmentId = requestData?['assignment'];
                          if (assignmentId == null || assignmentId == '') return 'Sin asignar';
                          
                          final users = controller.getAssignableUsers;
                          final assignedUser = users.firstWhere(
                            (user) => user['id'].toString() == assignmentId.toString(),
                            orElse: () => {'nameUser': 'Usuario no encontrado', 'FKroles': null},
                          );
                          
                          // Obtener el nombre del rol
                          String roleText = assignedUser['FKroles'] == 5 ? 'Instructor' : 
                                           assignedUser['FKroles'] == 6 ? 'Funcionario' : 
                                           'Rol desconocido';
                          
                          return '${assignedUser['nameUser']} (${roleText})';
                        }(),
                      ),
                      const SizedBox(height: 30),

                      const Text(
                        'Lugar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Municipio
                      const Text(
                        'Municipio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          requestData?['municipality'] ?? 'No especificado',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildSection(
                        'Ubicación',
                        requestData?['location'] ?? 'No especificada',
                      ),
                      const SizedBox(height: 20),

                      _buildSection(
                        'Comentario',
                        requestData?['comments'] ?? 'Sin comentarios',
                      ),
                      const SizedBox(height: 20),

                      _buildSection(
                        'Observaciones',
                        requestData?['observations'] ?? 'Sin observaciones',
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
