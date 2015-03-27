part of binary_generator.library_generator;

class LibraryGenerator {
  final LibraryGeneratorOptions options;

  LibraryGenerator(this.options) {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }
  }

  List<String> generate() {
    var scriptGenerator = new ScriptGenerator(options);
    return scriptGenerator.generate();
  }
}

class LibraryGeneratorOptions {
  final Map<String, String> environment;

  final String header;

  final List<String> headers;

  final String library;

  final String name;

  LibraryGeneratorOptions({this.environment, this.header, this.headers, this.library, this.name}) {
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
