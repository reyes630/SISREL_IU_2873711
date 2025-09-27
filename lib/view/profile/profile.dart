import 'package:flutter/material.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del usuario
              Center(
              child: Column(
                children: [
                  //IMAGEN DEL PERFIL (FOTO)
                  Container(
                    padding: const EdgeInsets.all(3), 
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF39A900), 
                        width: 5,           
                      ),
                    ),
                    child: const CircleAvatar(
                    
                      radius: 40,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Jennifer Cambill',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'jennifer.cambill@Jennah.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Contenedor de información en tabla
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 250, 250),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF39A900),),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Center(
                          child: Text(
                            'Documento',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Center(
                          child: Text(
                            'Rol',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Center(
                          child: Text(
                            'Teléfono',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Fila de datos
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Center(
                          child: Text(
                            '1036128879',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Center(
                          child: Text(
                            'Administrativo',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Center(
                          child: Text(
                            '3127391649',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Botón Modifier
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Acción para modificar perfil
                },
                icon: const Icon(
                  Icons.edit,
                  size: 20, // tamaño del ícono
                  color: Colors.white, // color del ícono
                ),
                label: const Text(
                  'Modifier',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF04324D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
      ),
    );
    
  }
}