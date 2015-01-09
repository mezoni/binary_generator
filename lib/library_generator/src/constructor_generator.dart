part of binary_generator.library_generator;

class ConstructorGenerator extends DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _HEADER = ClassLibraryGenerator.HEADER;

  static const String _LIBRARY = ClassLibraryGenerator.LIBRARY;

  static final String _template = '''
/**
 *
 */
{{NAME}}(DynamicLibrary library) {
  if (library == null) {
    throw new ArgumentError.notNull("library");
  }

  library.declare($_HEADER);  
  $_LIBRARY = library;
}
''';

  final BinaryDeclarations declarations;

  final LibraryGeneratorOptions options;

  ConstructorGenerator(this.declarations, this.options) {
    if (declarations == null) {
      throw new ArgumentError.notNull("declarations");
    }

    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    addTemplate(_TEMPLATE, _template);
  }

  String get name => options.name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("NAME", name);
    return block.process();
  }

  String _getName(String name, Set<String> used) {
    if (name != null && !name.isEmpty) {
      if (!used.contains(name)) {
        used.add(name);
        return name;
      }
    }

    var prefix = "arg";
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

  String _getType(TypeSpecification type, String result) {
    if (type is IntegerTypeSpecification) {
      result = "int";
      // } else if (returnType is VoidTypeSpecification) {
      // value = "void";
    } else if (type is StructureTypeSpecification) {
      result = "Map";
    }

    return result;
  }
}
