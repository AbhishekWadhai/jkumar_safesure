import 'package:flutter/material.dart';

Color getRiskColor(String riskLevel) {
  switch (riskLevel) {
    case 'Low':
      return Colors.green;
    case 'Medium':
      return Colors.amber;
    case 'High':
      return Colors.orange;
    case 'Critical':
      return Colors.red;
    default:
      return Colors.grey; // fallback color
  }
}
