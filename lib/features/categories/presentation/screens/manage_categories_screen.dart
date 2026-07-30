import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kakeibo/features/categories/domain/entities/category.dart';
import 'package:kakeibo/features/categories/presentation/providers/category_provider.dart';
import 'package:kakeibo/features/categories/presentation/widgets/icon_picker_grid.dart';
import 'package:kakeibo/features/categories/presentation/widgets/color_picker_row.dart';
import 'package:kakeibo/core/theme/app_colors.dart';
import 'package:kakeibo/core/utils/category_utils.dart';

class ManageCategoriesScreen extends ConsumerWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoryNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Manage Categories', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: categoriesState.when(
        loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
        error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: Theme.of(context).colorScheme.error))),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: categories.length,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final List<Category> updated = List.from(categories);
              final item = updated.removeAt(oldIndex);
              updated.insert(newIndex, item);
              ref.read(categoryNotifierProvider.notifier).reorder(updated);
            },
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryTile(
                key: ValueKey(category.id),
                category: category,
                index: index,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => _showCategoryDialog(context, ref),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, [Category? category]) {
    showDialog(
      context: context,
      builder: (ctx) => _CategoryDialog(category: category),
    ).then((result) {
      if (result != null && result is Category) {
        if (category == null) {
          ref.read(categoryNotifierProvider.notifier).addCategory(result);
        } else {
          ref.read(categoryNotifierProvider.notifier).updateCategory(result);
        }
      }
    });
  }
}

class _CategoryTile extends ConsumerWidget {
  final Category category;
  final int index;

  const _CategoryTile({super.key, required this.category, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryColor = AppColors.categoryColors[category.colorIndex % AppColors.categoryColors.length];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: categoryColor.withOpacity(0.2),
          child: Icon(CategoryUtils.getIcon(category.iconName), color: categoryColor),
        ),
        title: Text(category.name, style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => _CategoryDialog(category: category),
                ).then((result) {
                  if (result != null && result is Category) {
                    ref.read(categoryNotifierProvider.notifier).updateCategory(result);
                  }
                });
              },
            ),
            if (!category.isDefault)
              IconButton(
                icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Category?'),
                      content: Text('Are you sure you want to delete ${category.name}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(categoryNotifierProvider.notifier).deleteCategory(category.id!);
                            Navigator.pop(ctx);
                          },
                          child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const ReorderableDragStartListener(
              index: 0, // This is wrapped dynamically by ReorderableListView, but the handle visual needs to exist.
              // Actually, ReorderableListView automatically wraps the whole tile if we don't supply a trailing handle properly, 
              // but standard practice is a drag handle icon:
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.drag_handle, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(delay: (50 * index).ms).slideX(begin: 0.2);
  }
}

class _CategoryDialog extends StatefulWidget {
  final Category? category;
  const _CategoryDialog({this.category});

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  late TextEditingController _nameController;
  late String _selectedIcon;
  late int _selectedColorIndex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category?.iconName ?? 'shoppingBag';
    _selectedColorIndex = widget.category?.colorIndex ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.category == null ? 'New Category' : 'Edit Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Icon', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: IconPickerGrid(
                selectedIconName: _selectedIcon,
                onSelected: (name) => setState(() => _selectedIcon = name),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ColorPickerRow(
              selectedIndex: _selectedColorIndex,
              onSelected: (idx) => setState(() => _selectedColorIndex = idx),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty) return;
                    final category = Category(
                      id: widget.category?.id,
                      name: _nameController.text.trim(),
                      iconName: _selectedIcon,
                      colorIndex: _selectedColorIndex,
                      sortOrder: widget.category?.sortOrder ?? 0,
                      isDefault: widget.category?.isDefault ?? false,
                      createdAt: widget.category?.createdAt ?? DateTime.now(),
                    );
                    Navigator.pop(context, category);
                  },
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
