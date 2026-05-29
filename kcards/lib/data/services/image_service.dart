import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Abstracts image pick/save/delete for both local and Firebase Storage backends.
abstract interface class ImageService {
  /// Pick an image from [source], compress it, persist it (local disk or
  /// Firebase Storage), and return the stored path or download URL.
  /// Returns null if the user cancelled.
  Future<String?> pickAndSave(ImageSource source);

  /// Read raw bytes from [pathOrUrl] (local path or remote URL).
  Future<Uint8List?> readBytes(String pathOrUrl);

  /// Persist raw bytes (used during import) and return the stored path/URL.
  Future<String> saveBytes(Uint8List bytes, String prefix);

  /// Delete the image at [pathOrUrl].
  Future<void> delete(String pathOrUrl);
}
