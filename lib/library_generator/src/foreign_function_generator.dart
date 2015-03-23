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

  final ClassLibraryGenerator classGenerator;

  final FunctionDeclaration declaration;

  TypeHelper _typeHelper;

  String _name;

  ForeignFunctionGenerator(this.classGenerator, this.declaration) {
    if (classGenerator == null) {
      throw new ArgumentError.notNull("classGenerator");
    }

    _name = declaration.declarator.identifier.name;
    if (_name.startsWith("_")) {
      _name = "\$$name";
    }

    addTemplate(_TEMPLATE, _template);
    addTemplate(_TEMPLATE_BODY, _templateBody);
    addTemplate(_TEMPLATE_BODY_VARIADIC, _templateBodyVariadic);
  }

  String get name => _name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    _typeHelper = new TypeHelper();
    var names = new Set<String>();
    var arguments = <String>[];
    var parameters = <String>[];
    var params = "params";
    var declarator = declaration.declarator;
    for (var parameter in declarator.parameters.elements) {
      String name;
      if (parameter.declarator != null) {
        if (parameter.declarator.identifier != null) {
          name = parameter.declarator.identifier.name;
        }
      }

      name = _typeHelper.createName(name, names, prefix: "arg");
      //var type = _getType(parameter.type);
      //type = _filterParameterType(type, null);
      var type = null;
      arguments.add(name);
      var string = name;
      if (type != null) {
        string = "$type $name";
      }

      parameters.add(string);
    }

    var variadic = declarator.parameters.ellipsis != null;
    if (variadic) {
      params = _typeHelper.createName(params, names, prefix: params);
      parameters.add("[List $params]");
    }

    var returnType = "dynamic";
    if (declaration.type != null) {
      returnType = _resolveReturnType();
      returnType = _filterReturnType(returnType, "dynamic");
    }

    block.assign("NAME", name);
    block.assign("COMMENT", declaration);
    block.assign("RETURN_TYPE", returnType);
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
    blockBody.assign("NAME", declaration.declarator.identifier.name);

    //
    block.assign("#BODY", blockBody.process());
    return block.process();
  }

  String _filterParameterType(String type, [String defaultType]) {
    switch (type) {
      case "bool":
      case "double":
      case "int":
        break;
      default:
        type = defaultType;
    }

    return type;
  }

  String _resolveReturnType() {
    var declarator = declaration.declarator;
    if (declarator.isArray) {
      return "BinaryData";
    }

    if (declarator.isPointers) {
      return "BinaryData";
    }

    return _getType(declaration.type, "dynamic");
  }

  String _filterReturnType(String type, [String defaultType]) {
    switch (type) {
      case "BinaryData":
      case "bool":
      case "double":
      case "int":
      case "Map":
      case "void":
        break;
      default:
        type = defaultType;
    }

    return type;
  }

  String _getType(TypeSpecification type, [String defaultType]) {
    var result = _typeHelper.tryGetTypeOfValueForType(type, classGenerator.types);
    if (result == null) {
      result = defaultType;
    }

    return result;
  }
}
