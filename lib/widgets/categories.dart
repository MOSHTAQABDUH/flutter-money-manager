import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/category.dart';
import 'package:flutter_money_manager/routes/category_route.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';
import 'package:flutter_money_manager/widgets/category_future_builder.dart';

import 'color_circle.dart';

class Categories extends StatefulWidget {
  final onTap;
  final bool shrinkWrap;

  Categories({
    Key key,
    this.onTap,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<void> deleteCategory(BuildContext context, Category category) async {
    bool isCategoryExistInTransactionTable =
        await TransactionTable().isCategoryExist(category.id.toString());
    if (isCategoryExistInTransactionTable) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('${category.name} is using in transaction.')));

      return false;
    }

    int result = await CategoryTable().delete(category.id);
    if (result <= 0) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Fail to delete.')));

      return false;
    }

    setState(() {});

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Deleted successfully.')));
  }

  Widget _buildReorderableCategoryWidgets(List<Category> categories) {
    return ReorderableListView(
      children: categories.map((category) {
        return ListTile(
          key: Key(category.name),
          onTap: () => _showOptionsModalBottomSheet(
            context: context,
            category: category,
          ),
          leading: ColorCircle(color: category.color),
          title: Text(
            category.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          trailing: Text(category.transactionType.name),
        );
      }).toList(),
      onReorder: (int oldIndex, int newIndex) async {
        if (newIndex > oldIndex) newIndex--;

        Category c = categories.removeAt(oldIndex);
        categories.insert(newIndex, c);

        List<int> ids = [];
        List<int> values = [];

        if (newIndex > oldIndex) {
          for (int i = oldIndex; i <= newIndex; i++) {
            ids.add(categories[i].id);
            values.add(i + 1);
          }
        } else {
          for (int i = newIndex; i <= oldIndex; i++) {
            ids.add(categories[i].id);
            values.add(i + 1);
          }
        }

        await CategoryTable().updateColumn(
          ids: ids,
          column: CategoryTable().order,
          values: values,
        );

        setState(() {});
      },
    );
  }

  Widget _buildCategoryWidgets(List<Category> categories) {
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () => widget.onTap(context, categories[index]),
          leading: ColorCircle(color: categories[index].color),
          title: Text(
            categories[index].name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          trailing: Text(categories[index].transactionType.name),
        );
      },
      itemCount: categories.length,
    );
  }

  void _showOptionsModalBottomSheet({
    BuildContext context,
    Category category,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.edit),
                  title: new Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    _onTap(context, category);
                  }),
              new ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  deleteCategory(context, category);
                },
              ),
            ],
          );
        });
  }

  void _onTap(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryRoute(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CategoryFutureBuilder(
      loadingBuilderFn: (BuildContext context) {
        return Container(
          alignment: Alignment.center,
          child: new CircularProgressIndicator(),
        );
      },
      categoryListviewBuilderFn: (
        BuildContext context,
        List<Category> categories,
      ) {
        if (widget.shrinkWrap) {
          return _buildCategoryWidgets(categories);
        } else {
          return _buildReorderableCategoryWidgets(categories);
        }
      },
      emptyDataBuilderFn: (BuildContext context) {
        return Hint(
          iconData: Icons.format_list_bulleted,
          hint: 'Once you add a new category,'
              '\nyou\'ll see it listed here',
        );
      },
      errorBuilderFn: (BuildContext context, String error) {
        return Center(child: Text(error));
      },
      transactionType: null,
    );
  }
}
