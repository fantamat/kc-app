import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/services/image_service.dart';

class FirebaseImageService implements ImageService {
  FirebaseImageService({
    required FirebaseStorage storage,
    required String uid,
  })  : _storage = storage,
        _uid = uid;

  final FirebaseStorage _storage;
  final String _uid;

  @override
  Future<String?> pickAndSave(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return null;

    final compressed = await FlutterImageCompress.compressWithFile(
      picked.path,
      quality: 80,
      format: CompressFormat.jpeg,
    );
    if (compressed == null) return null;

    final path = 'users/$_uid/images/${const Uuid().v4()}.jpg';
    final ref = _storage.ref(path);
    await ref.putData(compressed, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  @override
  Future<Uint8List?> readBytes(String pathOrUrl) async {
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      final response = await http.get(Uri.parse(pathOrUrl));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.bodyBytes;
      }
      return null;
    }

    final ref = _storage.ref(pathOrUrl);
    return ref.getData();
  }

  @override
  Future<String> saveBytes(Uint8List bytes, String prefix) async {
    final path = 'users/$_uid/images/${prefix}_${const Uuid().v4()}.jpg';
    final ref = _storage.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  @override
  Future<void> delete(String pathOrUrl) async {
    try {
      if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
        await _storage.refFromURL(pathOrUrl).delete();
      } else {
        await _storage.ref(pathOrUrl).delete();
      }
    } catch (_) {
      // Ignore missing/deleted files.
    }
  }
}
