part of binary_generator.library_generator;

class LibraryGenerator {
  final String text;

  LibraryGenerator(this.text) {
    if (text == null) {
      throw new ArgumentError.notNull("header");
    }
  }

  List<String> generate(LibraryGeneratorOptions options) {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    var scriptGenerator = new ScriptGenerator(options);
    return scriptGenerator.generate();
  }
}

class LibraryGeneratorOptions {
  final String header;

  final String library;

  final String name;

  LibraryGeneratorOptions({this.header, this.library, this.name}) {
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
