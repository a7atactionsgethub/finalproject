import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    AppTheme.addListener(_onThemeChanged);
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    AppTheme.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          width: 56,
          height: 32,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: widget.value 
                ? LinearGradient(
                    colors: AppTheme.buttonGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      AppTheme.textTertiary.withOpacity(0.2),
                      AppTheme.textTertiary.withOpacity(0.1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: [
              // Main depth shadow
              BoxShadow(
                color: widget.value 
                    ? AppTheme.primaryColor.withOpacity(0.4)
                    : Colors.black.withOpacity(0.15),
                blurRadius: widget.value ? 12 : 8,
                offset: const Offset(0, 4),
                spreadRadius: widget.value ? 1 : 0,
              ),
              // Glow effect when active
              if (widget.value)
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                  spreadRadius: 2,
                ),
              // Inner shadow for depth
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: -2,
              ),
            ],
            border: Border.all(
              color: widget.value 
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Track indicator icons (optional subtle detail)
              if (widget.value)
                Positioned(
                  left: 6,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white.withOpacity(0.4),
                      size: 14,
                    ),
                  ),
                ),
              if (!widget.value)
                Positioned(
                  right: 6,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.close_rounded,
                      color: AppTheme.textTertiary.withOpacity(0.3),
                      size: 14,
                    ),
                  ),
                ),
              
              // Animated thumb
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.95),
                      ],
                    ),
                    boxShadow: [
                      // Main thumb shadow
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                      // Subtle inner shadow
                      BoxShadow(
                        color: widget.value 
                            ? AppTheme.primaryColor.withOpacity(0.2)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                        spreadRadius: -1,
                      ),
                      // Top highlight
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                        spreadRadius: -1,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 0.5,
                    ),
                  ),
                  child: widget.value
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: AppTheme.buttonGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}