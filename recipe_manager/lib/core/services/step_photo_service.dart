import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Handles compressing and persisting per-step photos (FR-033).
class StepPhotoService {
  static final StepPhotoService instance = StepPhotoService._();
  StepPhotoService._();

  final _uuid = const Uuid();

  /// Compresses [sourceFile] to max 800px on the longest side at JPEG quality
  /// 80 and saves it to `<documents>/step_photos/<uuid>.jpg`.
  /// Returns the saved file path, or null if compression fails.
  Future<String?> compressAndSave(File sourceFile) async {
    try {
      final bytes = await sourceFile.readAsBytes();
      final original = img.decodeImage(bytes);
      if (original == null) return null;

      // Resize to max 800px on the longest side, preserving aspect ratio
      img.Image resized;
      if (original.width >= original.height && original.width > 800) {
        resized = img.copyResize(original, width: 800);
      } else if (original.height > original.width && original.height > 800) {
        resized = img.copyResize(original, height: 800);
      } else {
        resized = original;
      }

      final compressed = img.encodeJpg(resized, quality: 80);

      final dir = await getApplicationDocumentsDirectory();
      final stepPhotosDir = Directory('${dir.path}/step_photos');
      if (!await stepPhotosDir.exists()) {
        await stepPhotosDir.create(recursive: true);
      }

      final filename = '${_uuid.v4()}.jpg';
      final dest = File('${stepPhotosDir.path}/$filename');
      await dest.writeAsBytes(compressed);

      return dest.path;
    } catch (e) {
      debugPrint('StepPhotoService: error compressing photo: $e');
      return null;
    }
  }

  /// Deletes a photo file at [path] if it exists.
  Future<void> deletePhoto(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (e) {
      debugPrint('StepPhotoService: error deleting photo: $e');
    }
  }
}
