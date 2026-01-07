import 'package:flutter/widgets.dart';

class ExpandOnly extends StatefulWidget {
  final Widget child;

  const ExpandOnly({
    super.key,
    required this.child,
  });

  @override
  State<ExpandOnly> createState() => _ExpandOnlyState();
}

class _ExpandOnlyState extends State<ExpandOnly> {
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox == null) return;

          final height = renderBox.size.height;
          if (height > _height) {
            setState(() {
              _height = height;
            });
          }
        });

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: _height,
          ),
          child: widget.child,
        );
      },
    );
  }
}
