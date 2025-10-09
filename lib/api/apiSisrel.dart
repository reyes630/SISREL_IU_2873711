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
    final currentUser = controller.getCurrentUser;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List allRequests = jsonResponse['data'];
      
      List filteredRequests;
      final userRole = currentUser?['FKroles'];
      
      if (userRole == 1) { // Administrativo
        // Solo mostrar solicitudes creadas por el usuario
        filteredRequests = allRequests.where((request) {
          bool isOwnRequest = request['FKusers'].toString() == currentUser?['id'].toString();
          bool isActive = request['archive_status'] == 0 || request['archive_status'] == null;
          return isOwnRequest && isActive;
        }).toList();
      } else if (userRole == 5 || userRole == 6) { // Instructor o Funcionario
        // Solo mostrar solicitudes asignadas al usuario
        filteredRequests = allRequests.where((request) {
          bool isActive = request['archive_status'] == 0 || request['archive_status'] == null;
          bool isAssigned = request['assignment'] == currentUser?['id'].toString();
          return isActive && isAssigned;
        }).toList();
      } else {
        // Para otros roles, mostrar todas las solicitudes activas
        filteredRequests = allRequests.where((request) => 
          request['archive_status'] == 0 || request['archive_status'] == null
        ).toList();
      }
      
      controller.setRequest(filteredRequests);
    } else if (response.statusCode == 401) {
      controller.logout();
      throw Exception('Sesión expirada. Por favor inicie sesión nuevamente.');
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

    // Si hay una asignación, asegurar que se guarde correctamente
    if (updateData.containsKey('assignment') && updateData['assignment'] != null) {
      // Convertir el ID del usuario asignado a string para comparación consistente
      updateData['assignment'] = updateData['assignment'].toString();
    }

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

Future<void> fetchSentRequests() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;
    final currentUser = controller.getCurrentUser;

    final response = await httpClient.get(
      Uri.parse('${baseUrl}/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List allRequests = jsonResponse['data'];
      
      // Filtrar solicitudes creadas por el usuario actual
      final sentRequests = allRequests.where((request) => 
        request['FKusers'].toString() == currentUser?['id'].toString()
      ).toList();
      
      controller.setSentRequests(sentRequests);
    } else {
      throw Exception('Error al cargar las solicitudes enviadas');
    }
  } catch (e) {
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

    // Crear objeto de actualización conservando datos importantes
    final Map<String, dynamic> userData = {
      'documentUser': updateData['documentUser'],
      'nameUser': updateData['nameUser'],
      'emailUser': updateData['emailUser'],
      'telephoneUser': updateData['telephoneUser'],
      'FKroles': currentUser['FKroles'], // Mantener el rol actual
      'coordinator': currentUser['coordinator'] ?? false,
      'role': currentUser['role'], // Mantener la información completa del rol
    };
    // Solo incluir la contraseña si se proporcionó una nueva
    if (updateData['passwordUser'] != null && updateData['passwordUser'].isNotEmpty) {
      userData['passwordUser'] = updateData['passwordUser'];
    }
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
      // Asegurarse de mantener la información del rol al actualizar el usuario
      final updatedUserData = jsonResponse['data'];
      if (currentUser['role'] != null) {
        updatedUserData['role'] = currentUser['role'];
      }
      controller.setCurrentUser(updatedUserData);
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
    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/auth/forgot-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(), // Asegurar que el email no tenga espacios
      }),
    ).timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        throw TimeoutException('El servidor tardó demasiado en responder');
      },
    );

    print('Respuesta del servidor: ${response.body}'); // Para debug

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return {
        'success': true,
        'message': responseData['message'] ?? 'Se ha enviado un token a tu correo'
      };
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Error al procesar la solicitud');
    }
  } catch (e) {
    print('Error en forgotPassword: $e'); // Para debug
    throw Exception('Error al procesar la solicitud: ${e.toString()}');
  }
}

// También modificar el método verifyResetCode:
Future<Map<String, dynamic>> verifyResetCode(String code) async {
  try {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/auth/verify-reset-code'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'code': code.trim(), // Asegurar que el código no tenga espacios
      }),
    );

    print('Código enviado: ${code.trim()}'); // Para debug
    print('Respuesta verificación: ${response.body}'); // Para debug

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'email': responseData['email'],
        'token': responseData['token'], // Asegurarse de obtener el token
      };
    } else {
      throw Exception(responseData['message'] ?? 'Token inválido o expirado');
    }
  } catch (e) {
    print('Error en verifyResetCode: $e'); // Para debug
    throw Exception('Error al verificar el token: ${e.toString()}');
  }
}

// 🔐 RESTABLECER CONTRASEÑA
Future<bool> resetPassword(String token, String newPassword) async {
  try {
    print('Iniciando reseteo de contraseña...');
    print('Token recibido: $token');

    if (token.isEmpty || newPassword.isEmpty) {
      throw Exception('El token y la nueva contraseña son obligatorios');
    }

    final Map<String, dynamic> requestBody = {
      'token': token.trim(),
      'newPassword': newPassword,
    };

    print('Cuerpo de la solicitud: $requestBody');

    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/auth/reset-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('Código de estado: ${response.statusCode}');
    print('Respuesta del servidor: ${response.body}');

    // Aceptar tanto 200 como 201 como respuestas exitosas
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final errorData = jsonDecode(response.body);
      if (response.statusCode == 400 && errorData['message']?.contains('token') ?? false) {
        throw Exception('El token ha expirado o no es válido');
      }
      throw Exception(errorData['message'] ?? 'Error al restablecer la contraseña');
    }
  } catch (e) {
    print('Error en resetPassword: $e');
    rethrow; // Propagar el error original
  }
}

// ESTADISTICAS ADMINISTRATIVO
Future<Map<String, int>> fetchRequestStatusStatistics() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List requests = jsonResponse['data'];
      
      Map<String, int> statusCount = {
        'pending': 0,
        'resolved': 0,
        'inProcess': 0,
        'executed': 0
      };

      for (var request in requests) {
        final stateId = request['FKstates'];
        switch (stateId) {
          case 1: // Pendiente
            statusCount['pending'] = (statusCount['pending'] ?? 0) + 1;
            break;
          case 4: // En proceso
            statusCount['inProcess'] = (statusCount['inProcess'] ?? 0) + 1;
            break;
          case 5: // Ejecutada
            statusCount['executed'] = (statusCount['executed'] ?? 0) + 1;
            break;
          case 6: // Resuelta
            statusCount['resolved'] = (statusCount['resolved'] ?? 0) + 1;
            break;
        }
      }

      return statusCount;
    } else {
      throw Exception('Error al obtener estadísticas');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error al cargar estadísticas');
  }
}

// ESTADISTICAS ADMINISTRADOR
Future<int> fetchResolvedRequestsCurrentMonth() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List requests = jsonResponse['data'];
      
      // Obtener el primer y último día del mes actual
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      // Filtrar solicitudes resueltas del mes actual
      final resolvedThisMonth = requests.where((request) {
        // Verificar si la solicitud está resuelta (estado 6)
        if (request['FKstates'] != 6) return false;

        // Convertir la fecha de la solicitud
        final requestDate = DateTime.parse(request['updatedAt']);
        
        // Verificar si la fecha está en el mes actual
        return requestDate.isAfter(firstDayOfMonth) && 
              requestDate.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
      }).length;

      return resolvedThisMonth;
    } else {
      throw Exception('Error al obtener estadísticas');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error al cargar estadísticas');
  }
}

Future<int> fetchNewUsersCurrentMonth() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List users = jsonResponse['data'];
      
      // Obtener el primer y último día del mes actual
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      // Filtrar usuarios creados este mes
      final newUsersThisMonth = users.where((user) {
        final createdAt = DateTime.parse(user['createdAt']);
        return createdAt.isAfter(firstDayOfMonth) && 
               createdAt.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
      }).length;

      return newUsersThisMonth;
    } else {
      throw Exception('Error al obtener estadísticas de usuarios');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error al cargar estadísticas de usuarios');
  }
}

Future<int> fetchNewRequestsCurrentMonth() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List requests = jsonResponse['data'];
      
      // Obtener el primer y último día del mes actual
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      // Filtrar solicitudes creadas este mes
      final newRequestsThisMonth = requests.where((request) {
        final createdAt = DateTime.parse(request['createdAt']);
        return createdAt.isAfter(firstDayOfMonth) && 
               createdAt.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
      }).length;

      return newRequestsThisMonth;
    } else {
      throw Exception('Error al obtener estadísticas de solicitudes');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error al cargar estadísticas de solicitudes');
  }
}

Future<int> fetchTotalUsers() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List users = jsonResponse['data'];
      return users.length;
    } else {
      throw Exception('Error al obtener total de usuarios');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error al cargar total de usuarios');
  }
}

// Agregar estos métodos al final del archivo

Future<void> createService(Map<String, dynamic> serviceData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/services'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(serviceData),
    );

    if (response.statusCode == 201) {
      await fetchServices();
    } else {
      throw Exception('Error al crear el servicio');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> updateService(int serviceId, Map<String, dynamic> serviceData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.put(
      Uri.parse('$baseUrl/api/v1/services/$serviceId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(serviceData),
    );

    if (response.statusCode == 200) {
      await fetchServices();
    } else {
      throw Exception('Error al actualizar el servicio');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> deleteService(int serviceId) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.delete(
      Uri.parse('$baseUrl/api/v1/services/$serviceId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await fetchServices();
    } else {
      throw Exception('Error al eliminar el servicio');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

// Agregar estos métodos al final del archivo
Future<void> createUser(Map<String, dynamic> userData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      await fetchUsers();
    } else {
      throw Exception('Error al crear el usuario');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.put(
      Uri.parse('$baseUrl/api/v1/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      await fetchUsers();
    } else {
      throw Exception('Error al actualizar el usuario');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> deleteUser(int userId) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.delete(
      Uri.parse('$baseUrl/api/v1/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await fetchUsers();
    } else {
      throw Exception('Error al eliminar el usuario');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> updateState(int stateId, Map<String, dynamic> stateData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.put(
      Uri.parse('$baseUrl/api/v1/states/$stateId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(stateData),
    );

    if (response.statusCode == 200) {
      await fetchStates();
    } else {
      throw Exception('Error al actualizar el estado');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> createState(Map<String, dynamic> stateData) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/v1/states'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(stateData),
    );

    print('Response status: ${response.statusCode}'); // Debug log
    print('Response body: ${response.body}'); // Debug log

    // Modificar esta parte para aceptar 200 o 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      await fetchStates(); // Actualizar la lista de estados
      return; // Si llegamos aquí, la operación fue exitosa
    }
    
    // Si llegamos aquí, hubo un error
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Error al crear el estado');
  } catch (e) {
    print('Error creating state: $e'); // Debug log
    throw Exception('Error al crear el estado: ${e.toString()}');
  }
}

Future<void> deleteState(int stateId) async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.delete(
      Uri.parse('$baseUrl/api/v1/states/$stateId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await fetchStates();
    } else {
      throw Exception('Error al eliminar el estado');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> fetchRoles() async {
  try {
    final ReactController controller = Get.find<ReactController>();
    final token = controller.getAuthToken;

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/v1/roles'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      controller.setRoles(jsonResponse['data']);
    } else {
      throw Exception('Error al obtener roles');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}