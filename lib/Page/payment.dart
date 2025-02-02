import 'package:flutter/material.dart';
import 'package:project_app/Page/product_list.dart';
import 'BasePage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

// class PaymentPage extends StatefulWidget {
//   const PaymentPage({super.key});
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           const Center(
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Padding(padding: EdgeInsets.only(top: 10),
//               child: Text('Confirm Payment',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//             ),
//           ),
//           ),
//
//           const Expanded(
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(top: 10),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Enter your Location(GPS)',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.location_on),
//                       ),
//                     ),
//                   ),
//                   Padding(padding: EdgeInsets.only(top: 10),
//                   child: Text("Name",
//                   style: TextStyle(fontSize: 15),
//                   )),
//                   Padding(padding: EdgeInsets.only(top: 10),
//                       child: Text("Quantity",
//                         style: TextStyle(fontSize: 15),
//                       )),
//                 ],
//               ),
//             ),
//           ),
//
//           Padding(
//               padding: const EdgeInsets.only(bottom: 70),
//               child: ElevatedButton(
//               onPressed: () {
//                 showDialog(context: context, builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: const Text('Payment Confirmed'),
//                     content: const Text('Your payment has been confirmed.'),
//                     actions: [
//                       TextButton(
//                         child: const Text('OK'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//                 },);
//               },
//               child: Text('Submit'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _currentAddress = "กำลังค้นหาที่อยู่...";
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _currentAddress = "${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _currentAddress = "ไม่สามารถดึงตำแหน่งได้: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    double totalPrice = cartProvider.getTotalPrice();
    int totalItems = cartProvider.counter;
    double shippingCost = 50;
    double grandTotal = totalPrice + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: Text("สรุปการสั่งซื้อ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ที่อยู่จัดส่ง",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _currentAddress,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.my_location),
                  onPressed: _getCurrentLocation,
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              "สรุปคำสั่งซื้อ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ReusableWidget(title: "ราคาสินค้าทั้งหมด", value: totalPrice),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("จำนวนสินค้าทั้งหมด", style: TextStyle(fontSize: 16)),
                Text(
                  "$totalItems ชิ้น",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ReusableWidget(title: "ค่าจัดส่ง", value: shippingCost),
            ReusableWidget(title: "ราคารวม", value: grandTotal),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('การชำระเงินสำเร็จ'),
                      content: Text('ขอบคุณสำหรับการชำระเงิน!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            cartProvider.clearCart(); // Clear cart
                            Navigator.of(context).pop();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => ProductPage()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                          child: Text('ตกลง'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("ชำระเงิน"),
            ),
          ],
        ),
      ),
    );
  }
}

// ReusableWidget สำหรับแสดงข้อมูลแต่ละบรรทัด
class ReusableWidget extends StatelessWidget {
  final String title;
  final double value;

  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(
            "${value.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

