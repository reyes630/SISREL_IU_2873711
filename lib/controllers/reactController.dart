import 'package:get/get.dart';

class ReactController extends GetxController {
  final _pagina = 0.obs;
  final _tituloAppBar = 'Mi Bienestar SENA controller'.obs;

  final _listCategories = [].obs;
  final _listRols = [].obs;
  final _listUsers = [].obs;
  final _listEvents = [].obs;

  // ----------- SETTERS -------------
  void setPagina(int newPage) {
    _pagina.value = newPage;
  }

  void setTituloAppBar(String newTitle) {
    _tituloAppBar.value = newTitle;
  }

  void setListCategories(List categoriesList) {
    _listCategories.value = categoriesList;
  }
  void setListRols(List RolsList) {
    _listRols.value = RolsList;
  }
  void setListUsers(List UsersList) {
    _listUsers.value = UsersList;
  }
  void setListEvents(List EventsList) {
    _listEvents.value = EventsList;
  }

  // ----------- GETTERS -------------
  int get getPagina => _pagina.value;
  String get getTituloAppBar => _tituloAppBar.value;
  List get getListCategories => _listCategories.value;
  List get getListRols => _listRols.value;
  List get getListUsers => _listUsers.value;
  List get getListEvents => _listEvents.value;
}
