import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  bool isLoading=true;
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProducts(true);
  }
  
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value){
     Provider.of<Products>(context).fetchAndSetProducts(true).then((_) {
        setState(() {
          isLoading = false;
        });
      });

    } );
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //bool isLoading=true;
    //final productsDataloader = Provider.of<Products>(context).fetchAndSetProducts(true);
    final productsData = Provider.of<Products>(context);
    // setState(() {
    //   isLoading=false;
    // });

    print("rebuilding....");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: 
      // FutureBuilder(
      //   future: _refreshProducts(context),
      //   builder: (ctx, snapshot)=>snapshot.connectionState==ConnectionState.waiting?Center(child:CircularProgressIndicator()): 
       isLoading?Center(child: CircularProgressIndicator(),): RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child:
          // Consumer<Products>(
          //     builder: (ctx,productsData, child)=>
              Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, i) => Column(
                    children: [
                      UserProductItem(
                        productsData.items[i].id,
                        productsData.items[i].title,
                        productsData.items[i].imageUrl,
                      ),
                      Divider(),
                    ],
                  ),
            ),
          ),
          //) 
        ),
               
     // ),
    );
  }
}
