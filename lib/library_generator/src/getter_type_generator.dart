part of binary_generator.library_generator;

class GetterTypeGenerator extends DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static final String _template = '''
/**
 * {{COMMENT}}
 */
{{BINARY_TYPE}} get {{NAME}} => this["{{SYNONYM}}"];
''';

  final ClassLibraryGenerator classGenerator;

  final Declarator declarator;

  final String name;

  TypeHelper _typeHelper;

  GetterTypeGenerator(this.classGenerator, this.declarator, this.name) {
    if (classGenerator == null) {
      throw new ArgumentError.notNull("classGenerator");
    }

    if (declarator == null) {
      throw new ArgumentError.notNull("declarator");
    }

    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    addTemplate(_TEMPLATE, _template);
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var binaryType = classGenerator.types[name];
    block.assign("SYNONYM", declarator.identifier.name);
    block.assign("BINARY_TYPE", binaryType.runtimeType.toString());
    block.assign("COMMENT", binaryType.typedefName);
    block.assign("NAME", name);
    return block.process();
  }
}
