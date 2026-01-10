import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<dynamic>> _future;

  static const roles = ['customer', 'seller', 'admin'];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final svc = Provider.of<UserService>(context, listen: false);
    setState(() {
      _future = svc.fetchUsers();
    });
  }

  Color _roleColor(String role, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    switch (role) {
      case 'admin':
        return Colors.red.withOpacity(.12);
      case 'seller':
        return primary.withOpacity(.12);
      default:
        return Colors.green.withOpacity(.12);
    }
  }

  Future<void> _showUserForm({Map<String, dynamic>? u}) async {
    final nameCtrl = TextEditingController(text: u?['name'] ?? '');
    final emailCtrl = TextEditingController(text: u?['email'] ?? '');
    String selectedRole = (u?['role'] ?? 'customer').toString();
    if (!roles.contains(selectedRole)) selectedRole = 'customer';

    final svc = Provider.of<UserService>(context, listen: false);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(u == null ? 'Tambah User' : 'Edit User'),
        content: StatefulBuilder(
          builder: (context, setLocal) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
                  items: roles.map((r) => DropdownMenuItem<String>(value: r, child: Text(r))).toList(),
                  onChanged: (v) => setLocal(() => selectedRole = v ?? 'customer'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final email = emailCtrl.text.trim();

              if (name.isEmpty || email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama dan email wajib diisi')),
                );
                return;
              }

              try {
                if (u == null) {
                  await svc.createUser(name, email, selectedRole);
                } else {
                  await svc.updateUser(
                    u['id'].toString(),
                    name: name,
                    email: email,
                    role: selectedRole,
                  );
                }
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal simpan user: $e')),
                );
                return;
              }

              if (!context.mounted) return;
              Navigator.pop(context);
              _reload();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(String id) async {
    final svc = Provider.of<UserService>(context, listen: false);
    try {
      await svc.deleteUser(id);
      _reload();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal hapus user: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengguna'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserForm(),
        icon: const Icon(Icons.person_add),
        label: const Text('Tambah'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));

          final users = snap.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('User kosong'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final u = users[i] as Map<String, dynamic>;
              final role = (u['role'] ?? 'customer').toString();

              return Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(.12),
                    child: const Icon(Icons.person),
                  ),
                  title: Text(u['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text(u['email'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _roleColor(role, context),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(role, style: const TextStyle(fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 6),
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _showUserForm(u: u)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(u['id'].toString()),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
