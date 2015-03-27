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

  String _name;

  TypeHelper _typeHelper;

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

  Map<String, FunctionType> get functions => classGenerator.scriptGenerator.functions;

  String get name => _name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    _typeHelper = new TypeHelper();
    var arguments = <String>[];
    var declarator = declaration.declarator;
    var declaratorParameters = declarator.parameters.elements;
    var function = functions[name];
    var arity = function.arity;
    var functionParameters = function.parameters;
    var names = new Set<String>();
    var parameters = <String>[];
    var params = "params";
    for (var i = 0; i < arity; i++) {
      var binaryType = functionParameters[i];
      var parameter = declaratorParameters[i];
      String name;
      var declarator = parameter.declarator;
      if (declarator != null) {
        var identifier = declarator.identifier;
        if (identifier != null) {
          name = identifier.name;
        }
      }

      name = _typeHelper.createName(name, names, prefix: "arg");
      var type = _typeHelper.getTypeOfValueForBinaryType(binaryType);
      type = _filterParameterType(type);
      arguments.add(name);
      var string = name;
      if (type != null) {
        string = "$type $name";
      }

      parameters.add(string);
    }

    var variadic = function.variadic;
    if (variadic) {
      params = _typeHelper.createName(params, names, prefix: params);
      parameters.add("[List $params]");
    }

    var returnType = _typeHelper.getTypeOfValueForBinaryType(function.returnType);
    returnType = _filterReturnType(returnType, "dynamic");

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
      case "Map":
        break;
      default:
        type = defaultType;
    }

    return type;
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
}
