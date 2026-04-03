import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/database_helper.dart';
import '../../domain/models/recipe.dart';

/// Repository for recipe CRUD operations
/// Wraps DatabaseHelper with domain-model conversions and image downloading
class RecipeRepository {
  static final RecipeRepository instance = RecipeRepository._();
  RecipeRepository._();

  final _uuid = const Uuid();

  /// Insert a new recipe, downloading the image if [imageUrl] is provided.
  Future<String> addRecipe({
    required String title,
    required List<String> ingredients,
    required List<String> instructions,
    String? imageUrl,
    String? sourceUrl,
    String? yield_,
    String? prepTime,
    String? cookTime,
    List<String> tags = const [],
  }) async {
    // Download image if URL provided
    String? localImagePath;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      localImagePath = await _downloadImage(imageUrl);
    }

    final recipeMap = {
      'title': title,
      'url': sourceUrl,
      'image': localImagePath,
      'ingredients': jsonEncode(ingredients),
      'instructions': jsonEncode(instructions),
      'yield': yield_,
      'prepTime': prepTime,
      'cookTime': cookTime,
    };

    final id = await DatabaseHelper.instance.insertRecipe(recipeMap);

    // Add tags
    for (final tag in tags) {
      await DatabaseHelper.instance.addTagToRecipe(id, tag);
    }

    return id;
  }

  /// Download image from URL, compress to max 800px / JPEG quality 80
  /// (NFR-202: cover images must be < 300 KB), and save to documents directory.
  Future<String?> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) return null;

      // Decode and compress – same logic as StepPhotoService
      final original = img.decodeImage(response.bodyBytes);
      if (original == null) return null;

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
      final imagesDir = Directory('${dir.path}/recipes/images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final filename = '${_uuid.v4()}.jpg';
      final file = File('${imagesDir.path}/$filename');
      await file.writeAsBytes(compressed);

      return file.path;
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }

  /// Get all recipes with their tags and step photos
  Future<List<Recipe>> getAllRecipes() async {
    final maps = await DatabaseHelper.instance.getAllRecipes();
    final recipes = <Recipe>[];

    for (final map in maps) {
      final id = map['id'] as String;
      final tags = await DatabaseHelper.instance.getRecipeTags(id);
      final stepPhotos = await DatabaseHelper.instance.getStepPhotos(id);
      recipes.add(Recipe.fromMap(map, tags: tags, stepPhotos: stepPhotos));
    }

    return recipes;
  }

  /// Get a single recipe by ID
  Future<Recipe?> getRecipe(String id) async {
    final map = await DatabaseHelper.instance.getRecipe(id);
    if (map == null) return null;
    final tags = await DatabaseHelper.instance.getRecipeTags(id);
    final stepPhotos = await DatabaseHelper.instance.getStepPhotos(id);
    return Recipe.fromMap(map, tags: tags, stepPhotos: stepPhotos);
  }

  /// Search recipes by title or ingredient
  Future<List<Recipe>> searchRecipes(String query) async {
    final maps = await DatabaseHelper.instance.searchRecipes(query);
    final recipes = <Recipe>[];
    for (final map in maps) {
      final id = map['id'] as String;
      final tags = await DatabaseHelper.instance.getRecipeTags(id);
      final stepPhotos = await DatabaseHelper.instance.getStepPhotos(id);
      recipes.add(Recipe.fromMap(map, tags: tags, stepPhotos: stepPhotos));
    }
    return recipes;
  }

  /// Update an existing recipe
  Future<void> updateRecipe(Recipe recipe) async {
    await DatabaseHelper.instance.updateRecipe(recipe.id, {
      'title': recipe.title,
      'url': recipe.sourceUrl,
      'image_path': recipe.imageLocalPath,
      'ingredients': jsonEncode(recipe.ingredients),
      'instructions': jsonEncode(recipe.instructions),
      'yield': recipe.yield_,
      'prep_time': recipe.prepTime,
      'cook_time': recipe.cookTime,
    });
  }

  /// Delete a recipe and its local image and step photos
  Future<void> deleteRecipe(String id) async {
    final recipe = await getRecipe(id);
    if (recipe?.imageLocalPath != null) {
      final file = File(recipe!.imageLocalPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    // Delete all step photo files
    if (recipe != null) {
      for (final photoPath in recipe.stepPhotos.values) {
        final file = File(photoPath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await DatabaseHelper.instance.deleteRecipe(id);
  }

  /// Save a step photo for an existing recipe.
  /// Replaces (and deletes) any existing photo for that step.
  Future<void> setStepPhoto(String recipeId, int stepIndex, String photoPath) async {
    // Delete old photo file if replacing
    final existing = await DatabaseHelper.instance.getStepPhotos(recipeId);
    if (existing.containsKey(stepIndex)) {
      final oldFile = File(existing[stepIndex]!);
      if (await oldFile.exists()) await oldFile.delete();
    }
    await DatabaseHelper.instance.setStepPhoto(recipeId, stepIndex, photoPath);
  }

  /// Remove a step photo for an existing recipe.
  Future<void> deleteStepPhoto(String recipeId, int stepIndex) async {
    final existing = await DatabaseHelper.instance.getStepPhotos(recipeId);
    if (existing.containsKey(stepIndex)) {
      final file = File(existing[stepIndex]!);
      if (await file.exists()) await file.delete();
    }
    await DatabaseHelper.instance.deleteStepPhoto(recipeId, stepIndex);
  }

  /// Get total recipe count
  Future<int> getRecipeCount() => DatabaseHelper.instance.getRecipeCount();

  /// Add a tag to a recipe
  Future<void> addTag(String recipeId, String tagName) =>
      DatabaseHelper.instance.addTagToRecipe(recipeId, tagName);

  /// Remove a tag from a recipe
  Future<void> removeTag(String recipeId, String tagName) =>
      DatabaseHelper.instance.removeTagFromRecipe(recipeId, tagName);

  /// Export all recipes as JSON string
  Future<String> exportAllAsJson() =>
      DatabaseHelper.instance.exportAllRecipesAsJson();

  /// Import recipes from JSON string
  Future<int> importFromJson(String jsonString) =>
      DatabaseHelper.instance.importRecipesFromJson(jsonString);
}
