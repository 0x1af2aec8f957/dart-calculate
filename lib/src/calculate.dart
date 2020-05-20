// import 'dart:mirrors';
import 'dart:math' as math;

// final RegExp IS_NUMBER = RegExp(r'^\-?\d*\.?\d*$');

int _getDigitLength(num arg1){ // 获取精度
  final String agrStr = arg1.toString();
  if (double.tryParse(agrStr) == null) return 0; // 非小数

  return ((String _str){
    int _digit = _str.length;
    _str.replaceAllMapped(RegExp(r'e-?\d+'), (Match _rem){
      _digit += (10 * int.parse(_rem.input.split('e').last) - _rem.input.length);
      return '+++calculation.dart+++';
    });
    return _digit;
  })(agrStr.replaceFirst(RegExp(r'^\-?\d*\.'), ''));
}

String _precisionFix(num _num, num digit) { // 精度修复
  final int _digit = _getDigitLength(_num); // 处理科学计数法

  if (_digit < digit) {
    final diffDigit = digit - _digit;
    return '$_num${[for (int i; i < diffDigit; i ++) 0].join('')}';
  }

  return RegExp('^\\-?\\d*\\.?\\d{1,$digit}').stringMatch(_num.toString());
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
    final int t1 = _getDigitLength(arg1);
    final int t2 = _getDigitLength(arg2);
    if (t1 == 0 && t2 == 0) return arg1 / arg2;
    final result = (arg1 * (math.pow(10, t1))) / (arg2 * (math.pow(10, t2)));

    return calc['*'](result, math.pow(10, t2 - t1));
  },
  '*': (num arg1, num arg2) { // 乘法
    final int t1 = _getDigitLength(arg1);
    final int t2 = _getDigitLength(arg2);

    if (t1 == 0 && t2 == 0) return arg1 * arg2;
    final num result = arg1 * arg2;
    final int m = t1 + t2;

    return _precisionFix(result, m);
  },
  '+': (num arg1, num arg2) { // 加法
    final int t1 = _getDigitLength(arg1);
    final int t2 = _getDigitLength(arg2);

    if (t1 == 0 && t2 == 0) return arg1 + arg2;
    final int m = math.pow(10, math.max(t1, t2));

    return (arg1 * m + arg2 * m) / m;
  },
  '-': (num arg1, num arg2) { // 减法
    final int t1 = _getDigitLength(arg1);
    final int t2= _getDigitLength(arg2);

    if (t1 == 0 && t2 == 0) return arg1 - arg2;
    final int m = 10 * math.max(t1, t2);
    final num result = ((arg1 * m - arg2 * m) / m);
    final int n = math.max(t1, t2);

    return _precisionFix(result, n);
  },
  '%': (num arg1, num arg2) { // 余数
    final int t1 = _getDigitLength(arg1);
    final int t2 = _getDigitLength(arg2);

    if (t1 == 0 && t2 == 0) return arg1 % arg2;
    final int m = math.pow(10, math.max(t1, t2));

    return num.parse(calc['*'](arg1, m)) % num.parse(calc['*'](arg2, m)) / m;
  },
  '**': (num arg1, num arg2) { // 幂运算
    final int r1 = _getDigitLength(arg1);
    return _precisionFix(math.pow(arg1, arg2), calc['*'](r1, arg2));
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