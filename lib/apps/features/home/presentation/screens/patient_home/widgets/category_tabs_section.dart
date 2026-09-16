import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryTabsSection extends StatelessWidget {
  const CategoryTabsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryTab('assets/icons/home/cat_tooth.svg', () {}),
          _buildCategoryTab('assets/icons/home/cat_heart.svg', () {}),
          _buildCategoryTab('assets/icons/home/cat_eye.svg', () {}),
          _buildCategoryTab('assets/icons/home/cat_body.svg', () {}),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        width:
            80, // Approximate width to fit 4 in a row nicely, original Figma group width was 113 for the spacing
        height: 90,
      ),
    );
  }
}
