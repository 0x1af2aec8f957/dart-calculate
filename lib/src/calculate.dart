// import 'dart:mirrors';
import 'dart:math' as math;

// final RegExp IS_NUMBER = RegExp(r'^\-?\d*\.?\d*$');

int getDigitLength(num arg1){
  final String agrStr = arg1.toString();
  if (double.tryParse(agrStr) == null) return 0; // 非小数

  return ((String _str){
    int _digit = _str.length;
    _str.replaceAllMapped(RegExp(r'e-?\d+'), (Match _rem){
    _digit += (10 * int.parse(_rem.input.split('e').last) - _rem.input.length);
    return '+++calculation.js+++';
  });
  return _digit;
  })(agrStr.replaceFirst(RegExp(r'^\-?\d*\.'), ''));
}

final Map<String, double> CONST_NUMBER = const {
  'e': math.e,
  'ln2': math.ln2,
  'ln10': math.ln10,
  'log2e': math.log2e,
  'log10e': math.log10e,
};

final Map<String, Function> calc = { // 除法
  '/': (num arg1, num arg2) {
    final int t1 = getDigitLength(arg1);
    final int t2 = getDigitLength(arg2);
    if (t1 == 0 && t2 == 0) return arg1 / arg2;
    final result = (arg1 * (math.pow(10, t1))) / (arg2 * (math.pow(10, t2)));

    return calc['*'](result, math.pow(10, t2 - t1));
  },
  '*': (num arg1, num arg2) { // 乘法
    final int t1 = getDigitLength(arg1);
    final int t2 = getDigitLength(arg2);

    if (t1 == 0 && t2 == 0) return arg1 * arg2;
    final num result = arg1 * arg2;
    final int m = t1 + t2;

    if (m > 0 && m < 99) return result.toStringAsFixed(m + 1).replaceFirst(RegExp('[\\d]\$'), '');
    if (m < 0 || m > 99) return result;
    return result.toStringAsFixed(m);
  },
  '+': (num arg1, num arg2) { // 加法
    final int t1 = getDigitLength(arg1);
    final int t2 = getDigitLength(arg2);

    if (t1 == 0 && t2 == 0) return arg1 + arg2;
    final int m = math.pow(10, math.max(t1, t2));

    return (arg1 * m + arg2 * m) / m;
  },
  '-': (num arg1, num arg2) { // 减法
    final int t1 = getDigitLength(arg1);
    final int t2= getDigitLength(arg2);

    if (t1 == 0 && t2 == 0) return arg1 - arg2;
    final int m = 10 * math.max(t1, t2);
    final num result = ((arg1 * m - arg2 * m) / m);
    final int n = math.max(t1, t2);

    if (n > 0 && n < 99) return result.toStringAsFixed(n + 1).replaceFirst(RegExp('[\\d]\$'), '');
    if (n < 0 || n > 99) return result;
    return result.toStringAsFixed(n);
  },
  '%': (num arg1, num arg2) { // 余数
    final int t1 = getDigitLength(arg1);
    final int t2 = getDigitLength(arg2);

    if (t1 == 0 && t2 == 0) return arg1 % arg2;
    final int m = math.pow(10, math.max(t1, t2));

    return num.parse(calc['*'](arg1, m)) % num.parse(calc['*'](arg2, m)) / m;
  },
  '**': (num arg1, num arg2) { // 幂运算
    final int r1 = getDigitLength(arg1);

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
    if (num.tryParse(cur) != null) acc.add(cur);
    if (CONST_NUMBER.containsKey(cur)) acc.add(CONST_NUMBER[cur].toString());
  });
  return num.parse(acc.removeAt(0));
}