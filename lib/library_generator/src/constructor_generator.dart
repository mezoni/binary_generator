part of binary_generator.library_generator;

class ConstructorGenerator extends DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _HEADER = ClassLibraryGenerator.HEADER;

  static const String _LIBRARY = ClassLibraryGenerator.LIBRARY;

  static final String _template = '''
/**
 *
 */
{{NAME}}(DynamicLibrary library, {Map<String, String> environment, BinaryTypes types})
    : super(types: types) {
  library.types = this; 
  library.declare($_HEADER, environment: environment);
  $_LIBRARY = library;
}
''';

  Declarations _declarations;

  final ClassLibraryGenerator classGenerator;

  final LibraryGeneratorOptions options;

  ConstructorGenerator(this.classGenerator, this.options) {
    if (classGenerator == null) {
      throw new ArgumentError.notNull("classGenerator");
    }

    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    addTemplate(_TEMPLATE, _template);
  }

  Declarations get declarations => classGenerator.declarations;

  String get name => options.name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("NAME", name);
    return block.process();
  }
}
