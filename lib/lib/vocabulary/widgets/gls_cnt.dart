import 'dart:ui';

import 'package:flutter/material.dart';

class GlassmorphicContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double blur;
  final AlignmentGeometry alignment;
  final LinearGradient linearGradient;
  final double border;
  final Color borderColor;
  final Widget child;

  const GlassmorphicContainer({
    required Key key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.blur,
    required this.alignment,
    required this.linearGradient,
    required this.border,
    required this.borderColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            blurRadius: blur,
            spreadRadius: -5,
            offset: Offset(4, 4),
            color: Colors.white.withOpacity(0.2),
          ),
          BoxShadow(
            blurRadius: blur,
            spreadRadius: 2,
            offset: Offset(-4, -4),
            color: Colors.black.withOpacity(0.2),
          ),
        ],
        border: Border.all(
          width: border,
          color: borderColor,
        ),
        gradient: linearGradient,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            alignment: alignment,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}