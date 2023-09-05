import 'package:flutter/material.dart';

class HomeTvPage extends StatelessWidget {
  static const ROUTE_NAME = '/tv';

  const HomeTvPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ditonton"),
        ),
        body: Center(
          child: Text("This is TV"),
        ),
      ),
    );
  }
}
