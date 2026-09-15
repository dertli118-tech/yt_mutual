import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const YtMutualApp());
}

class YtMutualApp extends StatelessWidget {
  const YtMutualApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YT Mutual',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFDC2626),
        scaffoldBackgroundColor: const Color(0xFFDC2626),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _oturumuKontrolEt();
  }

  Future<void> _oturumuKontrolEt() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    String? kaydedilenEmail = prefs.getString('aktif_kullanici_email');

    if (!mounted) return;

    if (kaydedilenEmail != null && kaydedilenEmail.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(userEmail: kaydedilenEmail),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Yt Mutual',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      String email = account?.email ?? "ytmutual@user.com";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('aktif_kullanici_email', email);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(userEmail: email),
          ),
        );
      }
    } catch (error) {
      String email = "ytmutual@user.com";
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('aktif_kullanici_email', email);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(userEmail: email),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: _handleGoogleSignIn,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
            child: const Text('Google ile Giriş Yap'),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String userEmail;
  const DashboardScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _puan = 6556;
  int _seciliTab = 0;

  Future<void> _puaniYukle() async {
    final prefs = await SharedPreferences.getInstance();
    int? emailPuani = prefs.getInt('kullanici_puani_${widget.userEmail}');
    setState(() {
      _puan = emailPuani ?? 6556;
    });
  }

  Future<void> _puanKaydet(int yeniPuan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('kullanici_puani_${widget.userEmail}', yeniPuan);
    setState(() {
      _puan = yeniPuan;
    });
  }

  @override
  void initState() {
    super.initState();
    _puaniYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Yt Mutual', style: TextStyle(color: Colors.black87)),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('$_puan Puan', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
      body: _seciliTab == 0 ? _buildKampanyaEkrani() : Center(child: Text('Sayfa $_seciliTab')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _seciliTab,
        onTap: (index) => setState(() => _seciliTab = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Kampanya'),
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'İzle'),
          BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: 'Abone Ol'),
        ],
      ),
    );
  }

  Widget _buildKampanyaEkrani() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Kampanya Bulunamadı', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateCampaignScreen(
                      mevcutPuan: _puan,
                      onKampanyaOlustur: (maliyet) {
                        _puanKaydet(_puan - maliyet);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Kampanya Oluştur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateCampaignScreen extends StatefulWidget {
  final int mevcutPuan;
  final Function(int) onKampanyaOlustur;

  const CreateCampaignScreen({Key? key, required this.mevcutPuan, required this.onKampanyaOlustur}) : super(key: key);

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final TextEditingController _urlController = TextEditingController();
  int _adet = 25;
  int _sure = 60;

  int get _maliyet => _adet * _sure;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanya Oluştur'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Video Bağlantı Adresi (URL)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Seçilen Adet: $_adet | Süre: $_sure sn', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text('Toplam Maliyet: $_maliyet Puan', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (widget.mevcutPuan < _maliyet) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Yetersiz Puan!')),
                    );
                    return;
                  }
                  widget.onKampanyaOlustur(_maliyet);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kampanya Başarıyla Oluşturuldu!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Kampanyayı Tamamla', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
