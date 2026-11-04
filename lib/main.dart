import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'giris_sayfasi.dart';
import 'lig_sayfalari.dart';
import 'tutorial_ekrani.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase başlatma hatası: $e");
  }

  // Tutorial'ın daha önce tamamlanıp tamamlanmadığını kontrol et
  final prefs = await SharedPreferences.getInstance();
  final bool tutorialGoruldu = prefs.getBool('tutorial_goruldu') ?? false;

  runApp(FutbolYoneticisiApp(tutorialGoruldu: tutorialGoruldu));
}

class FutbolYoneticisiApp extends StatelessWidget {
  final bool tutorialGoruldu;

  const FutbolYoneticisiApp({super.key, required this.tutorialGoruldu});

  @override
  Widget build(BuildContext context) {
    const authKapisi = AuthKapisi();

    return MaterialApp(
      title: 'Futbol Yöneticisi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // İlk defa açılıyorsa TutorialEkrani, daha önce görüldüyse doğrudan AuthKapisi
      home: tutorialGoruldu
          ? authKapisi
          : const TutorialEkrani(sonrakiSayfa: authKapisi),
    );
  }
}

/// Giriş yapılmışsa ana sayfayı, yapılmamışsa giriş ekranını gösterir.
class AuthKapisi extends StatelessWidget {
  const AuthKapisi({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) return const AnaSayfa();
        return const GirisSayfasi();
      },
    );
  }
}