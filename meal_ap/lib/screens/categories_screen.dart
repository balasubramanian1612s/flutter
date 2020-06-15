import 'package:flutter/material.dart';
import 'package:meal_ap/dummy_data.dart';
import '../widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Meals App'),
      // ),
        body: GridView(
          padding: const EdgeInsets.all(25),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 3 / 2),
      children: DUMMY_CATEGORIES
          .map((data) => CategoryItem(data.title, data.color,data.id))
          .toList(),
    ));
  }
}
