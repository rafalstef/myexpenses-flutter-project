import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/category/firebase_category.dart';
import 'package:myexpenses/utilities/generics/get_arguments.dart';

class CreateUpdateCategoryView extends StatefulWidget {
  const CreateUpdateCategoryView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateCategoryView> createState() =>
      _CreateUpdateCategoryViewState();
}

class _CreateUpdateCategoryViewState extends State<CreateUpdateCategoryView> {
  OperationCategory? _category;
  late final FirebaseCategory _categoryService;
  late final TextEditingController _nameController;
  bool _isIncomeValue = false;

  @override
  void initState() {
    _categoryService = FirebaseCategory();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    final newName = _nameController.text;

    if (newName.isEmpty) {
      return;
    }

    if (_category == null) {
      final currentUser = AuthService.firebase().currentUser;
      final userId = currentUser!.id;
      final newCategory =
          await _categoryService.createNewCategory(ownerUserId: userId);
      _category = newCategory;
    }

    await _categoryService.updateCategory(
      documentId: _category!.documentId,
      name: newName,
      isIncome: _isIncomeValue,
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      categoryViewRoute,
      (_) => false,
    );
  }

  Future<OperationCategory?> getExistingCategory(BuildContext context) async {
    final widgetCategory = context.getArgument<OperationCategory>();

    if (widgetCategory == null) {
      return null;
    }

    _category = widgetCategory;
    _nameController.text = widgetCategory.name;
    return widgetCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Category'),
      ),
      body: FutureBuilder(
        future: getExistingCategory(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Category name',
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Income'),
                    value: _isIncomeValue,
                    onChanged: (value) {
                      setState(() {
                        _isIncomeValue = value;
                      });
                    },
                    activeTrackColor: const Color.fromARGB(255, 89, 119, 255),
                    activeColor: const Color.fromARGB(255, 25, 28, 185),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _saveCategory();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
