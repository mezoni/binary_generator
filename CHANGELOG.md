## 0.0.21

- The `LibraryGenerator` now generates variables from the binary types

## 0.0.20

- The `ConstantsGenerator` now generates constants from the enum declarations

## 0.0.19

- Fixed bug in `ConstantsGenerator`

## 0.0.17

- Added new generator `ConstantsGenerator`. The generator allows to generate the `constants` from the textual format supported by the `binary_declarations`. The defintionss "#define" will be represented as the static constants members of the generated class

## 0.0.16

- Made adaptations to the new version of package `binary_types`

## 0.0.14

- The `LibraryGenerator` now generates constants from the macro definitions (only included in the `white list`)

## 0.0.12

- The `LibraryGenerator` now generates constants from the macro definitions   

## 0.0.9

- Temporarily was disabled a resolver of the function parameter type

## 0.0.8

- Impovements in `LibraryGenerator`

## 0.0.7

- Made adaptations to the new version of package `binary_declarations`

## 0.0.6

- Added support of the functions which started with the "_" (underscore) in the library generator. Now they are prefixed with the "$" (dollar sign) in the generated Dart code

## 0.0.5

- Fixed bug in `ForeignFunctionGenerator` with the function declarations with the abstract parameters (without the name)

## 0.0.4

- Added new generator `TypesGenerator`. The generator allows to generate the `binary types` from the textual format supported by the `binary_declarations`. The declarations "typedef" will be represented as the members of the generated class `binary types`
- Made adaptations to the new version of package `binary_declarations`
- Made adaptations to the new version of package `binary_types`

## 0.0.3

- Fixed bug in `ForeignFunctionGenerator`

## 0.0.2

- Library generator now utilizes the features of `binary types` not only `binary declarations`. For the better type resolutions now generator tries to declare the its own copy of the `binary types` directly from the `binary declarations`

## 0.0.1

- Initial release

