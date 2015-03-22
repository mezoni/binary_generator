part of binary_generator.internal.type_converter;

class TypeHelper {
  static final Set<String> _reservedWords = new Set<String>.from([
    "assert",
    "break",
    "case",
    "catch",
    "class",
    "const",
    "continue",
    "default",
    "do",
    "else",
    "enum",
    "extends",
    "false",
    "ﬁnal",
    "ﬁnally",
    "for",
    "if",
    "in",
    "is",
    "new",
    "null",
    "rethrow",
    "return",
    "super",
    "switch",
    "this",
    "throw",
    "true",
    "try",
    "var",
    "void",
    "while",
    "with"
  ]);

  String createName(String name, Set<String> used, {String prefix}) {
    if (name != null && !name.isEmpty) {
      if (!used.contains(name) && !_reservedWords.contains(name)) {
        used.add(name);
        return name;
      }
    }

    if (prefix == null) {
      prefix = name;
    }

    var index = 0;
    while (true) {
      name = "$prefix$index";
      index++;
      if (!used.contains(name)) {
        used.add(name);
        return name;
      }
    }
  }

  String getTypeOfValueForBinaryType(BinaryType type) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    String result;
    switch (type.kind) {
      case BinaryKinds.ARRAY:
        result = "List";
        break;
      case BinaryKinds.DOUBLE:
      case BinaryKinds.FLOAT:
        result = "double";
        break;
      case BinaryKinds.BOOL:
        result = "bool";
        break;
      case BinaryKinds.ENUM:
      case BinaryKinds.SINT16:
      case BinaryKinds.SINT32:
      case BinaryKinds.SINT64:
      case BinaryKinds.SINT8:
      case BinaryKinds.UINT16:
      case BinaryKinds.UINT32:
      case BinaryKinds.UINT64:
      case BinaryKinds.UINT8:
        result = "int";
        break;
      case BinaryKinds.POINTER:
        result = "BinaryData";
        break;
      case BinaryKinds.STRUCT:
        result = "Map";
        break;
      case BinaryKinds.VOID:
        result = "void";
    }

    return result;
  }

  String getTypeOfValueForTypeSpecification(TypeSpecification type) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    String result;
    switch (type.typeKind) {
      case TypeSpecificationKind.BOOL:
        result = "bool";
        break;
      case TypeSpecificationKind.ENUM:
        result = "int";
        break;
      case TypeSpecificationKind.STRUCTURE:
        result = "Map";
        break;
      case TypeSpecificationKind.VOID:
        result = "void";
        break;
    }

    return result;
  }

  String getTypeSpecificationName(TypeSpecification type) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    return type.name;
  }

  bool isReservedWord(String name) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    return _reservedWords.contains(name);
  }

  String tryGetTypeOfValueForType(TypeSpecification type, BinaryTypes types) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    if (types != null) {
      var name = getTypeSpecificationName(type);
      if (name != null) {
        return getTypeOfValueForBinaryType(types[name]);
      }
    }

    return getTypeOfValueForTypeSpecification(type);
  }
}
