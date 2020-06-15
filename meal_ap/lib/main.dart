import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meal_ap/dummy_data.dart';
import 'package:meal_ap/screens/filters_screen.dart';
import 'package:meal_ap/screens/meal_detail_screen.dart';
import 'package:meal_ap/screens/tabs_screen.dart';
import './screens/categories_screen.dart';
import './screens/category_meals.dart';
import 'models/meal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'vegan': false,
    'vegetarian': false,
    'lactose': false
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouriteMeals=[];
  void _setFilters(Map<String, bool> filterData) {
    print(filterData);
    setState(() {
      _filters = filterData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) {
          print(meal);
          return false;
        } else if (_filters['vegan'] && !meal.isVegan) {
          print(meal);
          return false;
        } else if (_filters['vegetarian'] && !meal.isVegetarian) {
          print(meal);
          return false;
        } else if (_filters['lactose'] && !meal.isLactoseFree) {
          print(meal);
          return false;
        }
        return true;
      }).toList();
    });
  }

bool isMealFavourite(mealId){
  if(_favouriteMeals.any((meal)=>meal.id==mealId)){
    return true;
  }else{
    return false;
  }
}
  void toggleFavourite(String mealId){
    final existingIndex= _favouriteMeals.indexWhere((meal)=>meal.id==mealId);
    if(existingIndex==-1){
      
      setState(() {
        _favouriteMeals.add(DUMMY_MEALS.firstWhere((element) => element.id==mealId));
      });

    }else{
      setState(() {
        _favouriteMeals.removeAt(existingIndex);
      });
      

    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.green,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                body2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                title: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(20, 51, 51, 1)),
              )),
      title: 'Flutter Demo',
      // home: Navigator.of(context).pushNamed('/'),
      //initialRoute: '/',
      routes: {
        '/': (ctx) => TabScreen(_favouriteMeals),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(toggleFavourite,isMealFavourite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_setFilters,_filters),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },
    );
  }
}
