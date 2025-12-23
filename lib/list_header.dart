import 'package:drawable_text/drawable_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_multi_type/image_multi_type.dart';

import 'app_color_manager.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({super.key, required this.headerTitle, this.seeAllFunction});

  final String headerTitle;
  final Function()? seeAllFunction;

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      text: headerTitle,
      color: AppColorManager.mainColor,
      size: 18.sp,
      padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 7.0).r,
      fontWeight: .bold,
      matchParent: true,
      drawableEnd: seeAllFunction != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0).r,
              decoration: BoxDecoration(
                color: AppColorManager.mainColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.0.r),
              ),
              child: InkWell(
                onTap: seeAllFunction,
                child: DrawableText(
                  text: 'see All',
                  size: 12.0.sp,
                  fontWeight: .bold,
                  drawableAlin: DrawableAlin.withText,
                  color: AppColorManager.mainColor,
                  drawableEnd: ImageMultiType(
                    url: Icons.arrow_forward_ios,
                    color: AppColorManager.mainColor,
                    height: 12.0.sp,
                    width: 12.0.sp,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
