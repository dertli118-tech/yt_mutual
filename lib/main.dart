Harika bir tasarım! İstediğin gibi Kampanya Oluştur ekranını gönderdiğin görseldeki birebir düzene (bilgilendirme kutusu, video adres alanı, sekme seçenekleri, ayarlar ve dinamik maliyet hesaplama özellikleriyle) güncelledim.
🛠️ Güncellemeyi Uygulama Adımları:
 * GitHub'daki lib/main.dart dosyanı aç ve düzenleme moduna geç.
 * Tüm eski kodları silip aşağıdakini yapıştır.
 * "Commit changes" ile kaydet ve Codemagic'ten yeni APK'nı al.
📋 Güncel Kod (main.dart):
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
              child: Center(
                child: Container(
                  width: 0,
                  height: 0,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 12, color: Colors.transparent),
                      bottom: BorderSide(width: 12, color: Colors.transparent),
                      left: BorderSide(width: 20, color: Color(0xFFDC2626)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Yt Mutual',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
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
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 85,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Container(
                  width: 0,
                  height: 0,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 12, color: Colors.transparent),
                      bottom: BorderSide(width: 12, color: Colors.transparent),
                      left: BorderSide(width: 20, color: Color(0xFFDC2626)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Yt Mutual',
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Kanalınız için daha fazla abone, beğeni ve izlenme kazanın.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 35, 25, 25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _handleGoogleSignIn,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('🌐', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 10),
                          Text(
                            'Google ile Giriş Yap',
                            style: TextStyle(
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
  int _puan = 6556; // Görseldeki örnek puan ile başlatıldı
  bool _otomatikMod = false;
  int _seciliTab = 0; // Varsayılan kampanya ekranı

  final String _youtubeVideoUrl = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _puaniYukle();
  }

  Future<void> _puaniYukle() async {
    final prefs = await SharedPreferences.getInstance();
    int? emailPuani = prefs.getInt('kullanici_puani_${widget.userEmail}');
    int? genelPuan = prefs.getInt('kalici_genel_puan_miktari');
    int yuklenenPuan = emailPuani ?? genelPuan ?? 6556;
    setState(() {
      _puan = yuklenenPuan;
    });
  }

  Future<void> _puanKaydet(int yeniPuan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('kullanici_puani_${widget.userEmail}', yeniPuan);
    await prefs.setInt('kalici_genel_puan_miktari', yeniPuan);
    setState(() {
      _puan = yeniPuan;
    });
  }

  Future<void> _cikisYap() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('aktif_kullanici_email');
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _videoAc() async {
    final Uri url = Uri.parse(_youtubeVideoUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Video açılamadı: $url');
    }
  }

  void _gorevTamamla(int kazanilanPuan) {
    int yeniBakiye = _puan + kazanilanPuan;
    _puanKaydet(yeniBakiye);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tebrikler! +$kazanilanPuan Puan eklendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    String ilkHarf = widget.userEmail.isNotEmpty ? widget.userEmail[0].toUpperCase() : 'A';
    String kullaniciAdi = widget.userEmail.contains('@') 
        ? widget.userEmail.split('@')[0] 
        : widget.userEmail;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Yt Mutual',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text('$_puan', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 4),
                const Icon(Icons.favorite, color: Colors.red, size: 20),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        ilkHarf,
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(kullaniciAdi, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(widget.userEmail, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red, size: 22),
                    title: const Text('Çıkış yap', style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      _cikisYap();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _seciliTab == 0
                  ? _buildKampanyaEkrani()
                  : _seciliTab == 1
                      ? _buildIzleEkrani()
                      : _seciliTab == 2
                          ? _buildAboneOlEkrani()
                          : _buildBegenEkrani(),
            ),
            // Reklam Alanı Banner
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kullandığınız hesap, YT hesabınızla aynı olmalıdır.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('Unity Ads', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                    onPressed: () {},
                    child: const Text('Beğem', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.format_list_bulleted, 'Kampanya', 0),
                  _buildNavItem(Icons.play_arrow_rounded, 'İzle', 1),
                  _buildNavItem(Icons.subscriptions, 'Abone Ol', 2),
                  _buildNavItem(Icons.thumb_up, 'Beğen', 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIzleEkrani() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Otomatik', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(width: 8),
                    Switch(
                      value: _otomatikMod,
                      activeColor: Colors.red,
                      onChanged: (val) => setState(() => _otomatikMod = val),
                    ),
                  ],
                ),
                const Icon(Icons.error_outline, color: Colors.black54),
              ],
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: _videoAc,
            child: Container(
              height: 220,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill, color: Colors.red, size: 70),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.favorite, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text('48 Puan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 30),
                Icon(Icons.timer, color: Colors.black54, size: 28),
                SizedBox(width: 8),
                Text('60 Saniye', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () => _gorevTamamla(48),
                child: const Text('Değiştir / Tamamla', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboneOlEkrani() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Otomatik', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      const SizedBox(width: 8),
                      Switch(
                        value: _otomatikMod,
                        activeColor: Colors.red,
                        onChanged: (val) => setState(() => _otomatikMod = val),
                      ),
                    ],
                  ),
                  const Icon(Icons.error_outline, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B4B),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(Icons.sports_esports, color: Colors.orange, size: 60),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'GMR Himanshu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.favorite, color: Colors.red, size: 20),
                        SizedBox(width: 6),
                        Text('210 Puan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.timer, color: Colors.black54, size: 20),
                        SizedBox(width: 6),
                        Text('60 Saniye', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () => _gorevTamamla(210),
                      child: const Text('Abone Ol', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Yeni kanal getiriliyor...')),
                        );
                      },
                      child: const Text('Değiştir', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.grey, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kullandığınız hesap, YT hesabınızla aynı olmalıdır.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBegenEkrani() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Otomatik', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      const SizedBox(width: 8),
                      Switch(
                        value: _otomatikMod,
                        activeColor: Colors.red,
                        onChanged: (val) => setState(() => _otomatikMod = val),
                      ),
                    ],
                  ),
                  const Icon(Icons.error_outline, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_fill, color: Colors.red, size: 60),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'How to Remove Algae From...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.favorite, color: Colors.red, size: 20),
                        SizedBox(width: 6),
                        Text('130 Puan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.timer, color: Colors.black54, size: 20),
                        SizedBox(width: 6),
                        Text('60 Saniye', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () => _gorevTamamla(130),
                      child: const Text('Beğen', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Yeni video getiriliyor...')),
                        );
                      },
                      child: const Text('Değiştir', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.grey, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kullandığınız hesap, YT hesabınızla aynı olmalıdır.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKampanyaEkrani() {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Icon(Icons.favorite, color: Colors.white, size: 50),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Kampanya bulunamadı.', style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Yeni kampanya oluşturmak için + butonuna dokunun.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFDC2626),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateCampaignScreen(
                    mevcutPuan: _puan,
                    onKampanyaOlustur: (maliyet) {
                      int yeniPuan = _puan - maliyet;
                      _puanKaydet(yeniPuan);
                    },
                  ),
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _seciliTab == index;
    return GestureDetector(
      onTap: () => setState(() => _seciliTab = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.red : Colors.grey, size: 24),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: isSelected ? Colors.red : Colors.grey, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
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
  int _seciliTip = 0; // 0: İzlenme, 1: Abone Ol, 2: Beğeni
  int _izlenmeSayisi = 25;
  int _gerekenSure = 60;
  final TextEditingController _urlController = TextEditingController();

  int get _toplamMaliyet {
    if (_seciliTip == 0) {
      return _izlenmeSayisi * _gerekenSure; // Örneğin 25 * 60 = 1500
    } else if (_seciliTip == 1) {
      return 500;
    } else {
      return 300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Kampanya Oluştur', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text('${widget.mevcutPuan}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 4),
                const Icon(Icons.favorite, color: Colors.red, size: 20),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Siyah Bilgilendirme Banner'ı
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('• Aynı video için çok sayıda kampanya oluşturmayın.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  SizedBox(height: 4),
                  Text('• Kampanyaların YT\'a yansıması 72 saati bulabilir.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  SizedBox(height: 4),
                  Text('• Politikaya aykırı kampanyalar silinir.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  SizedBox(height: 4),
                  Text('• Detaylı analiz için YT Studio uygulamasını kullanın.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  SizedBox(height: 4),
                  Text('• Kampanyaların tamamlanma süresi değişkenlik gösterebilir.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Video Bilgi Kutusu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(child: Text('?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Video bağlantısı almak için: Videonuzu YT\'da açın -> Paylaş -> Bağlantıyı Kopyala',
                        style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Video Bağlantı Adresi Giriş Alanı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          hintText: 'Video Bağlantı Adresi',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.history, color: Colors.grey, size: 20),
                      onPressed: () {},
                    ),
                    const Icon(Icons.play_arrow_rounded, color: Colors.red, size: 28),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Video bağlantısı eklendi.')),
                        );
                      },
                      child: const Text('Ekle', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kampanya Türü Seçimi (İzlenme / Abone Ol / Beğeni)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    _buildSecenekButonu('İzlenme', 0, Icons.play_arrow),
                    _buildSecenekButonu('Abone Ol', 1, Icons.subscriptions),
                    _buildSecenekButonu('Beğeni', 2, Icons.thumb_up),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Kampanya Ayarları Başlığı
            Row(
              children: const [
                Expanded(child: Divider(thickness: 1, indent: 20, endIndent: 10)),
                Text('Kampanya Ayarları', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                Expanded(child: Divider(thickness: 1, indent: 10, endIndent: 20)),
              ],
            ),
            const SizedBox(height: 15),

            // Ayar Satırları
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Text('İzlenme Sayısı', style: TextStyle(fontSize: 14, color: Colors.black8N ?? Colors.black87, fontWeight: FontWeight.w500)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Text('$_izlenmeSayisi', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(width: 8),
                            const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Text('Gereken Süre (sn.)', style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Text('$_gerekenSure', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(width: 8),
                            const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Kampanya Maliyeti Başlığı
            Row(
              children: const [
                Expanded(child: Divider(thickness: 1, indent: 20, endIndent: 10)),
                Text('Kampanya Maliyeti', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                Expanded(child: Divider(thickness: 1, indent: 10, endIndent: 20)),
              ],
            ),
            const SizedBox(height: 15),

            // Toplam Tutar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  const Text('Toplam Tutar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Row(
                    children: [
                      Text('$_toplamMaliyet', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(width: 6),
                      const Icon(Icons.favorite, color: Colors.red, size: 22),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Oluştur Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  onPressed: () {
                    if (widget.mevcutPuan < _toplamMaliyet) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Yetersiz puan! Lütfen önce puan kazanın.')),
                      );
                      return;
                    }
                    widget.onKampanyaOlustur(_toplamMaliyet);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kampanya başarıyla oluşturuldu!')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Oluştur', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSecenekButonu(String baslik, int index, IconData ikon) {
    bool secili = _seciliTip == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _seciliTip = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: secili ? const Color(0xFFDC2626) : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ikon, color: secili ? Colors.white : Colors.grey, size: 16),
              const SizedBox(width: 6),
              Text(
                baslik,
                style: TextStyle(
                  color: secili ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

