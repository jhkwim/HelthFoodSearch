import 'package:flutter/material.dart';

class StaggeredListItem extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration duration;
  final double verticalOffset;
  final bool shouldAnimate;

  const StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 375),
    this.verticalOffset = 50.0,
    this.shouldAnimate = true,
  });

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: Offset(
        0,
        widget.verticalOffset / 100,
      ), // Adjusted for relative offset
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (!widget.shouldAnimate) {
      _controller.value = 1.0;
      return;
    }

    // Stagger delay
    // Cap the delay to avoid long waits for items far down the list
    final int delayIndex = widget.index > 6 ? 6 : widget.index;
    Future.delayed(Duration(milliseconds: delayIndex * 50), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
