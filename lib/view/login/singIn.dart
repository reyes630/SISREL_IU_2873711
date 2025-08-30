
import 'package:flutter/material.dart';
import '../interface/inicio.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900], 
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Texto de bienvenida
              const Text(
                "Bienvenido",
                style: TextStyle(
                  color: Colors.white, // texto blanco
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Tarjeta blanca con el formulario
              Card(
                color: Colors.teal[50],
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Campo usuario
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Usuario",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Campo contraseña
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Botón de entrar con InkWell
                      InkWell(
                        onTap: () {
                          // 🔹 Navegar al inicio
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Inicio()),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.teal[400], // 🔵 botón azul
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Texto de olvidar contraseña
                      const Text(
                        "¿Olvidó su contraseña?",
                        style: TextStyle(
                          color: Colors.black, // texto negro
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              
            ],
          ),
        ),
      ),
    );
  }
}
