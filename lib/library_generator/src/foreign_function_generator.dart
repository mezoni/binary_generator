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

  TypeConverter _typeConverter;

  ForeignFunctionGenerator(this.classGenerator, this.declaration) {
    if (classGenerator == null) {
      throw new ArgumentError.notNull("classGenerator");
    }

    addTemplate(_TEMPLATE, _template);
    addTemplate(_TEMPLATE_BODY, _templateBody);
    addTemplate(_TEMPLATE_BODY_VARIADIC, _templateBodyVariadic);
  }

  String get name => declaration.name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    _typeConverter = new TypeConverter();
    var names = new Set<String>();
    var arguments = <String>[];
    var parameters = <String>[];
    var params = "params";
    var variadic = false;
    for (var parameter in declaration.parameters) {
      if (parameter.type is VaListTypeSpecification) {
        params = _typeConverter.createName(params, names, prefix: "arg");
        parameters.add("[List params]");
        variadic = true;
      } else {
        var name = _typeConverter.createName(parameter.name, names);
        var type = getType(parameter.type);
        arguments.add(name);
        var string = name;
        if (type != null) {
          string = "$type $name";
        }

        parameters.add(string);
      }
    }

    block.assign("NAME", name);
    block.assign("COMMENT", declaration);
    block.assign("RETURN_TYPE", getType(declaration.returnType, "dynamic"));
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

  String getType(TypeSpecification type, [String defaultType]) {
    String result;
    var dartType = _typeConverter.getDartTypeAdvanced(type, classGenerator.types);
    if (dartType == null) {
      result = defaultType;
    } else {
      result = dartType.toString();
    }

    return result;
  }
}
