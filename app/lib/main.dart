import 'dart:io';
import 'package:core/cubit/base_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:station/ui/map/station_map_page.dart';
import 'package:tankste/app/cubit/app_cubit.dart';
import 'package:tankste/app/cubit/app_state.dart';
import 'package:tankste/theme.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TanksteApp());
}

class TanksteApp extends StatelessWidget {
  const TanksteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? (Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            : SystemUiOverlayStyle.light,
        child: BlocProvider(
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
                home: StationMapPage(),
              );
            })));
  }
}
