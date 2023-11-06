import 'dart:io';
import 'dart:ui' as ui;
import 'package:core/config/config_repository.dart';
import 'package:core/cubit/base_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map/generic/generic_map.dart';
import 'package:settings/developer/model/developer_settings_model.dart';
import 'package:settings/developer/repository/developer_settings_repository.dart';
import 'package:settings/settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:station/repository/station_repository.dart';
import 'package:station/station_model.dart';
import 'package:station/usecase/get_stations_use_case.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:tankste/app/cubit/app_cubit.dart';
import 'package:tankste/app/cubit/app_state.dart';
import 'package:tankste/theme.dart';
import 'package:flutter/material.dart';
import 'package:tankste/filter_dialog.dart';
import 'package:station/details/station_details_page.dart';
import 'package:in_app_review/in_app_review.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit(),
        child: BlocConsumer<AppCubit, AppState>(listener: (context, state) {
          // iOS specific theme handling for native view elements
          if (Platform.isIOS) {
            MethodChannel channel =
                const MethodChannel('app.tankste.settings/theme');

            String value = "system";
            if (state.theme == ThemeMode.light) {
              value = "light";
            } else if (state.theme == ThemeMode.dark) {
              value = "dark";
            }

            channel.invokeMethod('setTheme', {"value": value});
          }
        }, builder: (context, state) {
          //TODO: show progress bar or splashscreen for this state
          if (state.status == Status.loading) {
            return Container();
          }

          //TODO: show error for this state
          if (state.status == Status.failure) {
            return Container();
          }

          return MaterialApp(
            title: 'tankste!',
            debugShowCheckedModeBanner: false,
            theme: tanksteTheme,
            darkTheme: tanksteThemeDark,
            themeMode: state.theme,
            home: const MyHomePage(),
          );
        }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final CameraPosition initialCameraPosition =
      CameraPosition(latLng: LatLng(51.2147194, 10.3634281), zoom: 6.0);
  final DeveloperSettingsRepository developerSettingsRepository =
      LocalDeveloperSettingsRepository();
  final Duration _refreshAfterBackgroundDuration = const Duration(minutes: 3);
  final Duration _reviewAfterFirstAppStartDuration = const Duration(days: 7);
  Set<Marker> _markers = {};
  List<StationModel> _stations = [];
  Filter _filter = Filter("e5");
  bool isFilterVisible = false;
  bool _showLabelMarkers = false;
  bool _showMarkers = true;
  DateTime? _lastRequestTime;
  CameraPosition? _lastRequestPosition;
  CameraPosition? _position;
  CameraPosition? _ownPosition;
  MapController? _mapController;
  bool _isLoading = true;
  String? _errorDetails;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? (Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            : SystemUiOverlayStyle.light,
        child: Stack(children: <Widget>[
          GenericMap(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (mapController) {
              mapController
                  .moveCameraToPosition(_position ?? initialCameraPosition);
              _mapController = mapController;
            },
            onCameraIdle: () {
              _updateStations(false);
            },
            onCameraMove: (position) {
              _handleCameraPositionUpdate(position);
            },
            markers: _markers,
          ),
          _isLoading
              ? const SafeArea(child: LinearProgressIndicator())
              : Container(),
          _errorDetails != null
              ? Positioned(
                  top: 8,
                  left: 8,
                  right: 80,
                  child: SafeArea(
                      child: Card(
                          child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Unerwarteter Fehler",
                            style: Theme.of(context).textTheme.headline6),
                        Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                                "Es ist ein Fehler aufgetreten. Bitte prüfe deine Internetverbindung oder versuche es später erneut.",
                                style: Theme.of(context).textTheme.bodyText2)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Fehler Details'),
                                            content: Text(_errorDetails ?? ""),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text('Ok')),
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text("Fehler anzeigen")),
                              Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _updateStations(true);
                                      },
                                      child: const Text("Wiederholen")))
                            ],
                          ),
                        )
                      ],
                    ),
                  ))))
              : Container(),
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
                                        builder: (context) =>
                                            const SettingsPage()));
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Icon(
                                    Icons.settings,
                                    color: Theme.of(context).primaryColor,
                                  ))),
                          const Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Divider(height: 1)),
                          InkWell(
                              onTap: () {
                                _moveCameraToOwnPosition()
                                    .then((value) => _updateStations(true));
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Icon(
                                    Icons.gps_fixed,
                                    color: Theme.of(context).primaryColor,
                                  ))),
                        ],
                      ))))),
          Positioned(
              bottom: !Platform.isIOS ? 8 : 32,
              // Need more padding to keep "legal" link visible
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
                                  padding: const EdgeInsets.all(16),
                                  child: Icon(
                                    Icons.tune,
                                    color: Theme.of(context).primaryColor,
                                  ))))))),
          isFilterVisible
              ? FilterDialog(
                  currentFilter: _filter,
                  onSubmit: (filter) {
                    _storeFilter(filter);

                    setState(() {
                      _filter = filter;
                      isFilterVisible = false;
                    });
                    _updateStations(true);
                  },
                  onCancel: () {
                    setState(() {
                      isFilterVisible = false;
                    });
                  })
              : Container()
        ]));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _requestReviewIfNeeded();

    _getFilter().then((filter) {
      setState(() {
        _filter = filter;
      });

      return _moveCameraToOwnPosition();
    }).then((value) => _updateStations(true));
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_lastRequestTime != null) {
        DateTime thresholdDate =
            _lastRequestTime!.add(_refreshAfterBackgroundDuration);
        if (DateTime.now().isAfter(thresholdDate)) {
          _updateStations(true);
        }
      }
    }
  }

  Future<Set<Marker>> _genMarkers(List<StationModel> stations) async {
    List<Marker> markers = await Future.wait(stations.map((s) async => Marker(
        id: "${s.id}#${Object.hash(s.prices.getFirstPrice(), s.prices.getFirstPriceRange(), _showLabelMarkers ? "label" : "dot")}",
        latLng: LatLng(s.coordinate.latitude, s.coordinate.longitude),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StationDetailsPage(
                        stationId: s.id,
                        stationName: s.label,
                        activeGasPriceFilter: _filter.gas,
                      )));
        },
        icon: await _genMarkerBitmap(s))));
    return markers.toSet();
  }

  Future<ByteData> _genMarkerBitmap(StationModel station) {
    if (_showLabelMarkers) {
      return _genLabelMarkerBitmap(station);
    } else {
      return _genDotMarkerBitmap(station);
    }
  }

  Future<ByteData> _genDotMarkerBitmap(StationModel station) async {
    String path;

    if (!station.isOpen) {
      path = 'assets/images/markers/grey.png';
    } else if (station.prices.getFirstPriceRange() == StationPriceRange.cheap) {
      path = 'assets/images/markers/green.png';
    } else if (station.prices.getFirstPriceRange() ==
        StationPriceRange.normal) {
      path = 'assets/images/markers/orange.png';
    } else if (station.prices.getFirstPriceRange() ==
        StationPriceRange.expensive) {
      path = 'assets/images/markers/red.png';
    } else {
      path = 'assets/images/markers/grey.png';
    }

    String resolutionName = await AssetImage(path)
        .obtainKey(ImageConfiguration.empty)
        .then((value) => value.name);

    return await rootBundle.load(resolutionName);
  }

  Future<ByteData> _genLabelMarkerBitmap(StationModel station) async {
    double ratio = MediaQuery.of(context).devicePixelRatio;

    // Ratio version *
    double padding = 1.6 * ratio;
    double textPadding = 3.2 * ratio;
    double triangleSize = 8.0 * ratio;
    double maxWidth = 51.2 * ratio;
    double brandFontSize = 8.0 * ratio;
    double priceFontSize = 14.4 * ratio;

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
              ..addText(station.label.length > 8
                  ? "${station.label.substring(0, 5)}..."
                  : station.label))
            .build();

    String priceText;

    double price = station.prices.getFirstPrice() ?? 0.0;
    if (!station.isOpen || price == 0.0) {
      priceText = "-,--\u{207B}";
    } else {
      priceText = price.toStringAsFixed(3).replaceAll('.', ',');
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

    ui.ParagraphConstraints constraints =
        ui.ParagraphConstraints(width: maxWidth);
    brandParagraph.layout(constraints);
    priceParagraph.layout(constraints);

    // Create background rect
    final backgroundPaint = Paint();
    if (!station.isOpen) {
      backgroundPaint.color = Colors.grey;
    } else if (station.prices.getFirstPriceRange() == StationPriceRange.cheap) {
      backgroundPaint.color = Colors.green;
    } else if (station.prices.getFirstPriceRange() ==
        StationPriceRange.normal) {
      backgroundPaint.color = Colors.orange;
    } else if (station.prices.getFirstPriceRange() ==
        StationPriceRange.expensive) {
      backgroundPaint.color = Colors.red;
    } else {
      backgroundPaint.color = Colors.grey;
    }

    final labelHeight = padding +
        textPadding +
        brandParagraph.height +
        priceParagraph.height +
        padding;

    var rect = Rect.fromLTWH(0, 0, maxWidth, labelHeight);
    var rrect = RRect.fromRectXY(rect, 12, 12);

    // Create triangle path
    var trianglePath = Path();
    trianglePath.moveTo(
        maxWidth / 2, labelHeight + triangleSize - (1 * ratio)); // Bottom
    trianglePath.lineTo(
        maxWidth / 2 - triangleSize, labelHeight - (1 * ratio)); // Top-Left
    trianglePath.lineTo(
        maxWidth / 2 + triangleSize, labelHeight - (1 * ratio)); // Top-Right
    trianglePath.close();

    // Draw background
    // canvas.drawRect(rect, backgroundPaint);
    canvas.drawRRect(rrect, backgroundPaint);

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
    return data!;
  }

  Future<List<StationModel>> _requestStations(CameraPosition location) async {
    setState(() {
      _isLoading = true;
      _errorDetails = null;
    });

    GetStationsUseCase getStationsUseCase = GetStationsUseCaseImpl(
        TankerkoenigStationRepository(FileConfigRepository()),
        LocalDeveloperSettingsRepository());

    _lastRequestTime = DateTime.now();

    return getStationsUseCase.invoke(_filter.gas,
        CoordinateModel(location.latLng.latitude, location.latLng.longitude));
  }

  Future<Position?> _moveCameraToOwnPosition() async {
    setState(() {
      _isLoading = true;
    });

    Position? locationData = await _getOwnPosition();
    CameraPosition cameraPosition = initialCameraPosition;
    if (locationData != null) {
      cameraPosition = CameraPosition(
          latLng: LatLng(locationData.latitude, locationData.longitude),
          zoom: 12.5);
    }
    _handleCameraPositionUpdate(cameraPosition);
    _mapController?.moveCameraToPosition(cameraPosition);
    _ownPosition = cameraPosition;
    return locationData;
  }

  Future<Position?> _getOwnPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _requestReviewIfNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int firstAppStartMilliseconds = prefs.getInt("first_app_start") ?? -1;
    if (firstAppStartMilliseconds == -1) {
      await prefs.setInt(
          "first_app_start", DateTime.now().millisecondsSinceEpoch);
    } else {
      DateTime firstAppStart =
          DateTime.fromMillisecondsSinceEpoch(firstAppStartMilliseconds);
      DateTime thresholdDate =
          firstAppStart.add(_reviewAfterFirstAppStartDuration);
      if (DateTime.now().isAfter(thresholdDate)) {
        InAppReview inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          await inAppReview.requestReview();
        }
      }
    }
  }

  Future<Filter> _getFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gas = prefs.getString("filter_gas") ?? "e5";
    return Filter(gas);
  }

  Future<void> _storeFilter(Filter filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("filter_gas", filter.gas);
  }

  void _updateStations(bool force) async {
    if (_position == null) {
      _stations = [];
      _updateMarkers();
      return;
    }

    // Prevent fetching stations for hidden markers.
    // This keep API request limits low
    if (!_showMarkers) {
      return;
    }

    // Allow fetching without location only with enabled flag
    DeveloperSettingsModel developerSettings =
        await developerSettingsRepository.get().first;
    CameraPosition position = _ownPosition!;
    if (developerSettings.isFetchingWithoutLocationEnabled) {
      position = _position!;
    }

    // Fetch new stations only if we move camera by 8 kilometers
    if (!force && _lastRequestPosition != null) {
      double movementDistance = Geolocator.distanceBetween(
          _lastRequestPosition!.latLng.latitude,
          _lastRequestPosition!.latLng.longitude,
          _position!.latLng.latitude,
          _position!.latLng.longitude);
      if (movementDistance < 8000) {
        return;
      }
    }

    _requestStations(position)
        .then((stations) {
          _lastRequestPosition = _position;
          _stations = stations;

          if (stations.isEmpty) {
            return Future.value(<Marker>{});
          }

          return _genMarkers(stations);
        })
        .then((m) => setState(() {
              _isLoading = false;
              _markers = m;
            }))
        .catchError((error) {
          if (kDebugMode) {
            if (error is Error) {
              print("===== Error =====");
              print("$error\n${error.stackTrace}");
            } else if (error is Exception) {
              print("===== Error =====");
              print(error.toString());
            }
          }

          setState(() {
            _errorDetails = error.toString();
            _isLoading = false;
          });
        });
  }

  void _updateMarkers() {
    if (_stations.isEmpty) {
      setState(() {
        _markers = {};
      });
      return;
    }

    if (!_showMarkers) {
      setState(() {
        _markers = {};
      });
      return;
    }

    _genMarkers(_stations).then((m) => setState(() {
          _markers = m;
        }));
  }

  void _handleCameraPositionUpdate(CameraPosition position) {
    _position = position;

    if (position.zoom >= 12) {
      if (!_showLabelMarkers || !_showMarkers) {
        _showLabelMarkers = true;
        _showMarkers = true;
        _updateMarkers();
      }
    } else if (position.zoom >= 10.5) {
      if (_showLabelMarkers || !_showMarkers) {
        _showLabelMarkers = false;
        _showMarkers = true;
        _updateMarkers();
      }
    } else {
      if (_showMarkers) {
        _showMarkers = false;
        _updateMarkers();
      }
    }
  }
}
