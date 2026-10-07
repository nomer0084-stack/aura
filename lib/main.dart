import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black,
  ));
  runApp(const AuraApp());
}

class AuraApp extends StatefulWidget {
  const AuraApp({super.key});

  @override
  State<AuraApp> createState() => _AuraAppState();
}

class _AuraAppState extends State<AuraApp> {
  String _displayName = 'Александр';
  String _username = 'alex_pro';
  String _avatarUrl = '👑';
  String _themeMode = 'oled';
  Color _accentColor = const Color(0xFF8E7CFF);
  bool _is120Fps = true;
  bool _isGamingMode = true;
  bool _isVpnConnected = true;

  final List<Map<String, String>> _receivedGifts = [
    {'icon': '⭐', 'name': 'Звезда', 'from': 'Алиса', 'count': '1'},
    {'icon': '🚀', 'name': 'Ракета', 'from': 'Максим', 'count': '2'},
    {'icon': '💎', 'name': 'Кристалл', 'from': 'Aura Team', 'count': '1'},
  ];

  ThemeData _buildTheme() {
    if (_themeMode == 'oled') {
      return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardColor: const Color(0xFF0A0A0A),
        colorScheme: ColorScheme.fromSeed(seedColor: _accentColor, brightness: Brightness.dark, surface: Colors.black),
      );
    } else if (_themeMode == 'light') {
      return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        canvasColor: Colors.white,
        cardColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: _accentColor, brightness: Brightness.light),
      );
    }
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF12131E),
      canvasColor: const Color(0xFF1A1B2A),
      cardColor: const Color(0xFF222438),
      colorScheme: ColorScheme.fromSeed(seedColor: _accentColor, brightness: Brightness.dark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura iOS Edition',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: AuraShellNavigation(
        displayName: _displayName,
        username: _username,
        avatarUrl: _avatarUrl,
        themeMode: _themeMode,
        accentColor: _accentColor,
        is120Fps: _is120Fps,
        isGamingMode: _isGamingMode,
        isVpnConnected: _isVpnConnected,
        receivedGifts: _receivedGifts,
        onProfileUpdated: (name, user, av) {
          setState(() {
            _displayName = name;
            _username = user;
            _avatarUrl = av;
          });
        },
        onThemeChanged: (m) => setState(() => _themeMode = m),
        onAccentChanged: (c) => setState(() => _accentColor = c),
        on120FpsChanged: (v) => setState(() => _is120Fps = v),
        onGamingModeChanged: (v) => setState(() => _isGamingMode = v),
        onVpnToggled: (v) => setState(() => _isVpnConnected = v),
        onGiftSent: (gift) => setState(() => _receivedGifts.add(gift)),
      ),
    );
  }
}

class AuraShellNavigation extends StatefulWidget {
  final String displayName;
  final String username;
  final String avatarUrl;
  final String themeMode;
  final Color accentColor;
  final bool is120Fps;
  final bool isGamingMode;
  final bool isVpnConnected;
  final List<Map<String, String>> receivedGifts;
  final Function(String name, String user, String av) onProfileUpdated;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<Color> onAccentChanged;
  final ValueChanged<bool> on120FpsChanged;
  final ValueChanged<bool> onGamingModeChanged;
  final ValueChanged<bool> onVpnToggled;
  final ValueChanged<Map<String, String>> onGiftSent;

  const AuraShellNavigation({
    super.key,
    required this.displayName,
    required this.username,
    required this.avatarUrl,
    required this.themeMode,
    required this.accentColor,
    required this.is120Fps,
    required this.isGamingMode,
    required this.isVpnConnected,
    required this.receivedGifts,
    required this.onProfileUpdated,
    required this.onThemeChanged,
    required this.onAccentChanged,
    required this.on120FpsChanged,
    required this.onGamingModeChanged,
    required this.onVpnToggled,
    required this.onGiftSent,
  });

  @override
  State<AuraShellNavigation> createState() => _AuraShellNavigationState();
}

class _AuraShellNavigationState extends State<AuraShellNavigation> {
  int _currentIndex = 3; // По умолчанию открыт Профиль

  final List<Map<String, dynamic>> _giftsCatalog = [
    {'id': 'star', 'icon': '⭐', 'name': 'Звезда', 'price': 99, 'rarity': 'Редкий', 'color': Color(0xFFFFD166)},
    {'id': 'rocket', 'icon': '🚀', 'name': 'Ракета', 'price': 199, 'rarity': 'Эпический', 'color': Color(0xFF00F59B)},
    {'id': 'diamond', 'icon': '💎', 'name': 'Кристалл', 'price': 499, 'rarity': 'Легендарный', 'color': Color(0xFF7AC7FF)},
    {'id': 'crown', 'icon': '👑', 'name': 'Корона', 'price': 990, 'rarity': 'Мифический', 'color': Color(0xFFFF8EB3)},
    {'id': 'cake', 'icon': '🎂', 'name': 'Праздничный торт', 'price': 149, 'rarity': 'Лимитированный', 'color': Color(0xFFFFCA7A)},
  ];

  final List<Map<String, String>> _vpnNodes = [
    {'name': '🇩🇪 Германия (Франкфурт)', 'type': 'VLESS-Reality', 'ping': '18 ms', 'host': 'fra.aura.vpn'},
    {'name': '🇫🇮 Финляндия (Хельсинки)', 'type': 'VLESS-Reality', 'ping': '15 ms', 'host': 'hel.aura.vpn'},
    {'name': '🇳🇱 Нидерланды (Амстердам)', 'type': 'WireGuard', 'ping': '22 ms', 'host': 'ams.aura.vpn'},
  ];

  final List<Map<String, String>> _directChats = [
    {'name': 'Алиса', 'lastMsg': 'Подарила тебе Звезду ⭐! Спасибо за стрим!', 'time': '10:48', 'unread': '1'},
    {'name': 'Максим', 'lastMsg': 'Стрим 120 FPS просто пушка 🔥', 'time': '09:20', 'unread': '0'},
  ];

  void _importVpnLink(String link) {
    if (link.isEmpty) return;
    String name = 'Кастомная нода';
    if (link.contains('#')) name = Uri.decodeComponent(link.split('#').last);
    setState(() {
      _vpnNodes.add({
        'name': '🛡️ $name',
        'type': 'VLESS-Reality',
        'ping': '19 ms',
        'host': link.substring(0, link.length > 25 ? 25 : link.length),
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Конфиг "$name" успешно добавлен!')));
  }

  void _openGiftsShop(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _GiftsShopSheet(
        catalog: _giftsCatalog,
        accentColor: widget.accentColor,
        themeMode: widget.themeMode,
        onBuyGift: (gift) {
          Navigator.pop(ctx);
          _showPaymentSheet(context, gift);
        },
      ),
    );
  }

  void _showPaymentSheet(BuildContext context, Map<String, dynamic> gift) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PaymentCheckoutSheet(
        gift: gift,
        accentColor: widget.accentColor,
        themeMode: widget.themeMode,
        onSuccess: () {
          Navigator.pop(ctx);
          widget.onGiftSent({
            'icon': gift['icon'],
            'name': gift['name'],
            'from': 'Вы',
            'count': '1',
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Подарок "${gift['name']}" куплен! Средства зачислены на привязанную карту.'),
              backgroundColor: const Color(0xFF00F59B),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _IosServersTab(
            themeMode: widget.themeMode,
            accentColor: widget.accentColor,
            is120Fps: widget.is120Fps,
            isGamingMode: widget.isGamingMode,
            onOpenGifts: () => _openGiftsShop(context),
          ),
          _IosChatsTab(
            themeMode: widget.themeMode,
            accentColor: widget.accentColor,
            chats: _directChats,
          ),
          _IosVpnTab(
            themeMode: widget.themeMode,
            accentColor: widget.accentColor,
            isConnected: widget.isVpnConnected,
            nodes: _vpnNodes,
            onToggle: widget.onVpnToggled,
            onImportLink: _importVpnLink,
          ),
          _IosProfileTab(
            displayName: widget.displayName,
            username: widget.username,
            avatarUrl: widget.avatarUrl,
            themeMode: widget.themeMode,
            accentColor: widget.accentColor,
            is120Fps: widget.is120Fps,
            isGamingMode: widget.isGamingMode,
            gifts: widget.receivedGifts,
            onProfileUpdated: widget.onProfileUpdated,
            onThemeChanged: widget.onThemeChanged,
            onAccentChanged: widget.onAccentChanged,
            on120FpsChanged: widget.on120FpsChanged,
            onGamingModeChanged: widget.onGamingModeChanged,
            onOpenGiftsShop: () => _openGiftsShop(context),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: widget.themeMode == 'oled' ? Colors.black : const Color(0xFF13141F),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: widget.accentColor,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.forum_outlined), activeIcon: Icon(Icons.forum), label: 'Каналы'),
            BottomNavigationBarItem(
              icon: Badge(label: const Text('1'), child: const Icon(Icons.chat_bubble_outline)),
              activeIcon: const Icon(Icons.chat_bubble),
              label: 'Чаты',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_outlined, color: widget.isVpnConnected ? const Color(0xFF00F59B) : null),
              activeIcon: const Icon(Icons.shield),
              label: 'VPN Happ',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Профиль'),
          ],
        ),
      ),
    );
  }
}

class _IosServersTab extends StatelessWidget {
  final String themeMode;
  final Color accentColor;
  final bool is120Fps;
  final bool isGamingMode;
  final VoidCallback onOpenGifts;

  const _IosServersTab({
    required this.themeMode,
    required this.accentColor,
    required this.is120Fps,
    required this.isGamingMode,
    required this.onOpenGifts,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Aura Community', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19, letterSpacing: -0.5)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.18), borderRadius: BorderRadius.circular(6)),
                  child: const Text('120 FPS', style: TextStyle(color: Color(0xFF00F59B), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.card_giftcard, color: Color(0xFFFFD166)),
                  tooltip: 'Подарки',
                  onPressed: onOpenGifts,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: themeMode == 'oled' ? const Color(0xFF0E0E0E) : const Color(0xFF1E2032),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00F59B).withOpacity(0.35)),
            ),
            child: Row(
              children: [
                const Icon(Icons.graphic_eq, color: Color(0xFF00F59B)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚡ Игровая арена 120 FPS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    Text(isGamingMode ? '● Задержка 10 мс (QoS EF)' : '● Стандартная задержка', style: const TextStyle(fontSize: 11, color: Color(0xFF00F59B))),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _header('ТЕКСТОВЫЕ КАНАЛЫ'),
                _card([
                  _tile('# общий-чат', 'Основной чат сообщества', Icons.tag),
                  _tile('# турниры-и-игры', 'Стримы в 120 FPS', Icons.sports_esports),
                ]),
                const SizedBox(height: 16),
                _header('ГОЛОСОВЫЕ КОМНАТЫ'),
                _card([
                  _tile('⚡ Игровая арена', '3 участника • 120 FPS', Icons.volume_up, tr: '10 мс'),
                  _tile('🎧 Лаунж зона', 'Свободно', Icons.headphones),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(String t) => Padding(padding: const EdgeInsets.only(left: 12, bottom: 6), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)));
  Widget _card(List<Widget> c) => Container(decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(16)), child: Column(children: c));
  Widget _tile(String t, String s, IconData ic, {String? tr}) => ListTile(dense: true, leading: Icon(ic, color: accentColor, size: 20), title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), subtitle: Text(s, style: const TextStyle(fontSize: 11, color: Colors.grey)), trailing: tr != null ? Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.18), borderRadius: BorderRadius.circular(6)), child: Text(tr, style: const TextStyle(color: Color(0xFF00F59B), fontSize: 10, fontWeight: FontWeight.bold))) : const Icon(Icons.chevron_right, color: Colors.grey, size: 18));
}

class _IosChatsTab extends StatelessWidget {
  final String themeMode;
  final Color accentColor;
  final List<Map<String, String>> chats;

  const _IosChatsTab({required this.themeMode, required this.accentColor, required this.chats});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 52, padding: const EdgeInsets.symmetric(horizontal: 16), alignment: Alignment.centerLeft, child: const Text('Сообщения', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, letterSpacing: -0.5))),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 64, color: Colors.white10),
              itemBuilder: (ctx, idx) {
                final c = chats[idx];
                final hasUnread = c['unread'] != '0';
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 24, backgroundColor: accentColor, child: Text(c['name']![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 2),
                            Text(c['lastMsg']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(c['time']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          if (hasUnread) ...[
                            const SizedBox(height: 4),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(10)), child: Text(c['unread']!, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IosVpnTab extends StatelessWidget {
  final String themeMode;
  final Color accentColor;
  final bool isConnected;
  final List<Map<String, String>> nodes;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onImportLink;

  const _IosVpnTab({required this.themeMode, required this.accentColor, required this.isConnected, required this.nodes, required this.onToggle, required this.onImportLink});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const Text('VPN Happ Core', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, letterSpacing: -0.5)),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00F59B).withOpacity(0.18), foregroundColor: const Color(0xFF00F59B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                icon: const Icon(Icons.add_link, size: 16),
                label: const Text('Вставить ссылку', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: () {
                  final ctrl = TextEditingController();
                  showDialog(context: context, builder: (ctx) => AlertDialog(backgroundColor: const Color(0xFF161826), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), title: const Text('Импорт VPN-ссылки'), content: TextField(controller: ctrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'vless://... или ss://...', hintStyle: TextStyle(color: Colors.grey))), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')), ElevatedButton(onPressed: () { Navigator.pop(ctx); onImportLink(ctrl.text.trim()); }, child: const Text('Добавить'))]));
                },
              ),
            ],
          ),
          const SizedBox(height: 28),
          Center(
            child: GestureDetector(
              onTap: () => onToggle(!isConnected),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isConnected ? const Color(0xFF00F59B) : Colors.white24, width: 3), color: isConnected ? const Color(0xFF00F59B).withOpacity(0.15) : Colors.white10),
                alignment: Alignment.center,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shield, size: 42, color: isConnected ? const Color(0xFF00F59B) : Colors.grey), const SizedBox(height: 4), Text(isConnected ? 'ПОДКЛЮЧЕН' : 'ОТКЛЮЧЕН', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text(isConnected ? '● VLESS-Reality Активен (Обход DPI)' : '○ VPN Отключен', style: TextStyle(color: isConnected ? const Color(0xFF00F59B) : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))),
          const SizedBox(height: 28),
          const Text('СЕРВЕРЫ И ПОЛЬЗОВАТЕЛЬСКИЕ ССЫЛКИ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          ...nodes.map((n) => Container(margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(16)), child: ListTile(title: Text(n['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), subtitle: Text('${n['type']} • ${n['host']}', style: const TextStyle(fontSize: 11, color: Colors.grey)), trailing: Text(n['ping']!, style: const TextStyle(color: Color(0xFF00F59B), fontWeight: FontWeight.bold, fontSize: 12))))),
        ],
      ),
    );
  }
}

class _IosProfileTab extends StatelessWidget {
  final String displayName;
  final String username;
  final String avatarUrl;
  final String themeMode;
  final Color accentColor;
  final bool is120Fps;
  final bool isGamingMode;
  final List<Map<String, String>> gifts;
  final Function(String name, String user, String av) onProfileUpdated;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<Color> onAccentChanged;
  final ValueChanged<bool> on120FpsChanged;
  final ValueChanged<bool> onGamingModeChanged;
  final VoidCallback onOpenGiftsShop;

  const _IosProfileTab({
    required this.displayName,
    required this.username,
    required this.avatarUrl,
    required this.themeMode,
    required this.accentColor,
    required this.is120Fps,
    required this.isGamingMode,
    required this.gifts,
    required this.onProfileUpdated,
    required this.onThemeChanged,
    required this.onAccentChanged,
    required this.on120FpsChanged,
    required this.onGamingModeChanged,
    required this.onOpenGiftsShop,
  });

  void _editProfile(BuildContext context) {
    final nameCtrl = TextEditingController(text: displayName);
    final userCtrl = TextEditingController(text: username);
    String selAv = avatarUrl;
    final presets = ['👑', '🦊', '⚡', '🎮', '🌸', '🚀', '🐱', '🐺'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          backgroundColor: const Color(0xFF161826),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Редактировать профиль'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 32, backgroundColor: accentColor, child: Text(selAv, style: const TextStyle(fontSize: 28))),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: presets.map((av) => GestureDetector(
                  onTap: () => setD(() => selAv = av),
                  child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, color: selAv == av ? accentColor.withOpacity(0.4) : Colors.transparent), child: Text(av, style: const TextStyle(fontSize: 20))),
                )).toList(),
              ),
              const SizedBox(height: 14),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Имя профиля')),
              TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'Юзернейм (@username)', prefixText: '@')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
            ElevatedButton(onPressed: () { Navigator.pop(ctx); onProfileUpdated(nameCtrl.text.trim(), userCtrl.text.trim().replaceAll('@', ''), selAv); }, child: const Text('Сохранить')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                CircleAvatar(radius: 34, backgroundColor: accentColor, child: Text(avatarUrl, style: const TextStyle(fontSize: 30))),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('@$username', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 4),
                      const Text('● В сети • 120 FPS Active', style: TextStyle(color: Color(0xFF00F59B), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _editProfile(context)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('ВИДРИНА ПОДАРКОВ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.storefront, size: 14, color: Color(0xFFFFD166)),
                label: const Text('Магазин подарков', style: TextStyle(fontSize: 12, color: Color(0xFFFFD166), fontWeight: FontWeight.bold)),
                onPressed: onOpenGiftsShop,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(20)),
            child: gifts.isEmpty
                ? const Center(child: Text('Пока нет подарков', style: TextStyle(color: Colors.grey)))
                : Wrap(
                    spacing: 12,
                    children: gifts.map((g) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(14)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [Text(g['icon']!, style: const TextStyle(fontSize: 20)), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(g['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), Text('от ${g['from']}', style: const TextStyle(fontSize: 10, color: Colors.grey))])]),
                    )).toList(),
                  ),
          ),
          const SizedBox(height: 20),
          const Text('НАСТРОЙКИ ЭКРАНА (OLED)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                RadioListTile<String>(title: const Text('OLED True Black (#000000)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), subtitle: const Text('0% выгорания, пиксели выключены', style: TextStyle(fontSize: 11, color: Colors.grey)), value: 'oled', groupValue: themeMode, onChanged: (v) => onThemeChanged(v!)),
                RadioListTile<String>(title: const Text('Velvet Dark (Матовая темная)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), value: 'velvet', groupValue: themeMode, onChanged: (v) => onThemeChanged(v!)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('ПРОИЗВОДИТЕЛЬНОСТЬ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                SwitchListTile(title: const Text('120 FPS для всего интерфейса', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), value: is120Fps, activeColor: const Color(0xFF00F59B), onChanged: on120FpsChanged),
                SwitchListTile(title: const Text('Игровой режим (10 мс)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), value: isGamingMode, activeColor: const Color(0xFF00F59B), onChanged: onGamingModeChanged),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GiftsShopSheet extends StatelessWidget {
  final List<Map<String, dynamic>> catalog;
  final Color accentColor;
  final String themeMode;
  final ValueChanged<Map<String, dynamic>> onBuyGift;

  const _GiftsShopSheet({required this.catalog, required this.accentColor, required this.themeMode, required this.onBuyGift});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF090909) : const Color(0xFF161828), borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.all(20), child: Row(children: [const Text('🎁 Магазин подарков Aura', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const Spacer(), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))])),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.95, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: catalog.length,
              itemBuilder: (ctx, idx) {
                final g = catalog[idx];
                final color = g['color'] as Color;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.4))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(g['icon'], style: const TextStyle(fontSize: 42)),
                      const SizedBox(height: 6),
                      Text(g['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(g['rarity'], style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), onPressed: () => onBuyGift(g), child: Text('${g['price']} ₽', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCheckoutSheet extends StatelessWidget {
  final Map<String, dynamic> gift;
  final Color accentColor;
  final String themeMode;
  final VoidCallback onSuccess;

  const _PaymentCheckoutSheet({required this.gift, required this.accentColor, required this.themeMode, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: themeMode == 'oled' ? Colors.black : const Color(0xFF161828), borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [Text(gift['icon'], style: const TextStyle(fontSize: 32)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Покупка: ${gift['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('К оплате: ${gift['price']} ₽', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 14))]), const Spacer(), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))]),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
            child: Row(children: const [Icon(Icons.credit_card, color: Color(0xFF00F59B)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Прямое зачисление на банковскую карту', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text('Поддерживается СБП (0% комиссии) и МИР / Visa', style: TextStyle(fontSize: 11, color: Colors.grey))]))]),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00F59B), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), onPressed: onSuccess, child: const Text('Оплатить и подарить 💳', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          ),
        ],
      ),
    );
  }
}
