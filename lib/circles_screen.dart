import 'package:flutter/material.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({Key? key}) : super(key: key);

  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen> {
  // --- Warna yang disesuaikan dengan desain ---
  final Color bgColor = const Color(0xFFF9F2E7);
  final Color primaryDark = const Color(0xFF5A4F43);
  final Color textDark = const Color(0xFF2C241B);
  final Color textLight = const Color(0xFF8C7E6E);
  final Color searchBg = const Color(0xFFEFE6D8);

  // Data tiruan untuk list lingkaran (circles)
  final List<Map<String, dynamic>> activeCircles = [
    {
      'title': 'Family',
      'members': 4,
      'active': 3,
      'time': '3 min',
      'iconColor': const Color(0xFFD69A64),
      'iconBg': const Color(0xFFF5E4D3),
      'avatars': [
        'https://i.pravatar.cc/150?img=1',
        'https://i.pravatar.cc/150?img=2',
        'https://i.pravatar.cc/150?img=3',
      ],
    },
    {
      'title': 'Work Team',
      'members': 6,
      'active': 2,
      'time': '12 min',
      'iconColor': const Color(0xFF4A8BBE),
      'iconBg': const Color(0xFFD9ECFA),
      'avatars': [
        'https://i.pravatar.cc/150?img=4',
        'https://i.pravatar.cc/150?img=5',
        'https://i.pravatar.cc/150?img=6',
      ],
    },
    {
      'title': 'College Friends',
      'members': 8,
      'active': 1,
      'time': '47 min',
      'iconColor': const Color(0xFF8B64AD),
      'iconBg': const Color(0xFFEBE0F5),
      'avatars': [
        'https://i.pravatar.cc/150?img=7',
        'https://i.pravatar.cc/150?img=8',
        'https://i.pravatar.cc/150?img=9',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // Navigasi bawah dihapus dari sini karena sudah diatur oleh main_layout.dart
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 40,
                  ), // Spasi penyeimbang agar judul di tengah
                  Text(
                    'My Circles',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryDark,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            // --- SEARCH BAR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: searchBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search circles...',
                    hintStyle: TextStyle(color: textLight),
                    prefixIcon: Icon(Icons.search, color: textLight),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- MAIN SCROLLABLE CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Text(
                      'ACTIVE CIRCLES',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textLight,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cards List
                    ...activeCircles
                        .map((circle) => _buildCircleCard(circle))
                        .toList(),

                    const SizedBox(height: 40),

                    // --- BOTTOM ACTION BUTTONS ---
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Have an invite code?',
                            style: TextStyle(color: textDark.withOpacity(0.7)),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: primaryDark, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Join a Circle',
                                style: TextStyle(
                                  color: textDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                'Create New Circle',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET UNTUK CARD CIRCLE ---
  Widget _buildCircleCard(Map<String, dynamic> circle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: circle['iconBg'],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              // Generic icon to replace the custom one in the design
              child: Icon(Icons.adjust, color: circle['iconColor'], size: 28),
            ),
          ),
          const SizedBox(width: 16),

          // Info Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  circle['title'],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${circle['members']} members · ${circle['active']} active now',
                  style: TextStyle(fontSize: 13, color: textLight),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: textLight.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Last seen ${circle['time']} ago',
                      style: TextStyle(
                        fontSize: 12,
                        color: textLight.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Avatars & Chevron
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 70,
                height: 32,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    // Positioned avatars (right to left stack)
                    Positioned(
                      right: 36,
                      child: _buildAvatar(circle['avatars'][2]),
                    ),
                    Positioned(
                      right: 18,
                      child: _buildAvatar(circle['avatars'][1]),
                    ),
                    Positioned(
                      right: 0,
                      child: _buildAvatar(circle['avatars'][0]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Icon(Icons.chevron_right, color: textLight, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  // --- HELPER UNTUK AVATAR TUMPANG TINDIH ---
  Widget _buildAvatar(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ), // White border for overlap effect
      ),
      child: CircleAvatar(
        radius: 12,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}
