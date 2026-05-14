import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await _authService.getLoggedInUser();
    setState(() {
      _username = user ?? 'Pengguna';
    });
  }

  void _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryDark = Color(0xFF0F172A);
    const Color bgColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profil', style: TextStyle(color: primaryDark, fontSize: 15, fontWeight: FontWeight.w700)),
        centerTitle: true,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: Colors.black.withOpacity(0.04), height: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: const Icon(Icons.person_outline_rounded, size: 44, color: primaryDark),
            ),
            const SizedBox(height: 16),
            Text(_username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: primaryDark)),
            const SizedBox(height: 32),
            Container(height: 1, color: Colors.black.withOpacity(0.04)),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('KETERANGAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black45, letterSpacing: 0.5)),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Sistem keranjang belanja telah terenkapsulasi secara persisten berbasis akun pengguna lokal.',
                style: TextStyle(fontSize: 13, color: primaryDark, height: 1.5),
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _handleLogout,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.black.withOpacity(0.12)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  foregroundColor: primaryDark,
                ),
                child: const Text('KELUAR AKUN', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}