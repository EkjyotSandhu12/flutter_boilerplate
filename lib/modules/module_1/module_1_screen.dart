import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/api/api_service.dart';
import 'package:flutter_boilerplate/common/helpers/exceptions.dart';
import 'package:flutter_boilerplate/common/services/loggy_service.dart';

@RoutePage()
class Module1Screen extends StatelessWidget {
  const Module1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {},
          child: Text('Api Error Call'),
        ),
      ),
    );
  }
}
