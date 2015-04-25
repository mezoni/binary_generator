part of binary_generator.internal.type_converter;

class TypeHelper {
  static final Set<String> _reservedWords = new Set<String>.from([
    "bool",
    "int",
    "double",
    "bool",
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
      case BinaryKind.ARRAY:
        result = "List";
        break;
      case BinaryKind.DOUBLE:
      case BinaryKind.FLOAT:
        result = "double";
        break;
      case BinaryKind.BOOL:
        result = "bool";
        break;
      case BinaryKind.ENUM:
      case BinaryKind.SINT16:
      case BinaryKind.SINT32:
      case BinaryKind.SINT64:
      case BinaryKind.SINT8:
      case BinaryKind.UINT16:
      case BinaryKind.UINT32:
      case BinaryKind.UINT64:
      case BinaryKind.UINT8:
        result = "int";
        break;
      case BinaryKind.POINTER:
        result = "BinaryData";
        break;
      case BinaryKind.STRUCT:
        result = "Map";
        break;
      case BinaryKind.VOID:
        result = "void";
        break;
      default:
        break;
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
