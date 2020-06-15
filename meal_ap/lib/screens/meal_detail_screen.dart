import 'package:flutter/material.dart';
import 'package:meal_ap/dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static String routeName = 'MealDetailScreen';

  final Function toggleFavourite;
  final Function isMealFavourite;
  MealDetailScreen(this.toggleFavourite,this.isMealFavourite);

  Widget buildSectionTitle(BuildContext context, sectionTitle) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Text(sectionTitle, style: Theme.of(context).textTheme.title));
  }

  Widget buildSectionListContent(BuildContext context, listContent, type) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)),
        height: type == "Ingredients" ? 200 : 400,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return Card(
                color: type == "Ingredients"
                      ? Theme.of(context).accentColor
                      :Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: type == "Ingredients"
                      ? Text(listContent[index])
                      : Column(
                        children: <Widget>[
                          ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  '${index + 1}',
                                ),
                              ),
                              title: Text(listContent[index]),
                            ),
                        ],
                      ),
                        
                ));
          },
          itemCount: listContent.length,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == id);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMeal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Image.network(
                selectedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            buildSectionTitle(context, "Ingredients"),
            buildSectionListContent(
                context, selectedMeal.ingredients, "Ingredients"),
            buildSectionTitle(context, "Steps"),
            buildSectionListContent(context, selectedMeal.steps, "Steps"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          isMealFavourite(id)?Icons.star:Icons.star_border
        ),
        onPressed: (){toggleFavourite(id);},
    ));
  }
}
