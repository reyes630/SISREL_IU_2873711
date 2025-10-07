import 'dart:convert';
import 'package:app_adso_711_1/controllers/reactController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../view/request/viewRequests.dart';

const baseUrl = "https://adso711-sisrel-94jo.onrender.com";
const baseUrl2 = "https://api-colombia.com/api/v1/Department/8/cities";

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

// ---------------------------------------- MUNICIPIOS ----------------------------------------

Future fetchMunicipalities() async {
  try {
    final ReactController controller = Get.find<ReactController>();

    final response = await http.get(
      Uri.parse(baseUrl2),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      // Guarda la lista completa de municipios en el controlador
      controller.setListMunicipalities(jsonResponse);
    } else {
      throw Exception('Error al traer los municipios: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

// ---------------------------------------- TIPO DE SERVICIOS ----------------------------------------

Future fetchServiceTypes() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await http.get(
      Uri.parse('${baseUrl}/api/v1/serviceTypes/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final serviceTypesData = jsonResponse['data'];
      controller.setServiceTypes(serviceTypesData);
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al traer los tipos de servicios');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

// ---------------------------------------- TIPO DE EVENTOS ----------------------------------------

Future fetchEventTypes() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await http.get(
      Uri.parse('${baseUrl}/api/v1/eventTypes/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final eventTypesData = jsonResponse['data'];
      controller.setEventType(eventTypesData);
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al traer los tipos de eventos');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

// ---------------------------------------- FORMULARIO DE SOLICITUD ---------------------------------------

Future<void> createRequestWithClient(Map<String, dynamic> formData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    // 1. Crear cliente
    final clientResponse = await http.post(
      Uri.parse('$baseUrl/api/v1/client/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'DocumentClient': formData['documentClient'],
        'NameClient': formData['nameClient'],
        'EmailClient': formData['emailClient'],
        'TelephoneClient': formData['telephoneClient'],
      }),
    );

    if (clientResponse.statusCode != 201 && clientResponse.statusCode != 200) {
      throw Exception('Error al crear el cliente');
    }

    final clientData = jsonDecode(clientResponse.body);
    final clientId = clientData['data']['id'];

    // 2. Formatear fecha
    final formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.parse(formData['eventDate']));

    // 3. Crear solicitud
    final requestData = {
      'eventDate': formattedDate,
      'location': formData['location'] ?? '',
      'municipality': formData['municipality'] ?? '',
      'observations': formData['observations'] ?? '',
      'comments': formData['comments'] ?? '',
      'requestMethod': 'Movil',
      'needDescription': formData['needDescription'] ?? '',
      'assignment': 'Pendiente de asignación',
      'FKstates': 1,
      'FKeventtypes': int.tryParse(formData['eventType'].toString()) ?? 1,
      'FKclients': clientId,
      'FKusers': controller.getCurrentUser?['id'],
      'FKservicetypes': int.tryParse(formData['serviceType'].toString()) ?? 1,
      'archive_status': 0,
    };

    final requestResponse = await http.post(
      Uri.parse('$baseUrl/api/v1/request/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestData),
    );

    if (requestResponse.statusCode == 201 ||
        requestResponse.statusCode == 200) {
      // Cambiar a la pestaña de ViewRequests (índice 1)
      controller.changeToTab(1);

      Get.snackbar(
        'Éxito',
        'Solicitud creada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      throw Exception('Error al crear la solicitud');
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'No se pudo crear la solicitud: ${e.toString()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

// ---------------------------------------- ELIMINAR SOLICITUD ----------------------------------------

Future<bool> deleteRequest(int requestId) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/request/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      // Refrescar la lista de solicitudes
      await fetchRequest();
      return true;
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al eliminar la solicitud');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

// ---------------------------------------- VER SOLICITUD POR ID ----------------------------------------

Future<Map<String, dynamic>> fetchRequestById(int requestId) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    // Agregar parámetros de populate para traer las relaciones
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/request/$requestId?populate=clients,users,states,servicetypes,eventtypes,services'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final requestData = jsonResponse['data'];
      return requestData;
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al traer la solicitud');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}


// ---------------------------------------- SERVICIOS ---------------------------------------
Future fetchServices() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await http.get(
      Uri.parse('${baseUrl}/api/v1/services/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final servicesData = jsonResponse['data'];
      controller.setServices(servicesData);
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al traer los servicios');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

