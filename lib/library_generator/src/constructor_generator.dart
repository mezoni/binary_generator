part of binary_generator.library_generator;

class ConstructorGenerator extends DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _LIBRARY = ClassLibraryGenerator.LIBRARY;

  static final String _template = '''
/**
 *
 */
{{NAME}}(DynamicLibrary library) { 
  var headers = <String>[{{#HEADERS}}];
  var types = library.types;
  var helper = new BinaryTypeHelper(types); 
  for (var header in headers) {
    helper.declare(header);    
  }

  library.link(headers);
  $_LIBRARY = library;
}
''';

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

  String get name => options.name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("NAME", name);
    var headers = options.links.join("\", \"");
    block.assign("#HEADERS", "\"$headers\"");
    return block.process();
  }
}
