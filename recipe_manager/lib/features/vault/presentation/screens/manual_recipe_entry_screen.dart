import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/iap_service.dart';
import '../../../../core/services/step_photo_service.dart';
import '../../../../data/repositories/recipe_repository.dart';

/// Manual recipe entry screen.
/// Can be pre-filled with data from URL extraction (FR-004).
class ManualRecipeEntryScreen extends StatefulWidget {
  /// Pre-filled data from RecipeExtractor (may be null for blank entry)
  final Map<String, dynamic>? prefillData;

  /// The original URL that was extracted from
  final String? sourceUrl;

  const ManualRecipeEntryScreen({
    super.key,
    this.prefillData,
    this.sourceUrl,
  });

  @override
  State<ManualRecipeEntryScreen> createState() =>
      _ManualRecipeEntryScreenState();
}

class _ManualRecipeEntryScreenState extends State<ManualRecipeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _yieldController;
  late final TextEditingController _prepTimeController;
  late final TextEditingController _cookTimeController;
  late final TextEditingController _tagsController;

  /// Per-step controllers (replaces the single _instructionsController)
  final List<TextEditingController> _stepControllers = [];
  /// Per-step pending photo paths (index mirrors _stepControllers)
  final List<String?> _stepPhotoPaths = [];

  final _imagePicker = ImagePicker();

  bool _isSaving = false;
  String? _imageUrl;

  bool get _isPrefilled => widget.prefillData != null;

  @override
  void initState() {
    super.initState();
    final p = widget.prefillData;

    _titleController =
        TextEditingController(text: p?['title'] as String? ?? '');
    _urlController =
        TextEditingController(text: widget.sourceUrl ?? (p?['url'] as String? ?? ''));
    _ingredientsController =
        TextEditingController(text: p?['ingredients'] as String? ?? '');
    _yieldController =
        TextEditingController(text: p?['yield'] as String? ?? '');
    _prepTimeController =
        TextEditingController(text: p?['prepTime'] as String? ?? '');
    _cookTimeController =
        TextEditingController(text: p?['cookTime'] as String? ?? '');
    _tagsController = TextEditingController();

    _imageUrl = p?['image'] as String?;

    // Build per-step controllers from pre-fill data
    final rawInstructions = p?['instructions'] as String? ?? '';
    if (rawInstructions.isNotEmpty) {
      final steps = rawInstructions
          .split('\n\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      for (final step in steps) {
        _stepControllers.add(TextEditingController(text: step));
        _stepPhotoPaths.add(null);
      }
    }
    // Always have at least one step field
    if (_stepControllers.isEmpty) {
      _stepControllers.add(TextEditingController());
      _stepPhotoPaths.add(null);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _ingredientsController.dispose();
    _yieldController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _tagsController.dispose();
    for (final c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
      _stepPhotoPaths.add(null);
    });
  }

  void _removeStep(int index) {
    // Delete the pending photo file if any
    final path = _stepPhotoPaths[index];
    if (path != null) {
      StepPhotoService.instance.deletePhoto(path);
    }
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
      _stepPhotoPaths.removeAt(index);
    });
  }

  Future<void> _pickStepPhoto(int index) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await _imagePicker.pickImage(source: source);
    if (picked == null) return;

    // Delete old pending photo for this step if replacing
    final oldPath = _stepPhotoPaths[index];
    if (oldPath != null) {
      await StepPhotoService.instance.deletePhoto(oldPath);
    }

    final saved = await StepPhotoService.instance.compressAndSave(File(picked.path));
    if (saved != null && mounted) {
      setState(() {
        _stepPhotoPaths[index] = saved;
      });
    }
  }

  Future<void> _removeStepPhoto(int index) async {
    final path = _stepPhotoPaths[index];
    if (path != null) {
      await StepPhotoService.instance.deletePhoto(path);
    }
    setState(() {
      _stepPhotoPaths[index] = null;
    });
  }

  void _showPaywallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ChefStash Pro'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, size: 64, color: Color(0xFFE67E22)),
            SizedBox(height: 16),
            Text(
              "You've reached the free limit of 10 recipes. Unlock unlimited recipes with Pro.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await IAPService.instance.restorePurchases();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(IAPService.instance.isPremium
                        ? 'Pro restored! Thank you!'
                        : 'No previous purchase found.'),
                  ),
                );
              }
            },
            child: const Text('Restore'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await IAPService.instance.purchase();
              if (!context.mounted) return;
              Navigator.pop(context);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pro unlocked! Thank you!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE67E22),
            ),
            child: const Text('Upgrade — \$19.99'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    // FR-031: enforce 10-recipe free limit before saving
    if (!IAPService.instance.isPremium) {
      final count = await RecipeRepository.instance.getRecipeCount();
      if (count >= 10) {
        if (!mounted) return;
        _showPaywallDialog();
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      // Parse ingredients list (one per line)
      final ingredients = _ingredientsController.text
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // Build instructions list from per-step controllers
      final instructions = _stepControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // Parse tags (comma separated), only for premium
      List<String> tags = [];
      if (IAPService.instance.isPremium) {
        tags = _tagsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }

      final recipeId = await RecipeRepository.instance.addRecipe(
        title: _titleController.text.trim(),
        ingredients: ingredients,
        instructions: instructions,
        imageUrl: _imageUrl,
        sourceUrl: _urlController.text.trim().isEmpty
            ? null
            : _urlController.text.trim(),
        yield_: _yieldController.text.trim().isEmpty
            ? null
            : _yieldController.text.trim(),
        prepTime: _prepTimeController.text.trim().isEmpty
            ? null
            : _prepTimeController.text.trim(),
        cookTime: _cookTimeController.text.trim().isEmpty
            ? null
            : _cookTimeController.text.trim(),
        tags: tags,
      );

      // Save step photos using the aligned index (skip empty steps)
      int savedStepIndex = 0;
      for (int i = 0; i < _stepControllers.length; i++) {
        final text = _stepControllers[i].text.trim();
        if (text.isEmpty) continue;
        final photoPath = _stepPhotoPaths[i];
        if (photoPath != null) {
          await RecipeRepository.instance.setStepPhoto(recipeId, savedStepIndex, photoPath);
        }
        savedStepIndex++;
      }

      if (!mounted) return;

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe saved successfully!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving recipe: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = IAPService.instance.isPremium;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isPrefilled ? 'Confirm & Edit Recipe' : 'Add Recipe Manually'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveRecipe,
              child: const Text(
                'SAVE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Extraction notice if pre-filled
            if (_isPrefilled) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE67E22).withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color(0xFFE67E22).withAlpha(80)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome,
                        color: Color(0xFFE67E22), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Recipe extracted from URL — review and edit before saving.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title *',
                hintText: 'e.g., Classic Spaghetti Carbonara',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Source URL
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Source URL (optional)',
                hintText: 'https://example.com/recipe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            // Image section
            if (_imageUrl != null && _imageUrl!.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.image, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Image will be downloaded from URL',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _imageUrl = null),
                    tooltip: 'Remove image',
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],


            // Yield
            TextFormField(
              controller: _yieldController,
              decoration: const InputDecoration(
                labelText: 'Servings (optional)',
                hintText: 'e.g., 4 servings',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
            ),
            const SizedBox(height: 16),

            // Times row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _prepTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Prep Time',
                      hintText: 'PT15M',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cookTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Cook Time',
                      hintText: 'PT30M',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_fire_department),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tags (Premium only, FR-013)
            if (isPremium) ...[
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (Premium)',
                  hintText: 'Dinner, Vegan, Quick (comma-separated)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Custom tags — Premium feature',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Ingredients
            TextFormField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Ingredients *',
                hintText: 'One ingredient per line',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingredients are required';
                }
                return null;
              },
              maxLines: 10,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 4),
            Text(
              'Tip: One ingredient per line',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Instructions — per-step with optional photo (FR-033)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Instructions *',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Step'),
                  onPressed: _addStep,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(_stepControllers.length, (index) {
              final photoPath = _stepPhotoPaths[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step number badge
                        Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(top: 14, right: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE67E22),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        // Step text field
                        Expanded(
                          child: TextFormField(
                            controller: _stepControllers[index],
                            decoration: InputDecoration(
                              hintText: 'Describe step ${index + 1}',
                              border: const OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            validator: index == 0
                                ? (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'At least one step is required';
                                    }
                                    return null;
                                  }
                                : null,
                            maxLines: 4,
                            minLines: 2,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        // Remove step button
                        if (_stepControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: Colors.red),
                            tooltip: 'Remove step',
                            onPressed: () => _removeStep(index),
                          ),
                      ],
                    ),
                    // Step photo area (FR-033 — available to all users)
                    Padding(
                      padding: const EdgeInsets.only(left: 36, top: 6),
                      child: photoPath != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(photoPath),
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeStepPhoto(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _pickStepPhoto(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE67E22),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(Icons.camera_alt,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : OutlinedButton.icon(
                              icon: const Icon(Icons.add_a_photo, size: 18),
                              label: const Text('Add step photo'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                side:
                                    BorderSide(color: Colors.grey[400]!),
                              ),
                              onPressed: () => _pickStepPhoto(index),
                            ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Another Step'),
              onPressed: _addStep,
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveRecipe,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save Recipe'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE67E22),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
