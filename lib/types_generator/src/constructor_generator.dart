part of binary_generator.types_generator;

class ConstructorGenerator extends DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _HEADER = ClassTypesGenerator.HEADER;

  static final String _template = '''
/**
 *
 */
{{NAME}}({DataModel dataModel, BinaryTypes types}) : super(dataModel: dataModel, types: types) {
  var helper = new BinaryTypeHelper(this);
  helper.declare($_HEADER);  
}
''';

  Declarations _declarations;

  final ClassTypesGenerator classGenerator;

  final TypesGeneratorOptions options;

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
