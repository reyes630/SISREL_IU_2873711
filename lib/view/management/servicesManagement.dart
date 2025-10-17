import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';

class ServicesManagementView extends StatefulWidget {
  const ServicesManagementView({super.key});

  @override
  State<ServicesManagementView> createState() => _ServicesManagementViewState();
}

class _ServicesManagementViewState extends State<ServicesManagementView> {
  final ReactController controller = Get.find<ReactController>();

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void _showServiceDialog({Map<String, dynamic>? service}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController =
        TextEditingController(text: service?['service'] ?? '');
    final _colorController =
        TextEditingController(text: service?['color'] ?? '#000000');
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title:
                  Text(service == null ? 'Crear Servicio' : 'Editar Servicio'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Servicio',
                        hintText: 'Ej: Soporte Técnico',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _colorController,
                      decoration: const InputDecoration(
                        labelText: 'Color (HEX)',
                        hintText: '#000000',
                        helperText: 'Formato: #RRGGBB',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un color';
                        }
                        if (!value.startsWith('#')) {
                          return 'El color debe comenzar con #';
                        }
                        if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value)) {
                          return 'Formato inválido. Use #RRGGBB';
                        }
                        return null;
                      },
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF39A900),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF39A900),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            try {
                              final serviceData = {
                                'service': _nameController.text.trim(),
                                'color': _colorController.text.toLowerCase(),
                              };

                              if (service == null) {
                                await createService(serviceData);
                                if (!mounted) return;
                                Navigator.pop(context);
                                Get.snackbar(
                                  'Éxito',
                                  'Servicio creado correctamente',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              }
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'No se pudo crear el servicio: ${e.toString()}',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } finally {
                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          }
                        },
                  child: Text(
                    service == null ? 'Crear' : 'Actualizar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Está seguro que desea eliminar el servicio "${service['service']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                try {
                  await deleteService(service['id']);
                  Navigator.pop(context);
                  Get.snackbar(
                    'Éxito',
                    'Servicio eliminado correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  Navigator.pop(context);
                  Get.snackbar(
                    'Error',
                    'No se pudo eliminar el servicio: ${e.toString()}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showServiceDetails(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Servicio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color:
                          Color(int.parse(service['color'].replaceAll('#', '0xFF'))),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    service['service'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Código de color:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service['color'],
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF39A900),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Servicios'),
        backgroundColor: const Color(0xFF39A900),
      ),
      body: Obx(() {
        final services = controller.getServices;

        if (services.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                Color(int.parse(service['color'].replaceAll('#', '0xFF'))),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service['service'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  size: 20,
                                  color: Color(0xFF39A900),
                                ),
                                onPressed: () => _showServiceDetails(service),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color(0xFF39A900),
                                ),
                                onPressed: () => _showServiceDialog(service: service),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDeleteConfirmation(service),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.palette_outlined, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          service['color'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF39A900),
        child: const Icon(Icons.add, color: Colors.white), 
        onPressed: () {
          _showServiceDialog();
        },
      ),
    );
  }
}