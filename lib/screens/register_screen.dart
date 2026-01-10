// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/user_service.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _name = TextEditingController();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   bool _loading = false;

//   void _submit() async {
//     setState(() => _loading = true);
//     try {
//       final svc = Provider.of<UserService>(context, listen: false);
//       await svc.register(_name.text.trim(), _email.text.trim(), _password.text.trim());
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Register failed: $e')));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Register')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
//             TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
//             TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
//             const SizedBox(height: 16),
//             _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _submit, child: const Text('Register')),
//           ],
//         ),
//       ),
//     );
//   }
// }
