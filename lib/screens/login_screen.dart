// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/user_service.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   bool _loading = false;

//   void _submit() async {
//     setState(() => _loading = true);
//     try {
//       final svc = Provider.of<UserService>(context, listen: false);
//       await svc.login(_email.text.trim(), _password.text.trim());
//       Navigator.pushReplacementNamed(context, '/products');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
//             TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
//             const SizedBox(height: 16),
//             _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _submit, child: const Text('Login')),
//             TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Register')),
//           ],
//         ),
//       ),
//     );
//   }
// }
