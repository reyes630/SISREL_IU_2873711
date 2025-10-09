import 'package:app_adso_711_1/view/dashboards/dashboard.dart';
import 'package:app_adso_711_1/view/dashboards/requestDashboard.dart';
import 'package:app_adso_711_1/view/profile/profile.dart';
import 'package:app_adso_711_1/view/requestForm/form_page_1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Importamos vistas para las pestañas del TabBar

import '../../controllers/reactController.dart';
import '../../main.dart';
//import '../Dashboards/dashboardAdmin.dart';
import '../dashboards/dashboardAdmin.dart';
import '../login/singIn.dart';

import '../request/viewRequests.dart';
//import 'HomePrincipal.dart';

class Inicio extends StatefulWidget {
  final int initialRole;
  
  const Inicio({
    Key? key,
    required this.initialRole,
  }) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool mostrarHome = true; // inicia en Home

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    final controller = Get.find<ReactController>();
    controller.setTabController(_tabController);

    // Si cambia el tab (por swipe), salimos de Home automáticamente
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          mostrarHome = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _getHomePageByRole(int role) {
    print('Rol recibido en Inicio: $role'); // Log detallado
    
    switch (role) {
      case 1:
        return const Dashboard();
      case 4:
        return const DashboardAdmin();
      case 5:
      case 6:
        return const RequestDashboard();
      default:
        return const Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color barraColor = const Color.fromARGB(255, 253, 255, 255);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Center(child: Text(myReactController.getTituloAppBar)),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          foregroundColor: const Color(0xFF39A900),
           shape: const Border(
            bottom: BorderSide(
              color: Color(0xFF39A900), 
              width: 1,              
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Cerrar sesión",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: const Row(
                        children: [
                          Icon(Icons.logout, color: Color(0xFF39A900)),
                          SizedBox(width: 10),
                          Text(
                            'Cerrar Sesión',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      content: const Text(
                        '¿Está seguro que desea cerrar sesión?',
                        style: TextStyle(color: Colors.black54),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF39A900),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Close the dialog and navigate to login
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginView()),
                            );
                          },
                          child: const Text('Cerrar Sesión'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),

       bottomNavigationBar: Material(
          color: barraColor,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF39A900),
            unselectedLabelColor: const Color.fromARGB(179, 68, 68, 68),
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            indicatorColor: const Color(0xFF39A900),
            onTap: (index) {
              setState(() {
                mostrarHome = index == 0; // Si es la pestaña 0, estamos en Home
              });
            },
            tabs: const [
              Tab(icon: Icon(Icons.home), text: "Home"),
              Tab(icon: Icon(Icons.list_outlined), text: "Requests"),
              Tab(icon: Icon(Icons.note_add), text: "Form"),
              Tab(icon: Icon(Icons.person), text: "Profile"),
            ],
          ),
        ),

        body: TabBarView(
          controller: _tabController,
          children: [
            _getHomePageByRole(widget.initialRole), // Dynamic home page
            const ViewRequests(),
            const ViewsForm(),
            const ViewProfile()
          ],
        ),

      ),
    );
  }
}
