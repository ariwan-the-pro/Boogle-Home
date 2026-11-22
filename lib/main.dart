
import 'package:material_ui/material_ui.dart';
import 'package:android_tv_remote/android_tv_remote.dart' as android_tv;
import 'package:path_provider/path_provider.dart';

import 'samsung_remote.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  await android_tv.AndroidTVRemote.init(basePath: directory.path);

  runApp(const BoogleHome());
}

final samsungRemote = SamsungRemote();

class BoogleHome extends StatelessWidget {
  const BoogleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boogle Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorSchemeSeed: const Color(0xFF5278E8),
      ),
      home: const HomeScreen(),
    );
  }
}

class TvDevice {
  final String name;
  final String model;
  final IconData icon;
  final Color color;

  const TvDevice({
    required this.name,
    required this.model,
    required this.icon,
    required this.color,
  });
}

const devices = [
  TvDevice(
    name: 'Woonkamer',
    model: 'Samsung UA50MU7980K',
    icon: Icons.tv,
    color: Color(0xFF5278E8),
  ),
  TvDevice(
    name: 'Slaapkamer',
    model: 'CHiQ Google TV',
    icon: Icons.tv,
    color: Color(0xFF9B70D6),
  ),
];

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Boogle Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F6FA),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Mijn huis',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Al je apparaten op één plek.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 28),
          const Text(
            'Kamers',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final device in devices)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DeviceCard(device: device),
            ),
          const SizedBox(height: 15),
          const Text(
            'Snelle acties',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ActionCard(
                  icon: Icons.settings_remote,
                  title: 'Afstandsbediening',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RemoteScreen(device: devices[0]),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionCard(
                  icon: Icons.devices,
                  title: 'Apparaten',
                  onTap: () => showMessage(
                    context,
                    'Je hebt 2 apparaten toegevoegd.',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Thuis',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices_outlined),
            label: 'Apparaten',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profiel',
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 1) {
            showMessage(context, 'Je hebt 2 apparaten.');
          } else if (index == 2) {
            showMessage(context, 'Profiel komt binnenkort.');
          }
        },
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final TvDevice device;

  const DeviceCard({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: device.color.withValues(alpha: 0.12),
          child: Icon(
            device.icon,
            color: device.color,
            size: 30,
          ),
        ),
        title: Text(
          device.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(device.model),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DeviceScreen(device: device),
          ),
        ),
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  final TvDevice device;

  const DeviceScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: device.color.withValues(alpha: 0.12),
                child: Icon(
                  device.icon,
                  size: 60,
                  color: device.color,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                device.model,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Lokaal apparaat',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.settings_remote),
                label: const Text('Open afstandsbediening'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RemoteScreen(device: device),
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

class RemoteScreen extends StatefulWidget {
  final TvDevice device;

  const RemoteScreen({super.key, required this.device});

  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
  String status = 'Niet verbonden';
  bool busy = false;

  bool get isSamsung =>
      widget.device.model.startsWith('Samsung');

  bool get isConnected =>
      status.toLowerCase().contains('verbonden') ||
      status.toLowerCase().contains('connected');

  @override
  void initState() {
    super.initState();

    if (isSamsung) {
      samsungRemote.onStatus = (message) {
        if (mounted) {
          setState(() => status = message);
        }
      };

      status = 'Verbinden met Samsung...';
      samsungRemote.connect();
    } else {
      connectChiq();
    }
  }

  Future<String> askForPin() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Google TV koppelen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Voer de 6-cijferige code in die op je CHiQ-tv verschijnt.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                maxLength: 6,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Koppelcode',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, ''),
              child: const Text('Annuleren'),
            ),
            FilledButton(
              onPressed: () {
                final pin = controller.text.trim();
                if (pin.length == 6) {
                  Navigator.pop(dialogContext, pin);
                }
              },
              child: const Text('Koppelen'),
            ),
          ],
        );
      },
    );

    controller.dispose();
    return result ?? '';
  }

  Future<void> connectChiq() async {
    if (busy) return;

    setState(() {
      busy = true;
      status = 'Rechtstreeks verbinden met CHiQ...';
    });

    try {
      final target = android_tv.TvDevice(
        id: 'chiq-192.168.1.189',
        name: 'CHiQ Google TV',
        host: '192.168.1.189',
        controlPort: 6466,
        pairingPort: 6467,
      );

      if (mounted) {
        setState(() => status = 'TV gevonden. Koppelen...');
      }

      await android_tv.AndroidTVRemote.instance.connect(
        target,
        onPairingCode: askForPin,
      );

      if (mounted) {
        setState(() => status = 'Verbonden met CHiQ!');
      }
    } catch (e) {
      if (mounted) {
        setState(() => status = 'Verbindingsfout: $e');
      }
    } finally {
      if (mounted) {
        setState(() => busy = false);
      }
    }
  }

  void chiqCommand(android_tv.RemoteKeyCode key) {
    try {
      android_tv.AndroidTVRemote.instance.sendKey(key);
    } catch (e) {
      if (mounted) {
        showMessage(context, 'Opdracht mislukt: $e');
      }
    }
  }

  void command(
    String samsungKey,
    android_tv.RemoteKeyCode chiqKey,
  ) {
    if (isSamsung) {
      samsungRemote.press(samsungKey);
    } else {
      chiqCommand(chiqKey);
    }
  }

  @override
  void dispose() {
    if (isSamsung) {
      samsungRemote.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;

    return Scaffold(
      appBar: AppBar(
        title: Text('${device.name} afstandsbediening'),
        actions: [
          IconButton(
            tooltip: 'Opnieuw verbinden',
            icon: const Icon(Icons.refresh),
            onPressed: busy
                ? null
                : isSamsung
                    ? () {
                        samsungRemote.connect();
                      }
                    : connectChiq,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Afstandsbediening',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                device.model,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isConnected ? Colors.green : Colors.grey,
                ),
              ),
              if (!isSamsung && busy) ...[
                const SizedBox(height: 12),
                const CircularProgressIndicator(),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RemoteButton(
                    icon: Icons.power_settings_new,
                    color: Colors.red,
                    onTap: () => command(
                      'KEY_POWER',
                      android_tv.RemoteKeyCode.power,
                    ),
                  ),
                  RemoteButton(
                    icon: Icons.home,
                    onTap: () => command(
                      'KEY_HOME',
                      android_tv.RemoteKeyCode.home,
                    ),
                  ),
                  RemoteButton(
                    icon: Icons.arrow_back,
                    onTap: () => command(
                      'KEY_RETURN',
                      android_tv.RemoteKeyCode.back,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 15,
                      child: IconButton(
                        iconSize: 35,
                        icon: const Icon(Icons.keyboard_arrow_up),
                        onPressed: () => command(
                          'KEY_UP',
                          android_tv.RemoteKeyCode.dpadUp,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      child: IconButton(
                        iconSize: 35,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () => command(
                          'KEY_DOWN',
                          android_tv.RemoteKeyCode.dpadDown,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      child: IconButton(
                        iconSize: 35,
                        icon: const Icon(Icons.keyboard_arrow_left),
                        onPressed: () => command(
                          'KEY_LEFT',
                          android_tv.RemoteKeyCode.dpadLeft,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      child: IconButton(
                        iconSize: 35,
                        icon: const Icon(Icons.keyboard_arrow_right),
                        onPressed: () => command(
                          'KEY_RIGHT',
                          android_tv.RemoteKeyCode.dpadRight,
                        ),
                      ),
                    ),
                    FilledButton(
                      onPressed: () => command(
                        'KEY_ENTER',
                        android_tv.RemoteKeyCode.dpadCenter,
                      ),
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(27),
                      ),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RemoteButton(
                    icon: Icons.volume_down,
                    onTap: () => command(
                      'KEY_VOLDOWN',
                      android_tv.RemoteKeyCode.volumeDown,
                    ),
                  ),
                  RemoteButton(
                    icon: Icons.volume_up,
                    onTap: () => command(
                      'KEY_VOLUP',
                      android_tv.RemoteKeyCode.volumeUp,
                    ),
                  ),
                  RemoteButton(
                    icon: Icons.volume_off,
                    onTap: () => command(
                      'KEY_MUTE',
                      android_tv.RemoteKeyCode.volumeMute,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RemoteButton(
                    icon: Icons.menu,
                    onTap: () => command(
                      'KEY_MENU',
                      android_tv.RemoteKeyCode.menu,
                    ),
                  ),
                  RemoteButton(
                    icon: Icons.arrow_back,
                    onTap: () => command(
                      'KEY_RETURN',
                      android_tv.RemoteKeyCode.back,
                    ),
                  ),
                  RemoteButton(
                    icon: Icons.home,
                    onTap: () => command(
                      'KEY_HOME',
                      android_tv.RemoteKeyCode.home,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!isSamsung)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: busy ? null : connectChiq,
                    icon: const Icon(Icons.link),
                    label: const Text('Opnieuw verbinden'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RemoteButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const RemoteButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 58,
          height: 58,
          child: Icon(
            icon,
            color: color,
            size: 27,
          ),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instellingen')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Over Boogle Home'),
            subtitle: Text('Versie 1.0'),
          ),
          const ListTile(
            leading: Icon(Icons.devices),
            title: Text('Apparaten'),
            subtitle: Text('2 apparaten toegevoegd'),
          ),
          const ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Uiterlijk'),
            subtitle: Text('Light mode'),
          ),
        ],
      ),
    );
  }
}
