import 'package:collection/collection.dart';
import 'package:core/log/log.dart';
import 'package:flutter/material.dart';

class LogPage extends StatelessWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Logs"),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
               scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
               scrollDirection: Axis.vertical,
                child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(memoryOutput.buffer
                    .map((log) => log.lines)
                    .flattened
                    .join("\n")))))));
  }
}
