part of binary_generator.library_generator;

class ClassLibraryGenerator extends ClassGenerator {
  static const String HEADER = "_header";

  static const String LIBRARY = "_library";

  LibraryGeneratorOptions _options;

  final ScriptGenerator scriptGenerator;

  ClassLibraryGenerator(this.scriptGenerator, LibraryGeneratorOptions options) : super(options.name, suffix: "extends BinaryTypes") {
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
      } else if (declaration is FunctionDeclaration) {
        var generator = new ForeignFunctionGenerator(this, declaration);
        addMethod(generator);
      }
    }

    // Constructor
    addConstructor(new ConstructorGenerator(this, _options));

    // HEADER
    var value = "'''\n${_options.header}'''";
    addConstant(new VariableGenerator(ClassLibraryGenerator.HEADER, "String", value: value));

    // LIBRARY
    addVariable(new VariableGenerator(ClassLibraryGenerator.LIBRARY, "DynamicLibrary"));

    return super.generate();
  }
}
