import 'package:flutter/cupertino.dart';
import 'package:project_app/Page/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db_helper.dart';
class CartProvider with ChangeNotifier {

  DBHelper db = DBHelper();
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0 ;
  double get totalprice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getDate() async {
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItem() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItem() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
    notifyListeners();
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItem();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    if (_totalPrice < 0) {
      _totalPrice = 0; // ป้องกันราคารวมติดลบ
    }
    _setPrefItem();
    notifyListeners();
  }


  double getTotalPrice() {
    if (_totalPrice < 0) {
      return 0.0; // ป้องกันการแสดงผลราคารวมติดลบ
    }
    return _totalPrice;
  }

  void addCounter() {
    _counter++;
    _setPrefItem();
    notifyListeners();
  }

  void removerCounter() {
    _counter--;
    _setPrefItem();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItem();
    return _counter;
  }

  void clearCart() async {
    DBHelper db = DBHelper();
    await db.initDatabase(); // Initialize database
    var dbClient = await db.db;
    await dbClient!.delete('cart'); // ลบสินค้าทั้งหมดจากฐานข้อมูล
    _totalPrice = 0.0; // รีเซ็ตราคารวม
    _counter = 0; // รีเซ็ตจำนวนสินค้า
    notifyListeners();
  }


}
