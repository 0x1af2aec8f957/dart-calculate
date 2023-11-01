// import 'dart:mirrors';
import 'dart:math' as math;
import 'package:decimal/decimal.dart';

final Map<String, double> CONST_NUMBER = {
  'e': math.e,
  'ln2': math.ln2,
  'ln10': math.ln10,
  'log2e': math.log2e,
  'log10e': math.log10e,
};


final Map<String, Function> calc = {
  '/': (String arg1, String arg2) => Decimal.parse(arg1) / Decimal.parse(arg2), // 除法
  '*': (String arg1, String arg2) => Decimal.parse(arg1) * Decimal.parse(arg2), // 乘法
  '+': (String arg1, String arg2) => Decimal.parse(arg1) + Decimal.parse(arg2), // 加法
  '-': (String arg1, String arg2) => Decimal.parse(arg1) - Decimal.parse(arg2), // 减法
  '%': (String arg1, String arg2) => Decimal.parse(arg1) % Decimal.parse(arg2), // 余数
  '**': (String arg1, String arg2) => Decimal.parse(arg1).pow(int.tryParse(arg2)!), // 幂运算
  'atan2': (String arg1, String arg2) => math.atan2(num.tryParse(arg1)!, num.tryParse(arg2)!),
  'max': (String arg1, String arg2) => math.max(num.tryParse(arg1)!, num.tryParse(arg2)!),
  'min': (String arg1, String arg2) => math.min(num.tryParse(arg1)!, num.tryParse(arg2)!),
};

num compute(String exStr) { // 逆波兰表达式计算
  final List<String> acc = [];

  exStr.split(' ').forEach((cur) {
    if (calc.containsKey(cur)) acc.add(Function.apply(calc[cur]!, [acc.removeLast(), acc.removeLast()].reversed.toList()).toString());
    if (num.tryParse(cur) != null) acc.add(cur);
    if (CONST_NUMBER.containsKey(cur)) acc.add(CONST_NUMBER[cur].toString());
  });
  return num.parse(acc.removeAt(0));
}
