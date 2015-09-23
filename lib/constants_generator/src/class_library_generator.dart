part of binary_generator.constants_generator;

class ClassLibraryGenerator extends ClassGenerator {
  ConstantsGeneratorOptions _options;

  final ScriptGenerator scriptGenerator;

  ClassLibraryGenerator(this.scriptGenerator, ConstantsGeneratorOptions options)
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
    var filenames = new Set<String>();
    filenames.addAll(_options.links);
    _generateConstants(filenames, helper, typeHelper);
    // Constructor
    addConstructor(new ConstructorGenerator(this, _options));
    return super.generate();
  }

  void _generateConstants(Set<String> filenames, BinaryTypeHelper helper, TypeHelper typeHelper) {
    void _error(MacroDefinition definition) {
      var sb = new StringBuffer();
      sb.write("Macro definition error");
      var filename = definition.filename;
      if (filename != null) {
        sb.write(" (");
        sb.write(filename);
        sb.write("): ");
      } else {
        sb.write(": ");
      }

      sb.write(definition.name);
      sb.write(" ");
      sb.write(definition);
      print(sb);
    }

    var constants = _options.constants;
    var definitions = helper.definitions;
    bool defined(String name) {
      return definitions.containsKey(name);
    }

    if (constants != null) {
      for (var name in constants) {
        var definition = definitions[name];
        if (definition == null) {
          throw new StateError("Constant not defined: '$name'");
        }

        var filename = definition.filename;
        if (filenames.contains(filename) && !definition.fragments.isEmpty) {
          var expander = new MacroExpander();
          var string = expander.expand(definition.fragments, definitions);
          var evaluator = new ExpressionEvaluator();
          try {
            var value = evaluator.evaluate(string, defined: defined);
            if (value is int) {
              var comment = "// #define $name $definition";
              value = value.toString();
              addConstant(new VariableGenerator(name, "static const int", comment: comment, value: value));
            }
          } catch (e) {
            _error(definition);
            rethrow;
          }
        }
      }
    } else {
      var links = new Set<String>();
      links.addAll(_options.links);
      for (var name in definitions.keys) {
        var definition = definitions[name];
        var filename = definition.filename;
        if (links.contains(filename) && !definition.fragments.isEmpty) {
          var expander = new MacroExpander();
          var string = expander.expand(definition.fragments, definitions);
          var evaluator = new ExpressionEvaluator();
          try {
            var value = evaluator.evaluate(string, defined: defined);
            if (value is int) {
              var comment = "// #define $name $definition";
              value = value.toString();
              addConstant(new VariableGenerator(name, "static const int", comment: comment, value: value));
            }
          } catch (e) {
            _error(definition);
            rethrow;
          }
        }
      }
    }
  }
}
