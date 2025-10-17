import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';
import 'editUserForm.dart';

class UsersManagementView extends StatefulWidget {
  const UsersManagementView({super.key});

  @override
  State<UsersManagementView> createState() => _UsersManagementViewState();
}

class _UsersManagementViewState extends State<UsersManagementView> {
  final ReactController controller = Get.find<ReactController>();
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchRoles(); 
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getRoleName(int roleId) {
    switch (roleId) {
      case 1:
        return 'Administrativo';
      case 3:
        return 'Usuario';
      case 4:
        return 'Administrador';
      case 5:
        return 'Instructor';
      case 6:
        return 'Funcionario';
      default:
        return 'Rol desconocido';
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Está seguro que desea eliminar este usuario?'),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF39A900),
                    radius: 20,
                    child: Text(
                      user['nameUser']?[0]?.toUpperCase() ?? 'U',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['nameUser'] ?? 'Sin nombre',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user['emailUser'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                try {
                  await deleteUser(user['id']);
                  if (!mounted) return;
                  Navigator.pop(context);
                  Get.snackbar(
                    'Éxito',
                    'Usuario eliminado correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  Navigator.pop(context);
                  Get.snackbar(
                    'Error',
                    'No se pudo eliminar el usuario: ${e.toString()}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add this method to filter users
  List<dynamic> _filterUsers(List<dynamic> users, String query) {
    if (query.isEmpty) return users;

    query = query.toLowerCase();
    return users.where((user) {
      final name = (user['nameUser'] ?? '').toString().toLowerCase();
      final document = (user['documentUser'] ?? '').toString().toLowerCase();
      return name.contains(query) || document.contains(query);
    }).toList();
  }

  void _showCreateUserDialog() {
    final _formKey = GlobalKey<FormState>();
    final _documentController = TextEditingController();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    final _passwordController = TextEditingController();
    int? _selectedRole;
    bool _isCoordinator = false;
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Crear Usuario'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _documentController,
                        decoration: const InputDecoration(
                          labelText: 'Documento',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Por favor ingrese el documento'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Por favor ingrese el nombre'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingrese el email';
                          }
                          if (!value!.contains('@')) {
                            return 'Por favor ingrese un email válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Por favor ingrese el teléfono'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Por favor ingrese la contraseña'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        final roles = controller.getListRoles;
                        return DropdownButtonFormField<int>(
                          value: _selectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Rol',
                            prefixIcon: Icon(Icons.work_outline),
                          ),
                          items: roles.map<DropdownMenuItem<int>>((role) {
                            return DropdownMenuItem<int>(
                              value: role['id'],
                              child: Text(role['Role']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Por favor seleccione un rol' : null,
                        );
                      }),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<bool>(
                        value: _isCoordinator,
                        decoration: const InputDecoration(
                          labelText: 'Coordinador',
                          prefixIcon: Icon(Icons.stars_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: false, child: Text('No')),
                          DropdownMenuItem(value: true, child: Text('Sí')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _isCoordinator = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF39A900),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            try {
                              final userData = {
                                'documentUser': int.parse(_documentController.text),
                                'nameUser': _nameController.text.trim(),
                                'emailUser': _emailController.text.trim(),
                                'telephoneUser': _phoneController.text.trim(),
                                'passwordUser': _passwordController.text,
                                'FKroles': _selectedRole,
                                'coordinator': _isCoordinator,
                              };

                              // Validar datos antes de enviar
                              if (userData['FKroles'] == null) {
                                throw Exception('Debe seleccionar un rol');
                              }
                              await createUser(userData);
                              if (!mounted) return;
                              Navigator.pop(context);
                              
                              Get.snackbar(
                                'Éxito',
                                'Usuario creado correctamente',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            } catch (e) {
                              if (!mounted) return;
                              
                              String errorMessage = e.toString();
                              if (errorMessage.contains('duplicate')) {
                                errorMessage = 'El documento o email ya existe en el sistema';
                              }
                              
                              Get.snackbar(
                                'Error',
                                errorMessage.replaceAll('Exception: ', ''),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 4),
                              );
                            } finally {
                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Crear',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Update the build method to include the search bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Usuarios',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF39A900),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o documento...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF39A900)),
                suffixIcon: Obx(() => _searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchQuery.value = '';
                        },
                      )
                    : const SizedBox.shrink()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF39A900), width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) => _searchQuery.value = value,
            ),
          ),
          // Users list
          Expanded(
            child: Obx(() {
              final users = controller.getListUsers;
              final filteredUsers = _filterUsers(users, _searchQuery.value);

              if (users.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF39A900),
                  ),
                );
              }

              if (filteredUsers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron usuarios',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFF39A900),
                                child: Text(
                                  user['nameUser']?[0]?.toUpperCase() ?? 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            user['nameUser'] ?? 'Sin nombre',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Color(0xFF39A900),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => EditUserForm(user: user),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _showDeleteConfirmation(user),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _getRoleName(user['FKroles']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                user['emailUser'] ?? 'Sin email',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                user['telephoneUser'] ?? 'Sin teléfono',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.badge_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Doc: ${user['documentUser'] ?? 'Sin documento'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchRoles();
          _showCreateUserDialog();
        },
        backgroundColor: const Color(0xFF39A900),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}