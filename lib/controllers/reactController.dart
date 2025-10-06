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

  void setPagina(int newPage) {
    _pagina.value = newPage;
  }

  void setTituloAppBar(String newTitle) {
    _tituloAppBar.value = newTitle;
  }

  void setListUsers(List newUser){
    _listUsers.value = newUser;
  }

  void setAuthToken(String token) {
    _authToken.value = token;
    _isAuthenticated.value = token.isNotEmpty;
  }

  void setCurrentUser(Map<String, dynamic> user) {
    _currentUser.value = user;
  }

  void setRequest(List newRequest){
    _listRequest.value = newRequest;
  }

  void setlistClient(List newClient){
    _listClient.value = newClient;
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
}