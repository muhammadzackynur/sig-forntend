import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'custom_widgets.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Know where they are",
      "subtitle": "See your family and friends on a\nprivate map in real-time.",
    },
    {
      "title": "Create your Circle",
      "subtitle":
          "Organize your people into private\nCircles for family, friends, or work.",
    },
    {
      "title": "Review any moment",
      "subtitle":
          "Look back at where everyone has been\nwith detailed location history.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAEFE3),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration area
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: index == 0
                              ? _buildSlide1Illustration()
                              : index == 1
                              ? _buildSlide2Illustration()
                              : _buildSlide3Illustration(),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          onboardingData[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2416),
                          ),
                        ),
                        // Premium badge only for slide 3
                        if (index == 2) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB5975A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.workspace_premium,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Premium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Text(
                          onboardingData[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF9A8B7A),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index, context),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomButton(
                text: _currentPage == onboardingData.length - 1
                    ? 'Get Started'
                    : 'Next',
                onPressed: () {
                  if (_currentPage < onboardingData.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AuthScreen(isLoginMode: false),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AuthScreen(isLoginMode: true),
                  ),
                );
              },
              child: const Text(
                'I already have an account',
                style: TextStyle(color: Color(0xFF9A8B7A), fontSize: 15),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SLIDE 1 – Know where they are
  // Oval map with roads, green areas, and avatar pins
  // ─────────────────────────────────────────────
  Widget _buildSlide1Illustration() {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Oval map background ──
          ClipOval(
            child: Container(
              width: 310,
              height: 220,
              color: const Color(0xFFEDE0CF),
              child: CustomPaint(painter: _MapPainter()),
            ),
          ),

          // ── Avatar pins ──
          // Mom – top center
          Positioned(
            top: 18,
            left: 128,
            child: _MapAvatarPin(name: 'Mom', color: const Color(0xFF6B5740)),
          ),
          // Emma – right
          Positioned(
            top: 68,
            right: 26,
            child: _MapAvatarPin(name: 'Emma', color: const Color(0xFF8B7060)),
          ),
          // Dad – left
          Positioned(
            top: 88,
            left: 20,
            child: _MapAvatarPin(name: 'Dad', color: const Color(0xFFB08060)),
          ),
          // Jake – bottom left
          Positioned(
            bottom: 48,
            left: 52,
            child: _MapAvatarPin(name: 'Jake', color: const Color(0xFF5C4A35)),
          ),
          // Sara – bottom right
          Positioned(
            bottom: 48,
            right: 52,
            child: _MapAvatarPin(name: 'Sara', color: const Color(0xFF9A8070)),
          ),

          // ── Small center location dot ──
          Positioned(
            top: 143,
            left: 146,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3D3020),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SLIDE 2 – Create your Circle
  // Concentric dashed circles with avatar bubbles
  // and a "Family Circle · 5 members" pill at bottom
  // ─────────────────────────────────────────────
  Widget _buildSlide2Illustration() {
    // Avatar placeholder data (name + color)
    final avatars = [
      {
        'name': 'Anna',
        'color': const Color(0xFF8B7355),
        'top': 0.05,
        'left': 0.38,
      },
      {
        'name': 'Sara',
        'color': const Color(0xFFB08060),
        'top': 0.25,
        'left': 0.08,
      },
      {
        'name': 'Tom',
        'color': const Color(0xFF6B7B5A),
        'top': 0.25,
        'left': 0.70,
      },
      {
        'name': 'Jake',
        'color': const Color(0xFF5C4A35),
        'top': 0.60,
        'left': 0.10,
      },
      {
        'name': 'Mia',
        'color': const Color(0xFF4A7090),
        'top': 0.60,
        'left': 0.68,
      },
    ];

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer dashed ring
        _DashedCircle(size: 280, color: const Color(0xFFD4B896)),
        // Middle ring
        _DashedCircle(size: 190, color: const Color(0xFFD4B896)),
        // Inner filled circle (subtle)
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE8D5C0).withOpacity(0.6),
          ),
        ),
        // Center icon button
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF3D3020),
          ),
          child: const Icon(
            Icons.share_outlined,
            color: Colors.white,
            size: 26,
          ),
        ),
        // Avatar bubbles positioned around the rings
        ...avatars.map((a) {
          return Positioned(
            top: 300 * (a['top'] as double),
            left: 300 * (a['left'] as double),
            child: _AvatarBubble(
              name: a['name'] as String,
              color: a['color'] as Color,
            ),
          );
        }),
        // Bottom pill label
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF3D3020), size: 18),
                SizedBox(width: 8),
                Text(
                  'Family Circle · 5 members',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2D2416),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SLIDE 3 – Review any moment
  // Timeline dots with avatar heads and a tooltip popup
  // ─────────────────────────────────────────────
  Widget _buildSlide3Illustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer dashed ring
        _DashedCircle(size: 280, color: const Color(0xFFD4B896)),
        // Inner ring
        _DashedCircle(size: 175, color: const Color(0xFFD4B896)),

        // ── Timeline dots (hollow rings with center dot) ──
        // "Now" dot – right side
        Positioned(top: 100, right: 20, child: _TimelineDot(isActive: true)),
        // "2 hrs ago" dot – center-left
        Positioned(top: 130, left: 60, child: _TimelineDot(isActive: false)),
        // "Yesterday" dot – top-center with label
        Positioned(
          top: 60,
          left: 115,
          child: Column(
            children: [
              _buildTimeLabel('Yesterday'),
              const SizedBox(height: 4),
              _TimelineDot(isActive: false),
            ],
          ),
        ),
        // "2 days ago" dot – bottom-left with label
        Positioned(
          bottom: 70,
          left: 30,
          child: Column(
            children: [
              _buildTimeLabel('2 days ago'),
              const SizedBox(height: 4),
              _TimelineDot(isActive: false),
            ],
          ),
        ),
        // extra small dot at very bottom
        Positioned(
          bottom: 52,
          left: 70,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFB5975A).withOpacity(0.5),
            ),
          ),
        ),

        // ── Avatar heads around the ring ──
        // Top-center avatar
        Positioned(
          top: 18,
          left: 130,
          child: _CircleAvatar2(color: const Color(0xFFB08060), size: 44),
        ),
        // Left avatar
        Positioned(
          top: 80,
          left: 28,
          child: _CircleAvatar2(color: const Color(0xFF6B7B5A), size: 44),
        ),
        // Left-lower avatar
        Positioned(
          top: 140,
          left: 10,
          child: _CircleAvatar2(color: const Color(0xFFB5A0D0), size: 44),
        ),
        // Bottom-left small avatar
        Positioned(
          bottom: 80,
          left: 0,
          child: _CircleAvatar2(color: const Color(0xFF5C4A35), size: 40),
        ),

        // ── Anna tooltip popup ──
        Positioned(bottom: 60, right: 0, child: _AnnaTooltip()),

        // ── Bottom pill: 30-day history ──
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, color: Color(0xFF3D3020), size: 18),
                SizedBox(width: 8),
                Text(
                  '30-day location history',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2D2416),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE0CF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF6B5740),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? const Color(0xFF3D3020)
            : const Color(0xFFD4B896),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Helper Widgets
// ─────────────────────────────────────────────

/// Paints a simplified street map inside the oval
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFD4BC9E)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final roadThinPaint = Paint()
      ..color = const Color(0xFFD4BC9E)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final greenPaint = Paint()
      ..color = const Color(0xFFCDDFB8).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final blockPaint = Paint()
      ..color = const Color(0xFFD6C4A8).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Green areas
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.28,
          size.height * 0.32,
          size.width * 0.18,
          size.height * 0.28,
        ),
        const Radius.circular(6),
      ),
      greenPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.55,
          size.height * 0.40,
          size.width * 0.16,
          size.height * 0.22,
        ),
        const Radius.circular(5),
      ),
      greenPaint,
    );

    // Building blocks
    final blocks = [
      Rect.fromLTWH(
        size.width * 0.50,
        size.height * 0.55,
        size.width * 0.14,
        size.height * 0.18,
      ),
      Rect.fromLTWH(
        size.width * 0.36,
        size.height * 0.62,
        size.width * 0.10,
        size.height * 0.12,
      ),
    ];
    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, const Radius.circular(3)),
        blockPaint,
      );
    }

    // Horizontal main road
    canvas.drawLine(
      Offset(0, size.height * 0.52),
      Offset(size.width, size.height * 0.48),
      roadPaint,
    );
    // Diagonal road top-left to bottom-right
    canvas.drawLine(
      Offset(size.width * 0.15, 0),
      Offset(size.width * 0.70, size.height),
      roadPaint,
    );
    // Thin road top-right
    canvas.drawLine(
      Offset(size.width * 0.50, 0),
      Offset(size.width * 0.85, size.height * 0.55),
      roadThinPaint,
    );
    // Thin road bottom
    canvas.drawLine(
      Offset(size.width * 0.10, size.height * 0.70),
      Offset(size.width * 0.90, size.height * 0.62),
      roadThinPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Avatar pin used on the map: circle photo + dark name badge
class _MapAvatarPin extends StatelessWidget {
  final String name;
  final Color color;
  const _MapAvatarPin({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF3D3020).withOpacity(0.88),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _DashedCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DashedCirclePainter(color: color),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const dashCount = 40;
    const dashAngle = 3.14159 * 2 / dashCount;

    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) {
        final startAngle = i * dashAngle;
        final sweepAngle = dashAngle * 0.6;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Avatar bubble with circular photo placeholder + name label below
class _AvatarBubble extends StatelessWidget {
  final String name;
  final Color color;
  const _AvatarBubble({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF3D3020).withOpacity(0.85),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Simple colored circle avatar (no label) used in slide 3
class _CircleAvatar2 extends StatelessWidget {
  final Color color;
  final double size;
  const _CircleAvatar2({required this.color, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );
  }
}

/// The hollow ring + center dot used as timeline markers
class _TimelineDot extends StatelessWidget {
  final bool isActive;
  const _TimelineDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? 28 : 22,
      height: isActive ? 28 : 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: isActive ? const Color(0xFF3D3020) : const Color(0xFFB5975A),
          width: isActive ? 2.5 : 1.8,
        ),
      ),
      child: Center(
        child: Container(
          width: isActive ? 8 : 6,
          height: isActive ? 8 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF3D3020) : const Color(0xFFB5975A),
          ),
        ),
      ),
    );
  }
}

/// Dark tooltip card showing Anna's location info
class _AnnaTooltip extends StatelessWidget {
  const _AnnaTooltip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3D3020),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Small avatar
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8B7060),
                  border: Border.all(color: Colors.white24, width: 1.5),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Anna',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              // Online dot
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white54, size: 13),
              SizedBox(width: 4),
              Text(
                'Central Park, NY',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Now · 2 hrs ago · Yesterday',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
