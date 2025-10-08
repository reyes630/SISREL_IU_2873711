import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../api/apiSisrel.dart';
import '../../controllers/reactController.dart';

class RequestDashboard extends StatefulWidget {
  const RequestDashboard({super.key});

  @override
  State<RequestDashboard> createState() => _RequestDashboardState();
}

class _RequestDashboardState extends State<RequestDashboard> {
  final ReactController controller = Get.find<ReactController>();
  bool isLoading = true;
  Map<String, dynamic> servicesData = {};
  Map<String, dynamic> municipalityData = {};
  Map<String, dynamic> stateData = {};
  final List<Color> municipalityColors = [
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFFFC107),
    const Color(0xFFFF5722),
    const Color(0xFF9C27B0),
    const Color(0xFF795548),
    const Color(0xFF607D8B),
    const Color(0xFF3F51B5),
  ];

  @override
  void initState() {
    super.initState();
    loadServicesData();
    loadMunicipalityData();
    loadStateData();
  }

  Future<void> loadServicesData() async {
    try {
      setState(() => isLoading = true);
      final data = await fetchServicesStatistics();
      setState(() {
        servicesData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error cargando estadísticas: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> loadMunicipalityData() async {
    try {
      setState(() => isLoading = true);
      final data = await fetchMunicipalityStatistics();
      setState(() {
        municipalityData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error cargando estadísticas de municipios: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> loadStateData() async {
    try {
      setState(() => isLoading = true);
      final data = await fetchStateStatistics();
      setState(() {
        stateData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error cargando estadísticas de estados: $e');
      setState(() => isLoading = false);
    }
  }

  Color parseApiColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', 'FF'), radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  List<PieChartSectionData> _generatePieChartSections() {
    final Map<String, int> counts = servicesData['counts'] ?? {};
    final Map<String, String> colors = servicesData['colors'] ?? {};
    
    if (counts.isEmpty) return [];

    final total = counts.values.reduce((a, b) => a + b);
    
    return counts.entries.map((entry) {
      final percentage = (entry.value / total * 100).roundToDouble();
      return PieChartSectionData(
        color: parseApiColor(colors[entry.key] ?? '#000000'),
        value: entry.value.toDouble(),
        title: '${percentage.round()}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<PieChartSectionData> _generateStateChartSections() {
    final Map<String, int> counts = stateData['counts'] ?? {};
    final Map<String, String> colors = stateData['colors'] ?? {};
    
    if (counts.isEmpty) return [];

    final total = counts.values.reduce((a, b) => a + b);
    
    return counts.entries.map((entry) {
      final percentage = (entry.value / total * 100).roundToDouble();
      return PieChartSectionData(
        color: parseApiColor(colors[entry.key] ?? '#000000'),
        value: entry.value.toDouble(),
        title: '${percentage.round()}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    final Map<String, int> counts = servicesData['counts'] ?? {};
    final Map<String, String> colors = servicesData['colors'] ?? {};

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: counts.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: parseApiColor(colors[entry.key] ?? '#000000'),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${entry.key}: ${entry.value}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStateLegend() {
    final Map<String, int> counts = stateData['counts'] ?? {};
    final Map<String, String> colors = stateData['colors'] ?? {};

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: counts.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: parseApiColor(colors[entry.key] ?? '#000000'),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${entry.key}: ${entry.value}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMunicipalityChart() {
    final Map<String, int> counts = municipalityData['counts'] ?? {};
    
    if (counts.isEmpty) return const Center(child: Text('No hay datos disponibles'));

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (counts.values.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= counts.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Text(
                      counts.keys.elementAt(value.toInt()),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                );
              },
              reservedSize: 42,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          counts.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: counts.values.elementAt(index).toDouble(),
                color: municipalityColors[index % municipalityColors.length],
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            const Text(
              'Estadísticas Solicitudes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF39A900),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Información sobre las solicitudes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),           
    
            const SizedBox(height: 15),

            // Primer contenedor - Servicios más Solicitados
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Servicios más Solicitados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 0,
                                  sections: _generatePieChartSections(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildLegend(),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Segundo contenedor - Estadísticas Solicitudes
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solicitudes por Municipio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildMunicipalityChart(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tercer contenedor - Gráfica adicional
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solicitudes por Estado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 0,
                                  sections: _generateStateChartSections(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildStateLegend(),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}