#### Dart Calculate

> 处理dart双精度计算丢失问题.

##### For instance :

```dart
import 'package:calculate';

print(compute('0.1 0.1 *'));
```

#### Usage

- 编辑`pubspec.yaml`文件

```yaml
dependencies:
  calculate: "0.0.2"
```

- 获取包

```basic
pub get
```

- 引入你的项目

```dart
import 'package:calculate/calculate.dart';
```

###### 如果你不习惯逆波兰表达式，推荐使用[dart-decimal](https://github.com/a14n/dart-decimal)处理精度问题。

#### 参考链接

1. [Reverse Polish notation (RPN)](https://en.wikipedia.org/wiki/Reverse_Polish_notation).
2. [Shunting-yard algorithm](https://en.wikipedia.org/wiki/Shunting-yard_algorithm)