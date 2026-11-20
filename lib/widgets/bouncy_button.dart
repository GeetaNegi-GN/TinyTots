import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BouncyButton extends StatefulWidget {
  const BouncyButton({
    super.key,
    required this.child,
    this.onTap,
    this.color = AppTheme.skyBlue,
    this.textColor = AppTheme.navy,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.borderRadius = 28,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: enabled ? widget.color : AppTheme.disabledBg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.35),
                      blurRadius: _pressed ? 4 : 10,
                      offset: Offset(0, _pressed ? 2 : 5),
                    ),
                  ]
                : [],
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: enabled ? widget.textColor : AppTheme.disabledText,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
