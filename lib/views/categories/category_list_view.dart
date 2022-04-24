import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/utilities/show_delete_dialog.dart';

typedef CategoryCallback = void Function(OperationCategory category);

class CategoryListView extends StatelessWidget {
  final Iterable<OperationCategory> categories;
  final CategoryCallback onDeleteCategory;
  final CategoryCallback onTap;

  const CategoryListView({
    Key? key,
    required this.categories,
    required this.onDeleteCategory,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(category);
          },
          title: Text(
            category.name,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteCategory(category);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
