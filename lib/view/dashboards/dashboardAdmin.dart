import 'package:flutter/material.dart';

import '../../api/apiSisrel.dart';
import '../management/servicesManagement.dart';
import '../management/statesManagement.dart';
import '../management/usersManagement.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int resolvedThisMonth = 0;
  int newUsersThisMonth = 0;
  int newRequestsThisMonth = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    try {
      setState(() => isLoading = true);
      
      // Cargar todas las estadísticas
      final resolved = await fetchResolvedRequestsCurrentMonth();
      final newUsers = await fetchNewUsersCurrentMonth();
      final newRequests = await fetchNewRequestsCurrentMonth();
      
      if (mounted) {
        setState(() {
          resolvedThisMonth = resolved;
          newUsersThisMonth = newUsers;
          newRequestsThisMonth = newRequests;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading statistics: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stack con contenedor verde y tarjetas flotantes
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Contenedor verde
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF39A900),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Gestión de Datos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 80), // espacio para tarjetas
                    ],
                  ),
                ),

                // Tarjetas flotando
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildManagementCard(
                          title: 'USUARIOS', // Eliminamos el espacio extra
                          color: const Color(0xFFFFFFFF),
                          icon: Icons.group_outlined,
                        ),
                        const SizedBox(width: 12),
                        _buildManagementCard(
                          title: 'SERVICIOS',
                          color: const Color(0xFFFFFFFF),
                          icon: Icons.miscellaneous_services_sharp,
                        ),
                        const SizedBox(width: 12),
                        _buildManagementCard(
                          title: 'ESTADOS',
                          color: const Color(0xFFFFFFFF),
                          icon: Icons.storage_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60), 

            // Sección Solicitudes Finalizadas
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Solicitudes Finalizadas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14181B),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF04324d),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon( 
                    Icons.check_circle_outline,
                    size: 80,
                    color: Color(0xFFF7F7F7),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 20,
                    thickness: 1,
                  ),
                  const Text(
                    'Solicitudes resueltas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : Text(
                        resolvedThisMonth.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Otras tarjetas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Usuarios Registrados
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Usuarios Registrados',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF39A900),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nuevos registros de usuarios',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isLoading ? '...' : newUsersThisMonth.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nuevas Solicitudes
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nuevas Solicitudes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF39A900),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Solicitudes actuales',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isLoading ? '...' : newRequestsThisMonth.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard({
    required String title,
    required Color color,
    IconData icon = Icons.manage_accounts,
  }) {
    return InkWell(
      onTap: () {
        switch (title.trim()) { // Agregamos trim() para eliminar espacios
          case 'USUARIOS':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UsersManagementView(),
              ),
            );
            break;
          case 'SERVICIOS':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ServicesManagementView(),
              ),
            );
            break;
          case 'ESTADOS':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StatesManagementView(),
              ),
            );
            break;
        }
      },
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Círculo con ícono
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF39A900),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gestión de',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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









