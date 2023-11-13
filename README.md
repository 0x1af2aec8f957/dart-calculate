![pub](https://img.shields.io/pub/v/calculate)

#### Dart Calculate

> 处理dart double计算精度丢失问题.
> 从V1.0.0开始。库内代码计算使用[dart-decimal](https://github.com/a14n/dart-decimal),本库仅提供`逆波兰表达式`实现。

##### For instance :

```dart
import 'package:calculate';

print(compute('0.1 0.1 *'));
```

#### Usage

- 编辑`pubspec.yaml`文件

```yaml
dependencies:
  calculate: "0.0.4"
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
