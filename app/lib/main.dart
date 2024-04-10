import 'dart:io';
import 'package:core/cubit/base_state.dart';
import 'package:core/log/log.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:station/ui/map/station_map_page.dart';
import 'package:tankste/app/cubit/app_cubit.dart';
import 'package:tankste/app/cubit/app_state.dart';
import 'package:tankste/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Log.init();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('de'), Locale('is')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      assetLoader: const YamlAssetLoader(),
      child: const TanksteApp()));
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
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: const StationMapPage(),
              );
            })));
  }
}
