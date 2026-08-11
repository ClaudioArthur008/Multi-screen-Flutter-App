import 'package:flutter/material.dart';
import 'package:flutter_app/models/rental/rental_model.dart';

class RentalStatusChip extends StatelessWidget {
  final RentalStatus value;

  const RentalStatusChip({super.key, required this.value});

  String get label {
    switch (value) {
      case RentalStatus.approved:
        return 'Approuvé';
      case RentalStatus.declined:
        return 'refusé';
      case RentalStatus.pending:
        return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
