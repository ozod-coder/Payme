import 'package:flutter/material.dart';

void main() => runApp(const PayDemoApp());

class PayDemoApp extends StatelessWidget {
  const PayDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pay Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1688F8)),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Transfer {
  final String recipient;
  final String card;
  final int amount;
  final DateTime date;
  Transfer(this.recipient, this.card, this.amount, this.date);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;
  int _balance = 5000000;
  final List<Transfer> _history = [];

  String money(int value) {
    final s = value.toString();
    final out = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      out.write(s[i]);
      final left = s.length - i - 1;
      if (left > 0 && left % 3 == 0) out.write(' ');
    }
    return '${out.toString()} soʻm';
  }

  Future<void> _newTransfer() async {
    final formKey = GlobalKey<FormState>();
    final recipient = TextEditingController();
    final card = TextEditingController();
    final amount = TextEditingController();
    final result = await showModalBottomSheet<Transfer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Demo pul oʻtkazmasi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Bu sinov rejimi. Haqiqiy pul oʻtkazilmaydi.', style: TextStyle(color: Colors.deepOrange)),
                const SizedBox(height: 18),
                TextFormField(
                  controller: recipient,
                  decoration: const InputDecoration(labelText: 'Qabul qiluvchi', border: OutlineInputBorder()),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Ism kiriting' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: card,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Karta raqami (demo)', hintText: '8600 **** **** 1234', border: OutlineInputBorder()),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Demo karta raqamini kiriting' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Summa (soʻm)', border: OutlineInputBorder()),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').replaceAll(' ', ''));
                    if (n == null || n <= 0) return 'Toʻgʻri summani kiriting';
                    if (n > _balance) return 'Virtual balans yetarli emas';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    final n = int.parse(amount.text.replaceAll(' ', ''));
                    Navigator.pop(ctx, Transfer(recipient.text.trim(), card.text.trim(), n, DateTime.now()));
                  },
                  child: const Text('Demo tarzida oʻtkazish'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _balance -= result.amount;
        _history.insert(0, result);
        _tab = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('DEMO: ${money(result.amount)} oʻtkazildi. Tarixga saqlandi.'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  String dateLabel(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$d.$m.${date.year}  $h:$min';
  }

  Widget _home() => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      const SizedBox(height: 8),
      const Text('Assalomu alaykum!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      const Text('Toʻlovlaringizni boshqaring', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 22),
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF1688F8), Color(0xFF0755C9)]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('VIRTUAL BALANS · DEMO', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 12),
          Text(money(_balance), style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Row(children: [
            Icon(Icons.credit_card, color: Colors.white),
            SizedBox(width: 8),
            Text('UZCARD / HUMO · sinov kartasi', style: TextStyle(color: Colors.white)),
          ]),
        ]),
      ),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: _action(Icons.swap_horiz, 'Pul oʻtkazish', _newTransfer)),
        const SizedBox(width: 12),
        Expanded(child: _action(Icons.receipt_long, 'Tarix', () => setState(() => _tab = 1))),
      ]),
      const SizedBox(height: 22),
      const Text('Tezkor xizmatlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Wrap(spacing: 10, runSpacing: 10, children: [
        _service(Icons.phone_android, 'Mobil aloqa'),
        _service(Icons.wifi, 'Internet'),
        _service(Icons.receipt, 'Kommunal'),
        _service(Icons.qr_code, 'QR toʻlov'),
      ]),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(14)),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.info_outline, color: Colors.deepOrange),
          SizedBox(width: 10),
          Expanded(child: Text('DEMO ILOVA: balans va oʻtkazmalar faqat telefon ichidagi sinov maʼlumotlari. Haqiqiy pul harakatlanmaydi.')),
        ]),
      ),
    ],
  );

  Widget _action(IconData icon, String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(children: [
        Icon(icon, color: const Color(0xFF1688F8), size: 30),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    ),
  );

  Widget _service(IconData icon, String label) => Container(
    width: 150,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Row(children: [
      Icon(icon, color: const Color(0xFF1688F8)),
      const SizedBox(width: 8),
      Flexible(child: Text(label)),
    ]),
  );

  Widget _historyPage() {
    if (_history.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          Icon(Icons.history, size: 64, color: Colors.black26),
          SizedBox(height: 12),
          Text('Hozircha operatsiyalar yoʻq', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('Demo pul oʻtkazmasini amalga oshirsangiz, u shu yerda saqlanadi.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
        ]),
      ));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Operatsiyalar tarixi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Barcha yozuvlar demo operatsiyalaridir.', style: TextStyle(color: Colors.deepOrange)),
        const SizedBox(height: 14),
        ..._history.map((item) => Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFFE4F3E8), child: Icon(Icons.arrow_upward, color: Colors.green)),
            title: Text(item.recipient, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item.card}\n${dateLabel(item.date)}\nDEMO · Muvaffaqiyatli'),
            isThreeLine: true,
            trailing: Text('-${money(item.amount)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        )),
      ],
    );
  }

  Widget _profilePage() => ListView(padding: const EdgeInsets.all(18), children: [
    const CircleAvatar(radius: 38, child: Icon(Icons.person, size: 42)),
    const SizedBox(height: 12),
    const Center(child: Text('Demo foydalanuvchi', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
    const Center(child: Text('Profil · sinov rejimi', style: TextStyle(color: Colors.black54))),
    const SizedBox(height: 24),
    const Card(child: ListTile(leading: Icon(Icons.language), title: Text('Ilova tili'), trailing: Text('Oʻzbekcha'))),
    const Card(child: ListTile(leading: Icon(Icons.security), title: Text('Xavfsizlik'), subtitle: Text('Demo maʼlumotlar, haqiqiy bank ulanishi yoʻq'))),
    const Card(child: ListTile(leading: Icon(Icons.info_outline), title: Text('Ilova haqida'), subtitle: Text('Pay Demo · mustaqil demo loyiha'))),
  ]);

  @override
  Widget build(BuildContext context) {
    final pages = [_home(), _historyPage(), _profilePage()];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay Demo', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        actions: const [Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.notifications_none))],
      ),
      body: SafeArea(child: pages[_tab]),
      floatingActionButton: _tab == 0 ? FloatingActionButton.extended(
        onPressed: _newTransfer,
        icon: const Icon(Icons.send),
        label: const Text('Oʻtkazma'),
      ) : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Bosh sahifa'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Tarix'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
