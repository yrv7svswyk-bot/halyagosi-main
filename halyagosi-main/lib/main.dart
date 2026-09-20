import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tkgcadujbnqrzxgutokr.supabase.co',
    anonKey: 'sb_publishable_hOjMNTGxdth8201wCjZKUQ_DRMQ_cFv',
  );
  runApp(const MaterialApp(
      home: HalyagosiApp(), debugShowCheckedModeBanner: false));
}

class HalyagosiApp extends StatefulWidget {
  const HalyagosiApp({super.key});
  @override
  State<HalyagosiApp> createState() => _HalyagosiAppState();
}

class _HalyagosiAppState extends State<HalyagosiApp> {
  int idx = 0;
  final pages = [
    const DashboardPage(),
    const ChippeltHalakPage(),
    const NapijegyPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081F1A),
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF081F1A),
          selectedItemColor: const Color(0xFFB9F5C8),
          unselectedItemColor: Colors.white38,
          currentIndex: idx,
          onTap: (i) => setState(() => idx = i),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.water), label: ' to'),
            BottomNavigationBarItem(
                icon: Icon(Icons.phishing), label: 'Chippelt halak'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), label: 'Jegyek')
          ]),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? weather;
  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      // : 
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=48.0191&longitude=19.144&current=temperature_2m,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min&timezone=auto');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        setState(() => weather = jsonDecode(res.body));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    String temp = weather?['current']?['temperature_2m']?.toString() ?? '22';
    String wind = weather?['current']?['wind_speed_10m']?.toString() ?? '10';
    String tempMax =
        weather?['daily']?['temperature_2m_max']?[0]?.toString() ?? '24';
    String tempMin =
        weather?['daily']?['temperature_2m_min']?[0]?.toString() ?? '14';
    return SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                  height: 190,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset('assets/halyagosi_header.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) => Container(color: Color(0xFF12372E), child: Icon(Icons.landscape, color: Colors.white38, size: 40))),
                        Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8)
                                    ])),
                            padding: const EdgeInsets.all(16),
                            child: const Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Halyagosi Horgaszto',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900)),
                                  ],
                                ))),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              const Text('Elo idojaras',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 10),
              Row(children: [
                _weatherCard('$temp C', 'Most ', Icons.wb_sunny),
                const SizedBox(width: 8),
                _weatherCard('$wind km/h', 'Szel', Icons.air),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                _weatherCard('18,6 C', 'Viz hofok', Icons.water_drop),
                const SizedBox(width: 8),
                _weatherCard(
                    '$tempMin-$tempMax C', 'Min/Max', Icons.thermostat),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TelepitesPage())),
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A5A4A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2ED47A).withOpacity(0.3)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: const Color(0xFF2ED47A).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.inventory_2, color: Color(0xFF2ED47A), size: 18),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(child: Text('Telepites', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                          ]),
                          const SizedBox(height: 8),
                          FutureBuilder(
                            future: Supabase.instance.client.from('telepitesek').select(),
                            builder: (ctx, snap) {
                              if (!snap.hasData) return const Text('Betoltes...', style: TextStyle(color: Color(0xFF7FB09A), fontSize: 10));
                              var data = snap.data as List;
                              double sum = 0;
                              for (var r in data) sum += (r['suly_kg'] as num? ?? 0).toDouble();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${data.length} telepites', style: const TextStyle(color: Color(0xFFB9F5C8), fontSize: 11, fontWeight: FontWeight.bold)),
                                  Text('${sum.toStringAsFixed(0)} kg osszesen', style: const TextStyle(color: Color(0xFF7FB09A), fontSize: 10)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FogasokPage())),
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D2E1A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFB84D).withOpacity(0.3)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: const Color(0xFFFFB84D).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.set_meal, color: Color(0xFFFFB84D), size: 18),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(child: Text('Fogasok', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                          ]),
                          const SizedBox(height: 8),
                          FutureBuilder(
                            future: Supabase.instance.client.from('fogasok').select(),
                            builder: (ctx, snap) {
                              if (!snap.hasData) return const Text('Betoltes...', style: TextStyle(color: Color(0xFF7FB09A), fontSize: 10));
                              var data = snap.data as List;
                              double sum = 0;
                              for (var r in data) sum += (r['suly_kg'] as num? ?? 0).toDouble();
                              int currentYear = DateTime.now().year;
                              double yearSum = 0;
                              for (var r in data) if ((r['ev'] ?? 0) == currentYear) yearSum += (r['suly_kg'] as num? ?? 0).toDouble();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${data.length} bejegyzes', style: const TextStyle(color: Color(0xFFFFE0A0), fontSize: 11, fontWeight: FontWeight.bold)),
                                  Text('$currentYear: ${yearSum.toStringAsFixed(0)} kg', style: const TextStyle(color: Color(0xFF7FB09A), fontSize: 10)),
                                  Text('Ossz: ${sum.toStringAsFixed(0)} kg', style: const TextStyle(color: Color(0xFF7FB09A), fontSize: 9)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ])));
  }

  Widget _weatherCard(String a, String b, IconData ic) => Expanded(
        child: Container(
            height: 90,
            decoration: BoxDecoration(
                color: const Color(0xFF1B4D3E),
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(ic, color: const Color(0xFFB9F5C8), size: 20),
              const SizedBox(height: 4),
              Text(a,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text(b,
                  style:
                      const TextStyle(color: Color(0xFF7FB09A), fontSize: 10))
            ])),
      );
}


// TELEPITES PAGE
class TelepitesPage extends StatefulWidget {
  const TelepitesPage({super.key});
  @override
  State<TelepitesPage> createState() => _TelepitesPageState();
}

class _TelepitesPageState extends State<TelepitesPage> {
  List<dynamic> adatok = [];
  final List<String> fajok = [
    'Ponty 2 nyaras',
    'Ponty 3 nyaras',
    'Ponty extra',
    'Csuka',
    'Sullo',
    'Balin',
    'Keszegfelek',
    'Szeles karasz',
    'Szurke harcsa',
    'Compo'
  ];
  String kivalasztottFaj = 'Ponty 2 nyaras';
  final sulyCtrl = TextEditingController();
  DateTime kivalasztottDatum = DateTime.now();

  @override
  void initState() {
    super.initState();
    betoltes();
  }

  Future<void> betoltes() async {
    try {
      var res = await Supabase.instance.client.from('telepitesek').select().order('datum', ascending: false);
      setState(() => adatok = res);
    } catch (e) {
      print('telepites betoltes hiba: $e');
    }
  }

  Future<void> hozzaad() async {
    double suly = double.tryParse(sulyCtrl.text.replaceAll(',', '.')) ?? 0;
    if (suly <= 0) return;
    try {
      await Supabase.instance.client.from('telepitesek').insert({
        'faj': kivalasztottFaj,
        'suly_kg': suly,
        'datum': kivalasztottDatum.toIso8601String().split('T')[0]
      });
      if (mounted) Navigator.pop(context);
      sulyCtrl.clear();
      await betoltes();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$kivalasztottFaj $suly kg mentve'), backgroundColor: Color(0xFF2ED47A)));
    } catch (e) {
      print('telepites mentes hiba: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hiba: $e'), backgroundColor: Colors.red));
    }
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          backgroundColor: Color(0xFF14352E),
          title: Text('Uj telepites', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<String>(
                value: kivalasztottFaj,
                dropdownColor: Color(0xFF14352E),
                style: TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(labelText: 'Faj', labelStyle: TextStyle(color: Colors.white54)),
                items: fajok.map((f) => DropdownMenuItem(value: f, child: Text(f, style: TextStyle(fontSize: 12)))).toList(),
                onChanged: (v) { if (v != null) { setState(() => kivalasztottFaj = v); setD(() => kivalasztottFaj = v); } },
              ),
              SizedBox(height: 12),
              TextField(
                controller: sulyCtrl,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(labelText: 'Suly kg', labelStyle: TextStyle(color: Colors.white54)),
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  var picked = await showDatePicker(context: context, initialDate: kivalasztottDatum, firstDate: DateTime(2020), lastDate: DateTime(2030));
                  if (picked != null) setD(() => kivalasztottDatum = picked);
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Color(0xFF1B4D3E), borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    Icon(Icons.calendar_today, color: Color(0xFF2ED47A), size: 16),
                    SizedBox(width: 8),
                    Text('${kivalasztottDatum.year}.${kivalasztottDatum.month}.${kivalasztottDatum.day}', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ]),
                ),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: Text('Megse')),
            FilledButton(onPressed: hozzaad, style: FilledButton.styleFrom(backgroundColor: Color(0xFF2ED47A)), child: Text('Mentes', style: TextStyle(color: Color(0xFF081F1A), fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Future<void> torles(id) async {
    bool? ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(backgroundColor: Color(0xFF14352E), title: Text('Torlod?', style: TextStyle(color: Colors.white)), actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: Text('Megse')), FilledButton(onPressed: () => Navigator.pop(c, true), child: Text('Torles'))]));
    if (ok != true) return;
    await Supabase.instance.client.from('telepitesek').delete().eq('id', id);
    await betoltes();
  }

  @override
  Widget build(BuildContext context) {
    double ossz = 0;
    for (var r in adatok) ossz += (r['suly_kg'] as num? ?? 0).toDouble();
    Map<String, double> fajOssz = {};
    for (var r in adatok) {
      String f = r['faj'] ?? '';
      fajOssz[f] = (fajOssz[f] ?? 0) + (r['suly_kg'] as num? ?? 0).toDouble();
    }
    return Scaffold(
      backgroundColor: Color(0xFF0A332A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A332A),
        title: Text('Telepitesek - ${ossz.toStringAsFixed(0)} kg', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 16), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: Icon(Icons.add, color: Color(0xFF2ED47A)), onPressed: showAddDialog)],
      ),
      body: Column(children: [
        if (fajOssz.isNotEmpty)
          Column(children: [
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Color(0xFF1B4D3E), borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Osszesites faj szerint', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 8),
                ...fajOssz.entries.map((e) => Padding(padding: EdgeInsets.only(bottom: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(e.key, style: TextStyle(color: Color(0xFFB9F5C8), fontSize: 11)), Text('${e.value.toStringAsFixed(0)} kg', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))]))).toList(),
              ]),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              padding: EdgeInsets.all(12),
              height: 160,
              decoration: BoxDecoration(color: Color(0xFF1B4D3E), borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Grafikon - kg / faj', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                SizedBox(height: 12),
                Expanded(child: CustomPaint(size: Size(double.infinity, 110), painter: BarChartPainter(fajOssz, barColor: Color(0xFF2ED47A)))),
              ]),
            ),
          ]),
        Expanded(
          child: adatok.isEmpty
              ? Center(child: Text('Nincs telepites', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  itemCount: adatok.length,
                  itemBuilder: (_, i) {
                    var r = adatok[i];
                    return ListTile(
                      title: Text('${r['faj']}', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text('${r['datum']} - ${r['suly_kg']} kg', style: TextStyle(color: Color(0xFF7FB09A), fontSize: 11)),
                      trailing: IconButton(icon: Icon(Icons.delete, color: Colors.white38, size: 18), onPressed: () => torles(r['id'])),
                    );
                  },
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: showAddDialog, backgroundColor: Color(0xFF2ED47A), child: Icon(Icons.add, color: Color(0xFF081F1A))),
    );
  }
}

// FOGASOK PAGE
class FogasokPage extends StatefulWidget {
  const FogasokPage({super.key});
  @override
  State<FogasokPage> createState() => _FogasokPageState();
}

class _FogasokPageState extends State<FogasokPage> {
  List<dynamic> adatok = [];
  final List<String> fajok = [
    'Ponty',
    'Csuka',
    'Amur',
    'Sullo',
    'Balin',
    'Keszegfelek',
    'Karasz',
    'Szurkeharcsa',
    'Torpeharcsa'
  ];
  String kivalasztottFaj = 'Ponty';
  final sulyCtrl = TextEditingController();
  final evCtrl = TextEditingController(text: DateTime.now().year.toString());

  @override
  void initState() {
    super.initState();
    betoltes();
  }

  Future<void> betoltes() async {
    try {
      var res = await Supabase.instance.client.from('fogasok').select().order('ev', ascending: false);
      setState(() => adatok = res);
    } catch (e) {
      print('fogas betoltes hiba: $e');
    }
  }

  Future<void> hozzaad() async {
    double suly = double.tryParse(sulyCtrl.text.replaceAll(',', '.')) ?? 0;
    int ev = int.tryParse(evCtrl.text) ?? DateTime.now().year;
    if (suly <= 0) return;
    try {
      await Supabase.instance.client.from('fogasok').insert({
        'faj': kivalasztottFaj,
        'suly_kg': suly,
        'ev': ev
      });
      if (mounted) Navigator.pop(context);
      sulyCtrl.clear();
      await betoltes();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$kivalasztottFaj $suly kg $ev mentve'), backgroundColor: Color(0xFFFFB84D)));
    } catch (e) {
      print('fogas mentes hiba: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hiba: $e'), backgroundColor: Colors.red));
    }
  }

  void showAddDialog() {
    evCtrl.text = DateTime.now().year.toString();
    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          backgroundColor: Color(0xFF2E2414),
          title: Text('Uj fogas', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(
              value: kivalasztottFaj,
              dropdownColor: Color(0xFF2E2414),
              style: TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(labelText: 'Faj', labelStyle: TextStyle(color: Colors.white54)),
              items: fajok.map((f) => DropdownMenuItem(value: f, child: Text(f, style: TextStyle(fontSize: 12)))).toList(),
              onChanged: (v) { if (v != null) { setState(() => kivalasztottFaj = v); setD(() => kivalasztottFaj = v); } },
            ),
            SizedBox(height: 12),
            TextField(
              controller: evCtrl,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'Ev (pl. 2026)', labelStyle: TextStyle(color: Colors.white54)),
            ),
            SizedBox(height: 12),
            TextField(
              controller: sulyCtrl,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: 'Suly kg', labelStyle: TextStyle(color: Colors.white54)),
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: Text('Megse')),
            FilledButton(onPressed: hozzaad, style: FilledButton.styleFrom(backgroundColor: Color(0xFFFFB84D)), child: Text('Mentes', style: TextStyle(color: Color(0xFF2E2414), fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Future<void> torles(id) async {
    bool? ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(backgroundColor: Color(0xFF2E2414), title: Text('Torlod?', style: TextStyle(color: Colors.white)), actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: Text('Megse')), FilledButton(onPressed: () => Navigator.pop(c, true), child: Text('Torles'))]));
    if (ok != true) return;
    await Supabase.instance.client.from('fogasok').delete().eq('id', id);
    await betoltes();
  }

  @override
  Widget build(BuildContext context) {
    // Osszesites ev szerint
    Map<int, double> evOssz = {};
    Map<String, double> fajOssz = {};
    double ossz = 0;
    for (var r in adatok) {
      int ev = r['ev'] as int? ?? 0;
      double s = (r['suly_kg'] as num? ?? 0).toDouble();
      evOssz[ev] = (evOssz[ev] ?? 0) + s;
      fajOssz[r['faj'] ?? ''] = (fajOssz[r['faj'] ?? ''] ?? 0) + s;
      ossz += s;
    }
    var evKeys = evOssz.keys.toList()..sort((a,b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Color(0xFF1A150A),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A150A),
        title: Text('Fogasok - ${ossz.toStringAsFixed(0)} kg ossz', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 16), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: Icon(Icons.add, color: Color(0xFFFFB84D)), onPressed: showAddDialog)],
      ),
      body: Column(children: [
        if (evKeys.isNotEmpty)
          Column(children: [
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Color(0xFF2E2414), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFFFFB84D).withOpacity(0.2))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Osszesites ev szerint', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 8),
                ...evKeys.map((ev) => Padding(padding: EdgeInsets.only(bottom: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('$ev', style: TextStyle(color: Color(0xFFFFE0A0), fontSize: 12, fontWeight: FontWeight.bold)), Text('${evOssz[ev]!.toStringAsFixed(0)} kg', style: TextStyle(color: Colors.white, fontSize: 12))]))).toList(),
                Divider(color: Colors.white12),
                ...fajOssz.entries.map((e) => Padding(padding: EdgeInsets.only(bottom: 3), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(e.key, style: TextStyle(color: Color(0xFF7FB09A), fontSize: 10)), Text('${e.value.toStringAsFixed(0)} kg', style: TextStyle(color: Colors.white70, fontSize: 10))]))).toList(),
              ]),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              padding: EdgeInsets.all(12),
              height: 160,
              decoration: BoxDecoration(color: Color(0xFF2E2414), borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Eves grafikon - kg / ev', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                SizedBox(height: 12),
                Expanded(child: CustomPaint(size: Size(double.infinity, 110), painter: BarChartPainter(evOssz.map((k,v) => MapEntry(k.toString(), v)), barColor: Color(0xFFFFB84D)))),
              ]),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              padding: EdgeInsets.all(12),
              height: 160,
              decoration: BoxDecoration(color: Color(0xFF2E2414), borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Faj szerint - kg', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                SizedBox(height: 12),
                Expanded(child: CustomPaint(size: Size(double.infinity, 110), painter: BarChartPainter(fajOssz, barColor: Color(0xFF7FB09A)))),
              ]),
            ),
          ]),
        Expanded(
          child: adatok.isEmpty
              ? Center(child: Text('Nincs fogas adat', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  itemCount: adatok.length,
                  itemBuilder: (_, i) {
                    var r = adatok[i];
                    return ListTile(
                      title: Text('${r['faj']} - ${r['ev']}', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text('${r['suly_kg']} kg', style: TextStyle(color: Color(0xFF7FB09A), fontSize: 11)),
                      trailing: IconButton(icon: Icon(Icons.delete, color: Colors.white38, size: 18), onPressed: () => torles(r['id'])),
                    );
                  },
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: showAddDialog, backgroundColor: Color(0xFFFFB84D), child: Icon(Icons.add, color: Color(0xFF2E2414))),
    );
  }
}

// CHIPPELT HALAK - CHIP LEGORDULO + TOBB KEP - IMAGE_PICKER

class ChippeltHalakPage extends StatefulWidget {
  const ChippeltHalakPage({super.key});
  @override
  State<ChippeltHalakPage> createState() => _ChippeltHalakPageState();
}

class _ChippeltHalakPageState extends State<ChippeltHalakPage> {
  String? selectedChip;
  List<dynamic> allFish = [];
  final nevCtrl = TextEditingController();
  final chipCtrl = TextEditingController();
  final fajCtrl = TextEditingController(text: "Ponty");
  final sulyCtrl = TextEditingController();
  List<Uint8List> pickedImagesBytes = [];
  List<String> pickedImagesNames = [];
  final ImagePicker picker = ImagePicker();

  Future<void> loadAll() async {
    try {
      final res = await Supabase.instance.client
          .from('chippelt_halak')
          .select()
          .order('nev');
      setState(() => allFish = res);
    } catch (e) {
      print('loadAll hiba: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<String?> uploadImage(Uint8List bytes, String chipId, String name) async {
    try {
      final fileName =
          '${chipId}_${DateTime.now().millisecondsSinceEpoch}_$name';
      // Probaljuk mindket bucket nevet - hal_kepek es hal-kepek
      String bucket = 'hal_kepek';
      try {
        await Supabase.instance.client.storage.from(bucket).uploadBinary(
            fileName, bytes,
            fileOptions: FileOptions(contentType: 'image/jpeg'));
      } catch (e) {
        print('hal_kepek bucket hiba, probaljuk hal-kepek: $e');
        bucket = 'hal-kepek';
        await Supabase.instance.client.storage.from(bucket).uploadBinary(
            fileName, bytes,
            fileOptions: FileOptions(contentType: 'image/jpeg'));
      }
      final url = Supabase.instance.client.storage
          .from(bucket)
          .getPublicUrl(fileName);
      print('FELTOLTVE URL: $url BUCKET: $bucket');
      return url;
    } catch (e) {
      print('upload hiba: $e');
      return null;
    }
  }

  Future<void> addNewFish() async {
    if (chipCtrl.text.isEmpty) return;
    String chipId = chipCtrl.text.trim();
    try {
      await Supabase.instance.client.from('chippelt_halak').insert({
        'nev': nevCtrl.text.isEmpty ? 'Nevenincs' : nevCtrl.text,
        'chip_id': chipId,
        'hal_faj': fajCtrl.text,
        'suly_kg': double.tryParse(sulyCtrl.text.replaceAll(',', '.')) ?? 0,
      });
      for (int i = 0; i < pickedImagesBytes.length; i++) {
        String? url = await uploadImage(pickedImagesBytes[i], chipId, pickedImagesNames[i]);
        if (url != null) {
          try {
            await Supabase.instance.client.from('hal_kepek').insert({
              'chip_id': chipId,
              'image_url': url,
              'datum': DateTime.now().toIso8601String().split('T')[0]
            });
          } catch (_) {}
        }
      }
      nevCtrl.clear();
      chipCtrl.clear();
      sulyCtrl.clear();
      pickedImagesBytes.clear();
      pickedImagesNames.clear();
      if (mounted) Navigator.pop(context);
      loadAll();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$chipId mentve'), backgroundColor: Color(0xFF2ED47A)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mentes hiba: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> files = await picker.pickMultiImage(imageQuality: 70);
      if (files.isNotEmpty) {
        List<Uint8List> bytesList = [];
        List<String> names = [];
        for (var f in files) {
          bytesList.add(await f.readAsBytes());
          names.add(f.name);
        }
        setState(() {
          pickedImagesBytes = bytesList;
          pickedImagesNames = names;
        });
      }
    } catch (e) {
      print('pick hiba: $e');
    }
  }

  void showAddDialog() {
    pickedImagesBytes = [];
    pickedImagesNames = [];
    showDialog(
        context: context,
        builder: (c) => StatefulBuilder(
            builder: (ctx, setD) => AlertDialog(
                  backgroundColor: const Color(0xFF14352E),
                  title: const Text('Uj chippelt hal',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(
                        controller: chipCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: 'Chip szam *',
                            labelStyle: TextStyle(color: Colors.white54))),
                    const SizedBox(height: 8),
                    TextField(
                        controller: nevCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: 'Hal neve (pl. Bela)',
                            labelStyle: TextStyle(color: Colors.white54))),
                    const SizedBox(height: 8),
                    TextField(
                        controller: fajCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: 'Faj',
                            labelStyle: TextStyle(color: Colors.white54))),
                    const SizedBox(height: 8),
                    TextField(
                        controller: sulyCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: 'Kezdo suly kg',
                            labelStyle: TextStyle(color: Colors.white54))),
                    const SizedBox(height: 12),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: const Color(0xFF122F27),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(children: [
                          Row(children: [
                            const Icon(Icons.photo_library,
                                color: Color(0xFFB9F5C8), size: 18),
                            const SizedBox(width: 8),
                            const Expanded(
                                child: Text('Hal kepei - tobb is lehet',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)))
                          ]),
                          const SizedBox(height: 8),
                          SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                  onPressed: () async {
                                    await pickImages();
                                    setD(() {});
                                  },
                                  icon: const Icon(Icons.add_a_photo, size: 16),
                                  label: Text('${pickedImagesBytes.length} kep kivalasztva'),
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          const Color(0xFFB9F5C8)))),
                          if (pickedImagesNames.isNotEmpty)
                            Wrap(
                                spacing: 6,
                                children: pickedImagesNames
                                    .map((name) => Container(
                                        margin: EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF1B4D3E),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))))
                                    .toList())
                        ])),
                  ])),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(c),
                        child: const Text('Megse')),
                    FilledButton(
                        onPressed: addNewFish,
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2ED47A)),
                        child: const Text('Mentes',
                            style: TextStyle(
                                color: Color(0xFF081F1A),
                                fontWeight: FontWeight.bold)))
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filtered = allFish;
    if (selectedChip != null && selectedChip!.isNotEmpty) {
      filtered = allFish
          .where((h) => h['chip_id'].toString() == selectedChip)
          .toList();
    }
    return SafeArea(
        child: Column(children: [
      Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFF122F27),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1E443A))),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        value: selectedChip,
                        isExpanded: true,
                        hint: const Text('Chip szam - kattints es valassz...',
                            style: TextStyle(color: Colors.white54, fontSize: 12)),
                        dropdownColor: const Color(0xFF122F27),
                        style: const TextStyle(color: Colors.white),
                        items: [
                          const DropdownMenuItem(
                              value: null,
                              child: Text('Osszes hal',
                                  style: TextStyle(color: Color(0xFFB9F5C8)))),
                          ...allFish
                              .map((h) => DropdownMenuItem(
                                  value: h['chip_id'].toString(),
                                  child: Text(
                                      '${h['chip_id']} - ${h['nev'] ?? ''}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12))))
                              .toList()
                        ],
                        onChanged: (v) {
                          setState(() => selectedChip = v);
                        }))),
            const SizedBox(height: 8),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ED47A),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: showAddDialog,
                    icon: const Icon(Icons.add, color: Color(0xFF081F1A), size: 16),
                    label: const Text('Uj chippelt hal + kepek',
                        style: TextStyle(
                            color: Color(0xFF081F1A),
                            fontWeight: FontWeight.bold, fontSize: 12)))),
          ])),
      Expanded(
          child: StreamBuilder(
              stream: Supabase.instance.client.from('chippelt_halak').stream(
                  primaryKey: ['chip_id']).order('suly_kg', ascending: false),
              builder: (ctx, snap) {
                if (!snap.hasData)
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFB9F5C8)));
                var data = filtered.isNotEmpty || selectedChip != null
                    ? filtered
                    : (snap.data as List);
                if (data.isEmpty)
                  return const Center(
                      child: Text('Nincs talalat on',
                          style: TextStyle(color: Colors.white54)));
                return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemCount: data.length,
                    itemBuilder: (_, i) {
                      var h = data[i];
                      return Card(
                          color: const Color(0xFF122F27),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                              leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFB9F5C8),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.phishing,
                                      color: Color(0xFF081F1A), size: 16)),
                              title: Text('${h['chip_id']} - ${h['nev'] ?? ''}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              subtitle: Text(
                                  '${h['hal_faj'] ?? 'Ponty'} - ${h['suly_kg'] ?? '?'} kg',
                                  style: const TextStyle(
                                      color: Color(0xFF7FB09A), fontSize: 10)),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  size: 12, color: Colors.white38),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          HalReszletekPage(hal: h))).then((_) => loadAll())));
                    });
              })),
    ]));
  }
}

class HalReszletekPage extends StatefulWidget {
  final Map<String, dynamic> hal;
  const HalReszletekPage({super.key, required this.hal});
  @override
  State<HalReszletekPage> createState() => _HalReszletekPageState();
}

class _HalReszletekPageState extends State<HalReszletekPage> {
  List<dynamic> kepek = [];
  List<dynamic> meresek = [];
  final sulyCtrl = TextEditingController();
  final fogoCtrl = TextEditingController(text: "Csaba Busai");
  final helyCtrl = TextEditingController(text: "12. spot");
  List<Uint8List> meresKepekBytes = [];
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      try {
        var k = await Supabase.instance.client
            .from('hal_kepek')
            .select()
            .eq('chip_id', widget.hal['chip_id'].toString())
            .order('datum', ascending: false);
        print('KEPEK BETOLTVE: ${k.length} db chip ${widget.hal['chip_id']}');
        for(var img in k){ print(' - ${img['image_url']}'); }
        setState(() => kepek = k);
      } catch (e) {
        print('kepek betoltes hiba hal_kepek: $e');
        try {
          var k = await Supabase.instance.client.from('hal-kepek').select().eq('chip_id', widget.hal['chip_id'].toString()).order('datum', ascending: false);
          setState(() => kepek = k);
        } catch (e2) { setState(() => kepek = []); }
      }
    } catch (_) { setState(() => kepek = []); }
    try {
      var m = await Supabase.instance.client
          .from('hal_meresek')
          .select()
          .eq('chip_id', widget.hal['chip_id'].toString())
          .order('datum', ascending: false);
      setState(() => meresek = m);
    } catch (e) {
      // ha hal_meresek tabla nincs, probaljuk fogasok tablat
      try {
        var m = await Supabase.instance.client
            .from('fogasok')
            .select()
            .eq('chip_id', widget.hal['chip_id'].toString())
            .order('datum', ascending: false);
        setState(() => meresek = m);
      } catch (_) { setState(() => meresek = []); }
    }
  }

  Future<String?> uploadMeresImage(Uint8List bytes) async {
    try {
      final fileName =
          '${widget.hal['chip_id']}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      String bucket = 'hal_kepek';
      try {
        await Supabase.instance.client.storage.from(bucket).uploadBinary(
            fileName, bytes,
            fileOptions: FileOptions(contentType: 'image/jpeg'));
      } catch (e) {
        bucket = 'hal-kepek';
        await Supabase.instance.client.storage.from(bucket).uploadBinary(
            fileName, bytes,
            fileOptions: FileOptions(contentType: 'image/jpeg'));
      }
      final url = Supabase.instance.client.storage.from(bucket).getPublicUrl(fileName);
      print('MERES KEP URL: $url');
      return url;
    } catch (e) {
      print('meres upload hiba: $e');
      return null;
    }
  }

  Future<void> addMeres() async {
    double? suly = double.tryParse(sulyCtrl.text.replaceAll(',', '.'));
    if (suly == null) return;
    String chipId = widget.hal['chip_id'].toString();
    String? fotoUrl;
    if (meresKepekBytes.isNotEmpty) {
      fotoUrl = await uploadMeresImage(meresKepekBytes.first);
      if (fotoUrl != null) {
        try {
          await Supabase.instance.client.from('hal_kepek').insert({
            'chip_id': chipId,
            'image_url': fotoUrl,
            'datum': DateTime.now().toIso8601String().split('T')[0]
          });
        } catch (_) {}
      }
    }
    try {
      await Supabase.instance.client.from('hal_meresek').insert({
        'chip_id': chipId,
        'suly_kg': suly,
        'fogo': fogoCtrl.text,
        'helyszin': helyCtrl.text,
        'foto_url': fotoUrl,
        'datum': DateTime.now().toIso8601String()
      });
    } catch (e) {
      try {
        await Supabase.instance.client.from('fogasok').insert({
          'chip_id': chipId,
          'suly_kg': suly,
          'horgasz_nev': fogoCtrl.text,
          'datum': DateTime.now().toIso8601String()
        });
      } catch (_) {}
    }
    try {
      await Supabase.instance.client
          .from('chippelt_halak')
          .update({'suly_kg': suly}).eq('chip_id', chipId);
    } catch (_) {}
    sulyCtrl.clear();
    meresKepekBytes.clear();
    if (mounted) Navigator.pop(context);
    loadData();
  }

  void showMeresDialog() {
    meresKepekBytes = [];
    showDialog(
        context: context,
        builder: (c) => StatefulBuilder(
            builder: (ctx, setD) => AlertDialog(
                  backgroundColor: const Color(0xFF14352E),
                  title: const Text('Uj meres',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                        'Datum: ${DateTime.now().toIso8601String().split('T')[0]}',
                        style: const TextStyle(
                            color: Color(0xFF7FB09A), fontSize: 10)),
                    const SizedBox(height: 8),
                    TextField(
                        controller: sulyCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: 'Uj suly kg *',
                            labelStyle: TextStyle(color: Colors.white54))),
                    const SizedBox(height: 8),
                    TextField(
                        controller: fogoCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: 'Fogo neve',
                            labelStyle: TextStyle(color: Colors.white54))),
                    const SizedBox(height: 8),
                    TextField(
                        controller: helyCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: 'Helyszin',
                            labelStyle: TextStyle(color: Colors.white54))),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                        onPressed: () async {
                          var x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
                          if (x != null) {
                            var b = await x.readAsBytes();
                            setD(() => meresKepekBytes = [b]);
                          }
                        },
                        icon: const Icon(Icons.camera_alt, size: 16),
                        label: Text('${meresKepekBytes.length} kep'),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFB9F5C8))),
                  ])),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(c),
                        child: const Text('Megse')),
                    FilledButton(
                        onPressed: addMeres,
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2ED47A)),
                        child: const Text('Mentes',
                            style: TextStyle(
                                color: Color(0xFF081F1A),
                                fontWeight: FontWeight.bold)))
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    String nev = widget.hal['nev']?.toString() ?? 'Bela';
    String faj = widget.hal['hal_faj']?.toString() ?? 'Ponty';
    String suly = widget.hal['suly_kg']?.toString() ?? '18,2';
    String chip = widget.hal['chip_id']?.toString() ?? '1';
    List<Map<String, dynamic>> sulyHistory = [
      {"date": "2023.01", "kg": 12.0},
      {"date": "2024.01", "kg": 14.5},
      {"date": "2025.09", "kg": double.tryParse(suly.replaceAll(',', '.')) ?? 18.2}
    ];
    if (meresek.isNotEmpty) {
      sulyHistory = meresek.reversed
          .map((m) => {
                "date":
                    m['datum'].toString().substring(0, 10).replaceAll('-', '.'),
                "kg": (m['suly_kg'] as num).toDouble()
              })
          .toList();
      if (sulyHistory.length > 6)
        sulyHistory = sulyHistory.sublist(sulyHistory.length - 6);
    }
    return Scaffold(
      backgroundColor: const Color(0xFF0A332A),
      appBar: AppBar(
          backgroundColor: const Color(0xFF0A332A),
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
              onPressed: () => Navigator.pop(context)),
          title: Text('$nev',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          centerTitle: true),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (kepek.isNotEmpty) ...[
              SizedBox(
                  height: 140,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: kepek.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(children: [
                              Image.network(kepek[i]['image_url'],
                                  width: 180, height: 140, fit: BoxFit.cover,
                                  errorBuilder: (a,b,c) {
                                    print('KEP BETOLTESI HIBA: ${kepek[i]['image_url']} - $b');
                                    return Container(width: 180, height: 140, color: Color(0xFF1B4D3E), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.broken_image, color: Colors.redAccent, size: 30), SizedBox(height: 4), Text('Bucket nem public?', style: TextStyle(color: Colors.white, fontSize: 8))]),);
                                  }),
                              Positioned(
                                  bottom: 4,
                                  left: 4,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(kepek[i]['datum'].toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9))))
                            ]));
                      })),
              const SizedBox(height: 12),
            ] else ...[
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                      'https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=800',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover)),
              const SizedBox(height: 12),
            ],
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(nev,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.0)),
                    const SizedBox(height: 4),
                    Text('Faj: $faj',
                        style: const TextStyle(
                            color: Color(0xFF7FB09A), fontSize: 12))
                  ])),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xFF12372E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2ED47A))),
                  child: Text('$suly kg',
                      style: const TextStyle(
                          color: Color(0xFFB9F5C8),
                          fontWeight: FontWeight.bold,
                          fontSize: 11))),
            ]),
            const SizedBox(height: 12),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFF0F2E27),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('Chip szam:',
                            style: TextStyle(
                                color: Color(0xFF7FB09A), fontSize: 10)),
                        Text(chip,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))
                      ])),
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: chip));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chip masolva: $chip')));
                      },
                      icon: const Icon(Icons.copy_rounded,
                          color: Color(0xFF2ED47A), size: 18))
                ])),
            const SizedBox(height: 12),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: const Color(0xFF12372E),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Icon(Icons.show_chart,
                            color: Color(0xFF2ED47A), size: 18),
                        SizedBox(width: 6),
                        Text('Sulyfejlodes',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13))
                      ]),
                      const SizedBox(height: 12),
                      SizedBox(
                          height: 100,
                          child: CustomPaint(
                              painter: SulyChartPainter(sulyHistory),
                              size: const Size(double.infinity, 100))),
                      const SizedBox(height: 6),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: sulyHistory
                              .map((e) => Text(e['date'],
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 9)))
                              .toList())
                    ])),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.list_alt, color: Color(0xFF2ED47A), size: 18),
              const SizedBox(width: 6),
              const Text('Fogas tortenet',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const Spacer(),
              Text('${meresek.length} meres',
                  style: const TextStyle(color: Colors.white38, fontSize: 10))
            ]),
            const SizedBox(height: 10),
            if (meresek.isEmpty) ...[
              _fogasCard(
                  '2025.09.20',
                  '$suly kg - Fogo: Csaba Busai',
                  true,
                  null)
            ] else ...[
              for (var m in meresek)
                Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _fogasCard(
                        m['datum']
                            .toString()
                            .substring(0, 16)
                            .replaceAll('T', ' '),
                        '${m['suly_kg']} kg - ${m['fogo'] ?? m['horgasz_nev'] ?? ''} - ${m['helyszin'] ?? ''}',
                        meresek.indexOf(m) == 0,
                        m['foto_url']))
            ],
            const SizedBox(height: 16),
            SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ED47A),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                    onPressed: showMeresDialog,
                    child: const Text('+ Uj meres + foto',
                        style: TextStyle(
                            color: Color(0xFF081F1A),
                            fontWeight: FontWeight.w900,
                            fontSize: 13)))),
            const SizedBox(height: 20),
          ])),
    );
  }

  Widget _fogasCard(
      String datum, String reszlet, bool legutobbi, String? foto) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color(0xFF12372E),
            borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          foto != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(foto,
                      width: 44, height: 44, fit: BoxFit.cover, errorBuilder: (a,b,c) => Container(width:44,height:44,color: Color(0xFF1B4D3E), child: Icon(Icons.image, size:16))))
              : Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: const Color(0xFF2ED47A),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.calendar_today,
                      size: 14, color: Color(0xFF081F1A))),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Text(datum,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                  if (legutobbi) ...[
                    const SizedBox(width: 6),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xFF2ED47A),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text('Legutobbi',
                            style: TextStyle(
                                color: Color(0xFF081F1A),
                                fontSize: 9,
                                fontWeight: FontWeight.bold)))
                  ]
                ]),
                const SizedBox(height: 2),
                Text(reszlet,
                    style:
                        const TextStyle(color: Color(0xFF9CC9B3), fontSize: 10))
              ]))
        ]));
  }
}


class BarChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Color barColor;
  BarChartPainter(this.data, {this.barColor = const Color(0xFF2ED47A)});
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    double maxVal = data.values.reduce((a,b) => a>b?a:b);
    if (maxVal == 0) maxVal = 1;
    double barWidth = (size.width / data.length) * 0.6;
    double gap = (size.width / data.length) * 0.4;
    int i = 0;
    data.forEach((key, value) {
      double barHeight = (value / maxVal) * (size.height - 30);
      double x = i * (barWidth + gap) + gap/2;
      double y = size.height - barHeight - 20;
      final barPaint = Paint()..color = barColor..style = PaintingStyle.fill;
      RRect r = RRect.fromRectAndRadius(Rect.fromLTWH(x, y, barWidth, barHeight), Radius.circular(6));
      canvas.drawRRect(r, barPaint);
      // value text
      final tp = TextPainter(text: TextSpan(text: '${value.toStringAsFixed(0)}', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(x + barWidth/2 - tp.width/2, y - 12));
      // label
      final label = key.length > 8 ? key.substring(0,8) : key;
      final tp2 = TextPainter(text: TextSpan(text: label, style: TextStyle(color: Color(0xFF7FB09A), fontSize: 7)), textDirection: TextDirection.ltr);
      tp2.layout(maxWidth: barWidth+10);
      tp2.paint(canvas, Offset(x + barWidth/2 - tp2.width/2, size.height - 14));
      i++;
    });
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> points; // {x: label, y: value}
  LineChartPainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    double maxY = points.map((e) => e['y'] as double).reduce((a,b) => a>b?a:b);
    double minY = points.map((e) => e['y'] as double).reduce((a,b) => a<b?a:b);
    if (maxY == minY) maxY += 1;
    final linePaint = Paint()..color = Color(0xFF2ED47A)..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final dotPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final fillPaint = Paint()..color = Color(0xFF2ED47A).withOpacity(0.15)..style = PaintingStyle.fill;
    Path path = Path();
    Path fillPath = Path();
    for (int i=0; i<points.length; i++) {
      double x = (i / (points.length - 1 == 0 ? 1 : points.length - 1)) * size.width;
      double y = size.height - 20 - ((points[i]['y'] - minY) / (maxY - minY)) * (size.height - 40);
      if (i==0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height - 20);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      if (i == points.length - 1) {
        fillPath.lineTo(x, size.height - 20);
        fillPath.close();
      }
    }
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
    for (int i=0; i<points.length; i++) {
      double x = (i / (points.length - 1 == 0 ? 1 : points.length - 1)) * size.width;
      double y = size.height - 20 - ((points[i]['y'] - minY) / (maxY - minY)) * (size.height - 40);
      canvas.drawCircle(Offset(x,y), 4, dotPaint);
      canvas.drawCircle(Offset(x,y), 4, linePaint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SulyChartPainter extends CustomPainter {

  final List<Map<String, dynamic>> data;
  SulyChartPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paintLine = Paint()
      ..color = const Color(0xFF2ED47A)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final paintDot = Paint()
      ..color = const Color(0xFFB9F5C8)
      ..style = PaintingStyle.fill;
    final paintFill = Paint()
      ..color = const Color(0xFF2ED47A).withOpacity(0.15)
      ..style = PaintingStyle.fill;
    double minY =
        data.map((e) => e['kg'] as double).reduce((a, b) => a < b ? a : b) - 1;
    double maxY =
        data.map((e) => e['kg'] as double).reduce((a, b) => a > b ? a : b) +
            0.5;
    if (data.length == 1) {
      minY = data[0]['kg'] - 1;
      maxY = data[0]['kg'] + 1;
    }
    Path path = Path();
    Path fillPath = Path();
    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      double x = data.length == 1
          ? size.width / 2
          : (i / (data.length - 1)) * size.width;
      double y =
          size.height - ((data[i]['kg'] - minY) / (maxY - minY)) * size.height;
      points.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(
        data.length == 1 ? size.width / 2 : size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);
    for (var p in points) {
      canvas.drawCircle(p, 4, paintDot);
      canvas.drawCircle(p, 2, Paint()..color = const Color(0xFF081F1A));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NapijegyPage extends StatefulWidget {
  const NapijegyPage({super.key});
  @override
  State<NapijegyPage> createState() => _NapijegyPageState();
}

class _NapijegyPageState extends State<NapijegyPage> {
  final Map<String, int> arak = {
    "Halas jegy": 6000,
    "sport 2 botos": 4000,
    "sport 3 botos": 6000,
    "turista": 3000,
    "ifi": 3000,
    "gyerek": 2000,
    "vendeg": 0,
    "tobb napos egyedi ar": 15000
  };
  String kivalasztott = "Halas jegy";
  final darabCtrl = TextEditingController(text: "1");
  final arCtrl = TextEditingController(text: "6000");
  String nezet = "Napi";
  List<dynamic> osszesAdat = [];
  String get ma => DateTime.now().toIso8601String().split("T")[0];
  String get hetEleje => DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday - 1))
      .toIso8601String()
      .split("T")[0];
  String get hoEleje => DateTime(DateTime.now().year, DateTime.now().month, 1)
      .toIso8601String()
      .split("T")[0];
  String get evEleje =>
      DateTime(DateTime.now().year, 1, 1).toIso8601String().split("T")[0];
  @override
  void initState() {
    super.initState();
    betoltes();
  }

  Future<void> betoltes() async {
    try {
      final res = await Supabase.instance.client
          .from("napijegyek")
          .select()
          .order("datum", ascending: false);
      setState(() => osszesAdat = res);
    } catch (e) {
      print('betoltes hiba: $e');
    }
  }

  Future<void> torles(dynamic id) async {
    bool? ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
                backgroundColor: const Color(0xFF14352E),
                title: const Text("Torlod?",
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: const Text("Megse")),
                  FilledButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text("Torles"))
                ]));
    if (ok != true) return;
    await Supabase.instance.client.from("napijegyek").delete().eq("id", id);
    await betoltes();
  }

  String katForTipus(String t) {
    t = t.toLowerCase();
    if (t.contains("halas")) return "Halas";
    if (t.contains("sport") || t.contains("botos")) return "Sport";
    if (t.contains("turista") ||
        t.contains("vendeg") ||
        t.contains("tobb napos")) return "Turista";
    return "Gyerek";
  }

  int arForTipus(String tipus) {
    for (var k in arak.keys) {
      if (tipus.toLowerCase() == k.toLowerCase()) return arak[k]!;
    }
    String t = tipus.toLowerCase();
    if (t.contains("halas")) return 6000;
    if (t.contains("2 botos")) return 4000;
    if (t.contains("3 botos")) return 6000;
    if (t.contains("turista")) return 3000;
    if (t.contains("ifi")) return 3000;
    if (t.contains("gyerek")) return 2000;
    return 0;
  }

  Future<void> mentes() async {
    int db = int.tryParse(darabCtrl.text) ?? 0;
    int ar = int.tryParse(arCtrl.text) ?? 0;
    if (db <= 0) {
      print('db 0 - nem ment');
      return;
    }
    String tipusMent = kivalasztott;
    if (kivalasztott.toLowerCase().contains("tobb napos")) {
      tipusMent = "tobb napos egyedi ar " + ar.toString();
    }
    print('MENTES: tipus=$tipusMent db=$db datum=$ma');
    try {
      // Eloszor csak a biztos 3 oszloppal probaljuk - ez minden tablaban van
      await Supabase.instance.client.from("napijegyek").insert({
        "tipus": tipusMent,
        "db": db,
        "datum": ma
      });
      print('MENTES SIKER - egyszeru');
    } catch (e) {
      print('egyszeru mentes hiba: $e - probaljuk ar+osszeggel');
      try {
        await Supabase.instance.client.from("napijegyek").insert({
          "tipus": tipusMent,
          "db": db,
          "datum": ma,
          "ar": ar,
          "osszeg": db * ar
        });
        print('MENTES SIKER - ar+osszeg');
      } catch (e2) {
        print('jegy mentes hiba: $e2');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Jegy mentes hiba: $e2'), backgroundColor: Colors.red)
          );
        }
        return;
      }
    }
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$db db $tipusMent mentve'), backgroundColor: Color(0xFF2ED47A))
      );
    }
    await betoltes();
  }

  void addDialog() {
    arCtrl.text = arak[kivalasztott]?.toString() ?? "0";
    showDialog(
        context: context,
        builder: (c) => StatefulBuilder(
            builder: (context, setD) => AlertDialog(
                    backgroundColor: const Color(0xFF14352E),
                    title: Text(kivalasztott,
                        style: const TextStyle(color: Colors.white, fontSize: 13)),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      DropdownButtonFormField<String>(
                          value: kivalasztott,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF14352E),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          items: arak.keys
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                      e + " - " + arak[e].toString() + " Ft",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11))))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => kivalasztott = v);
                              setD(() => {
                                    kivalasztott = v,
                                    arCtrl.text = arak[v]?.toString() ?? "0"
                                  });
                            }
                          }),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                            child: TextField(
                                controller: darabCtrl,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration:
                                    const InputDecoration(labelText: "Darab", labelStyle: TextStyle(fontSize: 11)))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextField(
                                controller: arCtrl,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration:
                                    const InputDecoration(labelText: "Ar Ft", labelStyle: TextStyle(fontSize: 11))))
                      ])
                    ]),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text("Megse")),
                      FilledButton(
                          onPressed: mentes, child: const Text("Mentes"))
                    ])));
  }

  @override
  Widget build(BuildContext context) {
    String tol = ma;
    if (nezet == "Heti") tol = hetEleje;
    if (nezet == "Havi") tol = hoEleje;
    if (nezet == "Evi") tol = evEleje;
    Map<String, int> katDb = {
      "Halas": 0,
      "Sport": 0,
      "Turista": 0,
      "Gyerek": 0
    };
    Map<String, int> katFt = {
      "Halas": 0,
      "Sport": 0,
      "Turista": 0,
      "Gyerek": 0
    };
    List<dynamic> szurt = [];
    for (var r in osszesAdat) {
      String datum = r["datum"]?.toString() ?? "";
      bool benne =
          nezet == "Napi" ? datum.startsWith(ma) : datum.compareTo(tol) >= 0;
      if (!benne) continue;
      szurt.add(r);
      String tipus = r["tipus"]?.toString() ?? "";
      int db = r["db"] ?? 0;
      int osszeg = 0;
      if (r["osszeg"] != null)
        osszeg = r["osszeg"];
      else if (r["ar"] != null)
        osszeg = db * (r["ar"] as int);
      else
        osszeg = db * arForTipus(tipus);
      String kat = katForTipus(tipus);
      katDb[kat] = katDb[kat]! + db;
      katFt[kat] = katFt[kat]! + osszeg;
    }
    int osszDb = katDb.values.fold(0, (a, b) => a + b);
    int osszFt = katFt.values.fold(0, (a, b) => a + b);
    int maxDb = katDb.values.fold(1, (a, b) => b > a ? b : a);
    return Scaffold(
      backgroundColor: const Color(0xFF081F1A),
      appBar: AppBar(
          backgroundColor: const Color(0xFF081F1A),
          title: const Text("Napijegy",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFFB9F5C8),
          onPressed: addDialog,
          icon: const Icon(Icons.add, color: Color(0xFF081F1A), size: 18),
          label: const Text("Uj jegy", style: TextStyle(color: Color(0xFF081F1A), fontSize: 12))),
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Column(children: [
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color(0xFF1A332C),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                    children: ["Napi", "Heti", "Havi", "Evi"]
                        .map((n) => Expanded(
                            child: GestureDetector(
                                onTap: () => setState(() => nezet = n),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                        color: nezet == n
                                            ? const Color(0xFFE8F5E9)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Text(n,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: nezet == n
                                                ? const Color(0xFF081F1A)
                                                : Colors.white54))))))
                        .toList())),
            const SizedBox(height: 18),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: const Color(0xFF122F27),
                    borderRadius: BorderRadius.circular(18)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nezet + " - " + ma,
                          style: const TextStyle(
                              color: Color(0xFF7FB09A), fontSize: 10)),
                      const SizedBox(height: 6),
                      Text(osszFt.toString() + " Ft",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900)),
                      Text(osszDb.toString() + " db",
                          style: const TextStyle(color: Color(0xFF6EE7A0), fontSize: 11))
                    ])),
            const SizedBox(height: 14),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: const Color(0xFF122F27),
                    borderRadius: BorderRadius.circular(18)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Jegy ertekesites",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 10),
                      SizedBox(
                          height: 120,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (var k in [
                                  "Halas",
                                  "Sport",
                                  "Turista",
                                  "Gyerek"
                                ])
                                  Expanded(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                        Text(katDb[k].toString() + "db",
                                            style: const TextStyle(
                                                color: Color(0xFF7FB09A),
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Container(
                                            height:
                                                (katDb[k]! / maxDb) * 60 + 10,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            decoration: BoxDecoration(
                                                color: katDb[k] == maxDb &&
                                                        katDb[k]! > 0
                                                    ? const Color(0xFFB9F5C8)
                                                    : const Color(0xFF2D5A4A),
                                                borderRadius:
                                                    BorderRadius.circular(4))),
                                        const SizedBox(height: 6),
                                        Text(k,
                                            style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 10))
                                      ]))
                              ]))
                    ])),
            const SizedBox(height: 14),
            for (var k in ["Halas", "Sport", "Turista", "Gyerek"])
              if (katDb[k]! > 0)
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(children: [
                      Expanded(
                          child: Text(k,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold, fontSize: 11))),
                      Text(katDb[k].toString() + "db",
                          style: const TextStyle(color: Colors.white, fontSize: 11)),
                      const SizedBox(width: 12),
                      Text(katFt[k].toString() + " Ft",
                          style: const TextStyle(
                              color: Color(0xFF7FB09A),
                              fontWeight: FontWeight.bold, fontSize: 11))
                    ])),
            const Divider(color: Color(0xFF1E443A)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Osszesen:",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 11)),
              Text(osszDb.toString() + " db - " + osszFt.toString() + " Ft",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))
            ]),
            if (nezet == "Napi") ...[
              const SizedBox(height: 16),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Napi lista (" + szurt.length.toString() + ")",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              const SizedBox(height: 8),
              for (var r in szurt)
                Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: const Color(0xFF122F27),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF1E443A))),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(r["tipus"]?.toString() ?? "",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11)),
                            Text(
                                (r["datum"]?.toString() ?? "") +
                                    " - " +
                                    (r["db"]?.toString() ?? "") +
                                    "db",
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 9))
                          ])),
                      Text((() {
                        int db = r["db"] ?? 0;
                        int o = 0;
                        if (r["osszeg"] != null)
                          o = r["osszeg"];
                        else if (r["ar"] != null)
                          o = db * (r["ar"] as int);
                        else
                          o = db * arForTipus(r["tipus"]?.toString() ?? "");
                        return o.toString() + " Ft";
                      })(),
                          style: const TextStyle(
                              color: Color(0xFF7FB09A),
                              fontWeight: FontWeight.bold,
                              fontSize: 10)),
                      const SizedBox(width: 6),
                      IconButton(
                          onPressed: () => torles(r["id"]),
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 18))
                    ]))
            ],
          ])),
    );
  }
}
