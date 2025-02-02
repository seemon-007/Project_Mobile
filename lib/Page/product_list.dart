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
  List<String> productCategory = ['Cat', 'Cat', 'Dog', 'Dog'];

  List<String> productImage = [
    'assets/images/CatLick.jpg',
    'assets/images/CatFood.jpg',
    'assets/images/Dog Gummy.jpg',
    'assets/images/DogFood.jpg'
  ];

  String searchQuery = ""; // ตัวแปรสำหรับค้นหา
  String selectedCategory = "All"; // ตัวแปรสำหรับประเภทสินค้า (สุนัข/แมว)

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    // กรองสินค้า
    List<int> filteredIndexes = [];
    for (int i = 0; i < productName.length; i++) {
      if ((selectedCategory == "All" || productCategory[i] == selectedCategory) &&
          (searchQuery.isEmpty || productName[i].toLowerCase().contains(searchQuery.toLowerCase()))) {
        filteredIndexes.add(i);
      }
    }

    Widget body = Scaffold(
      body: Column(
        children: [

          // ส่วนค้นหาและเลือกชนิดสินค้า
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "ค้นหาสินค้า",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: [
                    DropdownMenuItem(value: "All", child: Text("ทั้งหมด")),
                    DropdownMenuItem(value: "Dog", child: Text("สุนัข")),
                    DropdownMenuItem(value: "Cat", child: Text("แมว")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          // ส่วนรายการสินค้า
          Expanded(
            child: ListView.builder(
              itemCount: filteredIndexes.length,
              itemBuilder: (context, index) {
                int productIndex = filteredIndexes[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage(productImage[productIndex]),
                          height: 100,
                          width: 100,
                        ),
                        Expanded(

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName[productIndex],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("ราคา ${productPrice[productIndex]} บาท"),
                              Text("จำนวนคงเหลือ ${productQuantity[productIndex]} ชิ้น"),
                              // Text("ประเภท: ${productCategory[productIndex]}"),
                            ],
                          ),
                        ),

                        //ปุ่มสำหรับการเพิ่มลงตะกร้า
                        ElevatedButton(
                          onPressed: () {
                            dbHelper!.insert(
                              Cart(
                                id: productIndex,
                                productId: productIndex.toString(),
                                productName: productName[productIndex],
                                initialPrice: productPrice[productIndex],
                                productPrice: productPrice[productIndex],
                                productQuantity: productQuantity[productIndex],
                                productImage: productImage[productIndex],
                                quantity: 1,
                              ),
                            ).then((value) {
                              cart.addTotalPrice(productPrice[productIndex].toDouble());
                              cart.addCounter();
                            });
                            showDialog(context: context, builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("เพิ่มลงตะกร้าสินค้าสําเร็จ"),
                                actions: [
                                  TextButton(
                                    child: Text("ตกลง"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // สีพื้นหลังของปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // ขอบมน
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ระยะขอบด้านใน
                          ),
                          child: Text(
                            "เพิ่มลงตะกร้า",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
    return BasePage(body: body, index: 1);
  }
}
