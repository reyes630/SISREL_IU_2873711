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

//----------- USUARIOS -------------
/// Obtener todos los usuarios
Future fetchUsers() async {
  final response = await http.get(Uri.parse('$baseUrl/users/'));

  if (response.statusCode == 200) {
    myReactController.setListUsers(
      jsonDecode(response.body),
    );
  } else {
    throw Exception('Error al traer los usuarios');
  }
}

/// Crear un usuario
Future createUser(Map<String, dynamic> user) async {
  final response = await http.post(
    Uri.parse('$baseUrl/users/'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(user),
  );

  if (response.statusCode == 201) {
    await fetchUsers();
  } else {
    throw Exception('Error al crear el usuario');
  }
}

/// Actualizar un usuario
Future updateUser(int id, Map<String, dynamic> user) async {
  final response = await http.put(
    Uri.parse('$baseUrl/users/$id'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(user),
  );

  if (response.statusCode == 200) {
    await fetchUsers();
  } else {
    throw Exception('Error al actualizar el usuario');
  }
}

/// Eliminar un usuario
Future deleteUser(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/users/$id'),
  );

  if (response.statusCode == 200) {
    await fetchUsers();
  } else {
    throw Exception('Error al eliminar el usuario');
  }
}

//----------- EVENTOS -------------
/// Obtener todos los eventos
Future fetchEvents() async {
  final response = await http.get(Uri.parse('$baseUrl/events/'));

  if (response.statusCode == 200) {
    myReactController.setListEvents(
      jsonDecode(response.body),
    );
  } else {
    throw Exception('Error al traer los eventos');
  }
}

/// Crear un evento
Future createEvent(Map<String, dynamic> event) async {
  final response = await http.post(
    Uri.parse('$baseUrl/events/'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(event),
  );

  if (response.statusCode == 201) {
    await fetchEvents();
  } else {
    throw Exception('Error al crear el evento');
  }
}

/// Actualizar un evento
Future updateEvent(int id, Map<String, dynamic> event) async {
  final response = await http.put(
    Uri.parse('$baseUrl/events/$id'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(event),
  );

  if (response.statusCode == 200) {
    await fetchEvents();
  } else {
    throw Exception('Error al actualizar el evento');
  }
}

/// Eliminar un evento
Future deleteEvent(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/events/$id'),
  );

  if (response.statusCode == 200) {
    await fetchEvents();
  } else {
    throw Exception('Error al eliminar el evento');
  }
}



