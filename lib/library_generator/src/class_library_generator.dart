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

    _generateConstants(filenames, helper, typeHelper);
    _generateVariables(filenames, helper, typeHelper);
    // Constructor
    addConstructor(new ConstructorGenerator(this, _options));
    // LIBRARY
    addVariable(
        new VariableGenerator(ClassLibraryGenerator.LIBRARY, "DynamicLibrary"));
    return super.generate();
  }

  void _generateConstants(
      Set<String> filenames, BinaryTypeHelper helper, TypeHelper typeHelper) {
    var constants = _options.constants;
    if (constants == null) {
      return;
    }

    var definitions = helper.definitions;
    bool defined(String name) {
      return definitions.containsKey(name);
    }

    for (var name in constants) {
      var definition = definitions[name];
      if (definition == null) {
        throw new StateError("Constant not defined: '$name'");
      }

      var filename = definition.filename;
      if (filenames.contains(filename)) {
        var expander = new MacroExpander();
        var string = expander.expand(definition.fragments, definitions);
        var evaluator = new ExpressionEvaluator();
        try {
          var value = evaluator.evaluate(string, defined: defined);
          if (value is int) {
            var comment = "// #define $name $definition";
            value = value.toString();
            if (name.startsWith("_")) {
              name = "\$$name";
            }

            addConstant(new VariableGenerator(name, "static const int",
                comment: comment, value: value));
          }
        } catch (e) {
          // Nothing
        }
      }
    }
  }

  void _generateVariables(
      Set<String> filenames, BinaryTypeHelper helper, TypeHelper typeHelper) {
    for (var variable in helper.variables.values) {
      var filename = variable.filename;
      if (filenames.contains(filename)) {
        var name = variable.name;
      }

      var generator = new GetterVariableGenerator(this, variable);
      addProperty(generator);
    }
  }
}
