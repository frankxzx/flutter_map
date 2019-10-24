import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import './screen_pixel_crs.dart';
import '../widgets/drawer.dart';

class OverlayImagePage extends StatefulWidget {
  static const String route = 'overlay_image';

  @override
  State<StatefulWidget> createState() {
    return OverlayImagePageState();
  }
}

//1 将自定义 map 作为 overlay image layer 绘制在地图坐标系上
//2 将后台返回的 标注 像素点（x, y) 转化为地理坐标 绘制在地图上
//3
class OverlayImagePageState extends State<OverlayImagePage> {
  static const String route = 'overlay_image';

  var mapController = MapController();

  List<LatLng> tappedPoints = [];

  @override
  Widget build(BuildContext context) {
    var markers = tappedPoints.map((latlng) {
      var index = tappedPoints.indexOf(latlng);
      return Marker(
        width: 50.0,
        height: 30.0,
        point: latlng,
        builder: (ctx) => Container(
            child: Row(children: [FlutterLogo(), Text(index.toString())])),
      );
    }).toList();
    var overlayImages = <OverlayImage>[
      OverlayImage(
          bounds: LatLngBounds(LatLng(0, 0), LatLng(30, 30)),
          opacity: 1,
          // imageProvider: ExactAssetImage('assets/map.jpg')
          //  NetworkImage(
          //     'https://images.pexels.com/photos/231009/pexels-photo-231009.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=300&w=600')
          imageProvider: NetworkImage('https://fakeimg.pl/30x30/?text=Hello')),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Overlay Image')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('This is a map that is showing (51.5, -0.9).'),
            ),
            Flexible(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                    crs: CrsSimple(),
                    nePanBoundary: LatLng(30, 30),
                    swPanBoundary: LatLng(0, 0),
                    center: LatLng(15, 15),
                    debug: true,
                    zoom: 1.0,
                    maxZoom: 10,
                    minZoom: 1,
                    onTap: (position, latlng) {
                      var offset = position.relative;
                      var point = CustomPoint(15, 15);

                      var pointTR = CustomPoint(0, 0);
                      var pointCenter = CustomPoint(30, 30);

                      // var latlng1 = mapController.layerPointToLatLng(point);
                      // var latlng2 = mapController.layerPointToLatLng(pointTR);
                      // var latlng3 =
                      //     mapController.layerPointToLatLng(pointCenter);
                      // var latlngCenter =
                      //     mapController.layerPointToLatLng(point);

                      var latlng1 = LatLng(0, 0);
                      var latlng2 = LatLng(15, 15);
                      var latlng3 = LatLng(30, 30);
                      var latlng4 = LatLng(7.5, 7.5);
                      var latlngCenter = latlng2;
                      debugPrint(latlng1.toString());
                      debugPrint(latlng2.toString());
                      debugPrint(latlng3.toString());
                      debugPrint(latlngCenter.toString());
                      mapController.move(latlngCenter, 1);

                      setState(() {
                        tappedPoints.add(latlng1);
                        tappedPoints.add(latlng2);
                        tappedPoints.add(latlng3);
                        tappedPoints.add(latlngCenter);
                        tappedPoints.add(latlng4);
                      });

                      var bounds = LatLngBounds();
                      bounds.extend(latlng1);
                      bounds.extend(latlng3);
                      // bounds.extend(latlng3);
                      mapController.fitBounds(
                        bounds,
                        options: FitBoundsOptions(padding: EdgeInsets.all(15)),
                      );
                    }),
                layers: [
                  // TileLayerOptions(
                  //     urlTemplate:
                  //         'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  //     subdomains: ['a', 'b', 'c']),
                  OverlayImageLayerOptions(overlayImages: overlayImages),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
