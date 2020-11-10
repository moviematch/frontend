/// From a time in minutes, displays (HHhii) (or (iimins) if less than 60 minutes)
String runtimeDisplay(int runtime) {
  if (runtime == null || runtime == 0) return '';
  int hrs = (runtime / 60).floor();
  int mins = runtime - hrs * 60;
  if (hrs <= 0) return '(' + mins.toString() + 'mins)';
  return '(' +
      hrs.toString() +
      'h' +
      (mins < 10 ? '0' : '') +
      mins.toString() +
      ')';
}

/// Joins a list of strings with commas, with the last element having an added 'and'.
String naturalJoin(List<String> items) {
  String ret = '';
  for (int i = 0; i < items.length; ++i) {
    if (i > 0) {
      if (i == items.length - 1) {
        if (i > 2) ret += ',';
        ret += ' and ';
      } else {
        ret += ', ';
      }
    }
    ret += items[i];
  }
  return ret;
}
