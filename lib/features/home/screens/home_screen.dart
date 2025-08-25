// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../detection/screens/detection_screen.dart';
import '../../history/screens/history_screen.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/supabase_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _locationStatus = 'Checking...';
  Map<String, dynamic> _stats = {  // ✅ changed from Map<String,int> to Map<String,dynamic>
    'total_detections': 0,
    'total_violations': 0,
    'detections_with_violations': 0,
    'clean_detections': 0,
  };
  bool _statsLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _statsLoading = true);

    try {
      debugPrint('📊 Loading stats for home screen...');
      final stats = await SupabaseService().getDetectionStats();
      debugPrint('✅ Home screen stats loaded: $stats');

      if (mounted) {
        setState(() {
          _stats = stats;
          _statsLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading home screen stats: $e');
      if (mounted) {
        setState(() => _statsLoading = false);
      }
    }
  }

  void _onReturnFromDetection() {
    debugPrint('🔄 Returning from detection, refreshing stats...');
    _loadStats();
  }

  Future<void> _checkLocationStatus() async {
    try {
      final locationService = LocationService();
      final isEnabled = await locationService.isLocationServiceEnabled();
      final permission = await locationService.checkLocationPermission();

      if (mounted) {
        setState(() {
          if (!isEnabled) {
            _locationStatus = 'Service disabled';
          } else if (permission == LocationPermission.denied) {
            _locationStatus = 'Permission needed';
          } else if (permission == LocationPermission.deniedForever) {
            _locationStatus = 'Permission denied';
          } else {
            _locationStatus = 'Ready';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationStatus = 'Error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile coming soon!')),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Icon(
                      Icons.visibility,
                      size: 44,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Welcome to Billboard Detector',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Detect unauthorized billboards using AI-powered analysis',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _StatusIndicator(
                          icon: Icons.camera_alt,
                          label: 'Camera',
                          status: 'Ready',
                          isReady: true,
                        ),
                        const SizedBox(width: 20),
                        _StatusIndicator(
                          icon: Icons.location_on,
                          label: 'Location',
                          status: _locationStatus,
                          isReady: _locationStatus == 'Ready',
                        ),
                        const SizedBox(width: 20),
                        const _StatusIndicator(
                          icon: Icons.wifi,
                          label: 'Network',
                          status: 'Connected',
                          isReady: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetectionScreen(),
                  ),
                );
                if (result == true || result == null) {
                  _onReturnFromDetection();
                }
              },
              icon: const Icon(Icons.camera_alt, size: 28),
              label: const Text(
                'Start Detection',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.history,
                    title: 'History',
                    subtitle: 'View past detections',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.report,
                    title: 'Reports',
                    subtitle: 'View violation reports',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reports feature coming soon!'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.map,
                    title: 'Map View',
                    subtitle: 'View billboards on map',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Map feature coming soon!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings coming soon!'),
                          backgroundColor: Colors.purple,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          color: Theme.of(context).primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Quick Stats',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        if (_statsLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          IconButton(
                            onPressed: _loadStats,
                            icon: const Icon(Icons.refresh, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(maxWidth: 24, maxHeight: 24),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.camera_alt,
                          label: 'Detections',
                          value: '${_stats['total_detections'] ?? 0}',
                          color: Colors.blue,
                        ),
                        _StatItem(
                          icon: Icons.warning,
                          label: 'Violations',
                          value: '${_stats['total_violations'] ?? 0}',
                          color: Colors.red,
                        ),
                        const _StatItem(
                          icon: Icons.report,
                          label: 'Reports',
                          value: '0', // We'll add this later
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        _stats['total_detections'] == 0
                            ? 'Start detecting to see your statistics!'
                            : 'Last updated: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${AppConstants.appName} v${AppConstants.appVersion}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final String status;
  final bool isReady;

  const _StatusIndicator({
    required this.icon,
    required this.label,
    required this.status,
    required this.isReady,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isReady ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: isReady ? Colors.green : Colors.orange,
            size: 18,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          status,
          style: TextStyle(
            fontSize: 8,
            color: isReady ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 9,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 14,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}