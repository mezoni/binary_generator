part of binary_generator.library_generator;

class ClassLibraryGenerator extends ClassGenerator {
  static const String HEADER = "_header";

  static const String LIBRARY = "_library";

  LibraryGeneratorOptions _options;

  final ScriptGenerator scriptGenerator;

  ClassLibraryGenerator(this.scriptGenerator, LibraryGeneratorOptions options) : super(options.name) {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    _options = options;
  }

  BinaryDeclarations get declarations => scriptGenerator.declarations;

  BinaryTypes get types => scriptGenerator.types;

  List<String> generate() {
    var symbols = <String>[];
    for (var declaration in declarations) {
      if (declaration is FunctionDeclaration) {
        var generator = new ForeignFunctionGenerator(this, declaration);
        addMethod(generator);
        symbols.add(declaration.name);
      }
    }

    // Constructor
    addConstructor(new ConstructorGenerator(this, _options));

    // HEADER
    var value  = "'''\n${_options.header}'''";
    addConstant(new VariableGenerator(ClassLibraryGenerator.HEADER, "String", value: value));

    // LIBRARY
    addVariable(new VariableGenerator(ClassLibraryGenerator.LIBRARY, "DynamicLibrary"));

    return super.generate();
  }
}
