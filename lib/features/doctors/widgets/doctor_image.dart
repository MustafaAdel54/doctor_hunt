import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorImage extends StatelessWidget {
  final String? image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final String fallbackAsset;

  const DoctorImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.fallbackAsset = ImageAssets.popDoctor1,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final img = image?.trim();

    Widget placeholderWidget() => Container(
          width: width,
          height: height,
          color: palette.surfaceAlt,
          alignment: Alignment.center,
          child: Icon(
            Icons.person,
            color: palette.textPlaceholder,
            size: (height != null ? height! * 0.4 : 32).sp,
          ),
        );

    Widget fallbackWidget() => Image.asset(
          fallbackAsset,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => placeholderWidget(),
        );

    Widget imageContent;

    if (img == null || img.isEmpty) {
      imageContent = fallbackWidget();
    } else if (img.startsWith('http://') || img.startsWith('https://')) {
      imageContent = CachedNetworkImage(
        imageUrl: img,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => placeholderWidget(),
        errorWidget: (_, __, ___) => fallbackWidget(),
      );
    } else {
      // Local bundled asset
      imageContent = Image.asset(
        img,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => fallbackWidget(),
      );
    }

    if (shape == BoxShape.circle) {
      return ClipOval(child: imageContent);
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageContent,
      );
    }

    return imageContent;
  }
}
