
import 'package:flutter/material.dart';
import '../interface/inicio.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/fondoLogin.png", // IMAGEN DE FONDO
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                    // Tarjeta blanca con el formulario
                    Card(
                      color: const Color(0xFFFFFFFF),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              "INICIO SESIÓN",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF39A900), 
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Campo usuario
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                   "Usuario",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 12, 12, 12),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      ),
                                ),
                                TextField(
                                  cursorColor: Color.fromARGB(255, 63, 63, 63),
                                  decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: const Color.fromRGBO(0, 0, 0, 1))
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF39A900)), // color al enfocar
                                  ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                 Text(
                                   "Contraseña",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 12, 12, 12),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      ),
                                ),
                                TextField(
                                  obscureText: true, // 👈 oculta el texto con •••
                                  cursorColor: Color.fromARGB(255, 63, 63, 63),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 1)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF39A900)), // color al enfocar
                                    ),
                                  ),
                                ),
                              ],
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
                                  color: const Color(0xFF04324D), 
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Ingresar",
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
        ],
      )
    );
  }
}
