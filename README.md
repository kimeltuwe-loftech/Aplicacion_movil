# Kimeltuwe - Aplicación educativa sobre plantas y sensores

## Descripción General

**Kimeltuwe** es una aplicación móvil educativa diseñada para promover el conocimiento sobre plantas y sus aplicaciones en el contexto de pueblos originarios de Chile (por ejemplo: Mapuche y Aymara). La aplicación combina monitoreo de sensores IoT, un herbario interactivo y un sistema de gamificación (en desarrollo) para proporcionar una experiencia de aprendizaje inmersiva.

## Características Principales

### 1. **Sensores IoT en Tiempo Real**
- Visualización interactiva de datos de sensores (luz, humedad del suelo, temperatura, entre otros)
- Gráficos históricos con biblioteca `fl_chart` para análisis de tendencias
- Animaciones personalizadas para cada tipo de sensor
- Conexión UDP para comunicación de datos en tiempo real con el dispositivo microcontrolador
- Indicadores de estado de conexión

### 2. **Sistema de Juego Educativo** (en desarrollo)
- Juego basado en desafíos con sensores
- 5 pasos de progresión por ronda:
  - **Adivinanza**: Conectar sensor y capturar valor inicial
  - **Video**: Contenido educativo
  - **Desafío**: Ajustar sensor a valor objetivo
  - **Quiz**: Preguntas de múltiple elección
  - **Recompensa**: Descubrir letras de una frase secreta
- Soporte para múltiples equipos (1-6 equipos)
- Seguimiento de progreso y sesiones guardadas

### 3. **Herbario Interactivo**
- Catálogo de plantas del territorio
- Fichas detalladas con información cultural
- Galería de imágenes con captura de fotos
- Sistema de favoritos
- Almacenamiento persistente con biblioteca SharedPreferences

### 4. **Soporte Multilingüe**
- Español
- Aymara
- Mapuzungun
- Hechos culturales específicos para cada idioma
- Interfaz completamente localizada

### 5. **Personalización de Interfaz**
- Ajuste de tamaño de fuente (16, 18, 20, 22 puntos)
- Modo oscuro/claro
- Almacenamiento de preferencias

## Arquitectura

### Estructura de Directorios
```
lib/
├── main.dart                 # Punto de entrada principal
├── configuracion.dart        # Pantalla de configuración
├── loading_screen.dart       # Pantalla de carga
├── connection_gate.dart      # Wrapper de validación de conexión
├── ayudar.dart              # Pantalla de ayuda
├── tutorial.dart            # Tutorial inicial
├── connecting_help.dart      # Ayuda de conexión
├── game/                     # Módulo de juego
│   ├── rounds_list.dart     # Lista de rondas
│   ├── sensor_round.dart    # Controlador de ronda
│   ├── components/          # Componentes reutilizables
│   ├── setup/               # Pantallas de configuración
│   ├── sensor_round_steps/  # Pasos del juego
│   └── util/                # Utilidades de juego
├── sensors/                  # Módulo de sensores
│   ├── sensor_list.dart     # Lista de sensores
│   ├── sensor_graph.dart    # Visualización de sensores
│   └── loading_icon.dart    # Animación de carga
├── plants/                   # Módulo de herbario
├── globals/                  # Datos globales
│   ├── sensor_definitions.dart
│   ├── game_rounds.dart
│   ├── aymara_facts.dart
│   └── spanish_facts.dart
├── l10n/                     # Localización
└── util/                     # Utilidades
    ├── udp.dart            # Comunicación UDP
    ├── settings_service.dart
    ├── game_storage.dart
    └── plant_storage.dart
```

### Estado y Proveedores (Provider Pattern)
- `UdpSensorReceiver`: Recibe y almacena datos de sensores
- `AnySensorConnectionNotifier`: Monitorea conexión de cualquier sensor
- `SensorConnectionNotifier`: Monitorea conexión de sensor específico
- `SettingsService`: Gestiona configuración de usuario

### Almacenamiento Persistente
- **SharedPreferences**: Preferencias de usuario, datos de juego
- **JSON Local**: Fichas de plantas con serialización

## Diseño Visual

- **Color Principal**: Verde (#009900) - Tema natural
- **Fondo por defecto**: Azul claro (#D0EAFF)
- **Tema oscuro**: Gris oscuro (#121212)
- **Tema Material 3**: Implementado

## Requisitos Técnicos

- **Flutter**: 3.8.1 o superior
- **Dart**: Incluido con Flutter
- **SDK Android/iOS**: Según documentación de Flutter
- **Puerto UDP**: 12345 (configurable)

## Dependencias

| Dependencia | Versión | Propósito |
|---|---|---|
| udp | ^5.0.3 | Comunicación UDP con sensores |
| fl_chart | ^0.66.0 | Gráficos e histogramas |
| shared_preferences | ^2.2.2 | Almacenamiento local |
| image_picker | ^1.0.7 | Captura de fotos |
| flutter_randomcolor | ^1.0.16 | Colores aleatorios |
| flutter_spinkit | ^5.2.2 | Animaciones de carga |
| intl | any | Internacionalización |
| provider | ^6.1.5+1 | Gestión de estado |
| path_provider | ^2.1.5 | Rutas del sistema |
| accordion | ^2.6.0 | Widgets tipo acordeón |

## Instalación y Ejecución

### Clonar repositorio
```bash
git clone <repository-url>
cd Aplicacion_movil
```

### Instalar dependencias
```bash
flutter pub get
```

### Ejecutar en emulador/dispositivo
```bash
flutter run
```

### Compilar
```bash
# Android
flutter build apk

## Configuración Inicial

1. **Conectar sensores**: Asegurar que los sensores estén configurados para enviar datos UDP al puerto 12345
2. **Seleccionar idioma**: En la pantalla de configuración
3. **Ajustar tamaño de fuente**: Según preferencia
4. **Iniciar juego**: Seleccionar cantidad de equipos y equipo local

## Contenido Educativo

La aplicación incluye:
- **Hechos culturales Mapuche**: Sobre territorio, tradiciones y lengua
- **Hechos culturales Aymara**: Sobre astronomía, cosmología y prácticas
- **Datos de plantas**: Propiedades, usos tradicionales y medicinales
- **Desafíos con sensores**: Actividades prácticas de ciencia

## Privacidad y Datos

- Todos los datos se almacenan localmente en el dispositivo
- No hay conexión a servidores externos
- Las imágenes capturadas se guardan en el almacenamiento local

---

## Licencias de Dependencias

### Atribuciones de Librerías

#### **udp** (Ken Ekeoha)
- Licencia: BSD 3-Clause
- Uso: Comunicación UDP con sensores IoT
- [https://pub.dev/packages/udp](https://pub.dev/packages/udp)

#### **fl_chart** (Flutter 4 Fun)
- Licencia: MIT
- Uso: Visualización de gráficos históricos de sensores
- [https://pub.dev/packages/fl_chart](https://pub.dev/packages/fl_chart)

#### **shared_preferences** (Flutter Team - Google)
- Licencia: BSD 3-Clause
- Uso: Almacenamiento persistente de preferencias y datos de juego
- [https://pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences)

#### **image_picker** (Flutter Team - Google)
- Licencia: BSD 3-Clause
- Uso: Captura de fotos para fichas de plantas
- [https://pub.dev/packages/image_picker](https://pub.dev/packages/image_picker)

#### **flutter_randomcolor** (Damola Adekoya)
- Licencia: MIT
- Uso: Generación de colores aleatorios para UI
- [https://pub.dev/packages/flutter_randomcolor](https://pub.dev/packages/flutter_randomcolor)

#### **flutter_spinkit** (Jeremiah Ogbomo)
- Licencia: MIT
- Uso: Animaciones de carga personalizadas
- [https://pub.dev/packages/flutter_spinkit](https://pub.dev/packages/flutter_spinkit)

#### **intl** (Dart Team - Google)
- Licencia: BSD 3-Clause
- Uso: Soporte para internacionalización y localización
- [https://pub.dev/packages/intl](https://pub.dev/packages/intl)

#### **provider** (Remi Rousselet)
- Licencia: MIT
- Uso: Gestión de estado y reactividad
- [https://pub.dev/packages/provider](https://pub.dev/packages/provider)

#### **path_provider** (Flutter Team - Google)
- Licencia: BSD 3-Clause
- Uso: Acceso a rutas del sistema de archivos
- [https://pub.dev/packages/path_provider](https://pub.dev/packages/path_provider)

#### **accordion** (Christian Gotschim, Vulcansoft LLC)
- Licencia: MIT
- Uso: Widgets tipo acordeón para la interfaz
- [https://pub.dev/packages/accordion](https://pub.dev/packages/accordion)

---

**Kimeltuwe** © 2026 - Kimeltuwe lof Tech
