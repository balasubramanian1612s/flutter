import 'package:flutter/material.dart';
import 'package:meal_ap/dummy_data.dart';
import 'package:meal_ap/models/meal.dart';
import 'package:meal_ap/widgets/meal_item.dart';

class CategoryMealsScreen extends StatelessWidget {
// final String categoryID;
// final String categoryTitle;
// final Color categoryColor;

final List<Meal> availableMeals;

CategoryMealsScreen(this.availableMeals);

// CategoryMealsScreen({this.categoryID,this.categoryTitle,this.categoryColor});
  static String routeName = 'Category-Meals';
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map;
    final categoryTitle = routeArgs['title'];
    final categoryID = routeArgs['id'];
    final categoryMeals =availableMeals.where((meal) {
      return meal.categories.contains(categoryID);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(title: categoryMeals[index].title, duration: categoryMeals[index].duration, imageUrl: categoryMeals[index].imageUrl, affordability: categoryMeals[index].affordability, complexity: categoryMeals[index].complexity, id: categoryMeals[index].id,);
        },
        itemCount: categoryMeals.length,
      ),
    );
  }
}
