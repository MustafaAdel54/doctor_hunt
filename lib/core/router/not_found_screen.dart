import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, this.error});
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          t.common.noData,
          style: context.medium16TextMain,
        ),
      ),
    );
  }
}
