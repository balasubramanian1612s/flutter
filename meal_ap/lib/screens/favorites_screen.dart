import 'package:flutter/material.dart';
import 'package:meal_ap/models/meal.dart';
import 'package:meal_ap/screens/category_meals.dart';
import 'package:meal_ap/widgets/meal_item.dart';

class FavouriteScreen extends StatelessWidget {
  final List<Meal> favouriteMeals;
  FavouriteScreen(this.favouriteMeals);
  @override
  Widget build(BuildContext context) {
    return favouriteMeals.length==0?Center(child:Text('Add Favourites to See Here!')): ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(title: favouriteMeals[index].title, duration: favouriteMeals[index].duration, imageUrl: favouriteMeals[index].imageUrl, affordability: favouriteMeals[index].affordability, complexity: favouriteMeals[index].complexity, id: favouriteMeals[index].id,);
        },
        itemCount: favouriteMeals.length,
      );
  }
}