import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/utilities/dialogs/show_delete_dialog.dart';

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
    TextStyle subtitleStyle = const TextStyle(fontSize: 15.0);
    return Scaffold(
      //body:
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories.elementAt(index);
                return Slidable(
                  actionPane: const SlidableDrawerActionPane(),
                  actionExtentRatio: 0.45,
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.all(10.0),
                                    margin: const EdgeInsets.only(
                                        left: 150.0, right: 100.0),
                                    width: 100.0,
                                    child: Text(
                                      category.name,
                                      textAlign: TextAlign.center,
                                      style: subtitleStyle,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async {
                        final shouldDelete = await showDeleteDialog(context);
                        if (shouldDelete) {
                          onDeleteCategory(category);
                        }
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.green,
                      icon: Icons.edit,
                      onTap: () {
                        onTap(category);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
