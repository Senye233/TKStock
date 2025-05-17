import 'package:flutter/material.dart';


class Pressable extends StatefulWidget {
  final Function() onTap;
  final Function()? onLongPress;
  final Widget child;
  final bool enable;

  const Pressable({
    super.key,
    required this.onTap,
    this.enable = true,
    this.onLongPress,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _PressableState();
}

class _PressableState extends State<Pressable> with SingleTickerProviderStateMixin {
  var _isDown = false;
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _animation = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) {
        if (!widget.enable) return widget.child;
        return GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onTapDown: (_) {
            if (_controller.isAnimating) return;
            _isDown = true;
            _controller.forward().then((value) {
              if (!_isDown) {
                _controller.reverse();
              }
            });
          },
          onTapUp: (d) => _onTapUpOrCancel(),
          onTapCancel: _onTapUpOrCancel,
          child: Opacity(opacity: _animation.value, child: widget.child),
        );
      },
    );
  }

  void _onTapUpOrCancel() {
    _isDown = false;
    if (!_controller.isAnimating) {
      _controller.reverse();
    }
  }
}

class ReturnPressable extends StatelessWidget {
  final Widget child;

  const ReturnPressable({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Pressable(onTap: () => Navigator.of(context).pop(), child: child);
}
