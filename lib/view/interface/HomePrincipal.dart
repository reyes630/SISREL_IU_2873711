import 'package:flutter/material.dart';

class HomePrincipal extends StatefulWidget {
  const HomePrincipal({super.key});

  @override
  State<HomePrincipal> createState() => _HomePrincipalState();
}

class _HomePrincipalState extends State<HomePrincipal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('En la app Bienestar SENA encontraras todos los eventos deportivos de SENA Regional Caldas')),
    );
  }
}