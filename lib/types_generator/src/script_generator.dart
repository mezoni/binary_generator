part of binary_generator.types_generator;

class ScriptGenerator extends TemplateGenerator {
  static const String _TEMPLATE = 'TEMPLATE';

  static final String _template = '''
// This code was generated by a tool.
// Processing tool available at https://github.com/mezoni/binary_generator

{{#LIBRARY}}
import "package:binary_types/binary_types.dart";

{{#CLASSES}}
''';

  final TypesGeneratorOptions options;

  Declarations _declarations;

  BinaryTypes _types;

  Map<String, List<String>> _classes;

  ScriptGenerator(this.options) {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    addTemplate(_TEMPLATE, _template);
    _classes = <String, List<String>>{};
  }

  Declarations get declarations => _declarations;

  BinaryTypes get types => _types;

  void addClass(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError("declaration: $declaration");
    }

    _addDeclaration(declaration, _classes);
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var header = options.header;
    _declarations = new Declarations(options.header);
    _types = new BinaryTypes();
    var helper = new BinaryTypeHelper(_types);
    helper.declare(header, environment: options.environment);
    var classLibraryGenerator = new ClassTypesGenerator(this, options);
    addClass(classLibraryGenerator);
    if (options.library != null) {
      block.assign("#LIBRARY", "library ${options.library};\n");
    }

    _generateDeclarations(block, "#CLASSES", _classes);
    return block.process();
  }

  void _addDeclaration(DeclarationGenerator generator, Map<String, List<String>> members) {
    var name = generator.name;
    if (members.containsKey(name)) {
      throw new StateError("Declaration generator with name '$name' already exists.");
    }

    members[name] = generator.generate();
  }

  void _generateDeclarations(TemplateBlock block, String key, Map<String, List<String>> members) {
    var names = members.keys.toList();
    names.sort((a, b) => a.compareTo(b));
    for (var name in names) {
      block.assign(key, members[name]);
    }
  }
}
