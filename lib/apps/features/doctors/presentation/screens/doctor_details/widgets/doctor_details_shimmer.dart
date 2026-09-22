import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DoctorDetailsShimmer extends StatelessWidget {
  const DoctorDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Container(width: 120, height: 20, color: Colors.white),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Card Shimmer
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 30),

          // Stats Row Shimmer
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 30),

          // Services Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 24, color: Colors.white),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Map Shimmer
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
}
