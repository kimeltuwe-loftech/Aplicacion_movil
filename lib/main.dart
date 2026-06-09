import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Importaciones
import 'plants/list.dart';
import 'ayudar.dart';
import 'l10n/app_localizations.dart';
import 'util/udp.dart';
import 'util/settings_service.dart'; // <--- Importa el nuevo servicio
import 'configuracion.dart';
import 'util/game_storage.dart';
import 'game/setup/amount_of_teams.dart';
import 'game/rounds_list.dart';
import 'sensors/sensor_list.dart';

class _FallbackMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    if (GlobalMaterialLocalizations.delegate.isSupported(locale)) {
      return GlobalMaterialLocalizations.delegate.load(locale);
    }
    return GlobalMaterialLocalizations.delegate.load(const Locale('es'));
  }

  @override
  bool shouldReload(_FallbackMaterialLocalizationsDelegate old) => false;
}

class _FallbackWidgetsLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  const _FallbackWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    if (GlobalWidgetsLocalizations.delegate.isSupported(locale)) {
      return GlobalWidgetsLocalizations.delegate.load(locale);
    }
    return GlobalWidgetsLocalizations.delegate.load(const Locale('es'));
  }

  @override
  bool shouldReload(_FallbackWidgetsLocalizationsDelegate old) => false;
}

class _FallbackCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    if (GlobalCupertinoLocalizations.delegate.isSupported(locale)) {
      return GlobalCupertinoLocalizations.delegate.load(locale);
    }
    return GlobalCupertinoLocalizations.delegate.load(const Locale('es'));
  }

  @override
  bool shouldReload(_FallbackCupertinoLocalizationsDelegate old) => false;
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UdpSensorReceiver>(
          create: (_) {
            final receiver = UdpSensorReceiver();
            receiver.start(port: 12345);
            return receiver;
          },
        ),
        ChangeNotifierProvider(create: (_) => SettingsService()), // <--- Agregamos el servicio aquí
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);

    // Escuchamos los cambios de configuración y levantamos la localización
    final locale = Locale(settings.languageCode);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kimeltuwe',
      locale: locale,
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
        Locale('ay'), // aymara
        Locale('map'), // mapuzungun (custom code)
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        _FallbackMaterialLocalizationsDelegate(),
        _FallbackWidgetsLocalizationsDelegate(),
        _FallbackCupertinoLocalizationsDelegate(),
      ],
      

      // Modificamos el tema global basándonos en el tamaño de letra seleccionado
      theme: ThemeData(
        // 1. CAMBIO DE FONDO: Si es oscuro usa gris casi negro, si es claro usa tu celeste
        scaffoldBackgroundColor: settings.isDarkMode 
            ? const Color(0xFF121212) 
            : const Color(0xFFD0EAFF),
            
        // 2. ESQUEMA DE COLORES: Cambia el brillo general
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF009900),
          brightness: settings.isDarkMode ? Brightness.dark : Brightness.light,
        ),
      
      useMaterial3: true,

        // 3. TEXTOS 
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: settings.fontSize), 
          bodyLarge: TextStyle(fontSize: settings.fontSize + 2),
          titleMedium: TextStyle(fontSize: settings.fontSize + 4, fontWeight: FontWeight.bold),
          labelLarge: TextStyle(fontSize: settings.fontSize), 
        ),
        
        // 4. Ajustar AppBar y otros elementos si es necesario
        appBarTheme: AppBarTheme(
          backgroundColor: settings.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          foregroundColor: settings.isDarkMode ? Colors.white : Colors.black,
        ),
      ),

      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // --- Botón de Configuración (Superior Derecha) ---
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.settings),
                iconSize: 40,
                color: const Color(0xFF5F6368),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Configuracion(),
                    ),
                  );
                },
              ),
            ),

            // --- Contenido Central (Logo y Botones) ---
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo y Título 
                    Image.asset(
                      'assets/logo_principal.png',
                      width: 200,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 50),

                    // Botón SENSORES
                    _buildMenuButton(
                      context,
                      label: loc?.sensors ?? 'Sensores',
                      fontSize: settings.fontSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Sensores()),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Botón HERBARIO
                    _buildMenuButton(
                      context,
                      label: loc?.plantsInformation ?? 'Herbario',
                      fontSize: settings.fontSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FichasPlantas()),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Botón EXPLORAR
                    _buildMenuButton(
                      context,
                      label: 'JUEGO',
                      fontSize: settings.fontSize,
                      onTap: () async {
                        final Map<String, dynamic> gameInfo = await Storage.getGameInfo();
                        if (!mounted) return;

                        final selectedTeam = gameInfo['selectedTeam'] as int?;
                        final amountOfTeams = gameInfo['amountOfTeams'] as int?;
                        final sentence = gameInfo['sentence'] as String?;

                        // If either is missing, go to Welcome
                        if (selectedTeam == null || amountOfTeams == null || sentence == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AmountOfTeams()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoundsList(
                                teamNumber: selectedTeam,
                                amountOfTeams: amountOfTeams,
                                sentence: 'Aymara is cool',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // --- Botón de Ayuda (Inferior Derecha) ---
            Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.help),
                iconSize: 50,
                color: const Color(0xFF5F6368),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Ayudar()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para los botones del menú
  Widget _buildMenuButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    required double fontSize,
  }) {
    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 4,
          side: const BorderSide(color: Colors.black, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
