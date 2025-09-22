import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ComplaintStatus {
  solved, // 해결됨
  solving, // 해결중
  waiting; // 대기중

  String get displayName {
    switch (this) {
      case ComplaintStatus.solved:
        return '해결완료';
      case ComplaintStatus.solving:
        return '처리중';
      case ComplaintStatus.waiting:
        return '접수완료';
    }
  }

  Widget get icon {
    switch (this) {
      case ComplaintStatus.solved:
        return SvgPicture.asset('assets/icons/State1.svg');
      case ComplaintStatus.solving:
        return SvgPicture.asset('assets/icons/State2.svg');
      case ComplaintStatus.waiting:
        return SvgPicture.asset('assets/icons/State3.svg');
    }
  }

  static ComplaintStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'solved':
        return ComplaintStatus.solved;
      case 'solving':
        return ComplaintStatus.solving;
      case 'waiting':
        return ComplaintStatus.waiting;
      default:
        return ComplaintStatus.waiting;
    }
  }

  String toJson() => name;

  static ComplaintStatus fromJson(String json) => fromString(json);
}
