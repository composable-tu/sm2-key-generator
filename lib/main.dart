//
// Copyright (c) 2025 LuminaPJ
// SM2 Key Generator is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//          http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sm2_key_generator/data/pri_to_pub_state.dart';
import 'package:sm2_key_generator/data/rust_init_state.dart';
import 'package:sm2_key_generator/page/pri_to_pub_page.dart';
import 'package:window_manager/window_manager.dart';

import 'data/key_generator_state.dart';
import 'page/about_page.dart';
import 'page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(250, 400),
    center: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RustInitState()),
        ChangeNotifierProvider(create: (_) => PriToPubState()),
        ChangeNotifierProvider(create: (_) => KeyGeneratorState()),
      ],
      child: EasyLocalization(
        supportedLocales: [Locale('zh', 'CN')],
        path: 'assets/translations',
        fallbackLocale: Locale('zh', 'CN'),
        child: ChangeNotifierProvider(
          create: (_) => KeyGeneratorState(),
          child: SM2KeyGeneratorApp(),
        ),
      ),
    ),
  );
}

class SM2KeyGeneratorApp extends StatelessWidget {
  const SM2KeyGeneratorApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ...context.localizationDelegates,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'SM2 Key Generator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: const SM2KeyGeneratorPage(),
    );
  }
}

class AppDestination {
  const AppDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

List<AppDestination> createDestinations(BuildContext context) {
  return [
    AppDestination(
      context.tr('home'),
      Icon(Icons.home_outlined),
      Icon(Icons.home),
    ),
    AppDestination(
      context.tr('pri_to_pub'),
      Icon(Icons.vpn_key_outlined),
      Icon(Icons.vpn_key),
    ),
    AppDestination(
      context.tr('about'),
      Icon(Icons.info_outline),
      Icon(Icons.info),
    ),
  ];
}

class SM2KeyGeneratorPage extends StatefulWidget {
  const SM2KeyGeneratorPage({super.key});

  @override
  State<SM2KeyGeneratorPage> createState() => _SM2KeyGeneratorPageState();
}

class _SM2KeyGeneratorPageState extends State<SM2KeyGeneratorPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late List<AppDestination> destinations;
  int screenIndex = 0;
  late bool showNavigationDrawer;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  Widget buildBottomBarScaffold() {
    return Scaffold(
      body: Center(child: buildPageContent(context, screenIndex)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: screenIndex,
        onDestinationSelected: (int index) {
          setState(() {
            screenIndex = index;
          });
        },
        destinations:
            destinations.map((AppDestination destination) {
              return NavigationDestination(
                label: destination.label,
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
                tooltip: destination.label,
              );
            }).toList(),
      ),
    );
  }

  Widget buildDrawerScaffold(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: NavigationRail(
                destinations:
                    destinations.map((AppDestination destination) {
                      return NavigationRailDestination(
                        label: Text(destination.label),
                        icon: destination.icon,
                        selectedIcon: destination.selectedIcon,
                      );
                    }).toList(),
                selectedIndex: screenIndex,
                useIndicator: true,
                labelType: labelType,
                onDestinationSelected: (int index) {
                  setState(() {
                    screenIndex = index;
                  });
                },
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: buildPageContent(context, screenIndex)),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    destinations = createDestinations(context);
    showNavigationDrawer = MediaQuery.of(context).size.width >= 450;
  }

  @override
  Widget build(BuildContext context) {
    return showNavigationDrawer
        ? buildDrawerScaffold(context)
        : buildBottomBarScaffold();
  }

  Widget buildPageContent(BuildContext context, int screenIndex) {
    switch (screenIndex) {
      case 0:
        return SM2KeyGeneratorHomePage();
      case 1:
        return PriToPubPage();
      case 2:
        return AboutPage();
      default:
        return Center(child: Text('Page Index = $screenIndex'));
    }
  }
}
