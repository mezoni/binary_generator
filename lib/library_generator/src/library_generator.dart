part of binary_generator.library_generator;

class LibraryGenerator {
  List<String> generate(LibraryGeneratorOptions options) {
    if (options == null) {
      throw new ArgumentError.notNull("options");
    }

    var scriptGenerator = new ScriptGenerator(options);
    return scriptGenerator.generate();
  }
}

class LibraryGeneratorOptions {
  final Iterable<String> directives;

  final Map<String, String> environment;

  final String header;

  final Map<String, String> headers;

  final Iterable<String> links;

  final String name;

  final String prefix;

  final String suffix;

  LibraryGeneratorOptions(
      {this.directives, this.environment, this.header, this.headers, this.links, this.name, this.prefix, this.suffix}) {
    if (header == null) {
      throw new ArgumentError.notNull("header");
    }

    if (headers == null) {
      throw new ArgumentError.notNull("headers");
    }

    if (links == null) {
      throw new ArgumentError.notNull("links");
    }

    if (name == null) {
      throw new ArgumentError.notNull("name");
    }
  }
}
