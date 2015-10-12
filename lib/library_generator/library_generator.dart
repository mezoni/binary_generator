library binary_generator.library_generator;

import "package:binary_declarations/binary_declarations.dart";
import "package:binary_generator/internal/generators/generators.dart";
import "package:binary_generator/internal/type_helper/type_helper.dart";
import "package:binary_types/binary_types.dart";
import "package:macro_processor/expression_evaluator.dart";
import "package:macro_processor/macro_expander.dart";
import "package:template_block/template_block.dart";

part 'src/class_library_generator.dart';
part 'src/constructor_generator.dart';
part 'src/foreign_function_generator.dart';
part 'src/getter_type_generator.dart';
part 'src/getter_variable_generator.dart';
part 'src/library_generator.dart';
part 'src/script_generator.dart';
