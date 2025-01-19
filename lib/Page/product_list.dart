import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:project_app/Page/Product.dart';
import 'package:project_app/Page/cart_model.dart';
import 'package:project_app/Page/cart_provider.dart';
import 'package:project_app/Page/db_helper.dart';
import 'package:project_app/Page/product_list.dart';
import 'package:project_app/Page/BasePage.dart';
import 'package:project_app/utils/BtnPage.dart';
import 'package:provider/provider.dart';
import 'BasePage.dart';
import 'dart:convert';
import 'Product.dart';

// final Logger log = Logger();
//
// class ProductGridViewPage extends StatefulWidget {
//
//   @override
//   State createState() => ProductGridViewPageState();
// }
//
// class ProductGridViewPageState extends State<ProductGridViewPage> {
//   DBHelper dbHelper = DBHelper();
//   List<Product> products = [];
//   List<String> routes = ['/', '/product', '/about', '/Cart', '/User'];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }
//
//   Future<void> fetchProducts() async {
//     final String jsonString =
//         await rootBundle.loadString('assets/products.json');
//     final List<dynamic> jsonData = jsonDecode(jsonString);
//     var personList = jsonData.map((item) => Product.fromJson(item)).toList();
//     setState(() {
//       products = personList;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context);
//     Widget body = OrientationBuilder(builder: (context, orientation) {
//       // Check orientation and set crossAxisCount accordingly
//       int crossAxisCount = orientation == Orientation.portrait ? 1 : 3;
//
//       return GridView.builder(
//         padding: const EdgeInsets.all(8.0),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: crossAxisCount,
//           childAspectRatio: 2 / 3,
//           crossAxisSpacing: 8.0,
//           mainAxisExtent: 200.0,
//         ),
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           Product product = products[index];
//           return Card(
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Image.network(
//                     product.imageUrl,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded /
//                                   loadingProgress.expectedTotalBytes!
//                               : null,
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(child: Text('Image not available'));
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     product.name,
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: Text(
//                     '${product.price.toStringAsFixed(2)} บาท',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: InkWell(
//                     onTap: () {
//
//                     },
//                     child: Container(
//                       height: 35,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                       ),
//                       child: const Center(
//                         child: Text('Add to Card'),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       );
//     });
//     return BasePage(body: body, index: 1);
//   }
// }

void main() => runApp(MaterialApp(home: ProductPage()));

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});
  @override
  _ProductPage createState() => _ProductPage();
}

class _ProductPage extends State<ProductPage> {
  DBHelper? dbHelper = DBHelper();
  List<String> productName = ['Cat Lick', 'CatFood', 'Dog Gummy', 'DogFood'];
  List<int> productQuantity = [10, 20, 30, 40];
  List<int> productPrice = [15, 25, 35, 45];

  List<String> productImage = [
    'assets/images/CatLick.jpg',
    'assets/images/CatFood.jpg',
    'assets/images/Dog Gummy.jpg',
    'assets/images/DogFood.jpg'
  ];



  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    Widget body = Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  image: Image.asset(productImage[index]).image,
                                  height: 100,
                                  width: 100,
                                ),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5,),
                                        Text(" " +
                                            productName[index].toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " ราคา " + productPrice[index].toString() + " บาท",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " จำนวณคงเหลือ " + productQuantity[index].toString() + " ชิ้น",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5,),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: (){
                                              dbHelper!.insert(
                                                  Cart(
                                                    id: index,
                                                    productId: index.toString(),
                                                    productName: productName[index].toString(),
                                                    initialPrice: productPrice[index],
                                                    productPrice: productPrice[index],
                                                    productQuantity: productQuantity[index],
                                                    productImage: productImage[index],
                                                    quantity: 1,
                                                  )
                                              ).then((Value){
                                                print("Added to Cart");
                                                cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                                cart.addCounter();
                                              }).onError((erorr, stackTrace){
                                                print(erorr.toString());
                                              });
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text("Add to Cart",
                                                    style: TextStyle(
                                                        color: Colors.white,fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                )

                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),

        ],
      ),
    );
    return BasePage(body: body, index: 1);
  }
}

