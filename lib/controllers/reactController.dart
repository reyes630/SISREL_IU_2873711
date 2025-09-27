import 'package:get/get.dart';

class ReactController extends GetxController {
  final _pagina = 0.obs;
  final _tituloAppBar = 'SISREL'.obs;

 

  // ----------- SETTERS -------------
  void setPagina(int newPage) {
    _pagina.value = newPage;
  }

  void setTituloAppBar(String newTitle) {
    _tituloAppBar.value = newTitle;
  }



  // ----------- GETTERS -------------
  int get getPagina => _pagina.value;
  String get getTituloAppBar => _tituloAppBar.value;
}
