import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/map.dart';
import 'package:latlong/latlong.dart' hide Path; // conflict with Path from UI

class BitmapImageLayerOptions extends LayerOptions {
  final List<BitmapImage> bitmapImages;

  BitmapImageLayerOptions({this.bitmapImages = const [], rebuild})
      : super(rebuild: rebuild);
}

class BitmapImage {
  final List<CustomPoint> points;
  final List<Offset> offsets = [];

  BitmapImage({
    this.points,
  });
}

class BitmapImageLayer extends StatelessWidget {
  final BitmapImageLayerOptions bitmapImageOpts;
  final MapState map;
  final Stream stream;

  BitmapImageLayer(this.bitmapImageOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints bc) {
        // TODO unused BoxContraints should remove?
        final size = Size(bc.maxWidth, bc.maxHeight);
        return _build(context, size);
      },
    );
  }

  Widget _build(BuildContext context, Size size) {
    return StreamBuilder(
      stream: stream, // a Stream<void> or null
      builder: (BuildContext context, _) {
        for (var bitmapImageOpt in bitmapImageOpts.bitmapImages) {
          bitmapImageOpt.offsets.clear();
          var i = 0;
          for (var pos in bitmapImageOpt.points) {
            pos = pos.multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
                map.getPixelOrigin();
            bitmapImageOpt.offsets
                .add(Offset(pos.x.toDouble(), pos.y.toDouble()));
            if (i > 0 && i < bitmapImageOpt.points.length) {
              bitmapImageOpt.offsets
                  .add(Offset(pos.x.toDouble(), pos.y.toDouble()));
            }
            i++;
          }
        }

        return Container(
          child: Stack(
            children: [
              for (final bitmapImageOpt in bitmapImageOpts.bitmapImages)
                CustomPaint(
                  painter: BitmapImagePainter(bitmapImageOpt),
                  size: size,
                ),
            ],
          ),
        );
      },
    );
  }
}

class BitmapImagePainter extends CustomPainter {
  final BitmapImage bitmapImageOpt;

  BitmapImagePainter(this.bitmapImageOpt);

  @override
  void paint(Canvas canvas, Size size) {
    if (bitmapImageOpt.offsets.isEmpty) {
      return;
    }
    final rect = Offset.zero & size;
    canvas.clipRect(rect);
// _paintImage(canvas, rect)
  }

  void _paintImage(Canvas canvas, ui.Image image, Offset offset, Paint paint) {
    canvas.drawImage(image, offset, paint);
  }

  @override
  bool shouldRepaint(BitmapImagePainter other) => false;

  double _dist(Offset v, Offset w) {
    return sqrt(_dist2(v, w));
  }

  double _dist2(Offset v, Offset w) {
    return _sqr(v.dx - w.dx) + _sqr(v.dy - w.dy);
  }

  double _sqr(double x) {
    return x * x;
  }
}
