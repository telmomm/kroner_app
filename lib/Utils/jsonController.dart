// jsonController.dart
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File> definePath() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = p.join(directory.path, 'default.json');
  final file = File(path);
  if (!await file.exists()) {
	await file.create();
  }
  return file;
}

Future<void> saveJSON(String newContent) async {
  final file = await definePath(); // Asegúrate de que esta función devuelve la ruta correcta al archivo JSON

  // Inicializar currentJson como una lista vacía.
  List<dynamic> currentJson = [];

  try {
    // Intentar leer el contenido actual del archivo.
    String currentContent = await file.readAsString();
    if (currentContent.isNotEmpty) {
      // Si el contenido no está vacío, decodificarlo como una lista.
      currentJson = jsonDecode(currentContent);
    }
  } catch (e) {
    // Si ocurre un error al leer el archivo (por ejemplo, si no existe), currentJson ya está inicializado como una lista vacía.
    print("Error al leer el archivo: $e");
  }

  // Decodificar el nuevo contenido y añadirlo a la lista.
  Map<String, dynamic> newJson = jsonDecode(newContent);
  //currentJson.add(newJson);
  currentJson.insert(0, newJson);

  // Codificar la lista actualizada a un String JSON y escribirlo de vuelta al archivo.
  String updatedJson = jsonEncode(currentJson);
  await file.writeAsString(updatedJson);
  print('Datos actualizados guardados en ${file.path}');
}

Future<List<Map<String, dynamic>>> loadJSON() async {
  try {
    // Usar definePath para obtener la ruta al archivo JSON
    final file = await definePath();
    // Leer el contenido del archivo como String
    final String contents = await file.readAsString();
    // Decodificar el String JSON a una estructura de datos de Dart
    final List<dynamic> jsonData = jsonDecode(contents);
    // Asegurarse de que la estructura de datos se trate como una lista de mapas
    final List<Map<String, dynamic>> datos = List<Map<String, dynamic>>.from(jsonData);
    return datos;
  } catch (e) {
    // Manejar errores (por ejemplo, archivo no encontrado, formato JSON inválido, etc.)
    print("Error al cargar el JSON: $e");
    return []; // Devolver una lista vacía en caso de error
  }
}