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

    _name = declaration.identifier.name;
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
    var variadic = false;
    for (var parameter in declaration.parameters.parameters) {
      if (parameter.type is VaListTypeSpecification) {
        params = _typeHelper.createName(params, names, prefix: "arg");
        parameters.add("[List params]");
        variadic = true;
      } else {
        String name;
        if (parameter.identifier != null) {
          name = parameter.identifier.name;
        }

        name = _typeHelper.createName(name, names, prefix: "arg");
        var type = _getType(parameter.type);
        arguments.add(name);
        var string = name;
        if (type != null) {
          string = "$type $name";
        }

        parameters.add(string);
      }
    }

    var returnType = "dynamic";
    if (declaration.returnType == null) {
      returnType = _getType(declaration.returnType, "dynamic");
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
    blockBody.assign("NAME", declaration.identifier.name);

    //
    block.assign("#BODY", blockBody.process());
    return block.process();
  }

  String _getType(TypeSpecification type, [String defaultType]) {
    String result;
    var dartType = _typeHelper.tryGetDartTypeAdvanced(type, classGenerator.types);
    if (dartType == null) {
      result = defaultType;
    } else {
      result = dartType.toString();
    }

    return result;
  }
}
