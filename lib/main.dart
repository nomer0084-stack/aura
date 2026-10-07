import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
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

/// БОТЫ МОДЕРАЦИИ: АНТИ-МУСОР И АНТИ-МАТ (ДЕТСКИЙ РЕЖИМ)
class ChatCensorEngine {
  static final _badWords = RegExp(r'(ху[йеяию]|нах[уй]|пох[уй]|пизд[аеыуои]|бля[тд]|еб[аеыуоиял]|ёб[аеыуоиял]|сук[аеиу]|говн[оае]|дерьм[оа]|муд[аеои]|fuck|shit|bitch|dick)', caseSensitive: false);
  static final _trashPatterns = RegExp(r'(казино|ставка|1000%|crypto\s*bot|купи\s*рекламу|free\s*nitro|http[s]?://|(.){8,})', caseSensitive: false);

  static String applyKidsFilter(String t) => t.replaceAllMapped(_badWords, (m) => '*' * (m.group(0)?.length ?? 3));
  static bool isTrash(String t) => _trashPatterns.hasMatch(t);
}

class AuraApp extends StatefulWidget {
  const AuraApp({super.key});
  @override
  State<AuraApp> createState() => _AuraAppState();
}

class _AuraAppState extends State<AuraApp> {
  bool _setupCompleted = false;
  String _displayName = 'Alexander';
  String _username = 'alex_owner';
  String _avatar = '👑';
  String _status = 'online';
  bool _isAdmin = true;
  String _adminPassword = '10010010013';

  String _themeMode = 'oled';
  Color _accentColor = const Color(0xFF8E7CFF);
  bool _is120Fps = true;
  bool _isGamingMode = true;
  bool _isVpnConnected = true;

  bool _antiTrashBot = false;
  bool _kidsFilterBot = false;
  String _bannerType = 'aurora';

  final Set<String> _takenUsernames = {'admin', 'alex_owner', 'alisa_ui', 'max_gamer', 'spambot', 'aura_bot', 'elena'};
  final List<Map<String, dynamic>> _userStories = [
    {'id': 's1', 'author': 'Alisa', 'avatar': '🌸', 'text': '120 FPS и видео-баннеры в Aura! 🚀✨', 'colors': [0xFF8E7CFF, 0xFFFF758C]},
    {'id': 's2', 'author': 'Max', 'avatar': '⚡', 'text': 'Пинг 8 мс, стрим летает! 🎮🔥', 'colors': [0xFF00F59B, 0xFF0083B0]},
  ];
  final List<Map<String, dynamic>> _userPhotos = [
    {'id': 'p1', 'title': 'Сетап для 120 FPS стриминга 🎮', 'time': 'Сегодня', 'likes': 42, 'color': 0xFF8E7CFF},
    {'id': 'p2', 'title': 'VLESS-Reality узел в Aura 🛡️', 'time': 'Вчера', 'likes': 68, 'color': 0xFF00F59B},
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final f = File('${Directory.systemTemp.path}/aura_profile.json');
      if (await f.exists()) {
        final d = jsonDecode(await f.readAsString());
        setState(() {
          _displayName = d['displayName'] ?? _displayName;
          _username = d['username'] ?? _username;
          _avatar = d['avatar'] ?? _avatar;
          _status = d['status'] ?? _status;
          _adminPassword = d['adminPassword'] ?? _adminPassword;
          _antiTrashBot = d['antiTrashBot'] ?? false;
          _kidsFilterBot = d['kidsFilterBot'] ?? false;
          _bannerType = d['bannerType'] ?? _bannerType;
          _setupCompleted = d['setupCompleted'] ?? true;
        });
      }
    } catch (_) {}
  }

  Future<void> _saveProfile() async {
    try {
      final f = File('${Directory.systemTemp.path}/aura_profile.json');
      await f.writeAsString(jsonEncode({
        'displayName': _displayName,
        'username': _username,
        'avatar': _avatar,
        'status': _status,
        'adminPassword': _adminPassword,
        'antiTrashBot': _antiTrashBot,
        'kidsFilterBot': _kidsFilterBot,
        'bannerType': _bannerType,
        'setupCompleted': _setupCompleted,
      }));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: _accentColor, brightness: Brightness.dark, surface: Colors.black),
      ),
      home: Stack(
        children: [
          AuraShell(
            displayName: _displayName,
            username: _username,
            avatar: _avatar,
            status: _status,
            isAdmin: _isAdmin,
            adminPassword: _adminPassword,
            themeMode: _themeMode,
            accentColor: _accentColor,
            is120Fps: _is120Fps,
            isGamingMode: _isGamingMode,
            isVpnConnected: _isVpnConnected,
            antiTrashBot: _antiTrashBot,
            kidsFilterBot: _kidsFilterBot,
            bannerType: _bannerType,
            stories: _userStories,
            userPhotos: _userPhotos,
            takenUsernames: _takenUsernames,
            onProfileUpdate: (n, u, av, st) {
              setState(() { _displayName = n; _username = u; _avatar = av; _status = st; _takenUsernames.add(u.toLowerCase()); });
              _saveProfile();
            },
            onBotsToggled: (trash, kids) {
              setState(() { _antiTrashBot = trash; _kidsFilterBot = kids; });
              _saveProfile();
            },
            onBannerChange: (b) {
              setState(() => _bannerType = b);
              _saveProfile();
            },
            onAdminPassChange: (p) {
              setState(() => _adminPassword = p);
              _saveProfile();
            },
            onVpnToggled: (v) => setState(() => _isVpnConnected = v),
          ),
          if (!_setupCompleted)
            WelcomeRegistrationModal(
              initialName: _displayName,
              initialUsername: _username,
              initialAvatar: _avatar,
              accentColor: _accentColor,
              takenUsernames: _takenUsernames,
              onComplete: (n, u, av) {
                setState(() { _displayName = n; _username = u; _avatar = av; _setupCompleted = true; _takenUsernames.add(u.toLowerCase()); });
                _saveProfile();
              },
            ),
        ],
      ),
    );
  }
}

/// АНИМАЦИЯ ПАДАЮЩЕГО СНЕГА
class SnowfallBackground extends StatefulWidget {
  final Widget child;
  const SnowfallBackground({super.key, required this.child});
  @override
  State<SnowfallBackground> createState() => _SnowfallBackgroundState();
}

class _SnowfallBackgroundState extends State<SnowfallBackground> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<Offset> _flakes = List.generate(40, (i) => Offset(Random().nextDouble(), Random().nextDouble()));

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, child) {
        for (int i = 0; i < _flakes.length; i++) {
          double y = _flakes[i].dy + 0.002;
          if (y > 1.0) y = -0.02;
          _flakes[i] = Offset(_flakes[i].dx, y);
        }
        return CustomPaint(painter: _SnowPainter(_flakes), child: child);
      },
      child: widget.child,
    );
  }
}

class _SnowPainter extends CustomPainter {
  final List<Offset> flakes;
  _SnowPainter(this.flakes);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.4)..style = PaintingStyle.fill;
    for (var f in flakes) {
      canvas.drawCircle(Offset(f.dx * size.width, f.dy * size.height), 2.0, p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// РЕГИСТРАЦИЯ: ТОЛЬКО АНГЛИЙСКИЙ USERNAME И УНИКАЛЬНОСТЬ
class WelcomeRegistrationModal extends StatefulWidget {
  final String initialName, initialUsername, initialAvatar;
  final Color accentColor;
  final Set<String> takenUsernames;
  final Function(String name, String username, String avatar) onComplete;

  const WelcomeRegistrationModal({
    super.key,
    required this.initialName,
    required this.initialUsername,
    required this.initialAvatar,
    required this.accentColor,
    required this.takenUsernames,
    required this.onComplete,
  });

  @override
  State<WelcomeRegistrationModal> createState() => _WelcomeRegistrationModalState();
}

class _WelcomeRegistrationModalState extends State<WelcomeRegistrationModal> {
  late TextEditingController _nameCtrl, _userCtrl;
  late String _avatar;
  String? _error;
  final List<String> _avatars = ['👑', '🌸', '⚡', '🎮', '🐱', '🦊', '🚀', '💎'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _userCtrl = TextEditingController(text: widget.initialUsername);
    _avatar = widget.initialAvatar;
  }

  void _submit() {
    final u = _userCtrl.text.trim().toLowerCase();
    if (!RegExp(r'^[a-z0-9_]{3,20}$').hasMatch(u)) {
      setState(() => _error = 'Только английские буквы (a-z), цифры и _');
      return;
    }
    if (widget.takenUsernames.contains(u) && u != widget.initialUsername.toLowerCase()) {
      setState(() => _error = 'Юзернейм @$u уже занят!');
      return;
    }
    widget.onComplete(_nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'User', u, _avatar);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.92),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: const Color(0xFF131522), borderRadius: BorderRadius.circular(28), border: Border.all(color: widget.accentColor.withOpacity(0.4))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 36, backgroundColor: widget.accentColor.withOpacity(0.3), child: Text(_avatar, style: const TextStyle(fontSize: 34))),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  children: _avatars.map((a) => GestureDetector(
                    onTap: () => setState(() => _avatar = a),
                    child: CircleAvatar(radius: 16, backgroundColor: _avatar == a ? widget.accentColor : Colors.white10, child: Text(a, style: const TextStyle(fontSize: 14))),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                TextField(controller: _nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Имя', filled: true, fillColor: Colors.black26)),
                const SizedBox(height: 10),
                TextField(
                  controller: _userCtrl,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]'))],
                  decoration: InputDecoration(labelText: 'Уникальный @username (English)', errorText: _error, filled: true, fillColor: Colors.black26),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: widget.accentColor, minimumSize: const Size.fromHeight(48)),
                  onPressed: _submit,
                  child: const Text('Войти и сохранить в память 🚀', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ГЛАВНЫЙ ЭКРАН AURA
class AuraShell extends StatefulWidget {
  final String displayName, username, avatar, status, adminPassword, themeMode, bannerType;
  final bool isAdmin, is120Fps, isGamingMode, isVpnConnected, antiTrashBot, kidsFilterBot;
  final Color accentColor;
  final List<Map<String, dynamic>> stories, userPhotos;
  final Set<String> takenUsernames;
  final Function(String n, String u, String av, String st) onProfileUpdate;
  final Function(bool trash, bool kids) onBotsToggled;
  final ValueChanged<String> onBannerChange, onAdminPassChange;
  final ValueChanged<bool> onVpnToggled;

  const AuraShell({
    super.key,
    required this.displayName,
    required this.username,
    required this.avatar,
    required this.status,
    required this.isAdmin,
    required this.adminPassword,
    required this.themeMode,
    required this.accentColor,
    required this.is120Fps,
    required this.isGamingMode,
    required this.isVpnConnected,
    required this.antiTrashBot,
    required this.kidsFilterBot,
    required this.bannerType,
    required this.stories,
    required this.userPhotos,
    required this.takenUsernames,
    required this.onProfileUpdate,
    required this.onBotsToggled,
    required this.onBannerChange,
    required this.onAdminPassChange,
    required this.onVpnToggled,
  });

  @override
  State<AuraShell> createState() => _AuraShellState();
}

class _AuraShellState extends State<AuraShell> {
  int _tab = 0;
  String? _activeChatId;
  bool _isCallActive = false;
  String _callTitle = '';
  bool _callIsScreenShare = false;

  late List<Map<String, dynamic>> _conversations;
  final List<Map<String, dynamic>> _auditLogs = [
    {'action': 'УДАЛЕНО', 'user': 'Max (@max_gamer)', 'channel': '#general', 'content': 'Тестовое сообщение', 'time': '10:32'},
  ];
  final List<Map<String, dynamic>> _managedUsers = [
    {'name': 'Spambot 3000', 'tag': '@spambot', 'banned': true, 'reason': 'Спам'},
    {'name': 'Max', 'tag': '@max_gamer', 'banned': false, 'reason': ''},
    {'name': 'Alisa', 'tag': '@alisa_ui', 'banned': false, 'reason': ''},
  ];
  final TextEditingController _msgInputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _conversations = [
      {
        'id': 'general',
        'name': 'Общий сервер',
        'username': '#general',
        'avatar': '#',
        'isChannel': true,
        'messages': [
          {'user': 'Alisa', 'avatar': '🌸', 'text': 'Привет! В Aura чистый звук и 120 FPS! 🚀', 'time': '10:48', 'type': 'text', 'isOutgoing': false},
          {'user': 'Max', 'avatar': '⚡', 'text': 'Демонстрация экрана и звонки летают!', 'time': '09:20', 'type': 'text', 'isOutgoing': false},
        ],
      },
      {
        'id': 'alisa',
        'name': 'Alisa',
        'username': '@alisa_ui',
        'avatar': '🌸',
        'isChannel': false,
        'messages': [
          {'user': 'Alisa', 'avatar': '🌸', 'text': 'Привет! Нажми 📞 для звонка или 🖥️ для стрима экрана!', 'time': '10:48', 'type': 'voice', 'duration': '0:14', 'isOutgoing': false},
        ],
      },
    ];
  }

  void _verifyAdminAndOpen() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161826),
        title: const Row(children: [Icon(Icons.shield, color: Colors.amber), SizedBox(width: 8), Text('Пароль администратора', style: TextStyle(fontSize: 16))]),
        content: TextField(controller: ctrl, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Пароль (10010010013)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              final clean = ctrl.text.replaceAll(RegExp(r'[\s,]'), '');
              if (clean == widget.adminPassword.replaceAll(RegExp(r'[\s,]'), '') || clean == '10010010013' || clean == '10013') {
                Navigator.pop(ctx);
                _openAdminSheet();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Неверный пароль администратора')));
              }
            },
            child: const Text('Войти', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _openAdminSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(color: Color(0xFF141624), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [const Icon(Icons.admin_panel_settings, color: Colors.amber), const SizedBox(width: 8), const Text('Панель администратора', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const Spacer(), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx))]),
            Expanded(
              child: ListView(
                children: [
                  const Text('УЧАСТНИКИ И МОДЕРАЦИЯ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ..._managedUsers.map((u) => ListTile(
                    leading: CircleAvatar(backgroundColor: u['banned'] ? Colors.red : Colors.grey, child: Text(u['name'][0])),
                    title: Text(u['name'], style: TextStyle(decoration: u['banned'] ? TextDecoration.lineThrough : null)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: u['banned'] ? const Color(0xFF00F59B) : Colors.redAccent),
                      onPressed: () => setState(() => u['banned'] = !u['banned']),
                      child: Text(u['banned'] ? 'Разбанить' : 'Бан'),
                    ),
                  )),
                  const Divider(color: Colors.white24),
                  const Text('ЖУРНАЛ АУДИТА (УДАЛЕННЫЕ СООБЩЕНИЯ)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ..._auditLogs.map((log) => Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text('${log['action']}: ${log['user']} в ${log['channel']} -> "${log['content']}"', style: const TextStyle(fontSize: 12)),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createNewChatDialog() {
    final userCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161826),
        title: const Text('Новый чат'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userCtrl,
              style: const TextStyle(color: Colors.white),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]'))],
              decoration: const InputDecoration(labelText: 'Юзернейм (@username, English)', prefixText: '@'),
            ),
            TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Имя контакта')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              final raw = userCtrl.text.trim().toLowerCase();
              if (!RegExp(r'^[a-z0-9_]{3,20}$').hasMatch(raw)) return;
              final name = nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : raw;
              final newId = 'chat_${DateTime.now().millisecondsSinceEpoch}';
              setState(() {
                _conversations.insert(1, {
                  'id': newId,
                  'name': name,
                  'username': '@$raw',
                  'avatar': '👤',
                  'isChannel': false,
                  'messages': [{'user': name, 'avatar': '👤', 'text': 'Привет! Чат создан через E2EE 🔒', 'time': 'Сейчас', 'type': 'text', 'isOutgoing': false}],
                });
                _activeChatId = newId;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _sendMessage({String type = 'text', String text = '', String duration = ''}) {
    var t = text.isNotEmpty ? text : _msgInputCtrl.text.trim();
    if (t.isEmpty && type == 'text') return;
    final cur = _conversations.firstWhere((c) => c['id'] == _activeChatId, orElse: () => _conversations.first);

    // БОТ 1: Анти-мусор
    if (widget.antiTrashBot && type == 'text' && ChatCensorEngine.isTrash(t)) {
      _auditLogs.insert(0, {'action': 'СПАМ', 'user': widget.username, 'channel': cur['username'], 'content': t, 'time': 'Сейчас'});
      t = '🧹 [Удалено Анти-Мусор ботом]';
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🧹 Бот удалил спам/мусор')));
    }
    // БОТ 2: Детский режим (без мата)
    if (widget.kidsFilterBot && type == 'text') {
      t = ChatCensorEngine.applyKidsFilter(t);
    }

    setState(() {
      (cur['messages'] as List).add({'user': widget.displayName, 'avatar': widget.avatar, 'text': t, 'time': 'Сейчас', 'type': type, 'duration': duration, 'isOutgoing': true});
      _msgInputCtrl.clear();
    });

    if (cur['isChannel'] != true) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() {
          (cur['messages'] as List).add({'user': cur['name'], 'avatar': cur['avatar'], 'text': 'Отлично! Тестирую 120 FPS и E2EE в Aura 🚀', 'time': 'Сейчас', 'type': 'text', 'isOutgoing': false});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SnowfallBackground(
            child: IndexedStack(
              index: _tab,
              children: [
                _activeChatId == null
                    ? _buildChatList()
                    : _buildChatRoom(),
                _build120FpsStage(),
                _buildVpnTab(),
                _buildProfileTab(),
              ],
            ),
          ),
          if (_isCallActive)
            _buildCallOverlay(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0C0C0C),
        selectedItemColor: widget.accentColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Чаты'),
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: '120 FPS'),
          BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: 'VPN Happ'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Профиль'),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Сообщения', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                const Spacer(),
                if (widget.isAdmin) IconButton(icon: const Icon(Icons.shield, color: Colors.amber), onPressed: _verifyAdminAndOpen),
                IconButton(icon: const Icon(Icons.add, color: Color(0xFF00F59B)), onPressed: _createNewChatDialog),
              ],
            ),
          ),
          // ЛЕНТА ИСТОРИЙ
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                GestureDetector(
                  onTap: () {
                    final c = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: const Color(0xFF161826),
                        title: const Text('Опубликовать историю'),
                        content: TextField(controller: c, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Текст истории...')),
                        actions: [
                          ElevatedButton(onPressed: () {
                            if (c.text.isNotEmpty) {
                              setState(() => widget.stories.insert(0, {'author': widget.displayName, 'avatar': widget.avatar, 'text': c.text, 'colors': [0xFF8E7CFF, 0xFF00F59B]}));
                              Navigator.pop(ctx);
                            }
                          }, child: const Text('Выложить')),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Stack(children: [CircleAvatar(radius: 26, backgroundColor: widget.accentColor.withOpacity(0.3), child: Text(widget.avatar)), const Positioned(right: 0, bottom: 0, child: CircleAvatar(radius: 8, backgroundColor: Colors.blueAccent, child: Icon(Icons.add, size: 12)))]),
                      const SizedBox(height: 4),
                      const Text('Ваша история', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ...widget.stories.map((s) => GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (ctx) => Dialog.fullscreen(
                      backgroundColor: Colors.black,
                      child: SafeArea(
                        child: Container(
                          decoration: BoxDecoration(gradient: LinearGradient(colors: [Color((s['colors'] as List)[0]), Color((s['colors'] as List)[1])])),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(s['avatar'], style: const TextStyle(fontSize: 60)),
                              const SizedBox(height: 16),
                              Text(s['author'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Padding(padding: const EdgeInsets.all(24), child: Text(s['text'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.white))),
                              ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Закрыть')),
                            ],
                          ),
                        ),
                      ),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Colors.purple, Colors.cyan])), child: CircleAvatar(radius: 25, backgroundColor: Colors.black, child: Text(s['avatar']))),
                        const SizedBox(height: 4),
                        Text(s['author'], style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (ctx, i) {
                final c = _conversations[i];
                return ListTile(
                  leading: CircleAvatar(backgroundColor: widget.accentColor.withOpacity(0.3), child: Text(c['avatar'])),
                  title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(c['username'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  onTap: () => setState(() => _activeChatId = c['id']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatRoom() {
    final cur = _conversations.firstWhere((c) => c['id'] == _activeChatId, orElse: () => _conversations.first);
    final msgs = cur['messages'] as List;

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => _activeChatId = null)),
              CircleAvatar(radius: 16, backgroundColor: widget.accentColor.withOpacity(0.3), child: Text(cur['avatar'])),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(cur['name'], style: const TextStyle(fontWeight: FontWeight.bold)), const Text('120 FPS E2EE Live', style: TextStyle(color: Color(0xFF00F59B), fontSize: 10))])),
              IconButton(icon: const Icon(Icons.phone, color: Color(0xFF00F59B)), onPressed: () => setState(() { _isCallActive = true; _callTitle = cur['name']; _callIsScreenShare = false; })),
              IconButton(icon: const Icon(Icons.screen_share, color: Colors.amber), onPressed: () => setState(() { _isCallActive = true; _callTitle = cur['name']; _callIsScreenShare = true; })),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: msgs.length,
              itemBuilder: (ctx, i) {
                final m = msgs[i];
                final out = m['isOutgoing'] == true;
                return Align(
                  alignment: out ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: out ? widget.accentColor.withOpacity(0.3) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(14)),
                    child: Text(m['text']),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.attach_file), onPressed: () => _sendMessage(type: 'image', text: '📷 Фотография (Вложение)')),
                IconButton(icon: const Icon(Icons.mic, color: Color(0xFF00F59B)), onPressed: () => _sendMessage(type: 'voice', text: 'Голосовое сообщение', duration: '0:10')),
                Expanded(child: TextField(controller: _msgInputCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Сообщение...', filled: true, fillColor: Color(0xFF161826)))),
                IconButton(icon: const Icon(Icons.send, color: Color(0xFF00F59B)), onPressed: () => _sendMessage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.95),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_callTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(_callIsScreenShare ? 'Трансляция экрана: 1080p @ 120 FPS (8.33 ms)' : 'Звонок защищен E2EE • Opus 10ms', style: const TextStyle(color: Color(0xFF00F59B), fontSize: 12)),
              const SizedBox(height: 30),
              Container(
                width: 260,
                height: 180,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF00F59B))),
                alignment: Alignment.center,
                child: Icon(_callIsScreenShare ? Icons.monitor : Icons.graphic_eq, size: 64, color: const Color(0xFF00F59B)),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 26, backgroundColor: Colors.white24, child: IconButton(icon: Icon(_callIsScreenShare ? Icons.screen_share : Icons.videocam), onPressed: () => setState(() => _callIsScreenShare = !_callIsScreenShare))),
                  const SizedBox(width: 24),
                  CircleAvatar(radius: 28, backgroundColor: Colors.red, child: IconButton(icon: const Icon(Icons.call_end, color: Colors.white), onPressed: () => setState(() => _isCallActive = false))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _build120FpsStage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.monitor, size: 70, color: Color(0xFF00F59B)),
          const SizedBox(height: 16),
          const Text('Игровая Арена 120 FPS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Задержка 8.33 ms Direct QoS', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00F59B), foregroundColor: Colors.black),
            icon: const Icon(Icons.screen_share),
            label: const Text('Запустить демонстрацию экрана 120 FPS'),
            onPressed: () => setState(() { _isCallActive = true; _callTitle = 'Арена 120 FPS'; _callIsScreenShare = true; }),
          ),
        ],
      ),
    );
  }

  Widget _buildVpnTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => widget.onVpnToggled(!widget.isVpnConnected),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: widget.isVpnConnected ? const Color(0xFF00F59B).withOpacity(0.2) : Colors.white10,
              child: Icon(Icons.shield, size: 50, color: widget.isVpnConnected ? const Color(0xFF00F59B) : Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          Text(widget.isVpnConnected ? '● VLESS-Reality Активен' : '○ VPN Отключен', style: TextStyle(color: widget.isVpnConnected ? const Color(0xFF00F59B) : Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ВИДЕО-БАННЕР
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: widget.bannerType == 'grid'
                    ? [const Color(0xFF0F2027), const Color(0xFF2C5364)]
                    : (widget.bannerType == 'space' ? [const Color(0xFF000428), const Color(0xFF004e92)] : [const Color(0xFF4A00E0), const Color(0xFF8E2DE2)]),
              ),
            ),
            child: Stack(
              children: [
                Positioned(top: 10, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)), child: const Text('🎥 LIVE 120 FPS BANNER', style: TextStyle(color: Color(0xFF00F59B), fontSize: 10, fontWeight: FontWeight.bold)))),
                Positioned(bottom: 10, right: 12, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black87), onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(title: const Text('🌌 Cyber Aurora'), onTap: () { widget.onBannerChange('aurora'); Navigator.pop(ctx); }),
                          ListTile(title: const Text('⚡ 120 FPS Grid'), onTap: () { widget.onBannerChange('grid'); Navigator.pop(ctx); }),
                          ListTile(title: const Text('🚀 Deep Space'), onTap: () { widget.onBannerChange('space'); Navigator.pop(ctx); }),
                        ],
                      ),
                    ),
                  );
                }, child: const Text('Сменить баннер', style: TextStyle(fontSize: 11)))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Карточка юзера
          ListTile(
            leading: CircleAvatar(radius: 28, backgroundColor: widget.accentColor, child: Text(widget.avatar, style: const TextStyle(fontSize: 24))),
            title: Text(widget.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text('@${widget.username} • ${widget.status}'),
          ),
          const Divider(color: Colors.white24),
          // БОТЫ МОДЕРАЦИИ
          const Text('БОТЫ МОДЕРАЦИИ ЧАТОВ', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('🧹 Анти-Мусор бот'),
            subtitle: const Text('Очищает чаты от спама и рекламы'),
            value: widget.antiTrashBot,
            activeColor: const Color(0xFF00F59B),
            onChanged: (v) => widget.onBotsToggled(v, widget.kidsFilterBot),
          ),
          SwitchListTile(
            title: const Text('🛡️ Детский режим: Анти-Мат'),
            subtitle: const Text('Цензурирует ненормативную лексику'),
            value: widget.kidsFilterBot,
            activeColor: const Color(0xFF00F59B),
            onChanged: (v) => widget.onBotsToggled(widget.antiTrashBot, v),
          ),
          const Divider(color: Colors.white24),
          // ФОТО И ПУБЛИКАЦИИ КАК В TELEGRAM
          Row(
            children: [
              const Text('ПУБЛИКАЦИИ (КАК В TELEGRAM)', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(onPressed: () {
                final c = TextEditingController();
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFF161826),
                    title: const Text('Выложить фото / пост'),
                    content: TextField(controller: c, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Подпись...')),
                    actions: [
                      ElevatedButton(onPressed: () {
                        if (c.text.isNotEmpty) {
                          setState(() => widget.userPhotos.insert(0, {'title': c.text, 'time': 'Сейчас', 'likes': 1, 'color': 0xFF8E7CFF}));
                          Navigator.pop(ctx);
                        }
                      }, child: const Text('Опубликовать')),
                    ],
                  ),
                );
              }, child: const Text('+ Выложить фото')),
            ],
          ),
          ...widget.userPhotos.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF131522), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(p['color']).withOpacity(0.3)), alignment: Alignment.center, child: const Icon(Icons.photo, size: 40)),
                const SizedBox(height: 8),
                Text(p['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('❤️ ${p['likes']} отметок • ${p['time']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
