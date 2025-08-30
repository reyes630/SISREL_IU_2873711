import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_adso_711_1/main.dart';

// Importamos vistas para las pestañas del TabBar
import '../categories/viewCategories.dart';
import '../events/viewEvents.dart';
import '../login/singIn.dart';
import '../rols/viewRols.dart';
import '../users/ViewUsers.dart';
import 'HomePrincipal.dart';

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
    final Color barraColor = Colors.teal[400]!;

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Center(child: Text(myReactController.getTituloAppBar)),
          backgroundColor: Colors.teal[400],
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.home),
            tooltip: "Inicio",
            onPressed: () {
              setState(() {
                mostrarHome = true; // vuelve al Home dentro del mismo Scaffold
              });
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Cerrar sesión",
              onPressed: () {
                // Regresa a la pantalla de login 
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
            // Cuando estamos en Home, no se mostrara selección:
            labelColor: mostrarHome ? Colors.white70 : Colors.white,
            unselectedLabelColor: Colors.white70, //se quita la seleccion del color
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            indicatorColor: mostrarHome ? Colors.transparent : Colors.white,
            onTap: (index) {
              // Al tocar un tab activamos el modo tabs y se mostrara su contenido
              setState(() {
                mostrarHome = false;
              });
              // animacion para mover la seleccion del tab
              _tabController.animateTo(index);
            },
            tabs: const [
              Tab(icon: Icon(Icons.people), text: "Users"),
              Tab(icon: Icon(Icons.shield), text: "Roles"),
              Tab(icon: Icon(Icons.category), text: "Categories"),
              Tab(icon: Icon(Icons.event), text: "Events"),
            ],
          ),
        ),

        body: mostrarHome
            ? const HomePrincipal()
            : TabBarView(
                controller: _tabController,
                children: const [
                  ViewUsers(),
                  Viewroles(),
                  ViewCategories(),
                  ViewEvents(),
                ],
              ),
      ),
    );
  }
}
