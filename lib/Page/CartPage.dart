import 'package:flutter/material.dart';
import 'package:project_app/utils/BtnPage.dart';
import 'package:project_app/Page/BasePage.dart';
import 'package:project_app/Page/payment.dart';
import 'package:project_app/Page/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_app/Page/product_list.dart';
import 'package:project_app/Page/db_helper.dart';
import 'package:project_app/Page/cart_model.dart';

import 'cart_model.dart';

// class CartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context){
//     @override
//     Widget body = Container(
//       alignment: Alignment.bottomCenter,
//       child: ElevatedButton(
//           onPressed: (){
//             Navigator.pushNamed(context, '/Payment');
//           },
//           child: const Text("Submit")
//       ),
//     );
//     return BasePage(body: body, index: 2);
//   }
// }

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DBHelper? dbHelper = DBHelper();
  String? _deliveryMethod = "pickup"; // ตัวเลือกเริ่มต้น "รับที่ร้าน"
  int _deliveryFee = 0; // ค่าบริการขนส่งเริ่มต้น

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    Widget body = Scaffold(
      body: Column(
        children: [
          // รายการสินค้า (สามารถเลื่อนได้)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: cart.getDate(),
                    builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(), // ปิดการ Scroll ภายใน ListView
                          shrinkWrap: true, // ปรับขนาดตามเนื้อหา
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // แสดงภาพสินค้า
                                    Image(
                                      image: snapshot.data![index].productImage != null &&
                                          snapshot.data![index].productImage!.startsWith("http")
                                          ? NetworkImage(snapshot.data![index].productImage!)
                                          : AssetImage('${snapshot.data![index].productImage}') as ImageProvider,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 10),
                                    // ชื่อสินค้าและราคา
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data![index].productName.toString(),
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "${snapshot.data![index].productPrice.toString()} บาท",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        dbHelper!.delete(snapshot.data![index].id!).then((value) {
                                          cart.removeTotalPrice(
                                              double.parse(snapshot.data![index].productPrice.toString()));
                                          setState(() {
                                            cart.getDate(); // รีเฟรชข้อมูลรายการ
                                          });
                                        });
                                      },
                                    ),
                                    // แถบปุ่ม + - และจำนวนสินค้า
                                    Container(
                                      height: 35,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // ปุ่ม -
                                            InkWell(
                                              onTap: () {
                                                int quantity = snapshot.data![index].quantity!;
                                                int price = snapshot.data![index].initialPrice!;
                                                if (quantity > 1) {
                                                  quantity--;
                                                  int newPrice = quantity * price;

                                                  dbHelper!.updateQuantite(
                                                    Cart(
                                                      id: snapshot.data![index].id,
                                                      productId: snapshot.data![index].id?.toString(),
                                                      productName: snapshot.data![index].productName,
                                                      initialPrice: snapshot.data![index].initialPrice,
                                                      productPrice: newPrice,
                                                      productQuantity: quantity,
                                                      quantity: quantity,
                                                      productImage: snapshot.data![index].productImage.toString(),
                                                    ),
                                                  ).then((value) {
                                                    cart.removeTotalPrice(
                                                        double.parse(snapshot.data![index].initialPrice.toString()));
                                                  });
                                                }
                                              },
                                              child: Icon(Icons.remove, color: Colors.white),
                                            ),
                                            // จำนวนสินค้า
                                            Text(
                                              snapshot.data![index].quantity.toString(),
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            // ปุ่ม +
                                            InkWell(
                                              onTap: () {
                                                int quantity = snapshot.data![index].quantity!;
                                                int price = snapshot.data![index].initialPrice!;
                                                quantity++;
                                                int newPrice = quantity * price;

                                                dbHelper!.updateQuantite(
                                                  Cart(
                                                    id: snapshot.data![index].id,
                                                    productId: snapshot.data![index].id?.toString(),
                                                    productName: snapshot.data![index].productName,
                                                    initialPrice: snapshot.data![index].initialPrice,
                                                    productPrice: newPrice,
                                                    productQuantity: quantity,
                                                    quantity: quantity,
                                                    productImage: snapshot.data![index].productImage.toString(),
                                                  ),
                                                ).then((value) {
                                                  cart.addTotalPrice(
                                                      double.parse(snapshot.data![index].initialPrice.toString()));
                                                });
                                              },
                                              child: Icon(Icons.add, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // ส่วนราคารวมและปุ่มชำระเงิน (ติดด้านล่างสุด)
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery method selection (Horizontal)
                Text(
                  "วิธีรับสินค้า",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _deliveryMethod = "pickup";
                            _deliveryFee = 0; // No fee for pickup
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: _deliveryMethod == "pickup" ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              "มารับที่ร้าน",
                              style: TextStyle(
                                color: _deliveryMethod == "pickup" ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _deliveryMethod = "delivery";
                            _deliveryFee = 50; // Example delivery fee
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: _deliveryMethod == "delivery" ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              "จัดส่งสินค้า",
                              style: TextStyle(
                                color: _deliveryMethod == "delivery" ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(), // Add a divider for better UI separation
                ReusableWidget(title: "ราคาสินค้าทั้งหมด", value: cart.getTotalPrice()),
                ReusableWidget(title: "ค่าจัดส่ง", value: _deliveryFee.toDouble()),
                ReusableWidget(
                  title: "ราคารวม",
                  value: cart.getTotalPrice() + _deliveryFee,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Payment', arguments: {
                      "deliveryMethod": _deliveryMethod,
                      "totalPrice": cart.getTotalPrice() + _deliveryFee,
                    }); // Pass delivery method to Payment page
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("ชำระเงิน",style: TextStyle(fontSize: 20,color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return BasePage(body: body, index: 2);
  }
}





class ReusableWidget extends StatelessWidget {
  final String title;
  final double value; // เปลี่ยนเป็น double

  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(
            value < 0 ? "0 บาท" : "${value.toStringAsFixed(2)} บาท", // ป้องกันติดลบ
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}



// child: Container(
// alignment: Alignment.bottomCenter,
// child: ElevatedButton(
// onPressed: () {
// Navigator.pushNamed(context, '/Payment');
// },
// child: const Text("Submit")
// ),
// ),
