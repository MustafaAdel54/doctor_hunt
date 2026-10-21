import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteDoctorsSearchBar extends StatefulWidget {
  const FavouriteDoctorsSearchBar({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  State<FavouriteDoctorsSearchBar> createState() =>
      _FavouriteDoctorsSearchBarState();
}

class _FavouriteDoctorsSearchBarState extends State<FavouriteDoctorsSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      height: 54.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 30.r,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: context.regular14TextMain,
        decoration: InputDecoration(
          hintText: t.doctors.searchFavouritesHint,
          hintStyle: context.regular14TextSub,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: palette.textPlaceholder,
            size: 22.r,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: palette.textPlaceholder,
                    size: 18.r,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}
