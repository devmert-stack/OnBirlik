import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialEkrani extends StatefulWidget {
  final Widget sonrakiSayfa;

  const TutorialEkrani({super.key, required this.sonrakiSayfa});

  @override
  State<TutorialEkrani> createState() => _TutorialEkraniState();
}

class _TutorialEkraniState extends State<TutorialEkrani> {
  final PageController _controller = PageController();
  int _aktifSayfa = 0;

  final _sayfalar = [
    {
      'baslik': 'Kendi Ligini Kur veya Katıl',
      'aciklama':
          'Arkadaşlarınla 5 kişilik özel lig oluştur, davet kodunu paylaş ve hemen rekabete başla.',
      'ikon': Icons.groups_rounded,
      'renk': const Color(0xFF1B5E20),
    },
    {
      'baslik': 'Mevki Limitleri & Transfer Pazarı',
      'aciklama':
          '100M € bütçeni idareli kullan! Kadro kontenjanları:\n min 1 Kaleci | min 4 Defans | min 4 Orta Saha | min 2 Forvet.',
      'ikon': Icons.storefront_rounded,
      'renk': Colors.blueGrey.shade800,
    },
    {
      'baslik': '4-4-2 Taktik Saha & Esnek Kadro',
      'aciklama':
          'İlk 11\'ini sahaya sür! Forvetin eksik kalsa dahi yedeklerden mevki devşirilir, doğru mevki tam performans sağlar.',
      'ikon': Icons.sports_soccer_rounded,
      'renk': Colors.green.shade800,
    },
    {
      'baslik': 'Maç Simülasyonu & İkili Averaj',
      'aciklama':
          'Haftalık lig maçlarını simüle et. Puan eşitliğinde Süper Lig ikili averaj ve genel averaj kuralları geçerlidir.',
      'ikon': Icons.emoji_events_rounded,
      'renk': Colors.amber.shade900,
    },
  ];

  Future<void> _tutorialiBitir() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_goruldu', true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.sonrakiSayfa),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _tutorialiBitir,
                child: const Text(
                  'Geç',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _sayfalar.length,
                onPageChanged: (i) => setState(() => _aktifSayfa = i),
                itemBuilder: (context, index) {
                  final s = _sayfalar[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: (s['renk'] as Color).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            s['ikon'] as IconData,
                            size: 58,
                            color: s['renk'] as Color,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          s['baslik'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          s['aciklama'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.45,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _sayfalar.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _aktifSayfa == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _aktifSayfa == i ? const Color(0xFF1B5E20) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_aktifSayfa == _sayfalar.length - 1) {
                      _tutorialiBitir();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _aktifSayfa == _sayfalar.length - 1 ? 'Hemen Başla' : 'Devam Et',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}