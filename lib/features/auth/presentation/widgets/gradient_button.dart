import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final double buttonWidth, buttonHeight;
  final Color firstGradientColor, secondGradientColor;
  final String buttonText;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.firstGradientColor,
    required this.secondGradientColor,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.firstGradientColor,
            widget.secondGradientColor,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Text(
              widget.buttonText,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
