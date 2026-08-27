import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:cell_pulse/quickcalc.dart';
import 'package:cell_pulse/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();
  appName = packageInfo.appName;
  packageName = packageInfo.packageName;
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 16, 57, 19),
          foregroundColor: Colors.white,
          title: Row(
            children: [
              SvgPicture.asset(
                'master_logo.svg',
                width: 64,
                height: 64,
              ),
              const SizedBox(width: 8),
              const Text('Cell Pulse'),
            ],
          ),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: NavigationDrawer(
                    children: <Widget>[
                      SizedBox(height: kToolbarHeight),
                      _DrawerButton(
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home,
                        label: 'Home',
                        index: 0,
                        selectedIndex: _selectedIndex,
                        onTap: _selectDestination,
                      ),
                      _DrawerButton(
                        icon: Icons.calculate_outlined,
                        selectedIcon: Icons.calculate,
                        label: 'Quick Calc',
                        index: 1,
                        selectedIndex: _selectedIndex,
                        onTap: _selectDestination,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Text(
                    'Build: $buildNumber',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        color: const Color(0xFF424242),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/':
              case '/home':
                return MaterialPageRoute<void>(
                  builder: (_) => const Home(),
                );

              case '/quickcalc':
                return MaterialPageRoute<void>(
                  builder: (_) => const QuickCalc(),
                );

              default:
                return MaterialPageRoute<void>(
                  builder: (_) => const Home(),
                );
            }
          },
        ),
      ),
    );
  }

  void _selectDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _scaffoldKey.currentState?.closeDrawer();

    switch (index) {
      case 0:
        _navigatorKey.currentState?.pushReplacementNamed('/home');
        break;
      case 1:
        _navigatorKey.currentState?.pushReplacementNamed('/quickcalc');
        break;
    }
  }
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.secondaryContainer : null,
        border: Border.all(
          color: isSelected ? Colors.white70 : Colors.black87,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: 28,
                  color: isSelected
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 32,
                    color: isSelected
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurface,
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

late PackageInfo packageInfo;
late String appName;
late String packageName;
late String version;
late String buildNumber;