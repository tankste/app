import 'dart:convert';
import 'dart:ui' as ui;
import 'package:bertho/gas_station_model.dart';
import 'package:bertho/settings_page.dart';
import 'package:bertho/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:bertho/filter_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bertho',
      theme: berthoTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LatLng startPosition = LatLng(51.2147194, 10.3634281);
  Set<Marker> markers = {};
  List<GasStationModel> _stations = [];
  Filter _filter = Filter("e5");
  bool isFilterVisible = false;
  bool _showLabelMarkers = false;
  LocationData? _position;
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              _mapController = controller;
            });
          },
          onCameraMove: (position) {
            if (position.zoom >= 12 && !_showLabelMarkers) {
              setState(() {
                _showLabelMarkers = true;
              });
              _updateMarkers();
            } else if (position.zoom < 12 && _showLabelMarkers) {
              setState(() {
                _showLabelMarkers = false;
              });
              _updateMarkers();
            }
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          markers: markers,
          myLocationEnabled: true,
          initialCameraPosition:
              CameraPosition(target: startPosition, zoom: 6.0)),
      Positioned(
          top: 8,
          right: 8,
          child: SafeArea(
              child: SizedBox(
                  width: 64,
                  child: Card(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsPage()));
                          },
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                Icons.settings,
                                color: Theme.of(context).primaryColor,
                              ))),
                      Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Divider(height: 1)),
                      InkWell(
                          onTap: () {
                            _fetchNearbyStations();
                          },
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                Icons.gps_fixed,
                                color: Theme.of(context).primaryColor,
                              ))),
                    ],
                  ))))),
      Positioned(
          bottom: 8,
          right: 8,
          child: SafeArea(
              child: SizedBox(
                  width: 64,
                  child: Card(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isFilterVisible = true;
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                Icons.tune,
                                color: Theme.of(context).primaryColor,
                              ))))))),
      isFilterVisible
          ? FilterDialog(
              currentFilter: _filter,
              onSubmit: (filter) {
                setState(() {
                  _filter = filter;
                  isFilterVisible = false;
                  _updateStations();
                });
              },
              onCancel: () {
                setState(() {
                  isFilterVisible = false;
                });
              })
          : Container()
    ]);
  }

  @override
  void initState() {
    super.initState();
    _fetchNearbyStations();
  }

  Future<Set<Marker>> _genMarkers(
      List<GasStationModel> stations, double minPrice) async {
    List<Marker> markers = await Future.wait(stations.map((s) async => Marker(
        markerId: MarkerId(s.id),
        position: LatLng(s.lat, s.lng),
        consumeTapEvents: false,
        icon: await _genMarkerBitmap(s, minPrice))));
    return markers.toSet();
  }

  Future<BitmapDescriptor> _genMarkerBitmap(
      GasStationModel station, double minPrice) {
    if (_showLabelMarkers) {
      return _genLabelMarkerBitmap(station, minPrice);
    } else {
      return _genDotMarkerBitmap(station, minPrice);
    }
  }

  Future<BitmapDescriptor> _genDotMarkerBitmap(
      GasStationModel station, double minPrice) async {
    String path;
    if (!station.isOpen || station.price == 0) {
      path = 'assets/images/markers/grey.png';
    } else {
      if (minPrice + 0.04 >= station.price) {
        path = 'assets/images/markers/green.png';
      } else if (minPrice + 0.10 >= station.price) {
        path = 'assets/images/markers/orange.png';
      } else {
        path = 'assets/images/markers/red.png';
      }
    }

    return await BitmapDescriptor.fromAssetImage(ImageConfiguration(), path);
  }

  Future<BitmapDescriptor> _genLabelMarkerBitmap(
      GasStationModel station, double minPrice) async {
    const double padding = 5.0;
    const double textPadding = 10.0;
    const double triangleSize = 25.0;
    const double maxWidth = 160.0;
    const double brandFontSize = 25.0;
    const double priceFontSize = 45.0;

    // Create canvas
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Create bar name text
    var brandParagraph =
        (ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: ui.TextAlign.left))
              ..pushStyle(ui.TextStyle(
                color: Colors.white70,
                fontSize: brandFontSize,
              ))
              ..addText(station.brand.length > 8
                  ? "${station.brand.substring(0, 5)}..."
                  : station.brand))
            .build();

    String priceText;

    if (!station.isOpen || station.price == 0) {
      priceText = "-,--\u{207B}";
    } else {
      priceText = station.price.toString().replaceAll('.', ',');
    }

    if (priceText.length == 5) {
      priceText = priceText
          .replaceFirst('0', '\u{2070}', 4)
          .replaceFirst('1', '\u{00B9}', 4)
          .replaceFirst('2', '\u{00B2}', 4)
          .replaceFirst('3', '\u{00B3}', 4)
          .replaceFirst('4', '\u{2074}', 4)
          .replaceFirst('5', '\u{2075}', 4)
          .replaceFirst('6', '\u{2076}', 4)
          .replaceFirst('7', '\u{2077}', 4)
          .replaceFirst('8', '\u{2078}', 4)
          .replaceFirst('9', '\u{2079}', 4);
    }

    var priceParagraph =
        (ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: ui.TextAlign.left))
              ..pushStyle(ui.TextStyle(
                  color: Colors.white,
                  fontSize: priceFontSize,
                  fontWeight: FontWeight.bold))
              ..addText(priceText))
            .build();

    final constraints = ui.ParagraphConstraints(width: maxWidth);
    brandParagraph.layout(constraints);
    priceParagraph.layout(constraints);

    // Create background rect
    final backgroundPaint = Paint();
    if (!station.isOpen || station.price == 0) {
      backgroundPaint.color = Colors.grey;
    } else {
      if (minPrice + 0.04 >= station.price) {
        backgroundPaint.color = Colors.green;
      } else if (minPrice + 0.10 >= station.price) {
        backgroundPaint.color = Colors.orange;
      } else {
        backgroundPaint.color = Colors.red;
      }
    }

    final labelHeight = padding +
        textPadding +
        brandParagraph.height +
        priceParagraph.height +
        padding;

    var rect = Rect.fromLTWH(0, 0, maxWidth, labelHeight);

    // Create triangle path
    var trianglePath = Path();
    trianglePath.moveTo(
        maxWidth / 2, labelHeight + triangleSize); //TODO: dynamic width
    trianglePath.lineTo(
        maxWidth / 2 - triangleSize, labelHeight); //TODO: dynamic width
    trianglePath.lineTo(
        maxWidth / 2 + triangleSize, labelHeight); //TODO: dynamic width
    trianglePath.close();

    // Draw background
    canvas.drawRect(rect, backgroundPaint);

    // Draw text
    canvas.drawParagraph(
        brandParagraph, Offset(padding + textPadding, padding + textPadding));
    canvas.drawParagraph(priceParagraph,
        Offset(padding + textPadding, padding + textPadding + brandFontSize));

    // Draw trianglePath path
    canvas.drawPath(trianglePath, backgroundPaint);

    final img = await pictureRecorder
        .endRecording()
        .toImage(maxWidth.toInt(), labelHeight.toInt() + triangleSize.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<List<GasStationModel>> _requestStations(LocationData location) async {
    final double lat = location.latitude ?? 52.510494;
    final double lng = location.longitude ?? 13.396764;

    var url = Uri.parse(
        'https://creativecommons.tankerkoenig.de/json/list.php?lat=$lat&lng=$lng&rad=15&sort=price&type=${_filter.gas}&apikey=***REMOVED***');
    var response = await http.get(url);
    final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    return (jsonResponse['stations'] as List)
        .map((i) => GasStationModel.fromJson(i))
        .toList();
  }

  Future<LocationData?> _moveCameraToOwnPosition() async {
    LocationData? locationData = await _getOwnPosition();
    LatLng position;
    if (locationData != null) {
      position = LatLng(locationData.latitude ?? startPosition.latitude,
          locationData.longitude ?? startPosition.longitude);
    } else {
      position = startPosition;
    }
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 14));
    return locationData;
  }

  Future<LocationData?> _getOwnPosition() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  void _fetchNearbyStations() {
    _moveCameraToOwnPosition().then((position) {
      if (position == null) {
        return;
      }

      setState(() {
        _position = position;
      });

      _updateStations();
    });
  }

  void _updateStations() async {
    if (_position == null) {
      return;
    }

    _requestStations(_position!).then((stations) {
      setState(() {
        _stations = stations;
      });

      if (stations.isEmpty) {
        return Future.value(Set<Marker>());
      }

      final double minPrice = stations
          .where((s) => s.price != 0)
          .reduce((curr, next) => curr.price < next.price ? curr : next)
          .price;

      return _genMarkers(stations, minPrice);
    }).then((m) => setState(() {
          markers = m;
        }));
  }

  void _updateMarkers() {
    final double minPrice = _stations
        .where((s) => s.price != 0)
        .reduce((curr, next) => curr.price < next.price ? curr : next)
        .price;

    _genMarkers(_stations, minPrice).then((m) => setState(() {
          markers = m;
        }));
  }
}
