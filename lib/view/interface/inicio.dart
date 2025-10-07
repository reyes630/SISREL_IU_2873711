import 'package:app_adso_711_1/view/dashboards/requestDashboard.dart';
import 'package:app_adso_711_1/view/profile/profile.dart';
import 'package:app_adso_711_1/view/requestForm/form_page_1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Importamos vistas para las pestañas del TabBar

import '../../controllers/reactController.dart';
import '../../main.dart';
//import '../Dashboards/dashboardAdmin.dart';
import '../login/singIn.dart';

import '../request/viewRequests.dart';
//import 'HomePrincipal.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

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
                // Acción al cerrar sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
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
          children: const [
            RequestDashboard(), // Vista de inicio (ESTA DEPENDERA DEL ROL)
            ViewRequests(), // vista de las solicitudes
            ViewsForm(),     // Vista del formulario
            ViewProfile()      //Vista de perfil     
          ],
        ),

      ),
    );
  }
}
