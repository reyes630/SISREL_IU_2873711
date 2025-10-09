import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReactController extends GetxController {
  final _pagina = 0.obs;
  final _tituloAppBar = 'SISREL'.obs;
  final _listUsers = [].obs;
  final _authToken = ''.obs;
  final _currentUser = Rxn<Map<String, dynamic>>();
  final _isAuthenticated = false.obs;
  final _listRequest = [].obs;
  final _listClient = [].obs;
  final _listMunicipalities = [].obs;
  final _listServiceTypes = [].obs;
  final _listEventType = [].obs;
  final _listServices = [].obs;
  final _listStates = [].obs;
  final _archivedRequests = [].obs;
  final _assignableUsers = [].obs;
  final _sentRequests = [].obs;
  final _listRoles = [].obs;

  // Agregar TabController
  TabController? _tabController;

  void setPagina(int newPage) {
    _pagina.value = newPage;
  }

  void setTituloAppBar(String newTitle) {
    _tituloAppBar.value = newTitle;
  }

  void setListUsers(List newUser) {
    _listUsers.value = newUser;
  }

  void setAuthToken(String token) {
    _authToken.value = token;
    _isAuthenticated.value = token.isNotEmpty;
  }

  void setCurrentUser(Map<String, dynamic> user) {
    _currentUser.value = user;
  }

  void setRequest(List newRequest) {
    _listRequest.value = newRequest;
  }

  void setlistClient(List newClient) {
    _listClient.value = newClient;
  }

  void setListMunicipalities(List newMunicipalities) {
    _listMunicipalities.value = newMunicipalities;
  }

  void setServiceTypes(List newServiceTypes) {
    _listServiceTypes.value = newServiceTypes;
  }

  void setEventType(List newEeventType) {
    _listEventType.value = newEeventType;
  }

  void setServices(List newServices) {
    _listServices.value = newServices;
  }

  // Métodos para TabController
  void setTabController(TabController controller) {
    _tabController = controller;
  }

  void changeToTab(int index) {
    _tabController?.animateTo(index);
  }

  void setStates(List newStates) {
    _listStates.value = newStates;
  }

  List get getStates => _listStates.value;

  void setArchivedRequests(List newArchivedRequests) {
    _archivedRequests.value = newArchivedRequests;
  }

  void setAssignableUsers(List users) {
    _assignableUsers.value = users;
  }

  void setSentRequests(List requests) {
    _sentRequests.value = requests;
  }

  void setRoles(List newRoles) {
    _listRoles.value = newRoles;
  }

  void saveLoginData(Map<String, dynamic> loginData) {
    if (loginData['token'] != null) {
      setAuthToken(loginData['token']);
    }
    if (loginData['user'] != null) {
      setCurrentUser(loginData['user']);
    }
  }

  void logout() {
    _authToken.value = '';
    _currentUser.value = null;
    _isAuthenticated.value = false;
    _listUsers.value = [];
    _listRequest.value = [];
    _listClient.value = [];
    _pagina.value = 0;
  }

  int get getPagina => _pagina.value;
  String get getTituloAppBar => _tituloAppBar.value;
  List get getListUsers => _listUsers.value;
  String get getAuthToken => _authToken.value;
  Map<String, dynamic>? get getCurrentUser => _currentUser.value;
  bool get getIsAuthenticated => _isAuthenticated.value;
  List get getListRequest => _listRequest.value;
  List get getListClient => _listClient.value;
  List get getListMunicipalities => _listMunicipalities.value;
  List get getListServiceTypes => _listServiceTypes.value;
  List get getListEventType => _listEventType.value;
  List get getListService => _listServices.value;
  List get getListStates => _listStates.value;
  List get getArchivedRequests => _archivedRequests.value;
  List get getAssignableUsers => _assignableUsers.value;
  List get getSentRequests => _sentRequests.value;
  List get getServices => _listServices.value;
  List get getListRoles => _listRoles.value;
}