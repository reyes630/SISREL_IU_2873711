import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';

class StatesManagementView extends StatefulWidget {
  const StatesManagementView({super.key});

  @override
  State<StatesManagementView> createState() => _StatesManagementViewState();
}

class _StatesManagementViewState extends State<StatesManagementView> {
  final ReactController controller = Get.find<ReactController>();

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  void _showStateDialog({Map<String, dynamic>? state}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: state?['State'] ?? '');
    final _descriptionController = TextEditingController(text: state?['Description'] ?? '');
    final _colorController = TextEditingController(text: state?['color'] ?? '#000000');
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(state == null ? 'Crear Estado' : 'Editar Estado'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Estado',
                        hintText: 'Ej: En Proceso',
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
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Ej: Estado cuando la solicitud está siendo procesada',
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una descripción';
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
                        child: CircularProgressIndicator(),
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
                              final stateData = {
                                'State': _nameController.text.trim(),
                                'Description': _descriptionController.text.trim(),
                                'color': _colorController.text.toLowerCase(),
                              };

                              await createState(stateData);
                              // Si no hubo excepción, el estado se creó correctamente
                              if (!mounted) return;
                              Navigator.pop(context);
                              Get.snackbar(
                                'Éxito',
                                'Estado creado correctamente',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            } catch (e) {
                              print('Error en UI: $e'); // Debug log
                              if (!mounted) return;
                              Get.snackbar(
                                'Aviso',
                                'El estado podría haberse creado. Por favor, verifique la lista.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange,
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
                    state == null ? 'Crear' : 'Actualizar',
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

  void _showDeleteConfirmation(Map<String, dynamic> state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Está seguro que desea eliminar el estado "${state['State']}"?'),
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
                  await deleteState(state['id']);
                  Navigator.pop(context);
                  Get.snackbar(
                    'Éxito',
                    'Estado eliminado correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  Navigator.pop(context);
                  Get.snackbar(
                    'Error',
                    'No se pudo eliminar el estado: ${e.toString()}',
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

  void _showStateDetails(Map<String, dynamic> state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Estado'),
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
                      color: Color(int.parse(state['color'].replaceAll('#', '0xFF'))),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    state['State'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Descripción:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state['Description'] ?? 'Sin descripción',
                style: const TextStyle(fontSize: 14),
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
                state['color'],
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
        title: const Text('Gestión de Estados'),
        backgroundColor: const Color(0xFF39A900),
      ),
      body: Obx(() {
        final states = controller.getStates;

        if (states.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: states.length,
          itemBuilder: (context, index) {
            final state = states[index];
            // Reemplazar el return Card en el ListView.builder
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
                            color: Color(int.parse(state['color'].replaceAll('#', '0xFF'))),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      state['State'],
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
                                    onPressed: () => _showStateDetails(state),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Color(0xFF39A900),
                                    ),
                                    onPressed: () => _showStateDialog(state: state),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _showDeleteConfirmation(state),
                                  ),
                                ],
                              ),
                              Text(
                                state['Description'] ?? 'Sin descripción',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.palette_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          state['color'],
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
        child: const Icon(Icons.add),
        onPressed: () => _showStateDialog(),
      ),
    );
  }
}