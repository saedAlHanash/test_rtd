import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import 'kayanee_model.dart';
import 'list_header.dart';
import 'my_button.dart';

bool isAr = true;

class KayaneeWidget extends StatelessWidget {
  const KayaneeWidget({super.key, required this.kayanee});

  final KayaneeParms kayanee;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          ListHeader(headerTitle: kayanee.title),
          SizedBox(
            height: 45.0.h,
            child: DrawableText(
              text: kayanee.description,
              padding: EdgeInsets.symmetric(horizontal: 20.0).r,
              size: 14.0.sp,
              matchParent: true,
              color: Colors.black87,
            ),
          ),
          7.0.verticalSpace,
          Container(
            width: 359.0.w,
            height: 170.0.h,
            margin: EdgeInsets.symmetric(horizontal: 20.0).r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0.r),
              gradient: LinearGradient(
                colors: [kayanee.colorStart.getColor, kayanee.colorEnd.getColor],
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 25.0.h, end: 20.0.w),
                    child: Transform.scale(
                      scale: 1.3,
                      child: ImageMultiType(
                        url: kayanee.image,
                        fit: BoxFit.fill,
                        width: 100.0.w,
                        height: 175.0.h,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Container(
                    padding: EdgeInsets.all(10.0).r,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageMultiType(
                          url: kayanee.logo,
                          height: 35.0.h,

                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsetsDirectional.only(end: 100.0.w),
                          child: DrawableText(
                            text: kayanee.text,
                            color: Colors.white,
                            size: 12.0.sp,
                          ),
                        ),
                        Spacer(),
                        MyButton(
                          onTap: () {},
                          width: 100.0.w,
                          height: 30.0.h,
                          elevation: 0,
                          color: Colors.white,
                          text: kayanee.btn,
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension SplitByLength on String {
  Color get getColor => Color(int.parse('0xFF${replaceAll('#', '')}'));

  List<String> splitByLength1(int length, {bool ignoreEmpty = false}) {
    List<String> pieces = [];

    for (int i = 0; i < this.length; i += length) {
      int offset = i + length;
      String piece = substring(i, offset >= this.length ? this.length : offset);

      if (ignoreEmpty) {
        piece = piece.replaceAll(RegExp(r'\s+'), '');
      }

      pieces.add(piece);
    }
    return pieces;
  }

  String get logLongMessage {
    var r = [];
    var res = '';
    if (length > 800) {
      r = splitByLength1(800);
      for (var e in r) {
        res += '$e\n';
      }
    } else {
      res = this;
    }
    return res;
  }

  bool get canSendToSearch {
    if (isEmpty) false;

    return split(' ').last.length > 2;
  }

  int get numberOnly {
    final regex = RegExp(r'\d+');

    final numbers = regex.allMatches(this).map((match) => match.group(0)).join();

    try {
      return int.parse(numbers);
    } on Exception {
      return 0;
    }
  }

  String get fixPhoneNumber {
    String number = this;

    if (number.startsWith('+')) {
      number = number.substring(1);
    } else if (number.startsWith('00')) {
      number = number.substring(2);
    }

    return number;
  }

  bool get isZero => (num.tryParse(this) ?? 0) == 0;

  String get removeSpace => replaceAll(' ', '');

  num get tryParseOrZero => num.tryParse(this) ?? 0;

  int get tryParseOrZeroInt => int.tryParse(this) ?? 0;

  bool get tryParseBoolOrFalse => toString() == '1' || toString() == 'true';
}
