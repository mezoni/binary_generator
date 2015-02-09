part of binary_generator.types_generator;

class ClassTypesGenerator extends ClassGenerator {
  static const String HEADER = "_header";

  TypesGeneratorOptions _options;

  final ScriptGenerator scriptGenerator;

  ClassTypesGenerator(this.scriptGenerator, TypesGeneratorOptions options) : super(options.name, interfaces: "extends BinaryTypes") {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    _options = options;
  }

  Declarations get declarations => scriptGenerator.declarations;

  BinaryTypes get types => scriptGenerator.types;

  List<String> generate() {
    var symbols = <String>[];
    var typeHelper = new TypeHelper();
    for (var declaration in declarations) {
      if (declaration is TypedefDeclaration) {
        for (var synonym in declaration.synonyms) {
          if (!name.startsWith("_") && !typeHelper.isReservedWord(name)) {
            var name = _getSynonymName(synonym);
            var generator = new GetterTypeGenerator(this, synonym, name);
            addMethod(generator);
          }
        }
      }
    }

    // Constructor
    addConstructor(new ConstructorGenerator(this, _options));

    // HEADER
    var value = "'''\n${_options.header}'''";
    addConstant(new VariableGenerator(ClassTypesGenerator.HEADER, "String", value: value));

    return super.generate();
  }

  String _getSynonymName(TypeSpecification type) {
    switch (type.typeKind) {
      case TypeSpecificationKind.ARRAY:
        var arrayType = type as ArrayTypeSpecification;
        return _getSynonymName(arrayType.type);
      case TypeSpecificationKind.DEFINED:
        return type.name;
      case TypeSpecificationKind.POINTER:
        var pointerType = type as PointerTypeSpecification;
        return _getSynonymName(pointerType.type);
      default:
        throw new ArgumentError("Unable to get type synonym name: ${type.typeKind}");
    }
  }
}
