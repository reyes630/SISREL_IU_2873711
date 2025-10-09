import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../api/apiSisrel.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, int> statistics = {
    'pending': 0,
    'resolved': 0,
    'inProcess': 0,
    'executed': 0
  };
  Map<String, dynamic> stateData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
    loadStateData();
  }

  Future<void> loadStatistics() async {
    try {
      setState(() => isLoading = true);
      final data = await fetchRequestStatusStatistics();
      if (mounted) {
        setState(() {
          statistics = Map<String, int>.from(data);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading statistics: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> loadStateData() async {
    try {
      final data = await fetchStateStatistics();
      if (mounted) {
        setState(() {
          stateData = data;
        });
      }
    } catch (e) {
      print('Error loading state statistics: $e');
    }
  }

  Color parseApiColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', 'FF'), radix: 16));
    } catch (e) {
      return Colors.grey;
    }
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

  Widget _buildStatisticCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF39A900), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF04324D), size: 40),
            const SizedBox(height: 8),
            isLoading
                ? const CircularProgressIndicator(
                    color: Color(0xFF39A900),
                    strokeWidth: 2,
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14181B),
                    ),
                  ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: loadStatistics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estadísticas Solicitudes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39A900),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cantidad solicitudes por estado',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  _buildStatisticCard(
                    icon: Icons.pending_actions,
                    value: statistics['pending'].toString(),
                    label: 'Pendientes',
                  ),
                  const SizedBox(width: 12),
                  _buildStatisticCard(
                    icon: Icons.check_circle,
                    value: statistics['resolved'].toString(),
                    label: 'Resueltas',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  _buildStatisticCard(
                    icon: Icons.settings,
                    value: statistics['inProcess'].toString(),
                    label: 'En proceso',
                  ),
                  const SizedBox(width: 12),
                  _buildStatisticCard(
                    icon: Icons.playlist_add_check,
                    value: statistics['executed'].toString(),
                    label: 'Ejecutadas',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estados más solicitados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Distribución de solicitudes por estado actual',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
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
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estadísticas Generales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF39A900),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Solicitudes',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Registradas en el sistema',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: isLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF39A900),
                              )
                            : Center(
                                child: Text(
                                  '${statistics['pending']! + statistics['resolved']! + statistics['inProcess']! + statistics['executed']!}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF161616),
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Usuarios',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Registrados en el sistema',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: FutureBuilder<int>(
                            future: fetchTotalUsers(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF39A900),
                                );
                              }
                              return Center(
                                child: Text(
                                  '${snapshot.data ?? 0}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF161616),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
