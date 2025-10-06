import 'dart:convert';
import 'package:app_adso_711_1/controllers/reactController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://adso711-sisrel-94jo.onrender.com";

Future fetchUsers() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await http.get(
      Uri.parse('${baseUrl}/api/v1/users/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final categoryData = jsonResponse['data'];
      controller.setListUsers(categoryData);
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al traer los datos de usuarios');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future fetchRequest() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await http.get(
      Uri.parse('${baseUrl}/api/v1/request/'), // Agregamos ?populate=client
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final requestsData = jsonResponse['data'];
      controller.setRequest(requestsData);
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al traer las solicitudes');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future fetchClients() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await http.get(
      Uri.parse('${baseUrl}/api/v1/clients/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final clientsData = jsonResponse['data'];
      controller.setlistClient(clientsData);
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al traer los datos de clientes');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

