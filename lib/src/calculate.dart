// import 'dart:mirrors';
import 'dart:math' as math;

// final RegExp IS_NUMBER = RegExp(r'^\-?\d*\.?\d*$');
class CustomNumber {
  final num instance;
  const CustomNumber(this.instance);

  /// 获取真实的数字（字符串）
  String get _str => num.tryParse(this.toString())?.toString() ?? '';
  /// 获取小数位数
  int get digit {
    final String strDigit = _str.replaceFirst(RegExp(r'^\-?\d*\.?'), ''); // 排除整数部分
    int _digit = strDigit.length;

    strDigit.replaceAllMapped(RegExp(r'e-?\d+'), (Match _rem){ // 处理科学记数法
      _digit += (10 * int.parse(_rem.input.split('e').last) - _rem.input.length);
      return '+++calculation.dart+++';
    });

    return _digit;
  }

  /// 精度修复
  String precisionFix(int _digit) {
    final int decimal = digit; // 实际已有精度
    if (decimal < _digit) {
      final diffDigit = digit - decimal;
      return '${this.instance}${[for (int i = 0; i < diffDigit; i ++) 0].join('')}';
    }

    return RegExp('^\\-?\\d*\\.?\\d{1,$_digit}').stringMatch(_str) ?? 0.toString();
  }

  /// 非运算类
  double atan2(num _number) => math.atan2(instance, _number);
  num max(num _number) => math.max(instance, _number);
  num min(num _number) => math.min(instance, _number);

  /// 常量
  static double get e => math.e;
  static double get ln2 => math.ln2;
  static double get ln10 => math.ln10;
  static double get log2e => math.log2e;
  static double get log10e => math.log10e;

  @override  String toString() => this.instance.toStringAsFixed(20);
  
  @override
  noSuchMethod(Invocation invocation) => null;
}

/// 扩展实际运算符
extension _numberExtension on CustomNumber {
  num operator + (CustomNumber _number){ // 加法
    final int t1 = digit;
    final int t2 = _number.digit;

    if (t1 == 0 && t2 == 0) return this.instance + _number.instance;
    final int m = math.pow(10, math.max(t1, t2));

    return ((this.instance * m) + (_number.instance * m)) / m;
  }

  num operator - (CustomNumber _number){ // 减法
    final int t1 = digit;
    final int t2= _number.digit;

    if (t1 == 0 && t2 == 0) return this.instance - _number.instance;
    final int m = 10 * math.max(t1, t2);
    final CustomNumber result = CustomNumber(((this.instance * m) - (_number.instance * m)) / m);
    final int n = math.max(t1, t2);

    return num.parse(result.precisionFix(n));
  }

  @override
  num operator * (CustomNumber _number){ // 乘法
    final int t1 = digit;
    final int t2 = _number.digit;

    if (t1 == 0 && t2 == 0) return this.instance * _number.instance;
    final CustomNumber result = CustomNumber(this.instance * _number.instance);
    final int m = t1 + t2;

    return num.parse(result.precisionFix(m));
  }

  @override
  num operator / (CustomNumber _number){ // 除法
    final int t1 = digit;
    final int t2 = _number.digit;
    if (t1 == 0 && t2 == 0) return this.instance / _number.instance;
    final CustomNumber result = CustomNumber(this.instance * (math.pow(10, t1)) / (_number.instance * (math.pow(10, t2))));

    return result.instance * math.pow(10, t2 - t1);
  }

  @override
  num operator % (CustomNumber _number){ // 取余
    final int t1 = digit;
    final int t2 = _number.digit;

    if (t1 == 0 && t2 == 0) return this.instance % _number.instance;
    final int m = math.pow(10, math.max(t1, t2));

    return (this.instance * m) % (_number.instance * m) / m;
  }

  @override
  num pow (int _number){ // 幂运算
    final int r1 = digit;
    final CustomNumber result = CustomNumber(math.pow(this.instance, _number));
    return num.parse(result.precisionFix(r1 * _number));
  }
}

final Map<String, double> CONST_NUMBER = {
  'e': CustomNumber.e,
  'ln2': CustomNumber.ln2,
  'ln10': CustomNumber.ln10,
  'log2e': CustomNumber.log2e,
  'log10e': CustomNumber.log10e,
};


final Map<String, Function> calc = {
  '/': (num arg1, num arg2) => CustomNumber(arg1) / CustomNumber(arg2), // 除法
  '*': (num arg1, num arg2) => CustomNumber(arg1) * CustomNumber(arg2), // 乘法
  '+': (num arg1, num arg2) => CustomNumber(arg1) + CustomNumber(arg2), // 加法
  '-': (num arg1, num arg2) => CustomNumber(arg1) - CustomNumber(arg2), // 减法
  '%': (num arg1, num arg2) => CustomNumber(arg1) % CustomNumber(arg2), // 余数
  '**': (num arg1, int arg2) => CustomNumber(arg1).pow(arg2), // 幂运算
  'atan2': (num arg1, num arg2) => CustomNumber(arg1).atan2(arg2),
  'max': (num arg1, num arg2) => CustomNumber(arg1).max(arg2),
  'min': (num arg1, num arg2) => CustomNumber(arg1).min(arg2),
};

num compute(String exStr) { // 逆波兰表达式计算
  final List<String> acc = [];

  exStr.split(' ').forEach((cur) {
    if (calc.containsKey(cur)) acc.add(Function.apply(calc[cur], [num.parse(acc.removeLast()), num.parse(acc.removeLast())].reversed.toList()).toString());
    if (num.tryParse(cur) != null) acc.add(cur);
    if (CONST_NUMBER.containsKey(cur)) acc.add(CONST_NUMBER[cur].toString());
  });
  return num.parse(acc.removeAt(0));
}
