import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class CurvedBottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final center = size.width / 2;
    const notchRadius = 40.0;

    path.moveTo(0, 16);
    path.quadraticBezierTo(0, 0, 16, 0);

    // Left straight segment
    path.lineTo(center - notchRadius - 16, 0);

    // Smooth entry into flower petal notch
    path.quadraticBezierTo(
      center - notchRadius, 0,
      center - notchRadius + 6, 12,
    );
    path.arcToPoint(
      Offset(center + notchRadius - 6, 12),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );
    path.quadraticBezierTo(
      center + notchRadius, 0,
      center + notchRadius + 16, 0,
    );

    // Right straight segment
    path.lineTo(size.width - 16, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 16);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class FlowerVoicePetalButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isListening;

  const FlowerVoicePetalButton({
    super.key,
    required this.onTap,
    this.isListening = false,
  });

  @override
  State<FlowerVoicePetalButton> createState() => _FlowerVoicePetalButtonState();
}

class _FlowerVoicePetalButtonState extends State<FlowerVoicePetalButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = widget.isListening
              ? 1.0 + (_pulseController.value * 0.12)
              : 1.0;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: NutriviaColors.marigold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: NutriviaColors.marigold.withValues(alpha: widget.isListening ? 0.6 : 0.35),
                    blurRadius: widget.isListening ? 18 : 10,
                    spreadRadius: widget.isListening ? 4 : 1,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: Icon(
                  widget.isListening ? Icons.mic : Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NutriviaBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final VoidCallback onVoiceTap;
  final bool isListening;
  final String Function(String) tr;

  const NutriviaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onVoiceTap,
    this.isListening = false,
    required this.tr,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Background Curved Bar
          Positioned.fill(
            child: ClipPath(
              clipper: CurvedBottomBarClipper(),
              child: Container(
                color: NutriviaColors.snow,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: NutriviaColors.lavenderMist.withValues(alpha: 0.7), width: 1),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Destinations row
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.local_florist_outlined, Icons.local_florist_rounded, tr('nav_home')),
                _buildNavItem(1, Icons.healing_outlined, Icons.healing_rounded, tr('nav_track')),
                const SizedBox(width: 58), // Space for central voice petal
                _buildNavItem(2, Icons.restaurant_menu_outlined, Icons.restaurant_menu_rounded, tr('nav_eat')),
                _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, tr('nav_me')),
              ],
            ),
          ),

          // Central Flower Voice Petal
          Positioned(
            top: -14,
            child: FlowerVoicePetalButton(
              onTap: onVoiceTap,
              isListening: isListening,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected ? NutriviaColors.plum : NutriviaColors.stone;

    return InkWell(
      onTap: () => onTabSelected(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? filledIcon : outlineIcon, color: color, size: 26),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
