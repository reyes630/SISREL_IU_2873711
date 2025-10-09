import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reactController.dart';
import '../../services/authService.dart';
import '../interface/inicio.dart';
import 'forgotPassword.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ReactController controller = Get.find<ReactController>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

Future<void> _handleLogin() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text;

  setState(() {
    _isLoading = true;
  });

  try {
    final result = await AuthService.login(email, password);

    if (result['success']) {
      // Accedemos correctamente a los datos del usuario
      final userData = result['data']['user'];
      controller.saveLoginData(result['data']);
      
      // Obtenemos el rol del objeto user
      final userRole = userData['FKroles'] as int;
      
      if (!mounted) return;
      
      _showSnackBar('¡Bienvenido!');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Inicio(initialRole: userRole),
        ),
      );
    } else {
      _showSnackBar(result['message'] ?? 'Error al iniciar sesión', isError: true);
    }
  } catch (e) {
    _showSnackBar('Error inesperado: ${e.toString()}', isError: true);
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/FondoLogin.png",
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Card(
                    color: const Color(0xFFFFFFFF),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            "INICIO SESIÓN",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF39A900),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Correo Electrónico",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 12, 12, 12),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: const Color.fromARGB(255, 63, 63, 63),
                                decoration: const InputDecoration(
                                  hintText: 'ejemplo@correo.com',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 1)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF39A900)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Contraseña",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 12, 12, 12),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                cursorColor: const Color.fromARGB(255, 63, 63, 63),
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 1)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF39A900)),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: _isLoading ? null : _handleLogin,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: _isLoading ? Colors.grey : const Color(0xFF04324D),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPasswordView()),
                              );
                            },
                            child: const Text(
                              "¿Olvidó su contraseña?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
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
      ),
    );
  }
}