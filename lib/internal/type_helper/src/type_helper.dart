part of binary_generator.internal.type_converter;

class TypeHelper {
  static final Set<String> _reservedWords = new Set<String>.from(["assert", "break", "case", "catch", "class", "const", "continue", "default", "do", "else", "enum", "extends", "false", "ﬁnal", "ﬁnally", "for", "if", "in", "is", "new", "null", "rethrow", "return", "super", "switch", "this", "throw", "true", "try", "var", "void", "while", "with"]);

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

  Type getDartTypeForBinaryType(BinaryType type, {bool allowBinary: false}) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    Type result;
    switch (type.kind) {
      case BinaryKinds.ARRAY:
        result = List;
        break;
      case BinaryKinds.DOUBLE:
      case BinaryKinds.FLOAT:
        result = double;
        break;
      case BinaryKinds.ENUM:
        result = int;
        break;
      case BinaryKinds.SINT16:
      case BinaryKinds.SINT32:
      case BinaryKinds.SINT64:
      case BinaryKinds.SINT8:
      case BinaryKinds.UINT16:
      case BinaryKinds.UINT32:
      case BinaryKinds.UINT64:
      case BinaryKinds.UINT8:
        result = int;
        break;
      case BinaryKinds.POINTER:
        if (allowBinary) {
          result = BinaryType;
        }

        break;

      case BinaryKinds.STRUCT:
        result = Map;
    }

    return result;
  }

  Type getDartTypeForTypeSpecification(TypeSpecification type) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    Type result;
    switch (type.typeKind) {
      case TypeSpecificationKind.ARRAY:
        result = List;
        break;
      case TypeSpecificationKind.DEFINED:
        break;
      case TypeSpecificationKind.ENUM:
        result = int;
        break;
      case TypeSpecificationKind.FLOAT:
        result = double;
        break;
      case TypeSpecificationKind.INTEGER:
        result = int;
        break;
      case TypeSpecificationKind.STRUCTURE:
        result = Map;
        break;
    }

    return result;
  }

  String getTypeSpecificationName(TypeSpecification type) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    String result;
    switch (type.typeKind) {
      case TypeSpecificationKind.DEFINED:
      case TypeSpecificationKind.FLOAT:
      case TypeSpecificationKind.INTEGER:
      case TypeSpecificationKind.TAGGED:
        result = type.name;
        break;
      case TypeSpecificationKind.ENUM:
        var structureType = type as EnumTypeSpecification;
        var taggedType = structureType.taggedType;
        if (taggedType.tag != null) {
          result = taggedType.name;
        }

        break;
      case TypeSpecificationKind.STRUCTURE:
        var structureType = type as StructureTypeSpecification;
        var taggedType = structureType.taggedType;
        if (taggedType.tag != null) {
          result = taggedType.name;
        }

        break;
    }

    return result;
  }

  bool isReservedWord(String name) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    return _reservedWords.contains(name);
  }

  Type tryGetDartTypeAdvanced(TypeSpecification type, BinaryTypes types, {bool allowBinary: false}) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    if (types != null) {
      try {
        var name = getTypeSpecificationName(type);
        if (name != null) {
          return getDartTypeForBinaryType(types[name], allowBinary: allowBinary);
        }

      } catch (e) {
      }
    }

    return getDartTypeForTypeSpecification(type);
  }
}
