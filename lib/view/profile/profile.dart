import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_adso_711_1/controllers/reactController.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final ReactController controller = Get.find<ReactController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() {
            final currentUser = controller.getCurrentUser;
            if (currentUser == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final isCoordinator = currentUser['coordinator'] == true;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF39A900),
                            width: 5,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentUser['nameUser']?.toString() ?? 'No disponible',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentUser['emailUser']?.toString() ?? 'No disponible',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 250, 250),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF39A900)),
                  ),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                        ),
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Center(
                              child: Text(
                                'Documento',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Center(
                              child: Text(
                                'Rol',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Center(
                              child: Text(
                                'Teléfono',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Center(
                              child: Text(
                                'Coordinador',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Center(
                              child: Text(
                                currentUser['documentUser']?.toString() ??
                                    'No disponible',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Center(
                              child: Text(
                                currentUser['role']?['Role']?.toString() ??
                                    'No disponible',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Center(
                              child: Text(
                                currentUser['telephoneUser']?.toString() ??
                                    'No disponible',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Center(
                              child: Text(
                                isCoordinator ? 'Sí' : 'No',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isCoordinator
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Acción para modificar perfil
                    },
                    icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                    label: const Text(
                      'Modificar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF04324D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
