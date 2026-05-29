import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/services/image_service.dart';

class LocalImageService implements ImageService {
  const LocalImageService();

  Future<io.Directory> _imagesDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = io.Directory(p.join(docsDir.path, 'card_images'));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  @override
  Future<String?> pickAndSave(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return null;

    final dir = await _imagesDir();
    final targetPath = p.join(dir.path, '${const Uuid().v4()}.jpg');
    final compressed = await FlutterImageCompress.compressAndGetFile(
      picked.path,
      targetPath,
      quality: 80,
    );
    return compressed?.path;
  }

  @override
  Future<Uint8List?> readBytes(String pathOrUrl) async {
    final file = io.File(pathOrUrl);
    if (!file.existsSync()) return null;
    return file.readAsBytes();
  }

  @override
  Future<String> saveBytes(Uint8List bytes, String prefix) async {
    final dir = await _imagesDir();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final filePath = p.join(dir.path, '${prefix}_$ts.jpg');
    await io.File(filePath).writeAsBytes(bytes);
    return filePath;
  }

  @override
  Future<void> delete(String pathOrUrl) async {
    final file = io.File(pathOrUrl);
    if (file.existsSync()) {
      await file.delete();
    }
  }
}
