import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<File>? fileFromImageUrl(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  final documentDirectory = await getApplicationDocumentsDirectory();

  final file = File(join(documentDirectory.path, 'imagetest.png'));

  file.writeAsBytesSync(response.bodyBytes);

  return file;
}
