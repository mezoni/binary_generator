part of binary_generator.types_generator;

class TypesGenerator {
  final TypesGeneratorOptions options;

  TypesGenerator(this.options) {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }
  }

  List<String> generate() {
    var scriptGenerator = new ScriptGenerator(options);
    return scriptGenerator.generate();
  }
}

class TypesGeneratorOptions {
  final Map<String, String> environment;

  final String header;

  final String library;

  final String name;

  TypesGeneratorOptions({this.environment, this.header, this.library, this.name}) {
    if (header == null) {
      throw new ArgumentError.notNull("header");
    }

    if (library == null) {
      throw new ArgumentError.notNull("library");
    }

    if (name == null) {
      throw new ArgumentError.notNull("name");
    }
  }
}
