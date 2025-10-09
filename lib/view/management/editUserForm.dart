import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';

class EditUserForm extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserForm({super.key, required this.user});

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();
  final ReactController controller = Get.find<ReactController>();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _documentController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late String _selectedRole;
  late bool _isCoordinator;

  @override
  void initState() {
    super.initState();
    fetchRoles();
    _nameController = TextEditingController(text: widget.user['nameUser']);
    _emailController = TextEditingController(text: widget.user['emailUser']);
    _documentController =
        TextEditingController(text: widget.user['documentUser']?.toString());
    _phoneController = TextEditingController(text: widget.user['telephoneUser']);
    _passwordController = TextEditingController();
    _selectedRole = widget.user['FKroles']?.toString() ?? '3';
    _isCoordinator = widget.user['coordinator'] ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _documentController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header verde
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF39A900),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.user['nameUser']?[0]?.toUpperCase() ?? 'U',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF39A900),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.user['nameUser'] ?? 'Usuario',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.user['emailUser'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Formulario
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Documento'),
                      TextFormField(
                        controller: _documentController,
                        decoration: _buildInputDecoration(Icons.badge_outlined),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Por favor ingrese el documento' : null,
                      ),
                      const SizedBox(height: 16),

                      _buildFieldLabel('Nombre'),
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(Icons.person_outline),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Por favor ingrese el nombre' : null,
                      ),
                      const SizedBox(height: 16),

                      _buildFieldLabel('Email'),
                      TextFormField(
                        controller: _emailController,
                        decoration: _buildInputDecoration(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Por favor ingrese el email';
                          if (!value!.contains('@')) return 'Por favor ingrese un email válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildFieldLabel('Teléfono'),
                      TextFormField(
                        controller: _phoneController,
                        decoration: _buildInputDecoration(Icons.phone_outlined),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Por favor ingrese el teléfono' : null,
                      ),
                      const SizedBox(height: 16),

                      _buildFieldLabel('Nueva Contraseña'),
                      TextFormField(
                        controller: _passwordController,
                        decoration: _buildInputDecoration(Icons.lock_outline).copyWith(
                          helperText: 'Dejar vacío para mantener la actual',
                          helperStyle: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),

                      _buildFieldLabel('Rol'),
                      Obx(() {
                        final roles = controller.getListRoles;
                        return DropdownButtonFormField<int>(
                          value: int.tryParse(_selectedRole),
                          decoration: _buildInputDecoration(Icons.work_outline),
                          items: roles.map<DropdownMenuItem<int>>((role) {
                            return DropdownMenuItem<int>(
                              value: role['id'],
                              child: Text(role['Role']),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedRole = newValue.toString();
                              });
                            }
                          },
                        );
                      }),
                      const SizedBox(height: 16),

                      _buildFieldLabel('Coordinador'),
                      DropdownButtonFormField<bool>(
                        value: _isCoordinator,
                        decoration: _buildInputDecoration(Icons.stars_outlined),
                        items: const [
                          DropdownMenuItem(value: false, child: Text('No')),
                          DropdownMenuItem(value: true, child: Text('Sí')),
                        ],
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _isCoordinator = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botones
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  _isLoading ? null : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                side: BorderSide(color: Colors.grey[400]!),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => _isLoading = true);
                                        try {
                                          final userData = {
                                            'documentUser': int.parse(
                                                _documentController.text),
                                            'nameUser': _nameController.text.trim(),
                                            'emailUser': _emailController.text.trim(),
                                            'telephoneUser': _phoneController.text.trim(),
                                            'FKroles': int.parse(_selectedRole),
                                            'coordinator': _isCoordinator,
                                          };

                                          if (_passwordController
                                              .text.isNotEmpty) {
                                            userData['passwordUser'] =
                                                _passwordController.text;
                                          }

                                          await updateUser(
                                              widget.user['id'], userData);
                                          if (!mounted) return;
                                          Navigator.pop(context);
                                          Get.snackbar(
                                            'Éxito',
                                            'Usuario actualizado correctamente',
                                            snackPosition:
                                                SnackPosition.BOTTOM,
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                          );
                                        } catch (e) {
                                          Get.snackbar(
                                            'Error',
                                            'No se pudo actualizar el usuario: ${e.toString()}',
                                            snackPosition:
                                                SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        } finally {
                                          if (mounted) {
                                            setState(() => _isLoading = false);
                                          }
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF39A900),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.save, size: 18),
                                        SizedBox(width: 6),
                                        Text(
                                          'Guardar',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: Color(0xFF39A900), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
