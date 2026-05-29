import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:kcards/shared/providers/database_provider.dart';

/// Horizontal image strip with an "add image" button and per-image delete
/// buttons. [imagePaths] is the ordered list of local file paths to display.
/// [onAddImage] is called with the path of a newly picked & compressed image.
/// [onRemove] is called with the index in [imagePaths] to remove.
class ImageStripWidget extends ConsumerWidget {
  final List<String> imagePaths;
  final void Function(String path) onAddImage;
  final void Function(int index) onRemove;
  final bool readOnly;

  const ImageStripWidget({
    super.key,
    required this.imagePaths,
    required this.onAddImage,
    required this.onRemove,
    this.readOnly = false,
  });

  Future<void> _pickAndSave(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    final path = await ref.read(imageServiceProvider).pickAndSave(source);
    if (path != null) onAddImage(path);
  }

  void _showSourceSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndSave(context, ref, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickAndSave(context, ref, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 104,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (!readOnly)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => _showSourceSheet(context, ref),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
          for (int i = 0; i < imagePaths.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imagePaths[i].startsWith('http')
                        ? Image.network(
                            imagePaths[i],
                            width: 80,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 88,
                              color: colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          )
                        : Image.file(
                            io.File(imagePaths[i]),
                            width: 80,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 88,
                              color: colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                  ),
                  if (!readOnly)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: GestureDetector(
                        onTap: () => onRemove(i),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: colorScheme.error,
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
