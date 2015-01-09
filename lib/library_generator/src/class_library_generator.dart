part of binary_generator.library_generator;

class ClassLibraryGenerator extends ClassGenerator {
  static const String HEADER = "_header";

  static const String LIBRARY = "_library";

  LibraryGeneratorOptions _options;

  final BinaryDeclarations declarations;

  ClassLibraryGenerator(this.declarations, LibraryGeneratorOptions options) : super(options.name) {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    if (declarations == null) {
      throw new ArgumentError.notNull("declarations");
    }

    _options = options;
  }

  List<String> generate() {
    for (var declaration in declarations) {
      if (declaration is FunctionDeclaration) {
        var generator = new ForeignFunctionGenerator(declaration);
        addMethod(generator);
      }
    }

    addConstructor(new ConstructorGenerator(declarations, _options));
    addConstant(new VariableGenerator(ClassLibraryGenerator.HEADER, "String", value: "'''\n${_options.header}'''"));
    addVariable(new VariableGenerator(ClassLibraryGenerator.LIBRARY, "DynamicLibrary"));
    return super.generate();
  }
}
