part of binary_generator.constants_generator;

class ConstructorGenerator extends DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static final String _template = '''
/**
 *
 */
{{NAME}}._internal();
''';

  final ClassLibraryGenerator classGenerator;

  final ConstantsGeneratorOptions options;

  ConstructorGenerator(this.classGenerator, this.options) {
    if (classGenerator == null) {
      throw new ArgumentError.notNull("classGenerator");
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
}
