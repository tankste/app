import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionItem extends StatefulWidget {
  const VersionItem({Key? key}) : super(key: key);

  @override
  VersionItemState createState() => VersionItemState();
}

class VersionItemState extends State<VersionItem> {
  PackageInfo? _packageInfo;

  VersionItemState() {
    _init();
  }

  Future<void> _init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minLeadingWidth: 10,
        leading: const Icon(Icons.info),
        title: const Text("Version"),
        subtitle: Text(
          _packageInfo != null
              ? "${_packageInfo!.appName} v${_packageInfo!.version}+${_packageInfo!.buildNumber}"
              : "",
        ));
  }
}
