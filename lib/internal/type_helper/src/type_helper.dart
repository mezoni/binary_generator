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

  Type getDartTypeAdvanced(TypeSpecification type, BinaryTypes types, {bool allowBinary: false}) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    if (types != null) {
      try {
        var name = tryGetTypeSpecificationName(type);
        if (name != null) {
          return getDartTypeForBinaryType(types[name], allowBinary: allowBinary);
        }

      } catch (e) {
      }
    }

    return getDartTypeForTypeSpecification(type);
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
    if (type is IntegerTypeSpecification) {
      result = int;
    } else if (type is FloatTypeSpecification) {
      result = double;
    } else if (type is StructureTypeSpecification) {
      result = Map;
    } else if (type is EnumTypeSpecification) {
      result = int;
    } else if (type is ArrayTypeSpecification) {
      result = List;
    } else if (type is DefinedTypeSpecification) {
      switch (type.name) {
        case "intptr_t":
        case "size_t":
          result = int;
          break;
      }
    }

    return result;
  }

  bool isReservedWord(String name) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    return _reservedWords.contains(name);
  }

  String tryGetTypeSpecificationName(TypeSpecification type) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    String result;
    if (type is DefinedTypeSpecification) {
      result = type.name;
    } else if (type is IntegerTypeSpecification) {
      result = type.name;
    } else if (type is FloatingPointType) {
      result = type.name;
    } else if (type is StructureTypeSpecification) {
      StructureTypeSpecification structureType = type;
      var taggedType = structureType.taggedType;
      if (taggedType.tag != null) {
        result = taggedType.name;
      }

    } else if (type is EnumTypeSpecification) {
      EnumTypeSpecification structureType = type;
      var taggedType = structureType.taggedType;
      if (taggedType.tag != null) {
        result = taggedType.name;
      }
    } else if (type is TaggedTypeSpecification) {
      result = type.name;
    }

    return result;
  }
}
