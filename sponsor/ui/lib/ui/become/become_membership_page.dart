import 'package:flutter/material.dart';

class BecomeMembershipPage extends StatelessWidget {
  const BecomeMembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Icon(
              Icons.favorite,
              color: Theme.of(context).primaryColor,
              size: 128,
            ),
            Text("Werde tankste! Unterstützer"),
            Text("Werde tankste! Unterstützer"),
            FilledButton(onPressed: () {}, child: Text("5,99€ / Jahr")),
            FilledButton(onPressed: () {}, child: Text("0,99€ / Monat")),
          ],
        ),
      ),
    );
  }
}
