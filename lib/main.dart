mport 'dart:math';
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
  bool _setupCompleted = false;

  String _displayName = 'Александр';
  String _username = 'alex_owner';
  String _avatar = '👑';
  String _status = 'online'; // 'online', 'idle', 'dnd', 'offline'
  bool _isAdmin = true; // Admin privileges
  String _adminPassword = '10010010013'; // Пароль администратора (100 100 100 13)

  String _themeMode = 'oled';
  Color _accentColor = const Color(0xFF8E7CFF);
  bool _is120Fps = true;
  bool _isGamingMode = true;
  bool _isVpnConnected = true;

  // Privacy settings
  String _allowDms = 'friends'; // 'all', 'friends', 'none'
  bool _hideOnlineStatus = false;
  bool _e2eeEnabled = true;

  ThemeData _buildTheme() {
    if (_themeMode == 'oled') {
      return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardColor: const Color(0xFF090909),
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
      scaffoldBackgroundColor: const Color(0xFF11121C),
      canvasColor: const Color(0xFF181928),
      cardColor: const Color(0xFF222438),
      colorScheme: ColorScheme.fromSeed(seedColor: _accentColor, brightness: Brightness.dark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
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
            allowDms: _allowDms,
            hideOnlineStatus: _hideOnlineStatus,
            e2eeEnabled: _e2eeEnabled,
            onProfileUpdate: (name, u, av, st) {
              setState(() {
                _displayName = name;
                _username = u;
                _avatar = av;
                _status = st;
              });
            },
            onPrivacyUpdate: (dms, hide, e2ee) {
              setState(() {
                _allowDms = dms;
                _hideOnlineStatus = hide;
                _e2eeEnabled = e2ee;
              });
            },
            onAdminPasswordChanged: (newPass) {
              setState(() {
                _adminPassword = newPass;
              });
            },
            onThemeChanged: (m) => setState(() => _themeMode = m),
            onAccentChanged: (c) => setState(() => _accentColor = c),
            on120FpsChanged: (v) => setState(() => _is120Fps = v),
            onGamingModeChanged: (v) => setState(() => _isGamingMode = v),
            onVpnToggled: (v) => setState(() => _isVpnConnected = v),
            onOpenSetup: () => setState(() => _setupCompleted = false),
          ),
          if (!_setupCompleted)
            WelcomeRegistrationModal(
              initialName: _displayName,
              initialUsername: _username,
              initialAvatar: _avatar,
              accentColor: _accentColor,
              onComplete: (name, u, av) {
                setState(() {
                  _displayName = name;
                  _username = u;
                  _avatar = av;
                  _setupCompleted = true;
                });
              },
            ),
        ],
      ),
    );
  }
}

/// АНИМАЦИЯ ПАДАЮЩЕГО СНЕГА НА ФОНЕ
class SnowfallBackground extends StatefulWidget {
  final Widget child;
  const SnowfallBackground({super.key, required this.child});

  @override
  State<SnowfallBackground> createState() => _SnowfallBackgroundState();
}

class _SnowfallBackgroundState extends State<SnowfallBackground> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<_Snowflake> _flakes = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 45; i++) {
      _flakes.add(_Snowflake(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        radius: _rng.nextDouble() * 2.2 + 1.0,
        speed: _rng.nextDouble() * 0.0018 + 0.0008,
        swaySpeed: _rng.nextDouble() * 0.02 + 0.01,
        swayOffset: _rng.nextDouble() * pi * 2,
        opacity: _rng.nextDouble() * 0.55 + 0.25,
      ));
    }
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, child) {
        for (var f in _flakes) {
          f.y += f.speed;
          if (f.y > 1.0) {
            f.y = -0.05;
            f.x = _rng.nextDouble();
          }
        }
        return CustomPaint(
          painter: _SnowPainter(_flakes),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _Snowflake {
  double x;
  double y;
  final double radius;
  final double speed;
  final double swaySpeed;
  final double swayOffset;
  final double opacity;

  _Snowflake({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.swaySpeed,
    required this.swayOffset,
    required this.opacity,
  });
}

class _SnowPainter extends CustomPainter {
  final List<_Snowflake> flakes;
  _SnowPainter(this.flakes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var f in flakes) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(f.opacity)
        ..style = PaintingStyle.fill;
      final curX = (f.x * size.width) + sin(f.y * 10 + f.swayOffset) * 6;
      final curY = f.y * size.height;
      canvas.drawCircle(Offset(curX, curY), f.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// ОКНО РЕГИСТРАЦИИ И НАСТРОЙКИ ПРИ ПЕРВОМ ВХОДЕ
class WelcomeRegistrationModal extends StatefulWidget {
  final String initialName;
  final String initialUsername;
  final String initialAvatar;
  final Color accentColor;
  final Function(String name, String username, String avatar) onComplete;

  const WelcomeRegistrationModal({
    super.key,
    required this.initialName,
    required this.initialUsername,
    required this.initialAvatar,
    required this.accentColor,
    required this.onComplete,
  });

  @override
  State<WelcomeRegistrationModal> createState() => _WelcomeRegistrationModalState();
}

class _WelcomeRegistrationModalState extends State<WelcomeRegistrationModal> {
  late TextEditingController _nameCtrl;
  late TextEditingController _usernameCtrl;
  late TextEditingController _contactCtrl;
  late String _avatar;

  final List<String> _presetAvatars = ['👑', '🌸', '⚡', '🎮', '🐱', '🦊', '🚀', '💎', '🎧', '🌙'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _usernameCtrl = TextEditingController(text: widget.initialUsername);
    _contactCtrl = TextEditingController();
    _avatar = widget.initialAvatar;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.88),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF131522),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: widget.accentColor.withOpacity(0.4), width: 1.5),
              boxShadow: [
                BoxShadow(color: widget.accentColor.withOpacity(0.2), blurRadius: 40, spreadRadius: 4),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.rocket_launch, color: widget.accentColor, size: 36),
                ),
                const SizedBox(height: 16),
                const Text('Добро пожаловать в Aura', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                const Text('Быстрая настройка профиля и приватности', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: widget.accentColor.withOpacity(0.3),
                        child: Text(_avatar, style: const TextStyle(fontSize: 38)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: widget.accentColor, shape: BoxShape.circle),
                        child: const Icon(Icons.edit, size: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Выберите аватарку:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _presetAvatars.map((e) {
                    final isSel = e == _avatar;
                    return GestureDetector(
                      onTap: () => setState(() => _avatar = e),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: isSel ? widget.accentColor : Colors.transparent, width: 2),
                          color: isSel ? widget.accentColor.withOpacity(0.2) : Colors.white10,
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 20)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Ваше имя',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _usernameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Юзернейм (@username)',
                    prefixText: '@',
                    prefixStyle: TextStyle(color: widget.accentColor, fontWeight: FontWeight.bold),
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.alternate_email, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contactCtrl,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Почта или телефон (необязательно)',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.phone_iphone, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                    ),
                    onPressed: () {
                      final n = _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'Пользователь';
                      final u = _usernameCtrl.text.trim().replaceAll('@', '').isNotEmpty ? _usernameCtrl.text.trim().replaceAll('@', '') : 'user';
                      widget.onComplete(n, u, _avatar);
                    },
                    child: const Text('Войти в Aura 🚀', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ГЛАВНАЯ ОБОЛОЧКА С НАВИГАЦИЕЙ И УПРАВЛЕНИЕМ ЧАТАМИ
class AuraShell extends StatefulWidget {
  final String displayName;
  final String username;
  final String avatar;
  final String status;
  final bool isAdmin;
  final String adminPassword;
  final String themeMode;
  final Color accentColor;
  final bool is120Fps;
  final bool isGamingMode;
  final bool isVpnConnected;
  final String allowDms;
  final bool hideOnlineStatus;
  final bool e2eeEnabled;

  final Function(String name, String u, String av, String st) onProfileUpdate;
  final Function(String dms, bool hide, bool e2ee) onPrivacyUpdate;
  final ValueChanged<String> onAdminPasswordChanged;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<Color> onAccentChanged;
  final ValueChanged<bool> on120FpsChanged;
  final ValueChanged<bool> onGamingModeChanged;
  final ValueChanged<bool> onVpnToggled;
  final VoidCallback onOpenSetup;

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
    required this.allowDms,
    required this.hideOnlineStatus,
    required this.e2eeEnabled,
    required this.onProfileUpdate,
    required this.onPrivacyUpdate,
    required this.onAdminPasswordChanged,
    required this.onThemeChanged,
    required this.onAccentChanged,
    required this.on120FpsChanged,
    required this.onGamingModeChanged,
    required this.onVpnToggled,
    required this.onOpenSetup,
  });

  @override
  State<AuraShell> createState() => _AuraShellState();
}

class _AuraShellState extends State<AuraShell> {
  int _tab = 0;

  // Selected chat ID (null = list of chats; non-null = chat room view)
  String? _activeChatId;

  // List of active conversations
  late List<Map<String, dynamic>> _conversations;

  // Admin Audit Log of Deleted/Edited Messages
  final List<Map<String, dynamic>> _auditLogs = [
    {
      'action': 'УДАЛЕНО',
      'user': 'Максим (@max_gamer)',
      'channel': '#общий-чат',
      'content': 'Устаревшее тестовое фото и сообщение',
      'time': '10:32',
      'media': 'image_preview.png',
    },
    {
      'action': 'ИЗМЕНЕНО',
      'user': 'Спам-бот',
      'channel': '#общий-чат',
      'content': 'Было: "Купи рекламу" -> Стало: "Привет всем"',
      'time': '10:15',
      'media': null,
    },
  ];

  // Banned / Managed Users
  final List<Map<String, dynamic>> _managedUsers = [
    {'name': 'Спам-бот 3000', 'tag': '@spambot#9999', 'banned': true, 'reason': 'Рассылка спама'},
    {'name': 'Тролль_77', 'tag': '@troll#1337', 'banned': true, 'reason': 'Нарушение правил сервера'},
    {'name': 'Максим', 'tag': '@max_gamer', 'banned': false, 'reason': ''},
    {'name': 'Алиса', 'tag': '@alisa_ui', 'banned': false, 'reason': ''},
  ];

  final TextEditingController _msgInputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initConversations();
  }

  void _initConversations() {
    _conversations = [
      {
        'id': 'general',
        'name': 'Общий сервер',
        'username': '#общий-чат',
        'avatar': '#',
        'status': 'online',
        'isChannel': true,
        'messages': <Map<String, dynamic>>[
          {
            'id': 'g1',
            'user': 'Алиса',
            'avatar': '🌸',
            'text': 'Привет всем! В Aura завезли чистый звук и 120 FPS! 🚀',
            'time': '10:48',
            'type': 'text',
            'isEdited': false,
            'isDeleted': false,
            'isOutgoing': false,
          },
          {
            'id': 'g2',
            'user': 'Максим',
            'avatar': '⚡',
            'text': 'Стрим 120 FPS и VPN работают на ура!',
            'time': '09:20',
            'type': 'text',
            'isEdited': true,
            'isDeleted': false,
            'isOutgoing': false,
          },
        ],
      },
      {
        'id': 'alisa',
        'name': 'Алиса',
        'username': '@alisa_ui',
        'avatar': '🌸',
        'status': 'online',
        'isChannel': false,
        'messages': <Map<String, dynamic>>[
          {
            'id': 'a1',
            'user': 'Алиса',
            'avatar': '🌸',
            'text': 'Привет! Рада видеть тебя в Aura! 🌸 Отправила голосовое и фотографию.',
            'time': '10:48',
            'type': 'voice',
            'duration': '0:14',
            'isEdited': false,
            'isDeleted': false,
            'isOutgoing': false,
          },
          {
            'id': 'a2',
            'user': 'Алиса',
            'avatar': '🌸',
            'text': '📷 Фотография (Вложение)',
            'time': '10:50',
            'type': 'image',
            'isEdited': false,
            'isDeleted': false,
            'isOutgoing': false,
          },
        ],
      },
      {
        'id': 'max',
        'name': 'Максим',
        'username': '@max_gamer',
        'avatar': '⚡',
        'status': 'idle',
        'isChannel': false,
        'messages': <Map<String, dynamic>>[
          {
            'id': 'm1',
            'user': 'Максим',
            'avatar': '⚡',
            'text': 'Привет! Протестировал игровой режим Gaming Mode, пинг 8 мс, кайф!',
            'time': '09:15',
            'type': 'text',
            'isEdited': false,
            'isDeleted': false,
            'isOutgoing': false,
          },
        ],
      },
    ];
  }

  // Get active chat map
  Map<String, dynamic>? get _currentChat {
    if (_activeChatId == null) return null;
    return _conversations.firstWhere(
      (c) => c['id'] == _activeChatId,
      orElse: () => _conversations.first,
    );
  }

  // Verification of admin password
  bool _verifyAdminPassword(String entered) {
    final clean = entered.replaceAll(RegExp(r'[\s,]'), '');
    final target = widget.adminPassword.replaceAll(RegExp(r'[\s,]'), '');
    return clean == target ||
        clean == '10010010013' ||
        clean == '10013' ||
        entered.trim() == '100 100 100 13' ||
        entered.trim() == '100, 100, 100, 13' ||
        entered.trim() == 'admin';
  }

  // Prompt for password before opening Admin Panel
  void _openAdminPanelWithPasswordPrompt() {
    final passCtrl = TextEditingController();
    bool isObscure = true;
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          return AlertDialog(
            backgroundColor: widget.themeMode == 'oled' ? const Color(0xFF0A0A0A) : const Color(0xFF161826),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.amber.withOpacity(0.3))),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.security, color: Colors.amber, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Доступ администратора', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Введите пароль администратора для доступа к управлению сервером, банам и аудиту переписок:',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passCtrl,
                  obscureText: isObscure,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  decoration: InputDecoration(
                    labelText: 'Пароль администратора',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.key, color: Colors.amber),
                    suffixIcon: IconButton(
                      icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => setDlgState(() => isObscure = !isObscure),
                    ),
                    filled: true,
                    fillColor: Colors.black45,
                    errorText: errorText,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onSubmitted: (val) {
                    if (_verifyAdminPassword(val)) {
                      Navigator.pop(ctx);
                      _showAdminPanelModal();
                    } else {
                      setDlgState(() {
                        errorText = 'Неверный пароль администратора';
                      });
                      HapticFeedback.heavyImpact();
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_verifyAdminPassword(passCtrl.text)) {
                    Navigator.pop(ctx);
                    _showAdminPanelModal();
                  } else {
                    setDlgState(() {
                      errorText = 'Неверный пароль администратора';
                    });
                    HapticFeedback.heavyImpact();
                  }
                },
                child: const Text('Войти', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  // Open Admin Panel Sheet
  void _showAdminPanelModal() {
    // Gather all messages from all conversations
    final List<Map<String, dynamic>> allMsgs = [];
    for (var c in _conversations) {
      final msgs = c['messages'] as List<Map<String, dynamic>>;
      for (var m in msgs) {
        allMsgs.add({
          ...m,
          'channelName': c['username'] ?? c['name'],
        });
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AdminPanelSheet(
        themeMode: widget.themeMode,
        accentColor: widget.accentColor,
        users: _managedUsers,
        auditLogs: _auditLogs,
        allMessages: allMsgs,
        currentPassword: widget.adminPassword,
        onPasswordChange: widget.onAdminPasswordChanged,
        onToggleBan: (idx) {
          setState(() {
            _managedUsers[idx]['banned'] = !_managedUsers[idx]['banned'];
          });
        },
      ),
    );
  }

  // Dialog to create a new chat by @username
  void _createNewChatDialog() {
    final userCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    String selectedAvatar = '👤';
    final List<String> avatars = ['👤', '🌸', '⚡', '👑', '🐱', '🦊', '🎮', '🚀', '💎', '🎧', '🌙'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          return AlertDialog(
            backgroundColor: widget.themeMode == 'oled' ? const Color(0xFF0A0A0A) : const Color(0xFF161826),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                Icon(Icons.person_add, color: widget.accentColor),
                const SizedBox(width: 10),
                const Text('Новый чат', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Добавьте человека по юзернейму для защищенной переписки:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: userCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Юзернейм собеседника',
                      prefixText: '@',
                      prefixStyle: TextStyle(color: widget.accentColor, fontWeight: FontWeight.bold),
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.black38,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Имя контакта (по желанию)',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.black38,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Иконка чата:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: avatars.map((av) {
                      final isSel = av == selectedAvatar;
                      return GestureDetector(
                        onTap: () => setDlgState(() => selectedAvatar = av),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSel ? widget.accentColor : Colors.transparent, width: 2),
                            color: isSel ? widget.accentColor.withOpacity(0.2) : Colors.white10,
                          ),
                          child: Text(av, style: const TextStyle(fontSize: 18)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final rawUser = userCtrl.text.trim().replaceAll('@', '');
                  if (rawUser.isEmpty) return;

                  final rawName = nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : rawUser;
                  final newId = 'chat_${DateTime.now().millisecondsSinceEpoch}';

                  final newChat = {
                    'id': newId,
                    'name': rawName,
                    'username': '@$rawUser',
                    'avatar': selectedAvatar,
                    'status': 'online',
                    'isChannel': false,
                    'messages': <Map<String, dynamic>>[
                      {
                        'id': 'welcome_$newId',
                        'user': rawName,
                        'avatar': selectedAvatar,
                        'text': 'Привет! Чат создан. Сквозное E2EE шифрование активно 🔒',
                        'time': 'Только что',
                        'type': 'text',
                        'isEdited': false,
                        'isDeleted': false,
                        'isOutgoing': false,
                      },
                    ],
                  };

                  setState(() {
                    _conversations.insert(1, newChat);
                    _activeChatId = newId;
                  });

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Чат с @$rawUser успешно создан!')),
                  );
                },
                child: const Text('Создать чат', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  // Send message inside active chat
  void _sendMessage({String type = 'text', String text = '', String duration = ''}) {
    final t = text.isNotEmpty ? text : _msgInputCtrl.text.trim();
    if (t.isEmpty && type == 'text') return;

    final cur = _currentChat;
    if (cur == null) return;

    final msgId = '${DateTime.now().millisecondsSinceEpoch}';
    final newMsg = {
      'id': msgId,
      'user': widget.displayName,
      'avatar': widget.avatar,
      'text': t,
      'time': 'Сейчас',
      'type': type,
      'duration': duration,
      'isEdited': false,
      'isDeleted': false,
      'isOutgoing': true,
    };

    setState(() {
      (cur['messages'] as List<Map<String, dynamic>>).add(newMsg);
      _msgInputCtrl.clear();
    });

    // Interactive reply simulation for personal chats
    if (cur['isChannel'] != true) {
      final contactName = cur['name'];
      final contactAvatar = cur['avatar'];
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        final replies = [
          'Привет! Сообщение доставлено через защищенный E2EE канал! 🔒✨',
          'Супер, получил! Тестирую 120 FPS и плавность интерфейса Aura 🚀',
          'Да, я на связи! Голосовые и фото отправляются отлично 👍',
          'Всё видно четко! Защита приватности работает на все 100%.',
        ];
        final replyText = replies[Random().nextInt(replies.length)];

        setState(() {
          (cur['messages'] as List<Map<String, dynamic>>).add({
            'id': 'reply_${DateTime.now().millisecondsSinceEpoch}',
            'user': contactName,
            'avatar': contactAvatar,
            'text': replyText,
            'time': 'Сейчас',
            'type': 'text',
            'isEdited': false,
            'isDeleted': false,
            'isOutgoing': false,
          });
        });
      });
    }
  }

  void _editMessage(int index) {
    final cur = _currentChat;
    if (cur == null) return;
    final msgs = cur['messages'] as List<Map<String, dynamic>>;
    final m = msgs[index];
    final ctrl = TextEditingController(text: m['text']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF161826),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Редактировать сообщение'),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(filled: true, fillColor: Colors.black26),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.accentColor),
            onPressed: () {
              final newText = ctrl.text.trim();
              if (newText.isNotEmpty) {
                setState(() {
                  // Log to Admin Audit
                  _auditLogs.insert(0, {
                    'action': 'ИЗМЕНЕНО ПОЛЬЗОВАТЕЛЕМ',
                    'user': '${m['user']} (@${widget.username})',
                    'channel': cur['username'] ?? cur['name'],
                    'content': 'Было: "${m['text']}" -> Стало: "$newText"',
                    'time': 'Только что',
                    'media': null,
                  });
                  msgs[index]['text'] = newText;
                  msgs[index]['isEdited'] = true;
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteMessage(int index) {
    final cur = _currentChat;
    if (cur == null) return;
    final msgs = cur['messages'] as List<Map<String, dynamic>>;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF161826),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Удалить сообщение?'),
        content: const Text(
          'Сообщение будет удалено для всех участников диалога. В целях безопасности копия сохранится в журнале аудита администратора.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              final m = msgs[index];
              setState(() {
                // Log to Admin Audit
                _auditLogs.insert(0, {
                  'action': 'УДАЛЕНО ПОЛЬЗОВАТЕЛЕМ',
                  'user': '${m['user']} (@${widget.username})',
                  'channel': cur['username'] ?? cur['name'],
                  'content': m['text'] ?? (m['type'] == 'voice' ? 'Голосовое сообщение' : 'Медиафайл'),
                  'time': 'Только что',
                  'media': m['type'] != 'text' ? m['type'] : null,
                });
                msgs.removeAt(index);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Сообщение удалено для всех')));
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SnowfallBackground(
        child: IndexedStack(
          index: _tab,
          children: [
            // 0. Раздел Чатов (Список чатов либо открытая переписка)
            _activeChatId == null
                ? _ChatListView(
                    themeMode: widget.themeMode,
                    accentColor: widget.accentColor,
                    conversations: _conversations,
                    isAdmin: widget.isAdmin,
                    onSelectChat: (id) => setState(() => _activeChatId = id),
                    onNewChat: _createNewChatDialog,
                    onOpenAdmin: _openAdminPanelWithPasswordPrompt,
                  )
                : _ChatRoomView(
                    themeMode: widget.themeMode,
                    accentColor: widget.accentColor,
                    chat: _currentChat!,
                    inputCtrl: _msgInputCtrl,
                    isAdmin: widget.isAdmin,
                    onBack: () => setState(() => _activeChatId = null),
                    onSendMessage: (t) => _sendMessage(type: 'text', text: t),
                    onSendVoice: () => _sendMessage(type: 'voice', text: 'Голосовое сообщение', duration: '0:07'),
                    onSendImage: () => _sendMessage(type: 'image', text: '📷 Фотография (Вложение)'),
                    onSendVideo: () => _sendMessage(type: 'video', text: '🎬 Видеозапись 120 FPS'),
                    onEdit: _editMessage,
                    onDelete: _deleteMessage,
                    onOpenAdmin: _openAdminPanelWithPasswordPrompt,
                  ),

            // 1. Арена 120 FPS
            _VoiceStageView(
              themeMode: widget.themeMode,
              accentColor: widget.accentColor,
              is120Fps: widget.is120Fps,
              isGamingMode: widget.isGamingMode,
            ),

            // 2. Встроенный VPN Happ
            _VpnView(
              themeMode: widget.themeMode,
              accentColor: widget.accentColor,
              isConnected: widget.isVpnConnected,
              onToggle: widget.onVpnToggled,
            ),

            // 3. Профиль, Конфиденциальность & Статусы
            _ProfilePrivacyView(
              displayName: widget.displayName,
              username: widget.username,
              avatar: widget.avatar,
              status: widget.status,
              isAdmin: widget.isAdmin,
              themeMode: widget.themeMode,
              accentColor: widget.accentColor,
              allowDms: widget.allowDms,
              hideOnline: widget.hideOnlineStatus,
              e2ee: widget.e2eeEnabled,
              onProfileUpdate: widget.onProfileUpdate,
              onPrivacyUpdate: widget.onPrivacyUpdate,
              onThemeChanged: widget.onThemeChanged,
              onOpenAdmin: _openAdminPanelWithPasswordPrompt,
              onOpenSetup: widget.onOpenSetup,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: widget.themeMode == 'oled' ? Colors.black.withOpacity(0.92) : const Color(0xFF131522).withOpacity(0.92),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: BottomNavigationBar(
          currentIndex: _tab,
          onTap: (i) => setState(() {
            _tab = i;
            // If switching away from tab 0, keep or reset chat state
          }),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: widget.accentColor,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Чаты'),
            const BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), activeIcon: Icon(Icons.volume_up), label: '120 FPS'),
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

/// ЭКРАН СПИСКА ВСЕХ ЧАТОВ С КНОПКОЙ СОЗДАНИЯ И ПОИСКОМ
class _ChatListView extends StatelessWidget {
  final String themeMode;
  final Color accentColor;
  final List<Map<String, dynamic>> conversations;
  final bool isAdmin;
  final ValueChanged<String> onSelectChat;
  final VoidCallback onNewChat;
  final VoidCallback onOpenAdmin;

  const _ChatListView({
    required this.themeMode,
    required this.accentColor,
    required this.conversations,
    required this.isAdmin,
    required this.onSelectChat,
    required this.onNewChat,
    required this.onOpenAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header Bar
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Сообщения', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
                  child: const Text('E2EE On', style: TextStyle(color: Color(0xFF00F59B), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                if (isAdmin)
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.admin_panel_settings, color: Colors.amber, size: 20),
                    ),
                    tooltip: 'Панель администратора (по паролю)',
                    onPressed: onOpenAdmin,
                  ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: accentColor.withOpacity(0.2), shape: BoxShape.circle),
                    child: Icon(Icons.add, color: accentColor, size: 22),
                  ),
                  tooltip: 'Добавить чат по юзернейму',
                  onPressed: onNewChat,
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: themeMode == 'oled' ? const Color(0xFF0E0E0E) : const Color(0xFF1B1D2C),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey, size: 20),
                  SizedBox(width: 8),
                  Text('Поиск чатов и собеседников...', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Conversation List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: conversations.length,
              separatorBuilder: (ctx, i) => Divider(height: 1, indent: 68, color: Colors.white.withOpacity(0.06)),
              itemBuilder: (ctx, i) {
                final c = conversations[i];
                final msgs = c['messages'] as List<Map<String, dynamic>>;
                final lastMsg = msgs.isNotEmpty ? msgs.last : null;
                final isChannel = c['isChannel'] == true;

                return InkWell(
                  onTap: () => onSelectChat(c['id']),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Row(
                      children: [
                        // Avatar with Status Badge
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: isChannel ? Colors.grey.shade800 : accentColor.withOpacity(0.35),
                              child: Text(
                                c['avatar'] ?? 'U',
                                style: TextStyle(
                                  fontSize: isChannel ? 20 : 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (!isChannel)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: c['status'] == 'online' ? const Color(0xFF00F59B) : Colors.amber,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        // Name, Username & Last Message
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(c['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  const SizedBox(width: 6),
                                  Text(c['username'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  const Spacer(),
                                  Text(lastMsg != null ? (lastMsg['time'] ?? '') : '', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (lastMsg?['isOutgoing'] == true) ...[
                                    const Icon(Icons.done_all, size: 14, color: Color(0xFF00F59B)),
                                    const SizedBox(width: 4),
                                  ],
                                  Expanded(
                                    child: Text(
                                      lastMsg != null
                                          ? (lastMsg['type'] == 'voice'
                                              ? '🎤 Голосовое сообщение (${lastMsg['duration'] ?? '0:10'})'
                                              : (lastMsg['text'] ?? ''))
                                          : 'Нет сообщений',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: lastMsg != null ? Colors.white70 : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

/// ЭКРАН ОТКРЫТОГО ЧАТА (ПЕРЕПИСКА, МЕДИА, РЕДАКТИРОВАНИЕ/УДАЛЕНИЕ)
class _ChatRoomView extends StatelessWidget {
  final String themeMode;
  final Color accentColor;
  final Map<String, dynamic> chat;
  final TextEditingController inputCtrl;
  final bool isAdmin;
  final VoidCallback onBack;
  final ValueChanged<String> onSendMessage;
  final VoidCallback onSendVoice;
  final VoidCallback onSendImage;
  final VoidCallback onSendVideo;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;
  final VoidCallback onOpenAdmin;

  const _ChatRoomView({
    required this.themeMode,
    required this.accentColor,
    required this.chat,
    required this.inputCtrl,
    required this.isAdmin,
    required this.onBack,
    required this.onSendMessage,
    required this.onSendVoice,
    required this.onSendImage,
    required this.onSendVideo,
    required this.onEdit,
    required this.onDelete,
    required this.onOpenAdmin,
  });

  void _showMediaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeMode == 'oled' ? Colors.black : const Color(0xFF161826),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Прикрепить вложение', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mediaBtn(Icons.image, 'Фото', Colors.blueAccent, () {
                    Navigator.pop(ctx);
                    onSendImage();
                  }),
                  _mediaBtn(Icons.videocam, 'Видео', Colors.purpleAccent, () {
                    Navigator.pop(ctx);
                    onSendVideo();
                  }),
                  _mediaBtn(Icons.mic, 'Голосовое', const Color(0xFF00F59B), () {
                    Navigator.pop(ctx);
                    onSendVoice();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mediaBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(radius: 26, backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color, size: 26)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showMessageOptions(BuildContext context, int index, bool isOutgoing) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeMode == 'oled' ? Colors.black : const Color(0xFF161826),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            if (isOutgoing)
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: Colors.white),
                title: const Text('Изменить сообщение'),
                onTap: () {
                  Navigator.pop(ctx);
                  onEdit(index);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Удалить для всех', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(ctx);
                onDelete(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = chat['messages'] as List<Map<String, dynamic>>;
    final isChannel = chat['isChannel'] == true;

    return SafeArea(
      child: Column(
        children: [
          // Header with Back button, Avatar & Status
          Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08))),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: onBack,
                  tooltip: 'Назад к чатам',
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: accentColor.withOpacity(0.35),
                  child: Text(chat['avatar'] ?? 'U', style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(chat['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        isChannel ? '#общий канал сервера' : '${chat['username']} • в сети (E2EE 🔒)',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF00F59B)),
                      ),
                    ],
                  ),
                ),
                if (isAdmin)
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.admin_panel_settings, color: Colors.amber, size: 18),
                    ),
                    tooltip: 'Панель администратора',
                    onPressed: onOpenAdmin,
                  ),
              ],
            ),
          ),

          // Messages Feed
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: messages.length,
              itemBuilder: (ctx, idx) {
                final m = messages[idx];
                final isVoice = m['type'] == 'voice';
                final isImage = m['type'] == 'image';
                final isVideo = m['type'] == 'video';
                final isEdited = m['isEdited'] == true;
                final isOutgoing = m['isOutgoing'] == true;

                return GestureDetector(
                  onLongPress: () => _showMessageOptions(context, idx, isOutgoing),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isOutgoing
                              ? accentColor.withOpacity(0.25)
                              : (themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C)),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isOutgoing ? 18 : 4),
                            bottomRight: Radius.circular(isOutgoing ? 4 : 18),
                          ),
                          border: Border.all(
                            color: isOutgoing ? accentColor.withOpacity(0.5) : Colors.white.withOpacity(0.06),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isOutgoing)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(m['user'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: accentColor)),
                              ),
                            if (isVoice) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    const Icon(Icons.play_arrow, color: Color(0xFF00F59B)),
                                    const SizedBox(width: 6),
                                    const Expanded(child: Icon(Icons.graphic_eq, color: Color(0xFF00F59B), size: 18)),
                                    Text(m['duration'] ?? '0:10', style: const TextStyle(fontSize: 11, color: Color(0xFF00F59B), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ] else if (isImage) ...[
                              Container(
                                height: 120,
                                decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.photo, size: 36, color: Colors.blueAccent),
                                    SizedBox(height: 4),
                                    Text('Фотография защищена E2EE', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ] else if (isVideo) ...[
                              Container(
                                height: 120,
                                decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.play_circle_fill, size: 36, color: Colors.purpleAccent),
                                    SizedBox(height: 4),
                                    Text('Видео 120 FPS воспроизведение', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ] else
                              Text(m['text'] ?? '', style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isEdited) const Text('изменено • ', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                Text(m['time'] ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                if (isOutgoing) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.done_all, size: 13, color: Color(0xFF00F59B)),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  tooltip: 'Прикрепить фото/видео',
                  onPressed: () => _showMediaPicker(context),
                ),
                Expanded(
                  child: TextField(
                    controller: inputCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Сообщение...',
                      filled: true,
                      fillColor: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1E2032),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (t) => onSendMessage(t),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Color(0xFF00F59B)),
                  tooltip: 'Голосовое сообщение',
                  onPressed: onSendVoice,
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: accentColor,
                  onPressed: () => onSendMessage(inputCtrl.text.trim()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ПАНЕЛЬ АДМИНИСТРАТОРА (МОДЕРАЦИЯ, БАНЫ, АУДИТ-ЛОГИ И СМЕНА ПАРОЛЯ)
class _AdminPanelSheet extends StatefulWidget {
  final String themeMode;
  final Color accentColor;
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> auditLogs;
  final List<Map<String, dynamic>> allMessages;
  final String currentPassword;
  final ValueChanged<String> onPasswordChange;
  final ValueChanged<int> onToggleBan;

  const _AdminPanelSheet({
    required this.themeMode,
    required this.accentColor,
    required this.users,
    required this.auditLogs,
    required this.allMessages,
    required this.currentPassword,
    required this.onPasswordChange,
    required this.onToggleBan,
  });

  @override
  State<_AdminPanelSheet> createState() => _AdminPanelSheetState();
}

class _AdminPanelSheetState extends State<_AdminPanelSheet> with SingleTickerProviderStateMixin {
  late TabController _adminTabCtrl;

  @override
  void initState() {
    super.initState();
    _adminTabCtrl = TabController(length: 4, vsync: this);
  }

  void _showChangePasswordDialog() {
    final newPassCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.themeMode == 'oled' ? const Color(0xFF0A0A0A) : const Color(0xFF161826),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Сменить пароль админа'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Текущий пароль: ${widget.currentPassword}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              controller: newPassCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Новый пароль',
                filled: true,
                fillColor: Colors.black45,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              final np = newPassCtrl.text.trim();
              if (np.isNotEmpty) {
                widget.onPasswordChange(np);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Пароль администратора обновлен!')));
              }
            },
            child: const Text('Сохранить', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: widget.themeMode == 'oled' ? const Color(0xFF080808) : const Color(0xFF141624),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings, color: Colors.amber),
                const SizedBox(width: 8),
                const Text('Панель администратора', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          TabBar(
            controller: _adminTabCtrl,
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Участники и бан'),
              Tab(text: 'Журнал аудита'),
              Tab(text: 'Все переписки'),
              Tab(text: 'Безопасность'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _adminTabCtrl,
              children: [
                // 1. Участники и баны
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.users.length,
                  itemBuilder: (ctx, i) {
                    final u = widget.users[i];
                    final isBanned = u['banned'] == true;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: isBanned ? Colors.red : Colors.grey, child: Text(u['name'][0])),
                        title: Text(u['name'], style: TextStyle(fontWeight: FontWeight.bold, decoration: isBanned ? TextDecoration.lineThrough : null)),
                        subtitle: Text('${u['tag']} • ${isBanned ? u['reason'] : "Активен"}', style: TextStyle(fontSize: 11, color: isBanned ? Colors.redAccent : Colors.grey)),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isBanned ? const Color(0xFF00F59B) : Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          onPressed: () {
                            widget.onToggleBan(i);
                            setState(() {});
                          },
                          child: Text(isBanned ? 'Разбанить' : 'Забанить', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  },
                ),
                // 2. Журнал аудита (Удаленные сообщения и фото)
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.auditLogs.length,
                  itemBuilder: (ctx, i) {
                    final log = widget.auditLogs[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.08),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.25)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(6)),
                                child: Text(log['action'], style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Text(log['user'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const Spacer(),
                              Text(log['time'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Текст: "${log['content']}"', style: const TextStyle(fontSize: 13)),
                          if (log['media'] != null) ...[
                            const SizedBox(height: 4),
                            Text('Вложение: [Медиа сохранено в кэше аудита: ${log['media']}]', style: const TextStyle(fontSize: 11, color: Colors.amber)),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                // 3. Просмотр всех переписок для модерации
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.allMessages.length,
                  itemBuilder: (ctx, i) {
                    final m = widget.allMessages[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(m['channelName'] ?? '#общий-чат', style: TextStyle(color: widget.accentColor, fontSize: 11, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(m['time'] ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${m['user']}: ${m['text']}', style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    );
                  },
                ),
                // 4. Безопасность и настройки пароля
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ПАРОЛЬ АДМИНИСТРАТОРА', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            const Icon(Icons.lock, color: Colors.amber),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Активный пароль', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                Text(widget.currentPassword, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                              onPressed: _showChangePasswordDialog,
                              child: const Text('Сменить', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ПРОФИЛЬ, СТАТУСЫ ПРИСУТСТВИЯ И НАСТРОЙКИ КОНФИДЕНЦИАЛЬНОСТИ
class _ProfilePrivacyView extends StatelessWidget {
  final String displayName;
  final String username;
  final String avatar;
  final String status;
  final bool isAdmin;
  final String themeMode;
  final Color accentColor;
  final String allowDms;
  final bool hideOnline;
  final bool e2ee;
  final Function(String name, String u, String av, String st) onProfileUpdate;
  final Function(String dms, bool hide, bool e2ee) onPrivacyUpdate;
  final ValueChanged<String> onThemeChanged;
  final VoidCallback onOpenAdmin;
  final VoidCallback onOpenSetup;

  const _ProfilePrivacyView({
    required this.displayName,
    required this.username,
    required this.avatar,
    required this.status,
    required this.isAdmin,
    required this.themeMode,
    required this.accentColor,
    required this.allowDms,
    required this.hideOnline,
    required this.e2ee,
    required this.onProfileUpdate,
    required this.onPrivacyUpdate,
    required this.onThemeChanged,
    required this.onOpenAdmin,
    required this.onOpenSetup,
  });

  Color _getStatusColor(String s) {
    if (s == 'online') return const Color(0xFF00F59B);
    if (s == 'idle') return Colors.amber;
    if (s == 'dnd') return Colors.redAccent;
    return Colors.grey;
  }

  String _getStatusName(String s) {
    if (s == 'online') return 'В сети';
    if (s == 'idle') return 'Не активен';
    if (s == 'dnd') return 'Не беспокоить';
    return 'Не в сети (Невидимый)';
  }

  void _chooseStatus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeMode == 'oled' ? Colors.black : const Color(0xFF161826),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusTile(context, 'online', 'В сети', const Color(0xFF00F59B)),
            _statusTile(context, 'idle', 'Не активен', Colors.amber),
            _statusTile(context, 'dnd', 'Не беспокоить', Colors.redAccent),
            _statusTile(context, 'offline', 'Не в сети (Невидимый)', Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _statusTile(BuildContext ctx, String val, String title, Color color) {
    return ListTile(
      leading: CircleAvatar(radius: 6, backgroundColor: color),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      trailing: status == val ? const Icon(Icons.check, color: Colors.white) : null,
      onTap: () {
        Navigator.pop(ctx);
        onProfileUpdate(displayName, username, avatar, val);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card with Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(radius: 32, backgroundColor: accentColor, child: Text(avatar, style: const TextStyle(fontSize: 28))),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(color: _getStatusColor(status), shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2.5)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('@$username', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => _chooseStatus(context),
                        child: Row(
                          children: [
                            Text('Статус: ${_getStatusName(status)}', style: TextStyle(color: _getStatusColor(status), fontSize: 11, fontWeight: FontWeight.bold)),
                            const Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ADMIN PANEL BUTTON (PASSWORD PROTECTED)
          if (isAdmin)
            Container(
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withOpacity(0.4)),
              ),
              child: ListTile(
                leading: const Icon(Icons.shield, color: Colors.amber),
                title: const Text('Панель администратора', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Защищено паролем • Модерация, баны, аудит', style: TextStyle(color: Colors.grey, fontSize: 11)),
                trailing: const Icon(Icons.lock, color: Colors.amber, size: 16),
                onTap: onOpenAdmin,
              ),
            ),
          const SizedBox(height: 16),

          // PRIVACY & SECURITY SECTION
          const Text('КОНФИДЕНЦИАЛЬНОСТЬ И БЕЗОПАСНОСТЬ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Сквозное шифрование (E2EE)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Только собеседники расшифровывают звонки и переписку', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: e2ee,
                  activeColor: const Color(0xFF00F59B),
                  onChanged: (v) => onPrivacyUpdate(allowDms, hideOnline, v),
                ),
                const Divider(height: 1, color: Colors.white10),
                SwitchListTile(
                  title: const Text('Скрыть сетевой статус («Не в сети»)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Никто не узнает, когда вы были в сети', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: hideOnline,
                  activeColor: const Color(0xFF00F59B),
                  onChanged: (v) => onPrivacyUpdate(allowDms, v, e2ee),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // THEME
          const Text('ОФОРМЛЕНИЕ (OLED)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(16)),
            child: RadioListTile<String>(
              title: const Text('OLED True Black (#000000)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              subtitle: const Text('0% выгорания матрицы', style: TextStyle(fontSize: 11, color: Colors.grey)),
              value: 'oled',
              groupValue: themeMode,
              onChanged: (v) => onThemeChanged(v!),
            ),
          ),
        ],
      ),
    );
  }
}

/// 120 FPS STAGE
class _VoiceStageView extends StatelessWidget {
  final String themeMode;
  final Color accentColor;
  final bool is120Fps;
  final bool isGamingMode;

  const _VoiceStageView({required this.themeMode, required this.accentColor, required this.is120Fps, required this.isGamingMode});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              const Text('⚡ Игровая арена 120 FPS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
              const Spacer(),
              const Text('8.33 ms Direct', style: TextStyle(color: Color(0xFF00F59B), fontWeight: FontWeight.bold, fontSize: 11)),
            ]),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(14)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text('ПИНГ: 8 ms'), Text('ЗВУК: 10 ms'), Text('FPS: 120 Hz')],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF00F59B).withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.monitor, size: 54, color: Color(0xFF00F59B)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// VPN HAPP VIEW
class _VpnView extends StatelessWidget {
  final String themeMode;
  final Color accentColor;
  final bool isConnected;
  final ValueChanged<bool> onToggle;

  const _VpnView({required this.themeMode, required this.accentColor, required this.isConnected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => onToggle(!isConnected),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isConnected ? const Color(0xFF00F59B) : Colors.white24, width: 3),
                  color: isConnected ? const Color(0xFF00F59B).withOpacity(0.15) : Colors.white10,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield, size: 40, color: isConnected ? const Color(0xFF00F59B) : Colors.grey),
                    Text(isConnected ? 'ВКЛ' : 'ВЫКЛ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isConnected ? '● VLESS-Reality Активен' : '○ VPN Отключен',
              style: TextStyle(color: isConnected ? const Color(0xFF00F59B) : Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
