import 'dart:math';

import 'package:flutter/material.dart';

/// Renderer used to show popup window overlay
class PopupOverlayRenderer {
  OverlayEntry? _overlayEntry;

  /// [PopupOverlayRenderer] constructor
  PopupOverlayRenderer();

  /// Render overlay entry on the screen with dismiss logic
  OverlayEntry render(
    BuildContext context, {
    ValueChanged<TapDownDetails>? onClose,
    required Offset position,
    required WidgetBuilder popupBuilder,
  }) {
    final _createdEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: onClose,
        child: Material(
          color: Colors.transparent,
          type: MaterialType.canvas,
          child: Stack(
            children: [
              CustomSingleChildLayout(
                delegate: PopupOverlayLayoutDelegate(position, context),
                child: TapRegion(
                  onTapOutside: (_) => dismiss(),
                  child: popupBuilder(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_createdEntry);
    _overlayEntry = _createdEntry;

    return _createdEntry;
  }

  /// Remove popup
  void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

/// Class that calculates where to place popup window on the screen
class PopupOverlayLayoutDelegate extends SingleChildLayoutDelegate {
  /// desired position of popup window
  final Offset position;
  final BuildContext context; 

  /// [PopupOverlayLayoutDelegate] constructor
  const PopupOverlayLayoutDelegate(this.position, this.context);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return _calculatePosition(size, position, childSize, context);
  }

Offset _calculatePosition(Size size, Offset position, Size childSize, BuildContext context) {
  final _popupRect = Rect.fromCenter(
    center: position,
    width: childSize.width,
    height: childSize.height,
  );

  // Get the height of the keyboard
  double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

  // Calculate vertical position (dy)
  double dy = position.dy - childSize.height - keyboardHeight; // Display above the desired position and keyboard
  // Limiting Y offset to be at least 0
  dy = max(0, dy);

  // Calculate horizontal position (dx)
  double dx = _popupRect.left;
  // Limiting X offset
  dx = max(0, dx);
  final rightBorderPosition = dx + childSize.width;
  final rightScreenBorderOverflow = rightBorderPosition - size.width;
  if (rightScreenBorderOverflow > 0) {
    dx -= rightScreenBorderOverflow;
  }

  return Offset(dx, dy);
}



  @override
  bool shouldRelayout(covariant PopupOverlayLayoutDelegate oldDelegate) {
    return false;
  }
}
