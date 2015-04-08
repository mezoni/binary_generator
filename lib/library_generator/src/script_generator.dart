part of binary_generator.library_generator;

class ScriptGenerator extends TemplateGenerator {
  static const String _TEMPLATE = 'TEMPLATE';

  static final String _template = '''
// This code was generated by a tool.
// Processing tool available at https://github.com/mezoni/binary_generator

{{#DIRECTIVES}}
{{#CLASSES}}
''';

  final LibraryGeneratorOptions options;

  Map<String, List<String>> _classes;

  BinaryTypes _types;

  ScriptGenerator(this.options) {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    addTemplate(_TEMPLATE, _template);
    _classes = <String, List<String>>{};
  }

  BinaryTypes get types => _types;

  void addClass(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError("declaration: $declaration");
    }

    _addDeclaration(declaration, _classes);
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    _types = new BinaryTypes();
    var helper = new BinaryTypeHelper(_types);
    helper.addHeaders(options.headers);
    helper.declare(options.header, environment: options.environment);
    var classLibraryGenerator = new ClassLibraryGenerator(this, options);
    addClass(classLibraryGenerator);
    if (options.directives != null) {
      for (var directive in options.directives) {
        block.assign("#DIRECTIVES", "$directive;\n");
      }
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
