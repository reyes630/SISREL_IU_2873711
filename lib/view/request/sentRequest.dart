import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';
import '../CRUD/viewRequest.dart';

class SentRequests extends StatefulWidget {
  const SentRequests({super.key});

  @override
  State<SentRequests> createState() => _SentRequestsState();
}

class _SentRequestsState extends State<SentRequests> {
  final ReactController controller = Get.find<ReactController>();

  @override
  void initState() {
    super.initState();
    fetchSentRequests();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solicitudes Enviadas',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Obx(() {
        final requests = controller.getSentRequests;

        if (requests.isEmpty) {
          return const Center(
            child: Text('No hay solicitudes enviadas'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  request['Client']?['NameClient'] ?? 'Cliente no disponible',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Fecha: ${request['createdAt']?.substring(0, 10) ?? 'No disponible'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            request['State']?['State'] ?? 'Sin estado',
                            style: TextStyle(
                              color: parseApiColor(request['State']?['color']),
                              fontSize: 12,
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
                              color: parseApiColor(request['serviceType']
                                  ?['service']?['color']),
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: parseApiColor(request['serviceType']
                                  ?['service']?['color'])
                              .withOpacity(0.1),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ViewRequestFormModal(
                          requestId: request['id'],
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}