import 'package:flutter/material.dart';
import 'package:scouttalent2/utils/theme.dart';

class RoundedSliderTrackShape extends SliderTrackShape {
  const RoundedSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 8;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(

      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        Offset? secondaryOffset, // 🔥 REQUIRED FIX
        bool isEnabled = false,
        bool isDiscrete = false,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );

    final Paint inactivePaint = Paint()
      ..color = ThemeProvider.ratingTrack
      ..style = PaintingStyle.fill;

    final Paint activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF6A00), Color(0xFFFF8C3A)],
      ).createShader(trackRect);

    final Radius radius = Radius.circular(trackRect.height / 2);

    // Inactive track
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, radius),
      inactivePaint,
    );

    // Active track
    final Rect activeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeRect, radius),
      activePaint,
    );
  }
}
