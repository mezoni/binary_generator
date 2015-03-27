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
  void libraryCommand(String filename,
      {List<String> define, String library, String name, String output, List<String> types}) {
    var header = _readFromFile(filename);
    name = _getClassName(filename, name);
    if (library == null) {
      library = name.toLowerCase();
    }

    var headers = <String>[];
    if (types != null) {
      for (var file in types) {
        var header = _readFromFile(file);
        headers.add(header);
      }
    }

    var environment = _getVariables(define);
    var options = new LibraryGeneratorOptions(
        environment: environment, header: header, headers: headers, library: library, name: name);
    var generator = new LibraryGenerator(options);
    var lines = generator.generate();
    if (output == null) {
      output = name.toLowerCase() + ".dart";
    }

    _writeToFile(output, lines.join("\n"));
  }

  void typesCommand(String filename, {List<String> define, String library, String name, String output}) {
    var header = _readFromFile(filename);
    name = _getClassName(filename, name);
    if (library == null) {
      library = name.toLowerCase();
    }

    var environment = _getVariables(define);
    var options = new TypesGeneratorOptions(environment: environment, header: header, library: library, name: name);
    var generator = new TypesGenerator(options);
    var lines = generator.generate();
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

  Map<String, String> _getVariables(List<String> list) {
    var result = <String, String>{};
    if (list == null) {
      return result;
    }

    for (var element in list) {
      var index = element.indexOf("=");
      String key;
      var value = "";
      if (index == -1) {
        key = element;
      } else {
        key = element.substring(0, index);
        value = element.substring(index + 1);
      }

      key = key.trim();
      if (!key.isEmpty) {
        result[key] = value.trim();
      }
    }

    return result;
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
      define:
        allowMultiple: true        
        help: Define the environment variable (eg. --define __OS__)
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
      define:
        allowMultiple: true        
        help: Define the environment variable (eg. --define __OS__)       
      name:        
        help: Name of the generated Dart class (eg. --name MyLib)                
      library:        
        help: Name of the generated Dart library (eg. --library libs.mylib)
      output:        
        help: Output file name (eg. --output mylib.dart)
      types:
        allowMultiple: true
        help: External header files with a types (required only for missing types)
    rest:
      allowMultiple: false
      name: filename
      required: true 
''';
