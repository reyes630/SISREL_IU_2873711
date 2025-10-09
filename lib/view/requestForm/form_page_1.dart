import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';

class ViewsForm extends StatefulWidget {
  const ViewsForm({super.key});

  @override
  State<ViewsForm> createState() => _ViewsFormState();
}

class _ViewsFormState extends State<ViewsForm> {
  bool showSecondPage = false;
  int selectedServiceIndex = -1;
  final ReactController controller = Get.put(ReactController());
  String? selectedMunicipio; // guardar el valor seleccionado
  String? selectedServiceType;
  String? selectedEventType;
  String? selectedServiceId;
  final documentController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telephoneController = TextEditingController();
  final locationController = TextEditingController();
  final TextEditingController observationsController = TextEditingController();
  final TextEditingController needDescriptionController =
      TextEditingController();

  DateTime? selectedDate;

  @override
  void dispose() {
    documentController.dispose();
    nameController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    locationController.dispose();
    observationsController.dispose();
    needDescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchMunicipalities();
    fetchServiceTypes();
    fetchEventTypes();
    fetchServices(); // Agregar esta línea
  }

  void nextPage() {
    setState(() {
      showSecondPage = true;
    });
  }

  void previousPage() {
    setState(() {
      showSecondPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: showSecondPage ? _buildSecondPage(previousPage) : _buildFirstPage(),
    );
  }

  Widget _buildFirstPage() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo del SENA
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[700], // Verde SENA
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/logoSenaForm.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Texto de bienvenida
                    const Text(
                      'Bienvenid@ al Servicio Nacional de Aprendizaje',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Usted está a punto de realizar una solicitud de servicios',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // FORMULARIO
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título de la sección
                          const Text(
                            'Datos de quien solicita el servicio',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 15, 15, 15),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Campo Documento
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Documento ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 35,
                                child: TextFormField(
                                  controller: documentController,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: '123456789',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 76, 244, 54),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Campo Nombre Completo
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Nombre Completo ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 35,
                                child: TextFormField(
                                  controller: nameController,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: 'Nombre Apellido',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 76, 244, 54),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Campo Correo Electrónico
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Correo Electrónico ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 35,
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: 'correo@example.com',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 76, 244, 54),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Campo Teléfono
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Teléfono ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 35,
                                child: TextFormField(
                                  controller: telephoneController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: '3110000000',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 76, 244, 54),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Botón Siguiente
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_validateFirstPage()) {
                                  nextPage();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF09669C),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Siguiente',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Mueve aquí la función:
  Widget _buildSecondPage(VoidCallback onBack) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Encabezado con botón atrás y texto debajo
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: onBack,
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color.fromARGB(255, 43, 43, 43),
                              ),
                            ),
                            const Text(
                              'Datos del servicio a solicitar',
                              style: TextStyle(
                                color: Color.fromARGB(255, 53, 53, 53),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Campo Fecha de la solicitud
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fecha de la solicitud *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 35,
                            child: TextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: selectedDate == null
                                    ? ''
                                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} ${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}',
                              ),
                              style: const TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                hintText: 'Selecciona la fecha',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 76, 244, 54),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                              ),
                              onTap: () async {
                                FocusScope.of(context).requestFocus(
                                  FocusNode(),
                                ); // evita abrir teclado
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2024),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      DateTime.now().hour,
                                      DateTime.now().minute,
                                    );
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Dropdown Municipio dinámico
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Municipio ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            final municipios = controller.getListMunicipalities;

                            if (municipios.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                  strokeWidth: 2,
                                ),
                              );
                            }

                            return Container(
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.red, width: 2),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedMunicipio,
                                  hint: const Text(
                                    'Selecciona un municipio',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: municipios
                                      .map<DropdownMenuItem<String>>((
                                        municipio,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: municipio['name'],
                                          child: Text(municipio['name']),
                                        );
                                      })
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMunicipio = value;
                                    });
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Campo Lugar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lugar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 35,
                            child: TextFormField(
                              controller: locationController,
                              style: const TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 76, 244, 54),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Dropdown Servicio a Solicitar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Servicio a Solicitar ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            final services = controller.getListService;

                            if (services.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                  strokeWidth: 2,
                                ),
                              );
                            }

                            return Wrap(
                              spacing: 8,
                              children: services.map((service) {
                                final isSelected =
                                    selectedServiceId ==
                                    service['id'].toString();
                                final color = _getColorFromHex(
                                  service['color'] ?? '#808080',
                                );

                                return ChoiceChip(
                                  label: Text(
                                    service['service'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: color,
                                  backgroundColor: Colors.grey[500],
                                  showCheckmark: false,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedServiceId = selected ? service['id'].toString() : null;
                                      selectedServiceType = null; // Resetear el tipo de servicio
                                      print('Servicio seleccionado: $selectedServiceId');
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Dropdown Tipo Servicio
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tipo Servicio',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            final serviceTypes = controller.getListServiceTypes;

                            if (serviceTypes.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                  strokeWidth: 2,
                                ),
                              );
                            }

                            // Depuración
                            print('Todos los tipos de servicio: ${serviceTypes.length}');
                            serviceTypes.forEach((type) {
                              print('Tipo: ${type['serviceType']}, FKservices: ${type['FKservices']}, ID: ${type['id']}');
                            });

                            // Filtrar tipos de servicio basado en el servicio seleccionado
                            final filteredServiceTypes = selectedServiceId != null 
                                ? serviceTypes.where((type) {
                                    print('Comparando: type[FKservices]=${type['FKservices']}, selectedServiceId=$selectedServiceId');
                                    return type['FKservices'].toString() == selectedServiceId.toString();
                                  }).toList()
                                : [];

                            print('Tipos de servicio filtrados: ${filteredServiceTypes.length}');
                            print('Servicio seleccionado ID: $selectedServiceId');

                            return Container(
                              height: 35,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.red, width: 2),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedServiceType,
                                  hint: Text(
                                    selectedServiceId == null 
                                        ? 'Primero seleccione un servicio'
                                        : filteredServiceTypes.isEmpty
                                            ? 'No hay tipos disponibles para este servicio'
                                            : 'Seleccione un tipo de servicio',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: filteredServiceTypes.map<DropdownMenuItem<String>>((serviceType) {
                                    return DropdownMenuItem<String>(
                                      value: serviceType['id'].toString(),
                                      child: Text(
                                        serviceType['serviceType'] ?? 'Sin nombre',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: filteredServiceTypes.isEmpty 
                                      ? null 
                                      : (String? newValue) {
                                          setState(() {
                                            selectedServiceType = newValue;
                                            print('Tipo de servicio seleccionado: $newValue');
                                          });
                                        },
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Campo Descripción necesidad
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Descripción necesidad',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: needDescriptionController,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 4,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 76, 244, 54),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Dropdown Tipo Evento
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tipo Evento',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            final eventTypes = controller.getListEventType;

                            if (eventTypes.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                  strokeWidth: 2,
                                ),
                              );
                            }

                            return Container(
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.red, width: 2),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedEventType,
                                  hint: const Text(
                                    'Selecciona una opción',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: eventTypes
                                      .map<DropdownMenuItem<String>>((
                                        eventType,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: eventType['id'].toString(),
                                          child: Text(
                                            eventType['eventType'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      })
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedEventType = newValue;
                                    });
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Botón ENVIAR
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF09669C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'ENVIAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    // Validar formulario
    if (!_validateForm()) return;

    // Preparar datos
    final formData = {
      'documentClient': documentController.text.trim(),
      'nameClient': nameController.text.trim(),
      'emailClient': emailController.text.trim(),
      'telephoneClient': telephoneController.text.trim(),
      'eventDate': selectedDate!.toIso8601String(),
      'location': locationController.text.trim(),
      'municipality': selectedMunicipio!,
      'observations': observationsController.text.trim(),
      'needDescription': needDescriptionController.text.trim(),
      'eventType': selectedEventType!,
      'serviceType': selectedServiceType!,
    };

    // Enviar solicitud
    await createRequestWithClient(formData);
  }

  bool _validateForm() {
    if (documentController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        telephoneController.text.isEmpty ||
        selectedDate == null ||
        locationController.text.isEmpty ||
        selectedMunicipio == null ||
        selectedServiceId == null ||
        selectedServiceType == null ||
        selectedEventType == null) {
      Get.snackbar(
        'Error',
        'Por favor complete todos los campos requeridos',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  // Primero, agrega este método para validar la primera página
  bool _validateFirstPage() {
    if (documentController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        telephoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor complete todos los campos requeridos',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validar formato de email
    if (!emailController.text.contains('@') ||
        !emailController.text.contains('.')) {
      Get.snackbar(
        'Error',
        'Por favor ingrese un correo electrónico válido',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validar formato de teléfono (10 dígitos)
    if (telephoneController.text.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(telephoneController.text)) {
      Get.snackbar(
        'Error',
        'Por favor ingrese un número de teléfono válido (10 dígitos)',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse('0x$hexColor'));
  }
}
