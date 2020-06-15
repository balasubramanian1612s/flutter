import 'package:flutter/material.dart';
import 'package:meal_ap/screens/categories_screen.dart';
import 'package:meal_ap/widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static String routeName = 'filters';
  final Function setFilters;
  final Map<String, bool> _filters;
 

  FiltersScreen(this.setFilters,this._filters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _lactoseFree = false;
@override
  void initState() {
    _glutenFree=widget._filters['gluten'];
    _vegetarian=widget._filters['vegetarian'];
    _vegan=widget._filters['vegan'];
    _lactoseFree=widget._filters['lactose'];

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Filter'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                final selectedFilters = {
                  'gluten': _glutenFree,
                  'vegan': _vegan,
                  'vegetarian': _vegetarian,
                  'lactose': _lactoseFree
                };
                widget.setFilters(selectedFilters);
                Navigator.of(context).popAndPushNamed('/');
              },
            )
          ],
        ),
        drawer: MainDrawer(),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Adjust Your Meal Selection',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  SwitchListTile(
                    value: _glutenFree,
                    onChanged: (value) {
                      setState(() {
                        _glutenFree = value;
                      });
                    },
                    title: Text('Gluten-Free'),
                    subtitle: Text('Only Includes Gluten-Free'),
                  ),
                  SwitchListTile(
                    value: _vegetarian,
                    onChanged: (value) {
                      setState(() {
                        _vegetarian = value;
                      });
                    },
                    title: Text('Vegetarian'),
                    subtitle: Text('Only Includes Vegetarian'),
                  ),
                  SwitchListTile(
                    value: _vegan,
                    onChanged: (value) {
                      setState(() {
                        _vegan = value;
                      });
                    },
                    title: Text('Vegan'),
                    subtitle: Text('Only Includes Vegan'),
                  ),
                  SwitchListTile(
                    value: _lactoseFree,
                    onChanged: (value) {
                      setState(() {
                        _lactoseFree = value;
                      });
                    },
                    title: Text('Lactose-Free'),
                    subtitle: Text('Only Includes Lactose-Free'),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
