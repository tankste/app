import 'package:flutter/material.dart';
import 'package:station/model/marker_model.dart';

Color getMarkerStateColor(PriceState priceState) {
  switch (priceState) {
    case PriceState.expensive:
      return Colors.red;
    case PriceState.medium:
      return Colors.orange;
    case PriceState.cheap:
      return Colors.green;
    case PriceState.unknown:
    default:
      return Colors.grey;
  }
}
