import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color darkBrown = const Color(0xFF5B4D41);
  final Color lightCream = const Color(0xFFF7F2EB);
  final Color cardCream = const Color(0xFFEBE3D6);
  final Color greenDot = const Color(0xFF4CAF50);

  final LatLng myLocation = const LatLng(-6.2088, 106.8456);
  final LatLng sisLocation = const LatLng(-6.1944, 106.8229);

  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NAVBAR DIHAPUS DARI SINI
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(-6.2016, 106.8342),
                initialZoom: 13.5,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.circlee',
                  maxZoom: 19,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: myLocation,
                      width: 80,
                      height: 90,
                      child: _buildMapMarker(
                        'You',
                        'https://i.pravatar.cc/150?img=11',
                        true,
                      ),
                    ),
                    Marker(
                      point: sisLocation,
                      width: 70,
                      height: 80,
                      child: _buildMapMarker(
                        'Sis',
                        'https://i.pravatar.cc/150?img=5',
                        false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: _buildTopNotification(),
          ),
          Positioned(
            top: 140,
            left: 16,
            right: 16,
            child: _buildFamilyHeader(),
          ),
          Positioned(
            bottom: 320,
            right: 16,
            child: Column(
              children: [
                _buildMapButton(
                  Icons.add,
                  () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                ),
                const SizedBox(height: 8),
                _buildMapButton(
                  Icons.remove,
                  () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                ),
                const SizedBox(height: 8),
                _buildMapButton(
                  Icons.my_location,
                  () => _mapController.move(myLocation, 14),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: lightCream,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Family Circle',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: darkBrown,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: darkBrown,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '4 members',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: cardCream,
                        child: Icon(Icons.add, color: darkBrown, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMemberItem(
                          'You',
                          'Just now',
                          'https://i.pravatar.cc/150?img=11',
                          true,
                        ),
                        _buildMemberItem(
                          'Sis',
                          '2m ago',
                          'https://i.pravatar.cc/150?img=5',
                          true,
                        ),
                        _buildMemberItem(
                          'Mom',
                          '5m ago',
                          'https://i.pravatar.cc/150?img=9',
                          true,
                        ),
                        _buildMemberItem(
                          'Dad',
                          '1h ago',
                          'https://i.pravatar.cc/150?img=12',
                          false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardCream,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: darkBrown,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sis just arrived',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkBrown,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mall Grand Indonesia · 2 min ago',
                                style: TextStyle(
                                  color: darkBrown.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _mapController.move(sisLocation, 15),
                          child: Text(
                            'View',
                            style: TextStyle(
                              color: darkBrown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: cardCream,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color: darkBrown,
                          ),
                          label: Text(
                            'Message All',
                            style: TextStyle(
                              color: darkBrown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: darkBrown,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(
                            Icons.navigation_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Navigate',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: darkBrown, size: 20),
      ),
    );
  }

  Widget _buildTopNotification() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightCream,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Circlee',
                      style: TextStyle(
                        color: darkBrown.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'now',
                      style: TextStyle(
                        color: darkBrown.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Sis has arrived at Mall',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),
                Text(
                  'Near Jl. Sudirman, Jakarta',
                  style: TextStyle(
                    color: darkBrown.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.close, color: darkBrown.withOpacity(0.5), size: 20),
        ],
      ),
    );
  }

  Widget _buildFamilyHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: lightCream,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Family',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: darkBrown),
            ],
          ),
          Row(
            children: [
              Icon(Icons.notifications_active, color: darkBrown),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFCDA87C),
                child: Text(
                  'JD',
                  style: TextStyle(
                    color: darkBrown,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberItem(
    String name,
    String time,
    String imageUrl,
    bool isOnline,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 28, backgroundImage: NetworkImage(imageUrl)),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: greenDot,
                      shape: BoxShape.circle,
                      border: Border.all(color: lightCream, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, color: darkBrown),
          ),
          Text(
            time,
            style: TextStyle(color: darkBrown.withOpacity(0.5), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker(String label, String imageUrl, bool isYou) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isYou ? darkBrown : Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: isYou ? 24 : 20,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isYou ? darkBrown : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isYou ? Colors.white : darkBrown,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
