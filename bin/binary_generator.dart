library binary_generator.bin.binary_generator;

import "dart:io";

import "package:args_helper/args_helper.dart";
import "package:binary_generator/library_generator/library_generator.dart";
import "package:binary_generator/types_generator/types_generator.dart";
import "package:strings/strings.dart";
import "package:path/path.dart" as pathos;
import "package:yaml/yaml.dart" as yaml;

void main(List<String> arguments) {
  var config = yaml.loadYaml(_config);
  new ArgsHelper<Program>().run(arguments, config);
}

class Program {
  void libraryCommand(String filename, {String library, String name, String output}) {
    var header = _readFromFile(filename);
    name = _getClassName(filename, name);
    var generator = new LibraryGenerator(header);
    if (library == null) {
      library = name.toLowerCase();
    }

    var options = new LibraryGeneratorOptions(header: header, library: library, name: name);
    var lines = generator.generate(options);
    if (output == null) {
      output = name.toLowerCase() + ".dart";
    }

    _writeToFile(output, lines.join("\n"));
  }

  void typesCommand(String filename, {String library, String name, String output}) {
    var header = _readFromFile(filename);
    name = _getClassName(filename, name);
    var generator = new TypesGenerator(header);
    if (library == null) {
      library = name.toLowerCase();
    }

    var options = new TypesGeneratorOptions(header: header, library: library, name: name);
    var lines = generator.generate(options);
    if (output == null) {
      output = name.toLowerCase() + ".dart";
    }

    _writeToFile(output, lines.join("\n"));
  }

  String _getClassName(String filename, String name) {
    if (name != null) {
      return name;
    }

    name = pathos.basenameWithoutExtension(filename);
    name = name.replaceAll(".", "_");
    return camelize(name);
  }

  String _readFromFile(String filename) {
    var file = new File(filename);
    if (!file.existsSync()) {
      print("File not found: $filename");
      exit(-1);
    }

    return file.readAsStringSync();
  }

  void _writeToFile(String filename, String content) {
    var file = new File(filename);
    return file.writeAsStringSync(content);
  }
}

const _config = '''
name: binary_generator
description: Binary generator for develop code from the binary interop and binary types.
commands:
  types:
    description: Generate the binary types code for typedef types 
    options:       
      name:        
        help: Name of the generated Dart class (eg. --name MyTypes)                
      library:        
        help: Name of the generated Dart library (eg. --library libs.mytypes)
      output:        
        help: Output file name (eg. --output mytypes.dart)
    rest:
      allowMultiple: false
      name: filename
      required: true
  library:
    description: Generate the library code for functions and structures 
    options:       
      name:        
        help: Name of the generated Dart class (eg. --name MyLib)                
      library:        
        help: Name of the generated Dart library (eg. --library libs.mylib)
      output:        
        help: Output file name (eg. --output mylib.dart)
    rest:
      allowMultiple: false
      name: filename
      required: true 
''';
