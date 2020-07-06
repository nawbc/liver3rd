import 'package:liver3rd/app/widget/icons.dart';

class ForumUtils {
  static matchGame(int id) {
    switch (id) {
      case 1:
        return '崩坏3';
      case 2:
        return '原神';
      default:
        return '';
    }
  }

  static dynamic selectGender(int num, {double width = 15}) {
    switch (num) {
      case 0:
        return CustomIcons.unknown(width: width);
      case 1:
        return CustomIcons.male(width: width);
      case 2:
        return CustomIcons.female(width: width);
    }
  }
}
