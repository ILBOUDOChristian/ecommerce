import 'package:flutter/material.dart';

void playAddToCartAnimation({
  required BuildContext context,
  required GlobalKey imageKey,
  required GlobalKey cartIconKey,
  required String imageUrl,
}) {
  final overlay = Overlay.maybeOf(context);
  final imageBox = imageKey.currentContext?.findRenderObject() as RenderBox?;
  final cartBox = cartIconKey.currentContext?.findRenderObject() as RenderBox?;
  if (overlay == null || imageBox == null || cartBox == null) return;

  final start = imageBox.localToGlobal(Offset.zero);
  final end = cartBox.localToGlobal(Offset.zero) +
      Offset(cartBox.size.width / 2, cartBox.size.height / 2);

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) {
      return _FlyingProduct(
        start: start,
        end: end,
        size: imageBox.size,
        imageUrl: imageUrl,
        onDone: () => entry.remove(),
      );
    },
  );
  overlay.insert(entry);
}

class _FlyingProduct extends StatefulWidget {
  const _FlyingProduct({
    required this.start,
    required this.end,
    required this.size,
    required this.imageUrl,
    required this.onDone,
  });

  final Offset start;
  final Offset end;
  final Size size;
  final String imageUrl;
  final VoidCallback onDone;

  @override
  State<_FlyingProduct> createState() => _FlyingProductState();
}

class _FlyingProductState extends State<_FlyingProduct>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _controller.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _curve,
            builder: (context, child) {
              final t = _curve.value;
              final dx = widget.start.dx + (widget.end.dx - widget.start.dx) * t;
              final dy = widget.start.dy +
                  (widget.end.dy - widget.start.dy) * t -
                  (80 * (4 * t * (1 - t)));
              final scale = 1 - (0.75 * t);
              return Positioned(
                left: dx,
                top: dy,
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              );
            },
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: widget.size.width * 0.45,
                height: widget.size.height * 0.45,
                child: Image.network(widget.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
