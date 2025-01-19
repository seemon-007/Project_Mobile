import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_app/Page/Home.dart';
import 'package:project_app/Page/register.dart';
import 'package:project_app/Page/HomePage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
        ),
        body:Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: userText,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),

              //login button
              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: ()
                {
                  // loginUser(); // เรียกฟังก์ชันเข้าสู่ระบบ
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LinkPage()));
                },
                icon: const Icon(Icons.login),
                label: const Text("Login"),
              ),

              //register button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => RegisterPage()));
                },
                icon: const Icon(Icons.person_add),
                label: const Text("Register"),
              ),

              TextField(
                controller: displayText,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        )
    );
  }
}

var displayText = TextEditingController();
var userText = TextEditingController();
var passwordText = TextEditingController();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


// void main() => runApp(MaterialApp(
//     navigatorKey: navigatorKey,
//     home: Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('Login Page')),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: userText,
//               decoration: InputDecoration(
//                 labelText: 'Username',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: passwordText,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//
//             //login button
//             const SizedBox(height: 24.0),
//             ElevatedButton.icon(
//               onPressed: () => Get.to(() => HomePage()),
//               // {
//               //   // loginUser(); // เรียกฟังก์ชันเข้าสู่ระบบ
//               //
//               // },
//               icon: const Icon(Icons.login),
//               label: const Text("Login"),
//             ),
//
//             //register button
//             ElevatedButton.icon(
//               onPressed: () {
//
//               },
//               icon: const Icon(Icons.person_add),
//               label: const Text("Register"),
//             ),
//
//             TextField(
//               controller: displayText,
//               keyboardType: TextInputType.multiline,
//               maxLines: null,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//               ),
//             ),
//           ],
//         ),
//       ),
//     )));

// void main() => runApp(LoginPage());
//
// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: userText,
//               decoration: InputDecoration(
//                 labelText: 'Username',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: passwordText,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//
//             //login button
//             const SizedBox(height: 24.0),
//             ElevatedButton.icon(
//               onPressed: () {
//                 loginUser(); // เรียกฟังก์ชันเข้าสู่ระบบ
//               },
//               icon: const Icon(Icons.login),
//               label: const Text("Login"),
//             ),
//
//             //register button
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterPage()),
//                 );
//               },
//               icon: const Icon(Icons.person_add),
//               label: const Text("Register"),
//             ),
//
//             TextField(
//               controller: displayText,
//               keyboardType: TextInputType.multiline,
//               maxLines: null,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// ฟังก์ชันสำหรับการเข้าสู่ระบบ
Future<void> loginUser() async {
  final String username = userText.text;
  final String password = passwordText.text;

  // เช็คว่าผู้ใช้กรอกข้อมูลหรือยัง
  if (username.isEmpty || password.isEmpty) {
    displayText.text = "Please enter username and password";
    return;
  }

  // ทำการเชื่อมต่อกับ API เพื่อตรวจสอบข้อมูลผู้ใช้
  final response = await http.post(
    Uri.parse('http://192.168.124.107:3000/login'), // API URL สำหรับตรวจสอบการเข้าสู่ระบบ
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // ถ้าการเข้าสู่ระบบสำเร็จ
    displayText.text = "Login successful!";
    // เปลี่ยนหน้าไปยังหน้าอื่น (เช่น Home page)
    Navigator.pushReplacement(
      navigatorKey.currentState!.context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  } else {
    // ถ้าการเข้าสู่ระบบไม่สำเร็จ
    displayText.text = "Invalid username or password";
  }
}

// หน้า Home เมื่อผู้ใช้เข้าสู่ระบบสำเร็จ
// class Home extends StatelessWidget {
//   const Home({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Home Page")),
//       body: Center(child: const Text("Welcome to the Home Page")),
//     );
//   }
// }
