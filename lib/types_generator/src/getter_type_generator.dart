part of binary_generator.types_generator;

class GetterTypeGenerator extends DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static final String _template = '''
/**
 * {{COMMENT}}
 */
{{BINARY_TYPE}} get {{NAME}} => this["{{NAME}}"];
''';

  final ClassTypesGenerator classGenerator;

  final String name;

  final TypeSpecification type;

  TypeHelper _typeHelper;

  GetterTypeGenerator(this.classGenerator, this.type, this.name) {
    if (classGenerator == null) {
      throw new ArgumentError.notNull("classGenerator");
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    addTemplate(_TEMPLATE, _template);
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var binaryType = classGenerator.types[name];
    block.assign("BINARY_TYPE", "BinaryType");
    block.assign("COMMENT", binaryType.typedefName);
    block.assign("NAME", name);
    return block.process();
  }

  String getType(TypeSpecification type, [String defaultType]) {
    String result;
    var dartType = _typeHelper.getDartTypeAdvanced(type, classGenerator.types);
    if (dartType == null) {
      result = defaultType;
    } else {
      result = dartType.toString();
    }

    return result;
  }
}
