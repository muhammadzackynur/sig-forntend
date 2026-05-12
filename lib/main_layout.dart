import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'circles_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Warna untuk Navbar
  final Color darkBrown = const Color(0xFF5B4D41);
  final Color lightCream = const Color(0xFFF7F2EB);

  // Daftar halaman yang akan ditampilkan di dalam wadah
  // PERBAIKAN: Menghapus 'const' pada HomeScreen() dan CirclesScreen()
  final List<Widget> _pages = [
    HomeScreen(),
    CirclesScreen(),
    Center(child: Text('Waktu / History')), // Placeholder
    Center(child: Text('Notifikasi')), // Placeholder
    Center(child: Text('Profil')), // Placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga state halaman (misal peta tidak reload saat pindah tab)
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // Bottom Navigation Bar ditaruh di sini
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: darkBrown,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.map, 'Home', 0),
            _buildNavItem(Icons.people_outline, 'Circles', 1),
            _buildNavItem(Icons.access_time, '', 2),
            _buildNavItem(Icons.notifications_none, '', 3),
            _buildNavItem(Icons.person_outline, '', 4),
          ],
        ),
      ),
    );
  }

  // Widget tombol navigasi yang disesuaikan desainnya
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container ini memberikan efek kotak transparan pada ikon yang aktif
            Container(
              padding: isActive
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 6)
                  : EdgeInsets.zero,
              decoration: isActive
                  ? BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    )
                  : null,
              child: Icon(
                icon,
                color: isActive ? lightCream : lightCream.withOpacity(0.5),
                size: 28,
              ),
            ),
            if (label.isNotEmpty && isActive) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: lightCream,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
