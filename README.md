binary_generator
=====

Binary generator is a tool (set of generators) that allows generate a development code for the binary interop and binary types.

Version: 0.0.17

[Donate to binary generator for dart](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=binary.dart@gmail.com&item_name=binary.generator.for.dart&currency_code=USD)

**Interrelated (binary) software**

- [Binary declarations](https://pub.dartlang.org/packages/binary_declarations)
- [Binary generator](https://pub.dartlang.org/packages/binary_generator)
- [Binary interop](https://pub.dartlang.org/packages/binary_interop)
- [Binary marshalling](https://pub.dartlang.org/packages/binary_marshalling)
- [Binary types](https://pub.dartlang.org/packages/binary_types)

**Features**

- Generating the binary types (types generator)
- Generating the wrappers for the dynamic loadable libraries (library generator)

**Planned features**

- Generating the binary classes, wrappers over the binary structures
- Generating the converters of the end-user classes from binary classes and vice versa
- Generating the library loaders for different platform from distributed binary packages

**Types generator**

The "types generator" generates the dart library with a class  inherited from the `BinaryTypes` with a getters created from `typedef` C types.

Example:

Declaration (my_types.txt):

```c
typedef char CHAR;
typedef struct info {
  int i;
} INFO;

```

Generation:

```
$ dart binary_generator types --library my_package.my_types my_types.txt
```

Produced result:

```dart
// This code was generated by a tool.
// Processing tool available at https://github.com/mezoni/binary_generator

library my_package.my_types;

import "package:binary_types/binary_types.dart";

class MyTypes extends BinaryTypes {
  String _header = '''
typedef char CHAR;
typedef struct info {
  int i;
} INFO;
''';    
      
  /**
   *
   */
  MyTypes({DataModel dataModel, BinaryTypes types, Map<String, String> environment}) : super(dataModel: dataModel, types: types) {
    var helper = new BinaryTypeHelper(this);
    helper.declare(_header, environment: environment);  
  }
  
  /**
   * typedef char CHAR
   */
  Int8Type get CHAR => this["CHAR"];
  
  /**
   * typedef struct info INFO
   */
  StructType get INFO => this["INFO"];
  
}
```

**Library generator*

Documentation comming soon...
