part of binary_generator.library_generator;

class ForeignFunctionGenerator extends DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _TEMPLATE_BODY = "_TEMPLATE_BODY";

  static const String _TEMPLATE_BODY_VARIADIC = "_TEMPLATE_BODY_VARIADIC";

  static const String _LIBRARY = ClassLibraryGenerator.LIBRARY;

  static final String _template = '''
/**
 * {{COMMENT}}
 */
{{RETURN_TYPE}} {{NAME}}({{PARAMETERS}}) {
  {{#BODY}}
}
''';

  static final String _templateBody = '''
return $_LIBRARY.invoke("{{NAME}}", [{{ARGUMENTS}}]);''';

  static final String _templateBodyVariadic = '''
var arguments = [{{ARGUMENTS}}];
if ({{PARAMS_NAME}} != null) {
  arguments.addAll({{PARAMS_NAME}});
}

return $_LIBRARY.invoke("{{NAME}}", arguments);''';

  final FunctionDeclaration declaration;

  ForeignFunctionGenerator(this.declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declartion");
    }

    addTemplate(_TEMPLATE, _template);
    addTemplate(_TEMPLATE_BODY, _templateBody);
    addTemplate(_TEMPLATE_BODY_VARIADIC, _templateBodyVariadic);
  }

  String get name => declaration.name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var names = new Set<String>();
    var arguments = <String>[];
    var parameters = <String>[];
    var params = "params";
    var variadic = false;
    for (var parameter in declaration.parameters) {
      if (parameter.type is VaListTypeSpecification) {
        params = _getName(params, names);
        parameters.add("[List params]");
        variadic = true;
      } else {
        var name = _getName(parameter.name, names);
        var type = _getType(parameter.type, "");
        arguments.add(name);
        if (!type.isEmpty) {
          type += " ";
        }

        parameters.add("$type$name");
      }
    }

    block.assign("NAME", name);
    block.assign("COMMENT", declaration);
    block.assign("RETURN_TYPE", _getType(declaration.returnType, "dynamic"));
    block.assign("PARAMETERS", parameters.join(", "));

    //
    TemplateBlock blockBody;
    if (variadic) {
      blockBody = getTemplateBlock(_TEMPLATE_BODY_VARIADIC);
      blockBody.assign("PARAMS_NAME", params);
    } else {
      blockBody = getTemplateBlock(_TEMPLATE_BODY);
    }

    blockBody.assign("ARGUMENTS", arguments.join(", "));
    blockBody.assign("NAME", name);

    //
    block.assign("#BODY", blockBody.process());
    return block.process();
  }

  String _getName(String name, Set<String> used) {
    if (name != null && !name.isEmpty) {
      if (!used.contains(name)) {
        used.add(name);
        return name;
      }
    }

    var prefix = "arg";
    var index = 0;
    while (true) {
      name = "$prefix$index";
      index++;
      if (!used.contains(name)) {
        used.add(name);
        return name;
      }
    }
  }

  String _getType(TypeSpecification type, String result) {
    if (type is IntegerTypeSpecification) {
      result = "int";
    } else if (type is FloatTypeSpecification) {
      result = "double";
      // } else if (returnType is VoidTypeSpecification) {
      // value = "void";
    } else if (type is StructureTypeSpecification) {
      result = "Map";
    } else if (type is TypedefTypeSpecification) {
      switch (type.name) {
        case "size_t":
          result = "int";
          break;
      }
    }

    return result;
  }
}
