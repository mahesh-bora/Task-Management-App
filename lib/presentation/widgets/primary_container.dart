import 'package:flutter/material.dart';

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const PrimaryContainer({
    super.key,
    this.radius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10),
        boxShadow: [
          BoxShadow(
            color: color ?? const Color(0XFF4A4A4A),
          ),
          const BoxShadow(
            offset: Offset(-1, 0),
            blurRadius: 5,
            spreadRadius: 2,
            color: Colors.white,
            // inset: true,
          ),
        ],
      ),
      child: child,
    );
  }
}
