import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';

import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';

class RequestFormModal extends StatefulWidget {
  final int requestId;
  final Map<String, dynamic> initialData;

  const RequestFormModal({
    super.key,
    required this.requestId,
    required this.initialData,
  });

  @override
  State<RequestFormModal> createState() => _RequestFormModalState();
}

class _RequestFormModalState extends State<RequestFormModal> {
  final ReactController controller = Get.find<ReactController>();
  Map<String, dynamic>? requestData;
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial data first
    requestData = widget.initialData;
    _descriptionController.text = widget.initialData['needDescription'] ?? '';
    _commentsController.text = widget.initialData['comments'] ?? '';
    _observationsController.text = widget.initialData['observations'] ?? '';
    _locationController.text = widget.initialData['location'] ?? '';

    // Then load additional data
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    if (!mounted) return;

    try {
      setState(() => isLoading = true);

      // Load data in background
      await Future.wait([
        fetchServices(),
        fetchServiceTypes(),
        fetchStates(),
        fetchMunicipalities(),
        fetchAssignableUsers(), // Add this line
      ]);

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Error al cargar los datos: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  // En el mismo archivo, modificar el método _handleUpdate:

  // In the same file, update the _handleUpdate method:
  Future<void> _handleUpdate() async {
    try {
    Map<String, dynamic> updateData = {
      'needDescription': _descriptionController.text,
      'comments': _commentsController.text,
      'observations': _observationsController.text,
      'location': _locationController.text,
      'municipality': requestData?['municipality'],
      'FKservices': requestData?['serviceType']?['service']?['id'],
      'FKservicetypes': requestData?['FKservicetypes'],
      'FKstates': requestData?['FKstates'],
      'assignment': requestData?['assignment'],
      'eventDate': requestData?['eventDate'], // Agregar esta línea
    };

      await updateRequest(widget.requestId, updateData);

      Get.snackbar(
        'Éxito',
        'Solicitud actualizada correctamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Navigator.of(context).pop();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar la solicitud: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Request'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'Number Request: #${widget.requestId.toString().padLeft(3, '0')}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                        onPressed: loadInitialData,
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
                      // Description field
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter description...',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),

                      // Fecha Evento (read-only)
                      const Text(
                        'Fecha de Evento',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 35,
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: requestData?['eventDate'] != null 
                                ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(requestData!['eventDate']))
                                : '',
                          ),
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Selecciona la fecha',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode()); // evita abrir teclado
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: requestData?['eventDate'] != null 
                                  ? DateTime.parse(requestData!['eventDate'])
                                  : DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              final DateTime selectedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                DateTime.now().hour,
                                DateTime.now().minute,
                              );

                              setState(() {
                                requestData?['eventDate'] = selectedDateTime.toIso8601String();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Cliente (read-only)
                      const Text(
                        'Cliente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        requestData?['Client']?['NameClient']?.toString() ??
                            'No asignado',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Servicio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Servicio Actual',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Builder(
                                  builder: (context) {
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

                                    Color serviceColor = Colors.blue;
                                    final colorHex = service['color'];
                                    if (colorHex != null &&
                                        colorHex.toString().isNotEmpty) {
                                      try {
                                        serviceColor = Color(
                                          int.parse(
                                            colorHex.replaceAll('#', '0xFF'),
                                          ),
                                        );
                                      } catch (e) {
                                        serviceColor = Colors.blue;
                                      }
                                    }

                                    return Chip(
                                      label: Text(
                                        service['service'] ?? 'Sin nombre',
                                        style: TextStyle(
                                          color: serviceColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      backgroundColor: serviceColor.withOpacity(
                                        0.15,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cambiar Servicio',
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
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Obx(() {
                                    final services = controller.getListService;
                                    final currentServiceId =
                                        requestData?['serviceType']?['service']?['id'];

                                    if (services.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Cargando servicios...'),
                                      );
                                    }

                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: currentServiceId,
                                        isExpanded: true,
                                        hint: const Text(
                                          'Seleccionar servicio',
                                        ),
                                        items: services
                                            .map<DropdownMenuItem<int>>((
                                              service,
                                            ) {
                                              Color serviceColor = Colors.blue;
                                              final colorHex = service['color'];
                                              if (colorHex != null &&
                                                  colorHex
                                                      .toString()
                                                      .isNotEmpty) {
                                                try {
                                                  serviceColor = Color(
                                                    int.parse(
                                                      colorHex.replaceAll(
                                                        '#',
                                                        '0xFF',
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  serviceColor = Colors.blue;
                                                }
                                              }

                                              return DropdownMenuItem<int>(
                                                value: service['id'],
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 16,
                                                      height: 16,
                                                      margin:
                                                          const EdgeInsets.only(
                                                            right: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: serviceColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        service['service'] ??
                                                            '',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })
                                            .toList(),
                                        onChanged: (int? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              if (requestData != null) {
                                                if (requestData!['serviceType'] ==
                                                    null) {
                                                  requestData!['serviceType'] =
                                                      {};
                                                }
                                                if (requestData!['serviceType']['service'] ==
                                                    null) {
                                                  requestData!['serviceType']['service'] =
                                                      {};
                                                }
                                                requestData!['serviceType']['service']['id'] =
                                                    newValue;
                                                requestData!['FKservices'] =
                                                    newValue;
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

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
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Obx(() {
                          final serviceTypes = controller.getListServiceTypes;
                          final currentServiceId =
                              requestData?['serviceType']?['service']?['id'];
                          final currentServiceTypeId =
                              requestData?['FKservicetypes'];

                          // Filtrar el tipo de servicio correspondiente al servicio
                          final filteredServiceTypes = serviceTypes
                              .where(
                                (type) =>
                                    type['FKservices'] == currentServiceId,
                              )
                              .toList();

                          if (serviceTypes.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Cargando tipos de servicio...'),
                            );
                          }

                          if (filteredServiceTypes.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'No hay tipos de servicio para este servicio',
                              ),
                            );
                          }

                          // Verify if currentServiceTypeId exists in filtered items
                          final valueExists = filteredServiceTypes.any(
                            (type) => type['id'] == currentServiceTypeId,
                          );
                          final effectiveValue = valueExists
                              ? currentServiceTypeId
                              : null;

                          return DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: effectiveValue,
                              isExpanded: true,
                              hint: const Text('Seleccionar tipo de servicio'),
                              items: filteredServiceTypes
                                  .map<DropdownMenuItem<int>>((type) {
                                    return DropdownMenuItem<int>(
                                      value: type['id'],
                                      child: Text(
                                        type['serviceType'] ?? '',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  })
                                  .toList(),
                              onChanged: (int? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    requestData?['FKservicetypes'] = newValue;
                                  });
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Estado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Estado Actual',
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
                                            state['color'].replaceAll(
                                              '#',
                                              '0xFF',
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        stateColor = Colors.grey;
                                      }
                                    }

                                    return Chip(
                                      label: Text(
                                        state['State'] ?? 'Sin estado',
                                      ),
                                      backgroundColor: stateColor.withOpacity(
                                        0.2,
                                      ),
                                      labelStyle: TextStyle(color: stateColor),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cambiar Estado',
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
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Obx(() {
                                    final states = controller.getListStates;
                                    final currentStateId =
                                        requestData?['FKstates'];
                                    final allowedStates = states.where((state) {
                                      if (currentStateId == 1) {
                                        return state['id'] == 1 ||
                                            state['id'] ==
                                                3; // Pendiente o Asignado
                                      } else if (currentStateId == 3) {
                                        return state['id'] == 3 ||
                                            state['id'] ==
                                                4; // Asignado o En proceso
                                      } else if (currentStateId == 4) {
                                        return state['id'] == 4 ||
                                            state['id'] ==
                                                5; // En proceso o Ejecutado
                                      } else if (currentStateId == 5) {
                                        return state['id'] == 5 ||
                                            state['id'] == 6 ||
                                            state['id'] ==
                                                7; // Ejecutado, Resuelto o Cerrado
                                      } else if (currentStateId == 6 ||
                                          currentStateId == 7) {
                                        return state['id'] == 5 ||
                                            state['id'] == 6 ||
                                            state['id'] ==
                                                7; // Ejecutado, Resuelto o Cerrado
                                      }
                                      return false;
                                    }).toList();
                                    if (states.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Cargando estados...'),
                                      );
                                    }

                                    if (allowedStates.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'No hay estados disponibles',
                                        ),
                                      );
                                    }

                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: currentStateId,
                                        isExpanded: true,
                                        hint: const Text('Seleccionar estado'),
                                        items: allowedStates
                                            .map<DropdownMenuItem<int>>((
                                              state,
                                            ) {
                                              Color stateColor;
                                              try {
                                                stateColor = Color(
                                                  int.parse(
                                                    (state['color'] ??
                                                            '#808080')
                                                        .replaceAll(
                                                          '#',
                                                          '0xFF',
                                                        ),
                                                  ),
                                                );
                                              } catch (e) {
                                                stateColor = Colors.grey;
                                              }

                                              return DropdownMenuItem<int>(
                                                value: state['id'],
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 16,
                                                      height: 16,
                                                      margin:
                                                          const EdgeInsets.only(
                                                            right: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: stateColor
                                                            .withOpacity(0.7),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Text(
                                                      state['State'] ??
                                                          'Estado sin nombre',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                           })
                                            .toList(),
                                        onChanged: (int? newValue) {
                                          if (newValue != null) {
                                            final selectedState = allowedStates
                                                .firstWhere(
                                                  (state) =>
                                                      state['id'] == newValue,
                                                  orElse: () => {},
                                                );

                                            setState(() {
                                              requestData?['FKstates'] =
                                                  newValue;
                                              requestData?['State'] =
                                                  selectedState;
                                            });
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Usuario que Realizó la solicitud',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        requestData?['user']?['nameUser'] ?? 'No especificado',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Responsable Asignado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Obx(() {
                          final users = controller.getAssignableUsers;
                          final currentAssignment = requestData?['assignment']?.toString();

                          if (users.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Cargando usuarios...'),
                            );
                          }

                          // Verificar si el usuario asignado actual existe en la lista
                          final assignmentExists = users.any(
                            (user) => user['id'].toString() == currentAssignment
                          );

                          return DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: assignmentExists ? currentAssignment : null,
                              isExpanded: true,
                              hint: const Text('Seleccionar responsable'),
                              items: users.map<DropdownMenuItem<String>>((user) {
                                // Determine role text
                                String roleText = user['FKroles'] == 5 ? 'Instructor' : 
                                                 user['FKroles'] == 6 ? 'Funcionario' : 
                                                 'Rol desconocido';
                                  
                                return DropdownMenuItem<String>(
                                  value: user['id'].toString(),
                                  child: Text(
                                    '${user['nameUser'] ?? 'Usuario sin nombre'} ($roleText)',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    requestData?['assignment'] = newValue;
                                  });
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Lugar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

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
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Obx(() {
                          final municipalities =
                              controller.getListMunicipalities;
                          final currentMunicipality =
                              requestData?['municipality'];

                          if (municipalities.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Cargando municipios...'),
                            );
                          }

                          return DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: currentMunicipality,
                              isExpanded: true,
                              hint: const Text('Seleccionar municipio'),
                              items: municipalities
                                  .map<DropdownMenuItem<String>>((
                                    municipality,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: municipality['name'],
                                      child: Text(
                                        municipality['name'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  })
                                  .toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    requestData?['municipality'] = newValue;
                                  });
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      // Location field
                      const Text(
                        'Ubicación',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter location...',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Comments field
                      const Text(
                        'Comentario',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _commentsController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter comments...',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 20),

                      // Observations field
                      const Text(
                        'Observations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _observationsController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter observations...',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 30),

                      // Update button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Actualizar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
