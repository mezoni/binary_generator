part of binary_generator.library_generator;

class GetterVariableGenerator extends DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _LIBRARY = ClassLibraryGenerator.LIBRARY;

  static final String _template = '''
/**
 * {{COMMENT}}
 */
{{BINARY_TYPE}} get {{NAME}} => $_LIBRARY.variable({{SYMBOL_NAME}});
''';

  final ClassLibraryGenerator classGenerator;

  final Variable variable;

  String _name;

  String _symbolName;

  TypeHelper _typeHelper;

  GetterVariableGenerator(this.classGenerator, this.variable) {
    if (classGenerator == null) {
      throw new ArgumentError.notNull("classGenerator");
    }

    if (variable == null) {
      throw new ArgumentError.notNull("variable");
    }

    _symbolName = variable.name;
    _name = _symbolName;
    if (_name.startsWith("_")) {
      _name = "\$$name";
    }

    addTemplate(_TEMPLATE, _template);
  }

  String get name => _name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var binaryType = variable.type;
    block.assign("BINARY_TYPE", binaryType.runtimeType.toString());
    block.assign("COMMENT", binaryType.typedefName);
    block.assign("NAME", name);
    block.assign("SYMBOL_NAME", _symbolName);
    return block.process();
  }
}
