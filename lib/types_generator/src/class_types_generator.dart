part of binary_generator.types_generator;

class ClassTypesGenerator extends ClassGenerator {
  static const String HEADER = "_header";

  TypesGeneratorOptions _options;

  final ScriptGenerator scriptGenerator;

  ClassTypesGenerator(this.scriptGenerator, TypesGeneratorOptions options)
      : super(options.name, suffix: "extends BinaryTypes") {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    _options = options;
  }

  Declarations get declarations => scriptGenerator.declarations;

  BinaryTypes get types => scriptGenerator.types;

  List<String> generate() {
    var names = new Set<String>();
    var typeHelper = new TypeHelper();
    for (var declaration in declarations) {
      if (declaration is TypedefDeclaration) {
        for (var declarator in declaration.declarators.elements) {
          var name = declarator.identifier.name;
          if (!names.contains(name)) {
            if (!name.startsWith("_") && !typeHelper.isReservedWord(name)) {
              var generator = new GetterTypeGenerator(this, declarator, name);
              addMethod(generator);
            }

            names.add(name);
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
}
