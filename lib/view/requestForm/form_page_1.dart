import 'package:flutter/material.dart';


class ViewsForm extends StatefulWidget {
  const ViewsForm({super.key});

  @override
  State<ViewsForm> createState() => _ViewsFormState();
}

class _ViewsFormState extends State<ViewsForm> {
  bool showSecondPage = false;
  int selectedServiceIndex = -1;

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
                                        style: const TextStyle(
                                        fontSize: 12,  
                                    ),                              
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
                                    style: const TextStyle(
                                        fontSize: 12,  
                                    ),
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
                                          color:Color.fromARGB(255, 76, 244, 54),
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
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                        fontSize: 12,  
                                    ),
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
                                    keyboardType: TextInputType.phone,
                                    style: const TextStyle(
                                        fontSize: 12,  
                                    ),
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
                                onPressed: nextPage,
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
                            icon: const Icon(Icons.arrow_back,
                                color: Color.fromARGB(255, 43, 43, 43)),
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
                          'Fecha de la solicitud',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 35,
                          child: TextFormField(
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'DD/MM/AAAA',
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

                    // Dropdown Municipio
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
                        Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: null,
                              hint: const Text(
                                'Selecciona una opción',
                                style: TextStyle(fontSize: 12),
                              ),
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: const [
                                DropdownMenuItem(
                                    value: 'cali', child: Text('Cali')),
                                DropdownMenuItem(
                                    value: 'palmira', child: Text('Palmira')),
                                DropdownMenuItem(
                                    value: 'buenaventura',
                                    child: Text('Buenaventura')),
                              ],
                              onChanged: (value) {
                                // Sin funcionalidad
                              },
                            ),
                          ),
                        ),
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
                        Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text('Técnico', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              selected: selectedServiceIndex == 0,
                              selectedColor: Colors.green,
                              backgroundColor: Colors.grey[500],
                              showCheckmark: false,
                              onSelected: (selected) {
                                setState(() {
                                  selectedServiceIndex = selected ? 0 : -1;
                                });
                              },
                            ),
                            ChoiceChip(
                              label: const Text('Tecnólogo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              selected: selectedServiceIndex == 1,
                              selectedColor: Colors.blue,
                              backgroundColor: Colors.grey[500],
                              showCheckmark: false,
                              onSelected: (selected) {
                                setState(() {
                                  selectedServiceIndex = selected ? 1 : -1;
                                });
                              },
                            ),
                            ChoiceChip(
                              label: const Text('Complementario', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              selected: selectedServiceIndex == 2,
                              selectedColor: Colors.orange,
                              backgroundColor: Colors.grey[500],
                              showCheckmark: false,
                              onSelected: (selected) {
                                setState(() {
                                  selectedServiceIndex = selected ? 2 : -1;
                                });
                              },
                            ),
                            ChoiceChip(
                              label: const Text('Emprendimiento', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              selected: selectedServiceIndex == 3,
                              selectedColor: Colors.purple,
                              backgroundColor: Colors.grey[500],
                              showCheckmark: false,
                              onSelected: (selected) {
                                setState(() {
                                  selectedServiceIndex = selected ? 3 : -1;
                                });
                              },
                            ),
                            ChoiceChip(
                              label: const Text('Operario', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              selected: selectedServiceIndex == 4,
                              selectedColor: Colors.teal,
                              backgroundColor: Colors.grey[500],
                              showCheckmark: false,
                              onSelected: (selected) {
                                setState(() {
                                  selectedServiceIndex = selected ? 4 : -1;
                                });
                              },
                            ),
                            ChoiceChip(
                              label: const Text('SENNOVA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              selected: selectedServiceIndex == 5,
                              selectedColor: Colors.redAccent,
                              backgroundColor: Colors.grey[500],
                              showCheckmark: false,
                              onSelected: (selected) {
                                setState(() {
                                  selectedServiceIndex = selected ? 5 : -1;
                                });
                              },
                            ),
                          ],
                        ),
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
                        Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: null,
                              hint: const Text(
                                'Selecciona una opción',
                                style: TextStyle(fontSize: 12),
                              ),
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: const [
                                DropdownMenuItem(
                                    value: 'presencial', child: Text('Presencial')),
                                DropdownMenuItem(
                                    value: 'virtual', child: Text('Virtual')),
                                DropdownMenuItem(
                                    value: 'mixto', child: Text('Mixto')),
                              ],
                              onChanged: (value) {
                                // Sin funcionalidad
                              },
                            ),
                          ),
                        ),
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
                        Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: null,
                              hint: const Text(
                                'Selecciona una opción',
                                style: TextStyle(fontSize: 12),
                              ),
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: const [
                                DropdownMenuItem(
                                    value: 'taller', child: Text('Taller')),
                                DropdownMenuItem(
                                    value: 'conferencia',
                                    child: Text('Conferencia')),
                                DropdownMenuItem(
                                    value: 'seminario', child: Text('Seminario')),
                              ],
                              onChanged: (value) {
                                // Sin funcionalidad
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Botón ENVIAR
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Sin funcionalidad
                        },
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
}