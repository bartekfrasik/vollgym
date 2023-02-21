extension DateNameExt on int {
  String get toDayNameShort {
    switch (this) {
      case 1:
        return 'pon';
      case 2:
        return 'wt';
      case 3:
        return 'śr';
      case 4:
        return 'czw';
      case 5:
        return 'pt';
      case 6:
        return 'sob';
      case 7:
        return 'ndz';
      default:
        return '';
    }
  }

  String get toMonthNameShort {
    switch (this) {
      case 1:
        return 'st';
      case 2:
        return 'lut';
      case 3:
        return 'mrz';
      case 4:
        return 'kw';
      case 5:
        return 'maj';
      case 6:
        return 'cz';
      case 7:
        return 'lip';
      case 8:
        return 'sier';
      case 9:
        return 'wrz';
      case 10:
        return 'paź';
      case 11:
        return 'lis';
      case 12:
        return 'gr';
      default:
        return '';
    }
  }
}
