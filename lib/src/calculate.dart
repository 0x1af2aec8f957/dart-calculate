// import 'dart:mirrors';
import 'dart:math' as math;

final RegExp IS_NUMBER = RegExp(r'^\-?\d*\.?\d*$');

final Map<String, double> CONST_NUMBER = const {
  'e': math.e,
  'ln2': math.ln2,
  'ln10': math.ln10,
  'log2e': math.log2e,
  'log10e': math.log10e,
};

final Map<String, Function> calc = { // 除法
  '/': (num arg1, num arg2) {
    num t1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    num t2 = '$arg2'.split('.').length == 2 ? '$arg2'.split('.')[1].length : 0;
    final r1 = num.parse('$arg1'.replaceFirst('.', ''));
    final r2 = num.parse('$arg2'.replaceFirst('.', ''));

    return calc['*']((r1 / r2), math.pow(10, t2 - t1));
  },
  '*': (num arg1, num arg2) { // 乘法
    final s1 = '$arg1';
    final s2 = '$arg2';
    num m = s1.split('.').length == 2 ? s1.split('.')[1].length : 0;
    m += s2.split('.').length == 2 ? s2.split('.')[1].length : 0;
    return num.parse(s1.replaceFirst('.', '')) * num.parse(s2.replaceFirst('.', '')) / math.pow(10, m);
  },
  '+': (num arg1, num arg2) { // 加法
    num r1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    num r2 = '$arg2'.split('.').length == 2 ? '$arg2'.split('.')[1].length : 0;
    final m = math.pow(10, math.max(r1, r2));

    return (arg1 * m + arg2 * m) / m;
  },
  '-': (num arg1, num arg2) { // 减法
    num r1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    num r2 = '$arg2'.split('.').length == 2 ? '$arg2'.split('.')[1].length : 0;
    final m = 10 * math.max(r1, r2);

    return ((arg1 * m - arg2 * m) / m).toStringAsFixed(math.max(r1, r2));
  },
  '%': (num arg1, num arg2) { // 余数
    num r1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    num r2 = '$arg2'.split('.').length == 2 ? '$arg2'.split('.')[1].length : 0;
    final m = math.pow(10, math.max(r1, r2));
    return calc['*'](arg1, m) % calc['*'](arg2, m) / m;
  },
  '**': (num arg1, num arg2) { // 幂运算
    num r1 = '$arg1'.split('.').length == 2 ? '$arg1'.split('.')[1].length : 0;
    return math.pow(arg1, arg2).toStringAsFixed(calc['*'](r1, arg2));
  },
  'atan2': math.atan2,
  'max': math.max,
  'min': math.min,
};

num compute(String exStr) {
  final acc = [];

  exStr.split(' ').forEach((cur) {
    if (calc.containsKey(cur)) acc.add(Function.apply(calc[cur], [num.parse(acc.removeLast()), num.parse(acc.removeLast())].reversed.toList()).toString());
    if (IS_NUMBER.hasMatch(cur)) acc.add(cur);
    if (CONST_NUMBER.containsKey(cur)) acc.add(CONST_NUMBER[cur].toString());
  });
  return num.parse(acc.removeAt(0));
}