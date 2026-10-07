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

/// УМНЫЙ ДВИЖОК МОДЕРАЦИИ: АНТИ-МУСОР И ДЕТСКИЙ РЕЖИМ (АНТИ-МАТ)
class ChatCensorEngine {
  static final List<RegExp> _profanityPatterns = [
    RegExp(r'(ху[йеяию]|нах[уй]|пох[уй]|пизд[аеыуои]|бля[тд]|еб[аеыуоиял]|ёб[аеыуоиял]|сук[аеиу]|говн[оае]|дерьм[оа]|муд[аеои]|гандон|залуп|долбо[её]б)', caseSensitive: false),
    RegExp(r'(fuck|shit|bitch|asshole|dick|cunt|bastard|pussy|fag|nigger)', caseSensitive: false),
  ];

  static final List<RegExp> _trashPatterns = [
    RegExp(r'(казино|ставка|ставк[ие]|выигрыш|1000%|crypto\s*bot|купи\s*рекламу|free\s*nitro|бесплатн[оые]\s*нитро|подпишись\s*на\s*канал)', caseSensitive: false),
    RegExp(r'(http[s]?://[^\s]+)', caseSensitive: false),
    RegExp(r'(.){9,}', caseSensitive: false),
  ];

  static String applyKidsFilter(String text) {
    String censored = text;
    for (var pattern in _profanityPatterns) {
      censored = censored.replaceAllMapped(pattern, (match) {
        final word = match.group(0) ?? '';
        return '*' * word.length;
      });
    }
    return censored;
  }

  static bool isTrashOrSpam(String text) {
    for (var pattern in _trashPatterns) {
      if (pattern.hasMatch(text)) return true;
    }
    return false;
  }
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

  bool _allowDms = 'friends';
  bool _hideOnlineStatus = false;
  bool _e2eeEnabled = true;

  bool _antiTrashBot = false;
  bool _kidsFilterBot = false;
  String _bannerType = 'aurora'; // 'aurora', 'grid', 'space', 'crystal'

  final Set<String> _takenUsernames = {
    'admin',
    'alex_owner',
    'alisa_ui',
    'max_gamer',
    'moderator',
    'spambot',
    'aura_bot',
    'elena',
    'pavel',
  };

  final List<Map<String, dynamic>> _userStories = [
    {
      'id': 's_alisa',
      'author': 'Алиса',
      'avatar': '🌸',
      'time': '2 ч назад',
      'text': 'Тестируем 120 FPS видео-баннеры и истории в Aura! 🚀✨',
      'gradient': [const Color(0xFF8E7CFF), const Color(0xFFFF758C)],
    },
    {
      'id': 's_max',
      'author': 'Максим',
      'avatar': '⚡',
      'time': '4 ч назад',
      'text': 'Новый рекорд в игре с пингом 8 мс! Стрим идет на ура 🎮🔥',
      'gradient': [const Color(0xFF00F59B), const Color(0xFF0083B0)],
    },
  ];

  final List<Map<String, dynamic>> _userPhotos = [
    {
      'id': 'p1',
      'title': 'Мой сетап для 120 FPS стриминга 🎮',
      'time': 'Сегодня в 14:20',
      'likes': 42,
      'isLiked': true,
      'colorHex': 0xFF8E7CFF,
    },
    {
      'id': 'p2',
      'title': 'Запустил защищенный узел VLESS-Reality в Aura 🛡️',
      'time': 'Вчера',
      'likes': 68,
      'isLiked': false,
      'colorHex': 0xFF00F59B,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedUserProfile();
  }

  Future<void> _loadSavedUserProfile() async {
    try {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/aura_user_profile.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);
        setState(() {
          _displayName = data['displayName'] ?? _displayName;
          _username = data['username'] ?? _username;
          _avatar = data['avatar'] ?? _avatar;
          _status = data['status'] ?? _status;
          _adminPassword = data['adminPassword'] ?? _adminPassword;
          _themeMode = data['themeMode'] ?? _themeMode;
          _setupCompleted = data['setupCompleted'] ?? true;
          _allowDms = data['allowDms'] ?? _allowDms;
          _hideOnlineStatus = data['hideOnlineStatus'] ?? _hideOnlineStatus;
          _e2eeEnabled = data['e2eeEnabled'] ?? _e2eeEnabled;
          _antiTrashBot = data['antiTrashBot'] ?? false;
          _kidsFilterBot = data['kidsFilterBot'] ?? false;
          _bannerType = data['bannerType'] ?? _bannerType;
          if (data['takenUsernames'] != null) {
            final List list = data['takenUsernames'];
            _takenUsernames.addAll(list.map((e) => e.toString().toLowerCase()));
          }
        });
      }
    } catch (_) {}
  }

  Future<void> _saveUserProfile() async {
    try {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/aura_user_profile.json');
      final map = {
        'displayName': _displayName,
        'username': _username,
        'avatar': _avatar,
        'status': _status,
        'adminPassword': _adminPassword,
        'themeMode': _themeMode,
        'setupCompleted': _setupCompleted,
        'allowDms': _allowDms,
        'hideOnlineStatus': _hideOnlineStatus,
        'e2eeEnabled': _e2eeEnabled,
        'antiTrashBot': _antiTrashBot,
        'kidsFilterBot': _kidsFilterBot,
        'bannerType': _bannerType,
        'takenUsernames': _takenUsernames.toList(),
      };
      await file.writeAsString(jsonEncode(map));
    } catch (_) {}
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.black,
      cardColor: const Color(0xFF090909),
      colorScheme: ColorScheme.fromSeed(seedColor: _accentColor, brightness: Brightness.dark, surface: Colors.black),
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
            antiTrashBot: _antiTrashBot,
            kidsFilterBot: _kidsFilterBot,
            bannerType: _bannerType,
            stories: _userStories,
            userPhotos: _userPhotos,
            takenUsernames: _takenUsernames,
            onProfileUpdate: (name, u, av, st) {
              setState(() {
                _displayName = name;
                _username = u;
                _avatar = av;
                _status = st;
                _takenUsernames.add(u.toLowerCase());
              });
              _saveUserProfile();
            },
            onPrivacyUpdate: (dms, hide, e2ee) {
              setState(() {
                _allowDms = dms;
                _hideOnlineStatus = hide;
                _e2eeEnabled = e2ee;
              });
              _saveUserProfile();
            },
            onAdminPasswordChanged: (newPass) {
              setState(() => _adminPassword = newPass);
              _saveUserProfile();
            },
            onBotsToggled: (trash, kids) {
              setState(() {
                _antiTrashBot = trash;
                _kidsFilterBot = kids;
              });
              _saveUserProfile();
            },
            onBannerChange: (b) {
              setState(() => _bannerType = b);
              _saveUserProfile();
            },
            onAddStory: (text, grad) {
              setState(() {
                _userStories.insert(0, {
                  'id': 's_${DateTime.now().millisecondsSinceEpoch}',
                  'author': _displayName,
                  'avatar': _avatar,
                  'time': 'Только что',
                  'text': text,
                  'gradient': grad,
                });
              });
            },
            onAddPhotoPost: (title, colorHex) {
              setState(() {
                _userPhotos.insert(0, {
                  'id': 'p_${DateTime.now().millisecondsSinceEpoch}',
                  'title': title,
                  'time': 'Только что',
                  'likes': 1,
                  'isLiked': false,
                  'colorHex': colorHex,
                });
              });
            },
            onVpnToggled: (v) => setState(() => _isVpnConnected = v),
            onOpenSetup: () => setState(() => _setupCompleted = false),
          ),
          if (!_setupCompleted)
            WelcomeRegistrationModal(
              initialName: _displayName,
              initialUsername: _username,
              initialAvatar: _avatar,
              accentColor: _accentColor,
              takenUsernames: _takenUsernames,
              onComplete: (name, u, av) {
                setState(() {
                  _displayName = name;
                  _username = u;
                  _avatar = av;
                  _setupCompleted = true;
                  _takenUsernames.add(u.toLowerCase());
                });
                _saveUserProfile();
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
    for (int i = 0; i < 40; i++) {
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
  double x, y;
  final double radius, speed, swaySpeed, swayOffset, opacity;
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
      final paint = Paint()..color = Colors.white.withOpacity(f.opacity)..style = PaintingStyle.fill;
      final curX = (f.x * size.width) + sin(f.y * 10 + f.swayOffset) * 6;
      final curY = f.y * size.height;
      canvas.drawCircle(Offset(curX, curY), f.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// ОКНО РЕГИСТРАЦИИ: ТОЛЬКО АНГЛИЙСКИЙ USERNAME И ПРОВЕРКА НА УНИКАЛЬНОСТЬ
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
  late TextEditingController _nameCtrl, _usernameCtrl, _contactCtrl;
  late String _avatar;
  String? _usernameError;
  final List<String> _presetAvatars = ['👑', '🌸', '⚡', '🎮', '🐱', '🦊', '🚀', '💎', '🎧', '🌙'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _usernameCtrl = TextEditingController(text: widget.initialUsername);
    _contactCtrl = TextEditingController();
    _avatar = widget.initialAvatar;
  }

  bool _validateUsername(String raw) {
    final u = raw.trim().toLowerCase();
    if (u.isEmpty) {
      setState(() => _usernameError = 'Введите юзернейм');
      return false;
    }
    if (!RegExp(r'^[a-z0-9_]{3,20}$').hasMatch(u)) {
      setState(() => _usernameError = 'Только английские буквы (a-z), цифры и _');
      return false;
    }
    if (widget.takenUsernames.contains(u) && u != widget.initialUsername.toLowerCase()) {
      setState(() => _usernameError = 'Юзернейм @$u уже занят!');
      return false;
    }
    setState(() => _usernameError = null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.90),
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
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 40, backgroundColor: widget.accentColor.withOpacity(0.3), child: Text(_avatar, style: const TextStyle(fontSize: 38))),
                const SizedBox(height: 12),
                const Text('Добро пожаловать в Aura', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                const Text('Профиль автоматически сохранится в памяти', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
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
                    prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _usernameCtrl,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]'))],
                  onChanged: (val) => _validateUsername(val),
                  decoration: InputDecoration(
                    labelText: 'Уникальный юзернейм (English)',
                    prefixText: '@',
                    errorText: _usernameError,
                    helperText: 'Только английские буквы: a-z, 0-9 и _',
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: widget.accentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    onPressed: () {
                      final n = _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'User';
                      final u = _usernameCtrl.text.trim().toLowerCase();
                      if (!_validateUsername(u)) return;
                      widget.onComplete(n, u, _avatar);
                    },
                    child: const Text('Войти и сохранить в память 🚀', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
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

/// ЖИВОЙ АНИМИРОВАННЫЙ ВИДЕО-БАННЕР 120 FPS
class LiveVideoBannerWidget extends StatefulWidget {
  final String bannerType;
  final Color accentColor;
  final VoidCallback onChangeBanner;

  const LiveVideoBannerWidget({super.key, required this.bannerType, required this.accentColor, required this.onChangeBanner});

  @override
  State<LiveVideoBannerWidget> createState() => _LiveVideoBannerWidgetState();
}

class _LiveVideoBannerWidgetState extends State<LiveVideoBannerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(22), border: Border.all(color: widget.accentColor.withOpacity(0.35))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animCtrl,
              builder: (ctx, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 150),
                  painter: _LiveVideoBannerPainter(progress: _animCtrl.value, bannerType: widget.bannerType, accentColor: widget.accentColor),
                );
              },
            ),
            Positioned(
              top: 10,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.65), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF00F59B).withOpacity(0.6))),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.videocam, size: 13, color: Color(0xFF00F59B)),
                    SizedBox(width: 4),
                    Text('120 FPS VIDEO BANNER', style: TextStyle(color: Color(0xFF00F59B), fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 12,
              child: GestureDetector(
                onTap: widget.onChangeBanner,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.75), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white24)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Сменить баннер', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
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

class _LiveVideoBannerPainter extends CustomPainter {
  final double progress;
  final String bannerType;
  final Color accentColor;
  _LiveVideoBannerPainter({required this.progress, required this.bannerType, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    if (bannerType == 'grid') {
      canvas.drawRect(rect, Paint()..color = const Color(0xFF070814));
      final linePaint = Paint()..color = accentColor.withOpacity(0.25)..strokeWidth = 1.0;
      for (double x = 0; x < size.width; x += 22) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
      }
      for (double y = 0; y < size.height; y += 22) {
        final shift = (progress * 22);
        canvas.drawLine(Offset(0, (y + shift) % size.height), Offset(size.width, (y + shift) % size.height), linePaint);
      }
    } else if (bannerType == 'space') {
      canvas.drawRect(rect, Paint()..color = const Color(0xFF03030A));
      final starPaint = Paint()..color = Colors.white;
      for (int i = 0; i < 35; i++) {
        final sx = (sin(i * 99 + progress * 3) * 0.5 + 0.5) * size.width;
        final sy = (cos(i * 33 + progress * 2) * 0.5 + 0.5) * size.height;
        final r = (sin(i + progress * 6) * 0.8 + 1.2).clamp(0.8, 2.2);
        canvas.drawCircle(Offset(sx, sy), r, starPaint..color = Colors.white.withOpacity(0.7));
      }
    } else {
      final grad = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF140026), accentColor.withOpacity(0.6), const Color(0xFF00F59B).withOpacity(0.5)]);
      canvas.drawRect(rect, Paint()..shader = grad.createShader(rect));
      final wavePaint = Paint()..color = Colors.white.withOpacity(0.18)..style = PaintingStyle.stroke..strokeWidth = 2.0;
      final path = Path()..moveTo(0, size.height * 0.6);
      for (double x = 0; x <= size.width; x += 15) {
        final y = size.height * 0.55 + sin((x / 40) + progress * 6.28) * 16;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LiveVideoBannerPainter oldDelegate) => true;
}

/// ПОЛНОЭКРАННЫЙ ПРОСМОТР ИСТОРИЙ
class StoryViewerDialog extends StatefulWidget {
  final Map<String, dynamic> story;
  final VoidCallback onClose;
  const StoryViewerDialog({super.key, required this.story, required this.onClose});

  @override
  State<StoryViewerDialog> createState() => _StoryViewerDialogState();
}

class _StoryViewerDialogState extends State<StoryViewerDialog> with SingleTickerProviderStateMixin {
  late AnimationController _progressCtrl;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onClose();
      });
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.story['gradient'] as List<Color>? ?? [const Color(0xFF8E7CFF), const Color(0xFF00F59B)];
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colors)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white24)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.story['avatar'] ?? '🌸', style: const TextStyle(fontSize: 60)),
                        const SizedBox(height: 16),
                        Text(widget.story['text'] ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 12,
              right: 12,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _progressCtrl,
                    builder: (ctx, child) => ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: _progressCtrl.value, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.white), minHeight: 3),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(radius: 16, backgroundColor: Colors.white24, child: Text(widget.story['avatar'] ?? 'U')),
                      const SizedBox(width: 8),
                      Text(widget.story['author'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 22), onPressed: widget.onClose),
                    ],
                  ),
                ],
              ),
            ),
            const Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('❤️ 🔥 👏 🚀 💎', style: TextStyle(fontSize: 24))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ГЛАВНАЯ ОБОЛОЧКА С НАВИГАЦИЕЙ
class AuraShell extends StatefulWidget {
  final String displayName, username, avatar, status, adminPassword, themeMode, bannerType;
  final bool isAdmin, is120Fps, isGamingMode, isVpnConnected, allowDms, hideOnlineStatus, e2eeEnabled, antiTrashBot, kidsFilterBot;
  final Color accentColor;
  final List<Map<String, dynamic>> stories, userPhotos;
  final Set<String> takenUsernames;
  final Function(String name, String u, String av, String st) onProfileUpdate;
  final Function(String dms, bool hide, bool e2ee) onPrivacyUpdate;
  final ValueChanged<String> onAdminPasswordChanged, onBannerChange;
  final Function(bool trash, bool kids) onBotsToggled;
  final Function(String text, List<Color> grad) onAddStory;
  final Function(String title, int colorHex) onAddPhotoPost;
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
    required this.antiTrashBot,
    required this.kidsFilterBot,
    required this.bannerType,
    required this.stories,
    required this.userPhotos,
    required this.takenUsernames,
    required this.onProfileUpdate,
    required this.onPrivacyUpdate,
    required this.onAdminPasswordChanged,
    required this.onBotsToggled,
    required this.onBannerChange,
    required this.onAddStory,
    required this.onAddPhotoPost,
    required this.onVpnToggled,
    required this.onOpenSetup,
  });

  @override
  State<AuraShell> createState() => _AuraShellState();
}

class _AuraShellState extends State<AuraShell> {
  int _tab = 0;
  String? _activeChatId;

  bool _isCallActive = false;
  String _callParticipantName = '';
  String _callParticipantUsername = '';
  String _callParticipantAvatar = '';
  bool _callIsVideo = false;
  bool _callIsScreenSharing = false;

  late List<Map<String, dynamic>> _conversations;
  final List<Map<String, dynamic>> _auditLogs = [
    {'action': 'УДАЛЕНО', 'user': 'Max (@max_gamer)', 'channel': '#general', 'content': 'Тестовое фото и сообщение', 'time': '10:32'},
    {'action': 'ИЗМЕНЕНО', 'user': 'Spambot', 'channel': '#general', 'content': 'Было: "Buy promo" -> Стало: "Hello"', 'time': '10:15'},
  ];
  final List<Map<String, dynamic>> _managedUsers = [
    {'name': 'Спам-бот 3000', 'tag': '@spambot', 'banned': true, 'reason': 'Рассылка спама'},
    {'name': 'Тролль_77', 'tag': '@troll', 'banned': true, 'reason': 'Нарушение правил'},
    {'name': 'Максим', 'tag': '@max_gamer', 'banned': false, 'reason': ''},
    {'name': 'Алиса', 'tag': '@alisa_ui', 'banned': false, 'reason': ''},
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
        'status': 'online',
        'isChannel': true,
        'messages': <Map<String, dynamic>>[
          {'id': 'g1', 'user': 'Alisa', 'avatar': '🌸', 'text': 'Привет всем! В Aura завезли чистый звук и 120 FPS! 🚀', 'time': '10:48', 'type': 'text', 'isOutgoing': false},
          {'id': 'g2', 'user': 'Max', 'avatar': '⚡', 'text': 'Стрим 120 FPS, демонстрация экрана и звонки летают!', 'time': '09:20', 'type': 'text', 'isOutgoing': false},
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
          {'id': 'a1', 'user': 'Алиса', 'avatar': '🌸', 'text': 'Привет! Рада видеть тебя в Aura! 🌸 Отправила голосовое и фотографию.', 'time': '10:48', 'type': 'voice', 'duration': '0:14', 'isOutgoing': false},
          {'id': 'a2', 'user': 'Алиса', 'avatar': '🌸', 'text': '📷 Фотография (Вложение)', 'time': '10:50', 'type': 'image', 'isOutgoing': false},
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
          {'id': 'm1', 'user': 'Максим', 'avatar': '⚡', 'text': 'Привет! Протестировал игровой режим Gaming Mode, пинг 8 мс, кайф!', 'time': '09:15', 'type': 'text', 'isOutgoing': false},
        ],
      },
    ];
  }

  Map<String, dynamic>? get _currentChat => _activeChatId == null ? null : _conversations.firstWhere((c) => c['id'] == _activeChatId, orElse: () => _conversations.first);

  void _verifyAdminPasswordAndOpen() {
    final passCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161826),
        title: const Row(children: [Icon(Icons.security, color: Colors.amber), SizedBox(width: 8), Text('Доступ администратора', style: TextStyle(fontSize: 16))]),
        content: TextField(controller: passCtrl, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Пароль (10010010013)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              final clean = passCtrl.text.replaceAll(RegExp(r'[\s,]'), '');
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
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(color: Color(0xFF141624), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [const Icon(Icons.admin_panel_settings, color: Colors.amber), const SizedBox(width: 8), const Text('Панель администратора', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const Spacer(), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx))]),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const Text('УЧАСТНИКИ И БАНЫ', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ..._managedUsers.map((u) => ListTile(
                    leading: CircleAvatar(backgroundColor: u['banned'] ? Colors.red : Colors.grey, child: Text(u['name'][0])),
                    title: Text(u['name'], style: TextStyle(decoration: u['banned'] ? TextDecoration.lineThrough : null)),
                    subtitle: Text('${u['tag']} • ${u['banned'] ? u['reason'] : "Активен"}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: u['banned'] ? const Color(0xFF00F59B) : Colors.redAccent),
                      onPressed: () => setState(() => u['banned'] = !u['banned']),
                      child: Text(u['banned'] ? 'Разбанить' : 'Бан'),
                    ),
                  )),
                  const Divider(color: Colors.white24),
                  const Text('ЖУРНАЛ АУДИТА (УДАЛЕННЫЕ И СПАМ)', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ..._auditLogs.map((log) => Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
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
    String? error;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: const Color(0xFF161826),
          title: const Text('Новый чат'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userCtrl,
                style: const TextStyle(color: Colors.white),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]'))],
                decoration: InputDecoration(labelText: 'Юзернейм (English)', prefixText: '@', errorText: error),
              ),
              TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Имя (по желанию)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () {
                final raw = userCtrl.text.trim().toLowerCase().replaceAll('@', '');
                if (!RegExp(r'^[a-z0-9_]{3,20}$').hasMatch(raw)) {
                  setDlgState(() => error = 'Только буквы a-z, цифры и _');
                  return;
                }
                if (raw == widget.username.toLowerCase()) {
                  setDlgState(() => error = 'Нельзя создать диалог с собой');
                  return;
                }
                final name = nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : raw;
                final newId = 'chat_${DateTime.now().millisecondsSinceEpoch}';
                setState(() {
                  _conversations.insert(1, {
                    'id': newId,
                    'name': name,
                    'username': '@$raw',
                    'avatar': '👤',
                    'status': 'online',
                    'isChannel': false,
                    'messages': [{'id': 'w1', 'user': name, 'avatar': '👤', 'text': 'Привет! Чат создан через E2EE 🔒', 'time': 'Сейчас', 'type': 'text', 'isOutgoing': false}],
                  });
                  _activeChatId = newId;
                  widget.takenUsernames.add(raw);
                });
                Navigator.pop(ctx);
              },
              child: const Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }

  void _startCall({required String name, required String username, required String avatar, bool isVideo = false, bool isScreenSharing = false}) {
    setState(() {
      _isCallActive = true;
      _callParticipantName = name;
      _callParticipantUsername = username;
      _callParticipantAvatar = avatar;
      _callIsVideo = isVideo;
      _callIsScreenSharing = isScreenSharing;
    });
  }

  void _sendMessage({String type = 'text', String text = '', String duration = ''}) {
    var t = text.isNotEmpty ? text : _msgInputCtrl.text.trim();
    if (t.isEmpty && type == 'text') return;
    final cur = _currentChat;
    if (cur == null) return;

    if (widget.antiTrashBot && type == 'text' && ChatCensorEngine.isTrashOrSpam(t)) {
      _auditLogs.insert(0, {'action': 'СПАМ', 'user': widget.username, 'channel': cur['username'], 'content': t, 'time': 'Сейчас'});
      t = '🧹 [Удалено Анти-Мусор ботом]';
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🧹 Анти-Мусор бот скрыл спам/рекламу')));
    }
    if (widget.kidsFilterBot && type == 'text') {
      t = ChatCensorEngine.applyKidsFilter(t);
    }

    setState(() {
      (cur['messages'] as List).add({'id': '${DateTime.now().millisecondsSinceEpoch}', 'user': widget.displayName, 'avatar': widget.avatar, 'text': t, 'time': 'Сейчас', 'type': type, 'duration': duration, 'isOutgoing': true});
      _msgInputCtrl.clear();
    });

    if (cur['isChannel'] != true) {
      Future.delayed(const Duration(milliseconds: 1300), () {
        if (!mounted) return;
        setState(() {
          (cur['messages'] as List).add({'id': 'rep_${DateTime.now().millisecondsSinceEpoch}', 'user': cur['name'], 'avatar': cur['avatar'], 'text': 'Отлично! Тестирую 120 FPS и видео-баннеры в Aura 🚀', 'time': 'Сейчас', 'type': 'text', 'isOutgoing': false});
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
                    ? _ChatListView(
                        conversations: _conversations,
                        stories: widget.stories,
                        userAvatar: widget.avatar,
                        isAdmin: widget.isAdmin,
                        accentColor: widget.accentColor,
                        onSelectChat: (id) => setState(() => _activeChatId = id),
                        onNewChat: _createNewChatDialog,
                        onAddStory: widget.onAddStory,
                        onOpenAdmin: _verifyAdminPasswordAndOpen,
                      )
                    : _ChatRoomView(
                        chat: _currentChat!,
                        inputCtrl: _msgInputCtrl,
                        accentColor: widget.accentColor,
                        isAdmin: widget.isAdmin,
                        onBack: () => setState(() => _activeChatId = null),
                        onSendMessage: (t) => _sendMessage(type: 'text', text: t),
                        onSendVoice: () => _sendMessage(type: 'voice', text: 'Голосовое сообщение', duration: '0:07'),
                        onSendImage: () => _sendMessage(type: 'image', text: '📷 Фотография (Вложение)'),
                        onSendVideo: () => _sendMessage(type: 'video', text: '🎬 Видеозапись 120 FPS'),
                        onStartVoiceCall: () => _startCall(name: _currentChat!['name'], username: _currentChat!['username'], avatar: _currentChat!['avatar'], isVideo: false, isScreenSharing: false),
                        onStartVideoCall: () => _startCall(name: _currentChat!['name'], username: _currentChat!['username'], avatar: _currentChat!['avatar'], isVideo: true, isScreenSharing: false),
                        onStartScreenShare: () => _startCall(name: _currentChat!['name'], username: _currentChat!['username'], avatar: _currentChat!['avatar'], isVideo: false, isScreenSharing: true),
                        onOpenAdmin: _verifyAdminPasswordAndOpen,
                      ),
                _VoiceStageView(
                  accentColor: widget.accentColor,
                  onStartScreenShare: () => _startCall(name: 'Арена 120 FPS', username: '#voice-stage', avatar: '⚡', isVideo: false, isScreenSharing: true),
                ),
                _VpnView(accentColor: widget.accentColor, isConnected: widget.isVpnConnected, onToggle: widget.onVpnToggled),
                _ProfilePrivacyView(
                  displayName: widget.displayName,
                  username: widget.username,
                  avatar: widget.avatar,
                  status: widget.status,
                  isAdmin: widget.isAdmin,
                  accentColor: widget.accentColor,
                  bannerType: widget.bannerType,
                  userPhotos: widget.userPhotos,
                  antiTrashBot: widget.antiTrashBot,
                  kidsFilterBot: widget.kidsFilterBot,
                  onBannerChange: widget.onBannerChange,
                  onAddPhotoPost: widget.onAddPhotoPost,
                  onBotsToggled: widget.onBotsToggled,
                  onProfileUpdate: widget.onProfileUpdate,
                  onOpenAdmin: _verifyAdminPasswordAndOpen,
                ),
              ],
            ),
          ),
          if (_isCallActive)
            _ActiveCallScreen(
              name: _callParticipantName,
              username: _callParticipantUsername,
              avatar: _callParticipantAvatar,
              initialIsVideo: _callIsVideo,
              initialIsScreenSharing: _callIsScreenSharing,
              accentColor: widget.accentColor,
              onEndCall: () => setState(() => _isCallActive = false),
            ),
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
}

/// ЭКРАН СПИСКА ЧАТОВ С ЛЕНТОЙ ИСТОРИЙ
class _ChatListView extends StatelessWidget {
  final List<Map<String, dynamic>> conversations, stories;
  final String userAvatar;
  final bool isAdmin;
  final Color accentColor;
  final ValueChanged<String> onSelectChat;
  final VoidCallback onNewChat;
  final Function(String text, List<Color> grad) onAddStory;
  final VoidCallback onOpenAdmin;

  const _ChatListView({
    required this.conversations,
    required this.stories,
    required this.userAvatar,
    required this.isAdmin,
    required this.accentColor,
    required this.onSelectChat,
    required this.onNewChat,
    required this.onAddStory,
    required this.onOpenAdmin,
  });

  void _openCreateStory(BuildContext context) {
    final textCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161826),
        title: const Text('Опубликовать историю'),
        content: TextField(controller: textCtrl, maxLines: 2, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Текст истории или эмодзи...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: accentColor),
            onPressed: () {
              if (textCtrl.text.trim().isNotEmpty) {
                onAddStory(textCtrl.text.trim(), [const Color(0xFF8E7CFF), const Color(0xFF00F59B)]);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Опубликовать'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Сообщения', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Text('E2EE On', style: TextStyle(color: Color(0xFF00F59B), fontSize: 10, fontWeight: FontWeight.bold))),
                const Spacer(),
                if (isAdmin) IconButton(icon: const Icon(Icons.shield, color: Colors.amber), onPressed: onOpenAdmin),
                IconButton(icon: const Icon(Icons.add, color: Color(0xFF00F59B)), onPressed: onNewChat),
              ],
            ),
          ),
          // ЛЕНТА ИСТОРИЙ
          SizedBox(
            height: 94,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: stories.length + 1,
              itemBuilder: (ctx, i) {
                if (i == 0) {
                  return GestureDetector(
                    onTap: () => _openCreateStory(context),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(radius: 27, backgroundColor: accentColor.withOpacity(0.35), child: Text(userAvatar, style: const TextStyle(fontSize: 22))),
                              Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle), child: const Icon(Icons.add, size: 14, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text('Ваша история', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }
                final s = stories[i - 1];
                return GestureDetector(
                  onTap: () => showDialog(context: context, useSafeArea: false, builder: (ctx) => StoryViewerDialog(story: s, onClose: () => Navigator.pop(ctx))),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF8E7CFF), Color(0xFF00F59B)])),
                          child: CircleAvatar(radius: 25, backgroundColor: Colors.black, child: Text(s['avatar'] ?? '🌸', style: const TextStyle(fontSize: 22))),
                        ),
                        const SizedBox(height: 4),
                        Text(s['author'] ?? '', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: conversations.length,
              separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 64, color: Colors.white10),
              itemBuilder: (ctx, i) {
                final c = conversations[i];
                final msgs = c['messages'] as List;
                final lastMsg = msgs.isNotEmpty ? msgs.last : null;
                return ListTile(
                  leading: CircleAvatar(backgroundColor: accentColor.withOpacity(0.3), child: Text(c['avatar'] ?? 'U')),
                  title: Text(c['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(lastMsg != null ? (lastMsg['type'] == 'voice' ? '🎤 Голосовое сообщение' : lastMsg['text']) : '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  onTap: () => onSelectChat(c['id']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ЭКРАН ОТКРЫТОГО ЧАТА СО ЗВОНКАМИ И ДЕМОНСТРАЦИЕЙ ЭКРАНА
class _ChatRoomView extends StatelessWidget {
  final Map<String, dynamic> chat;
  final TextEditingController inputCtrl;
  final Color accentColor;
  final bool isAdmin;
  final VoidCallback onBack;
  final ValueChanged<String> onSendMessage;
  final VoidCallback onSendVoice, onSendImage, onSendVideo, onStartVoiceCall, onStartVideoCall, onStartScreenShare, onOpenAdmin;

  const _ChatRoomView({
    required this.chat,
    required this.inputCtrl,
    required this.accentColor,
    required this.isAdmin,
    required this.onBack,
    required this.onSendMessage,
    required this.onSendVoice,
    required this.onSendImage,
    required this.onSendVideo,
    required this.onStartVoiceCall,
    required this.onStartVideoCall,
    required this.onStartScreenShare,
    required this.onOpenAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final messages = chat['messages'] as List;
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
                CircleAvatar(radius: 16, backgroundColor: accentColor.withOpacity(0.3), child: Text(chat['avatar'] ?? 'U')),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(chat['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)), const Text('120 FPS E2EE Live', style: TextStyle(color: Color(0xFF00F59B), fontSize: 10))])),
                IconButton(icon: const Icon(Icons.phone, color: Color(0xFF00F59B), size: 20), onPressed: onStartVoiceCall),
                IconButton(icon: const Icon(Icons.screen_share, color: Colors.amber, size: 20), onPressed: onStartScreenShare),
                IconButton(icon: const Icon(Icons.videocam, color: Colors.purpleAccent, size: 20), onPressed: onStartVideoCall),
                if (isAdmin) IconButton(icon: const Icon(Icons.shield, color: Colors.amber, size: 20), onPressed: onOpenAdmin),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (ctx, idx) {
                final m = messages[idx];
                final isOut = m['isOutgoing'] == true;
                return Align(
                  alignment: isOut ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: isOut ? accentColor.withOpacity(0.3) : const Color(0xFF1B1D2C), borderRadius: BorderRadius.circular(16)),
                    child: Text(m['text'] ?? '', style: const TextStyle(fontSize: 14)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.attach_file), onPressed: onSendImage),
                IconButton(icon: const Icon(Icons.mic, color: Color(0xFF00F59B)), onPressed: onSendVoice),
                Expanded(child: TextField(controller: inputCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Сообщение...', filled: true, fillColor: Color(0xFF161826)))),
                IconButton(icon: const Icon(Icons.send, color: Color(0xFF00F59B)), onPressed: () => onSendMessage(inputCtrl.text.trim())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ПОЛНОЦЕННЫЙ ЭКРАН ЗВОНКА И ДЕМОНСТРАЦИИ ЭКРАНА
class _ActiveCallScreen extends StatefulWidget {
  final String name, username, avatar;
  final bool initialIsVideo, initialIsScreenSharing;
  final Color accentColor;
  final VoidCallback onEndCall;

  const _ActiveCallScreen({
    required this.name,
    required this.username,
    required this.avatar,
    required this.initialIsVideo,
    required this.initialIsScreenSharing,
    required this.accentColor,
    required this.onEndCall,
  });

  @override
  State<_ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<_ActiveCallScreen> with SingleTickerProviderStateMixin {
  late bool _isMicMuted, _isVideoOn, _isScreenSharing;
  int _sec = 0;
  Timer? _timer;
  late AnimationController _wave;

  @override
  void initState() {
    super.initState();
    _isMicMuted = false;
    _isVideoOn = widget.initialIsVideo;
    _isScreenSharing = widget.initialIsScreenSharing;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) => mounted ? setState(() => _sec++) : null);
    _wave = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.96),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Text('E2EE • 8.33 ms Direct QoS', style: TextStyle(color: Color(0xFF00F59B), fontSize: 10, fontWeight: FontWeight.bold))),
                  const Spacer(),
                  Text('${(_sec ~/ 60).toString().padLeft(2, '0')}:${(_sec % 60).toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.white70)),
                ]),
              ),
              Text(widget.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text('${widget.username} • 120 FPS Live', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0xFF0E101A), borderRadius: BorderRadius.circular(24), border: Border.all(color: _isScreenSharing ? const Color(0xFF00F59B) : widget.accentColor.withOpacity(0.4))),
                    alignment: Alignment.center,
                    child: _isScreenSharing
                        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.monitor, size: 72, color: Color(0xFF00F59B)), const SizedBox(height: 12), const Text('Трансляция экрана: 1080p @ 120 FPS', style: TextStyle(fontWeight: FontWeight.bold))])
                        : (_isVideoOn ? const Icon(Icons.videocam, size: 72, color: Colors.purpleAccent) : CircleAvatar(radius: 46, backgroundColor: widget.accentColor, child: Text(widget.avatar, style: const TextStyle(fontSize: 40)))),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: Icon(_isMicMuted ? Icons.mic_off : Icons.mic), color: _isMicMuted ? Colors.red : Colors.white, onPressed: () => setState(() => _isMicMuted = !_isMicMuted)),
                  IconButton(icon: Icon(_isScreenSharing ? Icons.screen_share : Icons.mobile_screen_share), color: _isScreenSharing ? const Color(0xFF00F59B) : Colors.white, onPressed: () => setState(() => _isScreenSharing = !_isScreenSharing)),
                  IconButton(icon: Icon(_isVideoOn ? Icons.videocam : Icons.videocam_off), color: _isVideoOn ? widget.accentColor : Colors.white, onPressed: () => setState(() => _isVideoOn = !_isVideoOn)),
                  CircleAvatar(radius: 24, backgroundColor: Colors.red, child: IconButton(icon: const Icon(Icons.call_end, color: Colors.white), onPressed: widget.onEndCall)),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// ВСПЛЫВАЮЩИЙ ПРОФИЛЬ, БАННЕРЫ И ПУБЛИКАЦИИ ФОТО
class _ProfilePrivacyView extends StatelessWidget {
  final String displayName, username, avatar, status, bannerType;
  final bool isAdmin, antiTrashBot, kidsFilterBot;
  final Color accentColor;
  final List<Map<String, dynamic>> userPhotos;
  final ValueChanged<String> onBannerChange;
  final Function(String title, int colorHex) onAddPhotoPost;
  final Function(bool trash, bool kids) onBotsToggled;
  final Function(String name, String u, String av, String st) onProfileUpdate;
  final VoidCallback onOpenAdmin;

  const _ProfilePrivacyView({
    required this.displayName,
    required this.username,
    required this.avatar,
    required this.status,
    required this.isAdmin,
    required this.accentColor,
    required this.bannerType,
    required this.userPhotos,
    required this.antiTrashBot,
    required this.kidsFilterBot,
    required this.onBannerChange,
    required this.onAddPhotoPost,
    required this.onBotsToggled,
    required this.onProfileUpdate,
    required this.onOpenAdmin,
  });

  void _showChangeBannerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161826),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('🌌 Cyber Aurora (Живой неоновый градиент)'), onTap: () { onBannerChange('aurora'); Navigator.pop(ctx); }),
          ListTile(title: const Text('⚡ 120 FPS Neon Grid (Анимированная сетка)'), onTap: () { onBannerChange('grid'); Navigator.pop(ctx); }),
          ListTile(title: const Text('🚀 Deep Space Warp (Космический полет)'), onTap: () { onBannerChange('space'); Navigator.pop(ctx); }),
        ],
      ),
    );
  }

  void _showAddPhotoDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161826),
        title: const Text('Новая публикация фото'),
        content: TextField(controller: titleCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Подпись к фото...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(onPressed: () {
            if (titleCtrl.text.isNotEmpty) {
              onAddPhotoPost(titleCtrl.text.trim(), 0xFF8E7CFF);
              Navigator.pop(ctx);
            }
          }, child: const Text('Опубликовать')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ВИДЕО-БАННЕР
          LiveVideoBannerWidget(bannerType: bannerType, accentColor: accentColor, onChangeBanner: () => _showChangeBannerModal(context)),
          const SizedBox(height: 12),
          // Карточка пользователя
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF121422), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                CircleAvatar(radius: 30, backgroundColor: accentColor, child: Text(avatar, style: const TextStyle(fontSize: 26))),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('@$username', style: const TextStyle(color: Colors.grey, fontSize: 13))]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ПАНЕЛЬ АДМИНА
          if (isAdmin)
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: Colors.amber.withOpacity(0.12),
              leading: const Icon(Icons.shield, color: Colors.amber),
              title: const Text('Панель администратора', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              subtitle: const Text('Защищено паролем 10010010013', style: TextStyle(fontSize: 11, color: Colors.grey)),
              onTap: onOpenAdmin,
            ),
          const SizedBox(height: 16),
          // БОТЫ МОДЕРАЦИИ
          const Text('БОТЫ МОДЕРАЦИИ ЧАТОВ', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('🧹 Анти-Мусор бот'),
            subtitle: const Text('Очищает все чаты от мусора, спам-ссылок и рекламы'),
            value: antiTrashBot,
            activeColor: const Color(0xFF00F59B),
            onChanged: (v) => onBotsToggled(v, kidsFilterBot),
          ),
          SwitchListTile(
            title: const Text('🛡️ Детский режим: Анти-Мат'),
            subtitle: const Text('Цензурирует ненормативную лексику и мат'),
            value: kidsFilterBot,
            activeColor: const Color(0xFF00F59B),
            onChanged: (v) => onBotsToggled(antiTrashBot, v),
          ),
          const SizedBox(height: 16),
          // ПУБЛИКАЦИИ ФОТО КАК В TELEGRAM
          Row(
            children: [
              const Text('ПУБЛИКАЦИИ И ФОТО (КАК В TELEGRAM)', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(icon: const Icon(Icons.add_a_photo, size: 14), label: const Text('Выложить фото'), onPressed: () => _showAddPhotoDialog(context)),
            ],
          ),
          ...userPhotos.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF141624), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 110, decoration: BoxDecoration(color: Color(p['colorHex']).withOpacity(0.3), borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Icon(Icons.photo_library, size: 38, color: Colors.white70)),
                const SizedBox(height: 8),
                Text(p['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('❤️ ${p['likes']} отметок • ${p['time']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

/// АРЕНА 120 FPS
class _VoiceStageView extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onStartScreenShare;
  const _VoiceStageView({required this.accentColor, required this.onStartScreenShare});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.monitor, size: 70, color: Color(0xFF00F59B)),
          const SizedBox(height: 16),
          const Text('Игровая Арена 120 FPS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('8.33 ms Direct QoS Screen Share', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00F59B), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            icon: const Icon(Icons.screen_share),
            label: const Text('Запустить демонстрацию экрана 120 FPS', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: onStartScreenShare,
          ),
        ],
      ),
    );
  }
}

/// VPN HAPP VIEW
class _VpnView extends StatelessWidget {
  final Color accentColor;
  final bool isConnected;
  final ValueChanged<bool> onToggle;
  const _VpnView({required this.accentColor, required this.isConnected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => onToggle(!isConnected),
            child: CircleAvatar(
              radius: 54,
              backgroundColor: isConnected ? const Color(0xFF00F59B).withOpacity(0.2) : Colors.white10,
              child: Icon(Icons.shield, size: 48, color: isConnected ? const Color(0xFF00F59B) : Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          Text(isConnected ? '● VLESS-Reality Активен' : '○ VPN Отключен', style: TextStyle(color: isConnected ? const Color(0xFF00F59B) : Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
