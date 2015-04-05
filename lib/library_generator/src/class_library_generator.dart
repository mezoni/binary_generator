part of binary_generator.library_generator;

class ClassLibraryGenerator extends ClassGenerator {
  static const String LIBRARY = "_library";

  LibraryGeneratorOptions _options;

  final ScriptGenerator scriptGenerator;

  ClassLibraryGenerator(this.scriptGenerator, LibraryGeneratorOptions options)
      : super(options.name, prefix: options.prefix, suffix: options.suffix) {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    _options = options;
  }

  BinaryTypes get types => scriptGenerator.types;

  List<String> generate() {    
    var typeHelper = new TypeHelper();
    var helper = new BinaryTypeHelper(types);
    var prototypes = helper.prototypes;
    var filenames = new Set<String>();
    filenames.addAll(_options.links);
    for (var name in prototypes.keys) {
      if (!typeHelper.isReservedWord(name)) {
        var prototype = prototypes[name];
        var filename = prototype.filename;
        if (filenames.contains(filename)) {
          var generator = new ForeignFunctionGenerator(this, prototype);
          addMethod(generator);
        }
      }
    }

    // Constructor
    addConstructor(new ConstructorGenerator(this, _options));

    // LIBRARY
    addVariable(new VariableGenerator(ClassLibraryGenerator.LIBRARY, "DynamicLibrary"));

    return super.generate();
  }
}
