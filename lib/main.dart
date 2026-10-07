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
  String _status = 'online';
  bool _isAdmin = true;

  String _themeMode = 'oled';
  Color _accentColor = const Color(0xFF8E7CFF);
  bool _is120Fps = true;
  bool _isGamingMode = true;
  bool _isVpnConnected = true;

  String _allowDms = 'friends';
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
              initialUser: _username,
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

class SnowfallBackground extends StatefulWidget {
  final Widget child;
  const SnowfallBackground({super.key, required this.child});

  @override
  State<SnowfallBackground> createState() => _SnowfallBackgroundState();
}

class _SnowfallBackgroundState extends State<SnowfallBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Snowflake> _snowflakes = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 60; i++) {
      _snowflakes.add(Snowflake(
        x: _rnd.nextDouble(),
        y: _rnd.nextDouble(),
        radius: _rnd.nextDouble() * 2.6 + 1.2,
        speed: _rnd.nextDouble() * 0.002 + 0.001,
        swingSpeed: _rnd.nextDouble() * 2 + 1,
        opacity: _rnd.nextDouble() * 0.55 + 0.25,
      ));
    }
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..addListener(() {
        for (var flake in _snowflakes) {
          flake.y += flake.speed;
          if (flake.y > 1.0) {
            flake.y = 0.0;
            flake.x = _rnd.nextDouble();
          }
        }
        setState(() {});
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: SnowPainter(_snowflakes, _controller.value),
          size: Size.infinite,
        ),
        widget.child,
      ],
    );
  }
}

class Snowflake {
  double x, y, radius, speed, swingSpeed, opacity;
  Snowflake({required this.x, required this.y, required this.radius, required this.speed, required this.swingSpeed, required this.opacity});
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> flakes;
  final double animValue;
  final Paint _paint = Paint();
  SnowPainter(this.flakes, this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var flake in flakes) {
      final double sway = sin((animValue * 2 * pi * flake.swingSpeed) + (flake.radius * 10)) * 10;
      final double posX = (flake.x * size.width) + sway;
      final double posY = flake.y * size.height;
      _paint.color = Colors.white.withOpacity(flake.opacity);
      canvas.drawCircle(Offset(posX, posY), flake.radius, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WelcomeRegistrationModal extends StatefulWidget {
  final String initialName;
  final String initialUser;
  final String initialAvatar;
  final Color accentColor;
  final Function(String name, String user, String av) onComplete;

  const WelcomeRegistrationModal({
    super.key,
    required this.initialName,
    required this.initialUser,
    required this.initialAvatar,
    required this.accentColor,
    required this.onComplete,
  });

  @override
  State<WelcomeRegistrationModal> createState() => _WelcomeRegistrationModalState();
}

class _WelcomeRegistrationModalState extends State<WelcomeRegistrationModal> {
  late TextEditingController _nameCtrl;
  late TextEditingController _userCtrl;
  late TextEditingController _contactCtrl;
  late String _avatar;
  bool _isPhone = true;

  final List<String> _avatars = ['👑', '⚡', '🦊', '🚀', '🎮', '🌸', '🐺', '🐱'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _userCtrl = TextEditingController(text: widget.initialUser);
    _contactCtrl = TextEditingController();
    _avatar = widget.initialAvatar;
  }

  void _finish() {
    final name = _nameCtrl.text.trim().isEmpty ? 'Александр' : _nameCtrl.text.trim();
    final user = _userCtrl.text.trim().replaceAll('@', '').isEmpty ? 'alex_owner' : _userCtrl.text.trim().replaceAll('@', '');
    widget.onComplete(name, user, _avatar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF161826),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: widget.accentColor.withOpacity(0.4), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.18), borderRadius: BorderRadius.circular(8)),
                  child: const Text('✨ Добро пожаловать в Aura', style: TextStyle(color: Color(0xFF00F59B), fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(height: 12),
                const Text('Быстрая регистрация', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: widget.accentColor,
                  child: Text(_avatar, style: const TextStyle(fontSize: 34)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: _avatars.map((av) => GestureDetector(
                    onTap: () => setState(() => _avatar = av),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _avatar == av ? widget.accentColor.withOpacity(0.3) : Colors.white10,
                        shape: BoxShape.circle,
                        border: Border.all(color: _avatar == av ? widget.accentColor : Colors.transparent, width: 2),
                      ),
                      child: Text(av, style: const TextStyle(fontSize: 18)),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                TextField(controller: _nameCtrl, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(labelText: 'Ваше имя', filled: true, fillColor: Colors.black38, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                const SizedBox(height: 10),
                TextField(controller: _userCtrl, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(labelText: 'Юзернейм (@username)', prefixText: '@', filled: true, fillColor: Colors.black38, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                const SizedBox(height: 10),
                TextField(controller: _contactCtrl, keyboardType: _isPhone ? TextInputType.phone : TextInputType.emailAddress, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(hintText: _isPhone ? '+7 (999) 000-00-00 (опционально)' : 'email@domain.com', filled: true, fillColor: Colors.black38, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: widget.accentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))), onPressed: _finish, child: const Text('Завершить и войти 🚀', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white))),
                ),
                const SizedBox(height: 6),
                TextButton(onPressed: _finish, child: const Text('Пропустить настройку', style: TextStyle(color: Colors.grey, fontSize: 12))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuraShell extends StatefulWidget {
  final String displayName;
  final String username;
  final String avatar;
  final String status;
  final bool isAdmin;
  final String themeMode;
  final Color accentColor;
  final bool is120Fps;
  final bool isGamingMode;
  final bool isVpnConnected;
  final String allowDms;
  final bool hideOnlineStatus;
  final bool e2eeEnabled;
  final Function(String name, String user, String av, String st) onProfileUpdate;
  final Function(String dms, bool hide, bool e2ee) onPrivacyUpdate;
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

  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'user': 'Алиса',
      'avatar': 'AL',
      'text': 'Привет! Отправила голосовое и фотографию 🌸',
      'time': '10:48',
      'type': 'voice',
      'duration': '0:14',
      'isEdited': false,
      'isDeleted': false,
    },
    {
      'id': '2',
      'user': 'Максим',
      'avatar': 'MA',
      'text': 'Стрим 120 FPS и VPN работают отлично!',
      'time': '09:20',
      'type': 'text',
      'isEdited': true,
      'isDeleted': false,
    },
  ];

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

  final List<Map<String, dynamic>> _managedUsers = [
    {'name': 'Спам-бот 3000', 'tag': '@spambot#9999', 'banned': true, 'reason': 'Рассылка спама'},
    {'name': 'Тролль_77', 'tag': '@troll#1337', 'banned': true, 'reason': 'Нарушение правил сервера'},
    {'name': 'Максим', 'tag': '@max_gamer#2026', 'banned': false, 'reason': ''},
    {'name': 'Алиса', 'tag': '@alisa_ui#1402', 'banned': false, 'reason': ''},
  ];

  final TextEditingController _msgInputCtrl = TextEditingController();

  void _sendMessage({String type = 'text', String text = '', String duration = ''}) {
    final t = text.isNotEmpty ? text : _msgInputCtrl.text.trim();
    if (t.isEmpty && type == 'text') return;

    setState(() {
      _messages.add({
        'id': '${DateTime.now().millisecondsSinceEpoch}',
        'user': widget.displayName,
        'avatar': widget.avatar,
        'text': t,
        'time': 'Сейчас',
        'type': type,
        'duration': duration,
        'isEdited': false,
        'isDeleted': false,
      });
      _msgInputCtrl.clear();
    });
  }

  void _editMessage(int index) {
    final m = _messages[index];
    final ctrl = TextEditingController(text: m['text']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161826),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Редактировать сообщение'),
        content: TextField(controller: ctrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(filled: true, fillColor: Colors.black26)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.accentColor),
            onPressed: () {
              final newText = ctrl.text.trim();
              if (newText.isNotEmpty) {
                setState(() {
                  _messages[index]['text'] = newText;
                  _messages[index]['isEdited'] = true;
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161826),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Удалить сообщение?'),
        content: const Text('Сообщение будет удалено из чата, но администратор сервера сможет увидеть его в аудит-логе безопасности.', style: TextStyle(fontSize: 12, color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              final m = _messages[index];
              setState(() {
                _auditLogs.insert(0, {
                  'action': 'УДАЛЕНО ПОЛЬЗОВАТЕЛЕМ',
                  'user': '${m['user']} (@${widget.username})',
                  'channel': '#общий-чат',
                  'content': m['text'] ?? (m['type'] == 'voice' ? 'Голосовое сообщение' : 'Медиафайл'),
                  'time': 'Только что',
                  'media': m['type'] != 'text' ? m['type'] : null,
                });
                _messages.removeAt(index);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Сообщение удалено')));
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openAdminPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AdminPanelSheet(
        themeMode: widget.themeMode,
        accentColor: widget.accentColor,
        users: _managedUsers,
        auditLogs: _auditLogs,
        allMessages: _messages,
        onToggleBan: (idx) {
          setState(() {
            _managedUsers[idx]['banned'] = !_managedUsers[idx]['banned'];
          });
        },
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
            _ChatScreen(
              themeMode: widget.themeMode,
              accentColor: widget.accentColor,
              messages: _messages,
              inputCtrl: _msgInputCtrl,
              isAdmin: widget.isAdmin,
              onSendMessage: (t) => _sendMessage(type: 'text', text: t),
              onSendVoice: () => _sendMessage(type: 'voice', text: 'Голосовое сообщение', duration: '0:07'),
              onSendImage: () => _sendMessage(type: 'image', text: '📷 Фотография (Вложение)'),
              onSendVideo: () => _sendMessage(type: 'video', text: '🎬 Видеозапись 120 FPS'),
              onEdit: _editMessage,
              onDelete: _deleteMessage,
              onOpenAdmin: _openAdminPanel,
            ),
            _VoiceStageView(
              themeMode: widget.themeMode,
              accentColor: widget.accentColor,
              is120Fps: widget.is120Fps,
              isGamingMode: widget.isGamingMode,
            ),
            _VpnView(
              themeMode: widget.themeMode,
              accentColor: widget.accentColor,
              isConnected: widget.isVpnConnected,
              onToggle: widget.onVpnToggled,
            ),
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
              onOpenAdmin: _openAdminPanel,
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
          onTap: (i) => setState(() => _tab = i),
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

class _ChatScreen extends StatelessWidget {
  final String themeMode;
  final Color accentColor;
  final List<Map<String, dynamic>> messages;
  final TextEditingController inputCtrl;
  final bool isAdmin;
  final ValueChanged<String> onSendMessage;
  final VoidCallback onSendVoice;
  final VoidCallback onSendImage;
  final VoidCallback onSendVideo;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;
  final VoidCallback onOpenAdmin;

  const _ChatScreen({
    required this.themeMode,
    required this.accentColor,
    required this.messages,
    required this.inputCtrl,
    required this.isAdmin,
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

  void _showMessageOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeMode == 'oled' ? Colors.black : const Color(0xFF161826),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
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
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('# общий-чат', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.18), borderRadius: BorderRadius.circular(6)),
                  child: const Text('E2EE Protected', style: TextStyle(color: Color(0xFF00F59B), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                if (isAdmin)
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.admin_panel_settings, color: Colors.amber, size: 20),
                    ),
                    tooltip: 'Панель администратора',
                    onPressed: onOpenAdmin,
                  ),
              ],
            ),
          ),
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

                return GestureDetector(
                  onLongPress: () => _showMessageOptions(context, idx),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: accentColor,
                          child: Text(m['avatar'] ?? 'U', style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: themeMode == 'oled' ? const Color(0xFF090909) : const Color(0xFF1B1D2C),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(m['user']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const Spacer(),
                                    if (isEdited) const Text('изменено • ', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                    Text(m['time']!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                if (isVoice) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
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
                                        Text('Фотография передана в зашифрованном виде', style: TextStyle(fontSize: 11, color: Colors.grey)),
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
                                  Text(m['text']!, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
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

class _AdminPanelSheet extends StatefulWidget {
  final String themeMode;
  final Color accentColor;
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> auditLogs;
  final List<Map<String, dynamic>> allMessages;
  final ValueChanged<int> onToggleBan;

  const _AdminPanelSheet({
    required this.themeMode,
    required this.accentColor,
    required this.users,
    required this.auditLogs,
    required this.allMessages,
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
    _adminTabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
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
            tabs: const [
              Tab(text: 'Участники и бан'),
              Tab(text: 'Журнал аудита'),
              Tab(text: 'Все чаты'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _adminTabCtrl,
              children: [
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
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.allMessages.length,
                  itemBuilder: (ctx, i) {
                    final m = widget.allMessages[i];
                    return ListTile(
                      dense: true,
                      leading: Text(m['avatar'] ?? 'U'),
                      title: Text('${m['user']}: ${m['text']}'),
                      subtitle: Text('Тип: ${m['type']} • Время: ${m['time']}'),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: themeMode == 'oled' ? const Color(0xFF0C0C0C) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(20)),
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

          if (isAdmin)
            Container(
              decoration: BoxDecoration(color: Colors.amber.withOpacity(0.12), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amber.withOpacity(0.4))),
              child: ListTile(
                leading: const Icon(Icons.shield, color: Colors.amber),
                title: const Text('Открыть панель администратора', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Модерация, баны, аудит удаленных сообщений', style: TextStyle(color: Colors.grey, fontSize: 11)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.amber, size: 14),
                onTap: onOpenAdmin,
              ),
            ),
          const SizedBox(height: 16),

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
            Row(children: [const Text('⚡ Игровая арена 120 FPS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)), const Spacer(), const Text('8.33 ms Direct', style: TextStyle(color: Color(0xFF00F59B), fontWeight: FontWeight.bold, fontSize: 11))]),
            const SizedBox(height: 14),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(14)), child: const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Text('ПИНГ: 8 ms'), Text('ЗВУК: 10 ms'), Text('FPS: 120 Hz')])),
            const SizedBox(height: 14),
            Expanded(child: Container(decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF00F59B).withOpacity(0.3))), alignment: Alignment.center, child: const Icon(Icons.monitor, size: 54, color: Color(0xFF00F59B)))),
          ],
        ),
      ),
    );
  }
}

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
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isConnected ? const Color(0xFF00F59B) : Colors.white24, width: 3), color: isConnected ? const Color(0xFF00F59B).withOpacity(0.15) : Colors.white10),
                alignment: Alignment.center,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shield, size: 40, color: isConnected ? const Color(0xFF00F59B) : Colors.grey), Text(isConnected ? 'ВКЛ' : 'ВЫКЛ', style: const TextStyle(fontWeight: FontWeight.bold))]),
              ),
            ),
            const SizedBox(height: 14),
            Text(isConnected ? '● VLESS-Reality Активен' : '○ VPN Отключен', style: TextStyle(color: isConnected ? const Color(0xFF00F59B) : Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
