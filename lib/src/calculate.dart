// import 'dart:mirrors';
import 'dart:math' as Math;

final RegExp isNumber = new RegExp(r'^\-?\d*\.?\d*$');

final Map<String, double> consNumber = const {
  'e': Math.e,
  'ln2': Math.ln2,
  'ln10': Math.ln10,
  'log2e': Math.log2e,
  'log10e': Math.log10e,
};

final Map<String, Function> calc = { // 除法
  '/': (num arg1, num arg2) {
    num t1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    num t2 = '$arg2'.split('.').length == 2 ? '$arg2'.split('.')[1].length : 0;
    num r1 = num.parse('$arg1'.replaceFirst('.', ''));
    num r2 = num.parse('$arg2'.replaceFirst('.', ''));

    return calc['*']((r1 / r2), Math.pow(10, t2 - t1));
  },
  '*': (num arg1, num arg2) { // 乘法
    String s1 = '$arg1';
    String s2 = '$arg2';
    num m = s1.split('.').length == 2 ? s1.split('.')[1].length : 0;
    m += s2.split('.').length == 2 ? s2.split('.')[1].length : 0;
    return num.parse(s1.replaceFirst('.', '')) * num.parse(s2.replaceFirst('.', '')) / Math.pow(10, m);
  },
  '+': (num arg1, num arg2) { // 加法
    num r1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    num r2 = '$arg2'.split('.').length == 2 ? '$arg2'.split('.')[1].length : 0;
    num m = Math.pow(10, Math.max(r1, r2));

    return (arg1 * m + arg2 * m) / m;
  },
  '-': (num arg1, num arg2) { // 减法
    num r1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    num r2 = '$arg2'.split('.').length == 2 ? '$arg2'.split('.')[1].length : 0;
    num m = 10 * Math.max(r1, r2);

    return ((arg1 * m - arg2 * m) / m).toStringAsFixed(Math.max(r1, r2));
  },
  '%': (num arg1, num arg2) { // 余数
    num r1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    num r2 = '$arg2'.split('.').length == 2 ? '$arg2'.split('.')[1].length : 0;
    num m = Math.pow(10, Math.max(r1, r2));
    return calc['*'](arg1, m) % calc['*'](arg2, m) / m;
  },
  '**': (num arg1, num arg2) { // 幂运算
    num r1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    return Math.pow(arg1, arg2).toStringAsFixed(calc['*'](r1, arg2));
  },
  'atan2': Math.atan2,
  'max': Math.max,
  'min': Math.min,
};

num compute(String exStr) {
  List<String> acc = [];

  exStr.split(' ').forEach((cur) {
    if (calc.containsKey(cur)) acc.add(Function.apply(calc[cur], [num.parse(acc.removeLast()), num.parse(acc.removeLast())].reversed.toList()).toString());
    if (isNumber.hasMatch(cur)) acc.add(cur);
    if (consNumber.containsKey(cur)) acc.add(consNumber[cur].toString());
  });
  return num.parse(acc.removeAt(0));
}