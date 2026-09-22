import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorDetailsHeader extends StatelessWidget {
  const DoctorDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.black54,
              ),
            ),
          ),
          // Title
          Text(
            'Doctor Details',
            style: context.medium18.copyWith(color: context.palette.textMain),
          ),
          // Search icon
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: const Icon(Icons.search, size: 28, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
