import 'dart:ui';

import 'package:flutter/material.dart';
import './dummy_data.dart';
import '../screens/category_meals_screen.dart';
import '../screens/filters_screen.dart';
import '../screens/meal_detail_screen.dart';
import '../screens/tabs_screen.dart';
import 'models/meal.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String,bool> _filters = {
    'gluten' : false,
    'lactose': false,
    'vegan' : false,
    'vegetarian' : false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoritesMeal=[];
  void _setFilters(Map<String,bool> filterData){
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if((_filters['gluten']?? false) && !meal.isGlutenFree){
          return false;
        }
        if((_filters['lactose']?? false) && !meal.isLactoseFree){
          return false;
        }
        if((_filters['vegan']?? false) && !meal.isVegan){
          return false;
        }
        if((_filters['vegetarian']?? false) && !meal.isGlutenFree){
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId){
    final existingIndex = _favoritesMeal.indexWhere((meal) => meal.id == mealId);
    if(existingIndex >= 0){
      setState(() {
        _favoritesMeal.removeAt(existingIndex);
      });
    }else{
      setState(() {
        _favoritesMeal.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId),);
      });
    }
  }

  bool _isMealFavorite(String id){
    return _favoritesMeal.any((meal) => meal.id == id);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DailyMeals",
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
              bodyLarge: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              titleMedium: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ))),
     // home: CategoriesScreen(),
     initialRoute: '/',
      routes:{
        '/':(ctx) =>TabsScreen(_favoritesMeal),
        CategoryMealsScreen.routeName:(ctx)=> CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName:(ctx)=> MealDetailScreen(_toggleFavorite,_isMealFavorite),
        FiltersScreen.routeName:(ctx) => FiltersScreen(_setFilters,_filters),
      }
    );
  }
}
