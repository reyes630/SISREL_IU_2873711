import 'package:get/get.dart';

class ReactController extends GetxController {
  final _pagina = 0.obs;
  final _tituloAppBar = 'Mi Bienestar SENA controller'.obs;

  final _listCategories = [].obs;
  final _listRols = [].obs;

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

  // ----------- GETTERS -------------
  int get getPagina => _pagina.value;
  String get getTituloAppBar => _tituloAppBar.value;
  List get getListCategories => _listCategories.value;
  List get getListRols => _listRols.value;
}
