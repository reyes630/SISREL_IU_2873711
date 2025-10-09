import 'dart:async';
import 'dart:convert';
import 'package:app_adso_711_1/controllers/reactController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../view/request/viewRequests.dart';

const baseUrl = "https://adso711-sisrel-94jo.onrender.com";
const baseUrl2 = "https://api-colombia.com/api/v1/Department/8/cities";

final httpClient = http.Client();
const Duration apiTimeout = Duration(seconds: 60);

Future fetchUsers() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/users/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

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

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List allRequests = jsonResponse['data'];
      
      final activeRequests = allRequests.where((request) => 
        request['archive_status'] == 0 || request['archive_status'] == null
      ).toList();
      
      controller.setRequest(activeRequests);
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

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/clients/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

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

Future fetchMunicipalities() async {
  try {
    final ReactController controller = Get.find<ReactController>();

    final response = await httpClient.get(
      Uri.parse(baseUrl2),
      headers: {'Content-Type': 'application/json'},
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      controller.setListMunicipalities(jsonResponse);
    } else {
      throw Exception('Error al traer los municipios: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future fetchServiceTypes() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/serviceTypes/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

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

Future fetchEventTypes() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/eventTypes/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

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

Future<void> createRequestWithClient(Map<String, dynamic> formData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final clientResponse = await httpClient.post(
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
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (clientResponse.statusCode != 201 && clientResponse.statusCode != 200) {
      throw Exception('Error al crear el cliente');
    }

    final clientData = jsonDecode(clientResponse.body);
    final clientId = clientData['data']['id'];

    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(formData['eventDate']));

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

    final requestResponse = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/request/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestData),
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (requestResponse.statusCode == 201 || requestResponse.statusCode == 200) {
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

Future<bool> deleteRequest(int requestId) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.delete(
      Uri.parse('$baseUrl/api/v1/request/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200 || response.statusCode == 204) {
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

Future<Map<String, dynamic>> fetchRequestById(int requestId) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/request/$requestId?populate=clients,users,states,servicetypes,eventtypes,services'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

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

Future<void> updateRequest(int requestId, Map<String, dynamic> updateData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.put(
      Uri.parse('$baseUrl/api/v1/request/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updateData),
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      await fetchRequest();
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al actualizar la solicitud');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> fetchArchivedRequests() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List allRequests = jsonResponse['data'];
      
      final archivedRequests = allRequests.where((request) => 
        request['archive_status'] == 1
      ).toList();
      
      controller.setArchivedRequests(archivedRequests);
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
    } else {
      throw Exception('Error al cargar las solicitudes archivadas');
    }
  } catch (e) {
    print('Error fetching archived requests: $e');
    throw Exception('Error: ${e.toString()}');
  }
}

Future fetchServices() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/services/'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

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

Future fetchStates() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/states'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> statesData = jsonResponse['data'] as List<dynamic>;
      controller.setStates(statesData);
    } else {
      throw Exception('Error al cargar los estados');
    }
  } catch (e) {
    print('Error fetching states: $e');
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> fetchAssignableUsers() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List allUsers = jsonResponse['data'];
      
      final assignableUsers = allUsers.where((user) => 
        user['FKroles'] == 5 || user['FKroles'] == 6
      ).toList();
      
      controller.setAssignableUsers(assignableUsers);
    } else {
      throw Exception('Error al cargar los usuarios asignables');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> updateUserProfile(Map<String, dynamic> updateData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;
    final currentUser = controller.getCurrentUser;

    if (currentUser == null) {
      throw Exception('No se encontró el usuario actual');
    }

    final userData = {
      'documentUser': updateData['documentUser'],
      'nameUser': updateData['nameUser'],
      'emailUser': updateData['emailUser'],
      'telephoneUser': updateData['telephoneUser'],
      'FKroles': currentUser['FKroles'],
      'coordinator': currentUser['coordinator'],
      'passwordUser': currentUser['passwordUser'],
    };

    final response = await httpClient.put(
      Uri.parse('$baseUrl/api/v1/users/${currentUser['id']}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      controller.setCurrentUser(jsonResponse['data']);
      await fetchUsers();
    } else {
      throw Exception('Error al actualizar el perfil: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al actualizar: ${e.toString()}');
  }
}

Future<Map<String, dynamic>> fetchServicesStatistics() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List requests = jsonResponse['data'];
      
      Map<String, int> serviceCount = {};
      Map<String, String> serviceColors = {};

      for (var request in requests) {
        final serviceName = request['serviceType']?['service']?['service'] ?? 'Sin servicio';
        final serviceColor = request['serviceType']?['service']?['color'] ?? '#000000';
        
        serviceCount[serviceName] = (serviceCount[serviceName] ?? 0) + 1;
        serviceColors[serviceName] = serviceColor;
      }

      return {
        'counts': serviceCount,
        'colors': serviceColors,
      };
    } else {
      throw Exception('Error al obtener estadísticas de servicios');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<Map<String, dynamic>> fetchMunicipalityStatistics() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List requests = jsonResponse['data'];
      
      Map<String, int> municipalityCount = {};

      for (var request in requests) {
        final municipality = request['municipality'] ?? 'Sin municipio';
        municipalityCount[municipality] = (municipalityCount[municipality] ?? 0) + 1;
      }

      var sortedEntries = municipalityCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return {
        'counts': Map.fromEntries(sortedEntries),
      };
    } else {
      throw Exception('Error al obtener estadísticas de municipios');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<Map<String, dynamic>> fetchStateStatistics() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(apiTimeout, onTimeout: () {
      throw TimeoutException('El servidor tardó demasiado en responder');
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List requests = jsonResponse['data'];
      
      Map<String, int> stateCount = {};
      Map<String, String> stateColors = {};

      for (var request in requests) {
        final stateName = request['State']?['State'] ?? 'Sin estado';
        final stateColor = request['State']?['color'] ?? '#000000';
        
        stateCount[stateName] = (stateCount[stateName] ?? 0) + 1;
        stateColors[stateName] = stateColor;
      }

      return {
        'counts': stateCount,
        'colors': stateColors,
      };
    } else {
      throw Exception('Error al obtener estadísticas de estados');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

// 🔐 RECUPERAR CONTRASEÑA
Future<Map<String, dynamic>> forgotPassword(String email) async {
  try {
    print('Enviando solicitud de recuperación a: $email');

    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    ).timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        throw TimeoutException('El servidor tardó demasiado en responder');
      },
    );

    print('Status code: ${response.statusCode}');
    print('Respuesta del servidor: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': responseData['message'] ?? 'Se ha enviado un correo con las instrucciones'
      };
    } else if (response.statusCode == 404) {
      throw Exception('No se encontró una cuenta con ese correo');
    } else {
      throw Exception(responseData['message'] ?? 'Error al procesar la solicitud');
    }
  } on TimeoutException catch (e) {
    print('Error de timeout en forgotPassword: $e');
    throw Exception('El servidor tardó demasiado en responder. Intenta nuevamente.');
  } catch (e) {
    print('Error en forgotPassword: $e');
    throw Exception('Error al procesar la solicitud: ${e.toString()}');
  }
}


Future<Map<String, dynamic>> verifyResetCode(String code) async {
  try {
    print('Verificando código: $code');

    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/auth/verify-reset-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'code': code}),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException('El servidor tardó demasiado en responder');
      },
    );

    print('Respuesta verificación: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return {
        'success': true,
        'email': responseData['email'],
      };
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Código inválido o expirado');
    } else {
      throw Exception('Error al verificar el código');
    }
  } on TimeoutException catch (e) {
    print('Error de timeout en verifyResetCode: $e');
    throw Exception('Timeout al verificar el código');
  } catch (e) {
    print('Error en verifyResetCode: $e');
    throw Exception(e.toString());
  }
}

// 🔐 RESTABLECER CONTRASEÑA
Future<bool> resetPassword(String token, String newPassword) async {
  try {
    print('Reseteando contraseña con token: $token');

    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'newPassword': newPassword,
      }),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException('El servidor tardó demasiado en responder');
      },
    );

    print('Respuesta reset password: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Error al restablecer la contraseña');
    } else {
      throw Exception('Error del servidor');
    }
  } on TimeoutException catch (e) {
    print('Error de timeout en resetPassword: $e');
    throw Exception('Timeout al restablecer la contraseña');
  } catch (e) {
    print('Error en resetPassword: $e');
    throw Exception(e.toString());
  }
}