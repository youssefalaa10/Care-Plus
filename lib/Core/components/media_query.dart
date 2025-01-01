import 'package:flutter/material.dart';

class CustomMQ {
  final BuildContext context;
  CustomMQ(this.context);

  double width(double factor) =>
      MediaQuery.of(context).size.width * (factor / 100);
  double height(double factor) =>
      MediaQuery.of(context).size.height * (factor / 100);
}