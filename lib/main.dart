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
  String _themeMode = 'oled'; // 'oled', 'velvet', 'light'
  Color _accentColor = const Color(0xFF8E7CFF);
  bool _is120Fps = true;
  bool _isGamingMode = true;
  bool _isVpnConnected = true;
  bool _onboardingDone = false;

  ThemeData _getTheme() {
    if (_themeMode == 'oled') {
      return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardColor: const Color(0xFF080808),
        colorScheme: ColorScheme.fromSeed(
          seedColor: _accentColor,
          brightness: Brightness.dark,
          surface: Colors.black,
        ),
      );
    } else if (_themeMode == 'light') {
      return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F1FA),
        canvasColor: const Color(0xFFFAF9FF),
        cardColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _accentColor,
          brightness: Brightness.light,
        ),
      );
    }
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF13141F),
      canvasColor: const Color(0xFF1B1C2B),
      cardColor: const Color(0xFF24263A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentColor,
        brightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura',
      debugShowCheckedModeBanner: false,
      theme: _getTheme(),
      home: _onboardingDone
          ? AuraShellScreen(
              themeMode: _themeMode,
              accentColor: _accentColor,
              is120Fps: _is120Fps,
              isGamingMode: _isGamingMode,
              isVpnConnected: _isVpnConnected,
              onThemeChanged: (m) => setState(() => _themeMode = m),
              onAccentChanged: (c) => setState(() => _accentColor = c),
              on120FpsChanged: (v) => setState(() => _is120Fps = v),
              onGamingModeChanged: (v) => setState(() => _isGamingMode = v),
              onVpnToggled: (v) => setState(() => _isVpnConnected = v),
              onRestartOnboarding: () => setState(() => _onboardingDone = false),
            )
          : OnboardingWizard(
              initialTheme: _themeMode,
              initialAccent: _accentColor,
              onFinished: (theme, accent, fps, game) {
                setState(() {
                  _themeMode = theme;
                  _accentColor = accent;
                  _is120Fps = fps;
                  _isGamingMode = game;
                  _onboardingDone = true;
                });
              },
            ),
    );
  }
}

/// Мастер настройки при регистрации
class OnboardingWizard extends StatefulWidget {
  final String initialTheme;
  final Color initialAccent;
  final Function(String theme, Color accent, bool fps120, bool gamingMode) onFinished;

  const OnboardingWizard({
    super.key,
    required this.initialTheme,
    required this.initialAccent,
    required this.onFinished,
  });

  @override
  State<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends State<OnboardingWizard> {
  int _step = 0;
  late String _theme;
  late Color _accent;
  bool _fps120 = true;
  bool _gameMode = true;

  @override
  void initState() {
    super.initState();
    _theme = widget.initialTheme;
    _accent = widget.initialAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A10),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: List.generate(3, (i) {
                      final active = i <= _step;
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: active ? _accent : Colors.white12,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),
                  Text(_getTitle(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(_getSub(), style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Expanded(child: _buildBody()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_step > 0)
                        TextButton(onPressed: () => setState(() => _step--), child: const Text('Назад', style: TextStyle(color: Colors.grey)))
                      else
                        const SizedBox(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        onPressed: () {
                          if (_step < 2) {
                            setState(() => _step++);
                          } else {
                            widget.onFinished(_theme, _accent, _fps120, _gameMode);
                          }
                        },
                        child: Text(_step == 2 ? 'Войти в Aura 🚀' : 'Далее →'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    if (_step == 0) return 'Шаг 1: Тема и защита OLED';
    if (_step == 1) return 'Шаг 2: Скорость и 120 FPS';
    return 'Шаг 3: Цвет и стиль';
  }

  String _getSub() {
    if (_step == 0) return 'OLED Black отключает пиксели матрицы и предотвращает выгорание экрана.';
    if (_step == 1) return 'Активирует рендеринг 120 Гц и аудиопакеты Opus 10 мс для минимальной задержки.';
    return 'Выберите цвет акцента для кнопок, свечений и статусов.';
  }

  Widget _buildBody() {
    if (_step == 0) {
      return ListView(
        children: [
          _tile('oled', 'OLED True Black (#000000)', '0% выгорания, отключение пикселей', Colors.black),
          _tile('velvet', 'Velvet Dark (Матовая темная)', 'Глубокий оттенок с размытием', const Color(0xFF13141F)),
          _tile('light', 'Pastel Light (Светлая пастель)', 'Мягкие светлые тона', const Color(0xFFF2F1FA)),
        ],
      );
    } else if (_step == 1) {
      return ListView(
        children: [
          _sw('Глобальный режим 120 FPS', '8.33 мс на кадр для всех анимаций', _fps120, (v) => setState(() => _fps120 = v)),
          _sw('Игровой режим (10 мс)', 'Приоритет пакетов QoS EF, нулевой джиттер', _gameMode, (v) => setState(() => _gameMode = v)),
        ],
      );
    }
    return Center(
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          _dot(const Color(0xFF8E7CFF)),
          _dot(const Color(0xFF00F59B)),
          _dot(const Color(0xFFFF8EB3)),
          _dot(const Color(0xFF7AC7FF)),
          _dot(const Color(0xFFFFCA7A)),
        ],
      ),
    );
  }

  Widget _tile(String val, String title, String sub, Color c) {
    final sel = _theme == val;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161826),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: sel ? _accent : Colors.white12, width: sel ? 2 : 1),
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: c, radius: 14),
        title: Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: sel ? Icon(Icons.check_circle, color: _accent) : null,
        onTap: () => setState(() => _theme = val),
      ),
    );
  }

  Widget _sw(String title, String sub, bool val, ValueChanged<bool> fn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF161826), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white12)),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
              Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ]),
          ),
          Switch(value: val, activeColor: _accent, onChanged: fn),
        ],
      ),
    );
  }

  Widget _dot(Color c) {
    final sel = _accent == c;
    return GestureDetector(
      onTap: () => setState(() => _accent = c),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          border: Border.all(color: sel ? Colors.white : Colors.transparent, width: 3),
          boxShadow: [if (sel) BoxShadow(color: c.withOpacity(0.4), blurRadius: 14, spreadRadius: 2)],
        ),
      ),
    );
  }
}

/// Главный экран приложения
class AuraShellScreen extends StatefulWidget {
  final String themeMode;
  final Color accentColor;
  final bool is120Fps;
  final bool isGamingMode;
  final bool isVpnConnected;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<Color> onAccentChanged;
  final ValueChanged<bool> on120FpsChanged;
  final ValueChanged<bool> onGamingModeChanged;
  final ValueChanged<bool> onVpnToggled;
  final VoidCallback onRestartOnboarding;

  const AuraShellScreen({
    super.key,
    required this.themeMode,
    required this.accentColor,
    required this.is120Fps,
    required this.isGamingMode,
    required this.isVpnConnected,
    required this.onThemeChanged,
    required this.onAccentChanged,
    required this.on120FpsChanged,
    required this.onGamingModeChanged,
    required this.onVpnToggled,
    required this.onRestartOnboarding,
  });

  @override
  State<AuraShellScreen> createState() => _AuraShellScreenState();
}

class _AuraShellScreenState extends State<AuraShellScreen> {
  final List<Map<String, String>> _messages = [
    {'u': 'Александр', 'r': 'Владелец', 't': 'Aura работает в 120 FPS! Тайминги 8.33 мс на кадр ⚡'},
    {'u': 'Алиса', 'r': 'Lead UI', 't': 'Встроенный VPN Happ (VLESS Reality) защищает звонки и обходит блокировки 🛡️'},
  ];
  final TextEditingController _msgCtrl = TextEditingController();

  void _send() {
    final s = _msgCtrl.text.trim();
    if (s.isEmpty) return;
    setState(() {
      _messages.add({'u': 'Вы', 'r': 'Admin', 't': s});
      _msgCtrl.clear();
    });
  }

  void _showVpnDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.themeMode == 'oled' ? Colors.black : const Color(0xFF131522),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                const Text('🛡️ Встроенный VPN (Happ Core)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ]),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  widget.onVpnToggled(!widget.isVpnConnected);
                  setMState(() {});
                },
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.isVpnConnected ? const Color(0xFF00F59B) : Colors.grey, width: 3),
                    color: widget.isVpnConnected ? const Color(0xFF00F59B).withOpacity(0.15) : Colors.white10,
                  ),
                  alignment: Alignment.center,
                  child: Text(widget.isVpnConnected ? 'ВКЛ' : 'ВЫКЛ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.isVpnConnected ? '● VLESS-Reality Активен (18 ms, Германия)' : '○ VPN Отключен',
                style: TextStyle(color: widget.isVpnConnected ? const Color(0xFF00F59B) : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('✦ Aura', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFF00F59B).withOpacity(0.18), borderRadius: BorderRadius.circular(6)),
              child: const Text('120 FPS', style: TextStyle(color: Color(0xFF00F59B), fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shield, color: widget.isVpnConnected ? const Color(0xFF00F59B) : Colors.grey),
            tooltip: 'VPN Happ',
            onPressed: _showVpnDialog,
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Мастер настройки',
            onPressed: widget.onRestartOnboarding,
          ),
        ],
      ),
      body: Column(
        children: [
          // Voice 120 FPS strip
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: widget.themeMode == 'oled' ? const Color(0xFF0A0A0A) : const Color(0xFF1E2032),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00F59B).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.graphic_eq, color: Color(0xFF00F59B), size: 20),
                const SizedBox(width: 8),
                const Text('⚡ Игровая арена', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const Spacer(),
                const Text('10 ms • 120 Hz', style: TextStyle(fontSize: 10, color: Color(0xFF00F59B), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Chat list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final m = _messages[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 16, backgroundColor: widget.accentColor, child: Text(m['u']![0], style: const TextStyle(fontSize: 12, color: Colors.white))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.themeMode == 'oled' ? const Color(0xFF080808) : const Color(0xFF1D1F30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m['u']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: widget.accentColor)),
                              const SizedBox(height: 3),
                              Text(m['t']!, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Input
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      decoration: InputDecoration(
                        hintText: '120 FPS сообщение...',
                        filled: true,
                        fillColor: widget.themeMode == 'oled' ? const Color(0xFF0A0A0A) : const Color(0xFF1E2032),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.send), color: widget.accentColor, onPressed: _send),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
