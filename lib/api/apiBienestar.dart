import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_adso_711_1/main.dart';

const baseUrl = 'https://api-bienestar-711.onrender.com';

/// Obtener todas las categorías
Future fetchCategories() async {
  final response = await http.get(Uri.parse('$baseUrl/categories/'));

  if (response.statusCode == 200) {
    myReactController.setListCategories(
      jsonDecode(response.body), // Si tu controlador espera un Map completo
    );
  } else {
    throw Exception('Error al traer las categorías');
  }
}

/// Crear una categoría
Future createCategory(Map<String, dynamic> category) async {
  final response = await http.post(
    Uri.parse('$baseUrl/categories/'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(category),
  );

  if (response.statusCode == 201) {
    await fetchCategories();
  } else {
    throw Exception('Error al crear la categoría');
  }
}

/// Actualizar una categoría
Future updateCategory(int id, Map<String, dynamic> category) async {
  final response = await http.put(
    Uri.parse('$baseUrl/categories/$id'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(category),
  );

  if (response.statusCode == 200) {
    await fetchCategories();
  } else {
    throw Exception('Error al actualizar la categoría');
  }
}

/// Eliminar una categoría
Future deleteCategory(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/categories/$id'),
  );

  if (response.statusCode == 200) {
    await fetchCategories();
  } else {
    throw Exception('Error al eliminar la categoría');
  }
}

//----------- ROLS -------------
/// Obtener todos los roles
Future fetchRoles() async {
  final response = await http.get(Uri.parse('$baseUrl/roles/'));

  if (response.statusCode == 200) {
   myReactController.setListRols(
      jsonDecode(response.body), // Si tu controlador espera un Map completo
    );
  } else {
    throw Exception('Error al traer los roles');
  }
}


/// Crear un rol
Future createRole(Map<String, dynamic> role) async {
  final response = await http.post(
    Uri.parse('$baseUrl/roles/'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(role),
  );

  if (response.statusCode == 201) {
    await fetchRoles();
  } else {
    throw Exception('Error al crear el rol');
  }
}

/// Actualizar un rol
Future updateRole(int id, Map<String, dynamic> role) async {
  final response = await http.put(
    Uri.parse('$baseUrl/roles/$id'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(role),
  );

  if (response.statusCode == 200) {
    await fetchRoles();
  } else {
    throw Exception('Error al actualizar el rol');
  }
}

/// Eliminar un rol
Future deleteRole(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/roles/$id'),
  );

  if (response.statusCode == 200) {
    await fetchRoles();
  } else {
    throw Exception('Error al eliminar el rol');
  }
}



