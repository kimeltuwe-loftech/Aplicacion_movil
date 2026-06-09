import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../util/udp.dart';
import '../globals/sensor_definitions.dart';

// Importamos las pantallas de navegación
import '../configuracion.dart';
import '../ayudar.dart';

class SensorGraph extends StatefulWidget {
  final SensorType sensorType;
  const SensorGraph({super.key, required this.sensorType});

  @override
  State<SensorGraph> createState() => _SensorGraphState();
}

class _SensorGraphState extends State<SensorGraph> {
  bool _initialized = false;
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _togglePage() {
    if (_pageController.page == 0) {
      _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final conn = context.watch<UdpSensorReceiver>();
    final samples = conn.getSensorValues(widget.sensorType);

    final sensorInfo = getSensorInfo(context);
    final info = sensorInfo[widget.sensorType]!;

    String nombreSensor = widget.sensorType.toString().toLowerCase();
    bool esSensorLluvia = nombreSensor.contains('lluvia');
    bool esSensorLuz = nombreSensor.contains('luz') || nombreSensor.contains('luminosidad');
    bool esSensorTemp = nombreSensor.contains('temperatura') || nombreSensor.contains('temp');
    bool esSensorSuelo = nombreSensor.contains('suelo') || nombreSensor.contains('tierra');
    bool esSensorAgua = nombreSensor.contains('particulado') || nombreSensor.contains('agua') || nombreSensor.contains('turbidez');
    bool esSensorHumedadAmbiente = nombreSensor.contains('humedad') && !nombreSensor.contains('suelo');
    bool esSensorRuido = nombreSensor.contains('ruido');
    bool esSensorPulso = nombreSensor.contains('pulsa') || nombreSensor.contains('ritmo');

    Widget contenidoVisualizacion;
    Widget contenidoGrafico;

    if (samples.isEmpty) {
      contenidoVisualizacion = const Center(child: Text("Esperando datos del sensor...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)));
      contenidoGrafico = const Center(child: Text("Sin historial aún...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)));
    } else {
      double valorActual = samples.last.value;
      
      // 1. Preparamos la ANIMACIÓN
      if (esSensorLluvia) contenidoVisualizacion = _buildRain(valorActual, info);
      else if (esSensorLuz) contenidoVisualizacion = _buildSun(valorActual, info);
      else if (esSensorTemp) contenidoVisualizacion = _buildTemp(valorActual, info);
      else if (esSensorSuelo) contenidoVisualizacion = _buildSoil(valorActual, info);
      else if (esSensorAgua) contenidoVisualizacion = _buildWater(valorActual, info);
      else if (esSensorHumedadAmbiente) contenidoVisualizacion = _buildAmbientHumidity(valorActual, info);
      else if (esSensorRuido) contenidoVisualizacion = _buildNoise(valorActual, info);     // NUEVO
      else if (esSensorPulso) contenidoVisualizacion = _buildHeartRate(valorActual, info); // NUEVO
      else contenidoVisualizacion = _buildFallbackChart(samples, info);

      // 2. Preparamos el GRÁFICO HISTÓRICO
      contenidoGrafico = _buildHistoricalChart(samples, info);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0EAFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black54, size: 35),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54, size: 35),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Configuracion())),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Ayudar())),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.help, size: 60, color: Color(0xFF6E6E6E)),
      ),

      body: Column(
        children: [
          const Divider(color: Colors.black87, thickness: 1.5, height: 0),

          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                Icon(info.icon, color: info.color, size: 35),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    info.label,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: AspectRatio(
                  aspectRatio: 0.85, 
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          PageView(
                            controller: _pageController,
                            children: [
                              GestureDetector(onTap: _togglePage, child: contenidoVisualizacion),
                              GestureDetector(onTap: _togglePage, child: contenidoGrafico),
                            ],
                          ),
                          Positioned(
                            top: 15, right: 15,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
                              child: AnimatedBuilder(
                                animation: _pageController,
                                builder: (context, child) {
                                  double page = 0.0;
                                  if (_pageController.hasClients) page = _pageController.page ?? 0.0;
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [_buildDot(page < 0.5), const SizedBox(width: 5), _buildDot(page >= 0.5)],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), height: 8, width: isActive ? 16 : 8,
      decoration: BoxDecoration(color: isActive ? Colors.white : Colors.white54, borderRadius: BorderRadius.circular(4)),
    );
  }

  // ==========================================================
  // GRÁFICO HISTÓRICO
  // ==========================================================
  Widget _buildHistoricalChart(List<SensorSample> samples, SensorInfo info) {
    final DateTime baseTime = samples.first.timestamp;
    final barGroups = samples.asMap().entries.map((entry) {
      final sample = entry.value; 
      final x = sample.timestamp.difference(baseTime).inSeconds.toDouble();
      return BarChartGroupData(x: x.toInt(), barRods: [BarChartRodData(toY: sample.value, color: info.color, width: 16, borderRadius: BorderRadius.circular(4))]);
    }).toList();

    double maxY = info.limites[1] > 0 ? info.limites[1] : 50.0;
    double minY = info.limites[0];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 40, right: 30, left: 10, bottom: 20),
      child: BarChart(BarChartData(minY: minY, maxY: maxY, barGroups: barGroups, titlesData: FlTitlesData(leftTitles: AxisTitles(axisNameWidget: Text(info.unidad, style: const TextStyle(color: Color(0xFF009900), fontWeight: FontWeight.bold, fontSize: 18)), axisNameSize: 35, sideTitles: SideTitles(showTitles: true, reservedSize: 35, getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: const TextStyle(color: Color(0xFF009900), fontWeight: FontWeight.bold, fontSize: 16)))), bottomTitles: AxisTitles(axisNameWidget: const Padding(padding: EdgeInsets.only(top: 10.0), child: Text("Tiempo", style: TextStyle(color: Color(0xFF009900), fontWeight: FontWeight.bold, fontSize: 18))), axisNameSize: 45, sideTitles: SideTitles(showTitles: true, interval: 5, reservedSize: 30, getTitlesWidget: (value, meta) { final dt = baseTime.add(Duration(seconds: value.toInt())); final ss = dt.second.toString().padLeft(2, '0'); return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(ss, style: const TextStyle(color: Color(0xFF009900), fontWeight: FontWeight.bold, fontSize: 12))); })), topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false))), borderData: FlBorderData(show: false), gridData: FlGridData(show: true, drawVerticalLine: true, getDrawingHorizontalLine: (value) => const FlLine(color: Colors.lightBlueAccent, strokeWidth: 1), getDrawingVerticalLine: (value) => const FlLine(color: Colors.lightBlueAccent, strokeWidth: 1)))),
    );
  }

  // ==========================================================
  // CONSTRUCTORES DE CONTENIDO INTERNO (ANIMACIONES)
  // ==========================================================

  Widget _buildInfoCard(double valor, SensorInfo info, String estado, Color colorTexto) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(15), border: Border.all(color: colorTexto, width: 2), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${valor.toStringAsFixed(1)} ${info.unidad}", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colorTexto)),
            const SizedBox(height: 2),
            Text(estado, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87), textAlign: TextAlign.center),
            const SizedBox(height: 5),
            const Text("👆 Toca o desliza para historial", style: TextStyle(fontSize: 11, color: Colors.black54, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  // NUEVO: RUIDO
  Widget _buildNoise(double valor, SensorInfo info) {
    double minN = info.limites[0], maxN = info.limites[1]; if (minN >= maxN) { minN = -130; maxN = 320; } 
    double intensidad = ((valor - minN) / (maxN - minN)).clamp(0.0, 1.0);
    
    String estado = "Silencioso"; Color cText = Colors.green[700]!; Color cBg = const Color(0xFFE8F5E9);
    if (intensidad < 0.3) { estado = "Ambiente tranquilo"; } 
    else if (intensidad < 0.6) { estado = "Ruido moderado"; cText = Colors.orange[800]!; cBg = const Color(0xFFFFF3E0); } 
    else if (intensidad < 0.8) { estado = "Ruidoso"; cText = Colors.deepOrange; cBg = const Color(0xFFFFEBE6); }
    else { estado = "¡Ruido dañino!"; cText = Colors.red[900]!; cBg = const Color(0xFFFFCDD2); }

    return Container(color: cBg, child: Stack(children: [Positioned.fill(child: NoiseAnimationWidget(intensidad: intensidad, colorBase: cText)), _buildInfoCard(valor, info, estado, cText)]));
  }

  // NUEVO: PULSO CARDÍACO
  Widget _buildHeartRate(double valor, SensorInfo info) {
    String estado = "Buscando pulso..."; Color cText = Colors.grey[700]!; Color cBg = const Color(0xFFF5F5F5);
    if (valor > 40 && valor <= 60) { estado = "Pulso en reposo (Bajo)"; cText = Colors.blue[700]!; cBg = const Color(0xFFE3F2FD); }
    else if (valor > 60 && valor <= 100) { estado = "Pulso normal"; cText = Colors.green[700]!; cBg = const Color(0xFFE8F5E9); }
    else if (valor > 100 && valor <= 140) { estado = "Pulso elevado (Actividad)"; cText = Colors.orange[800]!; cBg = const Color(0xFFFFF3E0); }
    else if (valor > 140) { estado = "¡Pulso muy acelerado!"; cText = Colors.red[800]!; cBg = const Color(0xFFFFCDD2); }

    return Container(color: cBg, child: Stack(children: [Positioned.fill(child: HeartBeatAnimationWidget(bpm: valor, colorCorazon: cText)), _buildInfoCard(valor, info, estado, cText)]));
  }

  Widget _buildAmbientHumidity(double valor, SensorInfo info) {
    double minHum = info.limites[0]; double maxHum = info.limites[1]; if (minHum >= maxHum) { minHum = 0; maxHum = 100; } 
    double intensidad = ((valor - minHum) / (maxHum - minHum)).clamp(0.0, 1.0);
    String estado = "Ambiente Seco"; Color cText = Colors.blue[300]!; Color cBg = const Color(0xFFFFF9C4); Color cLiq = Colors.lightBlueAccent;
    if (intensidad < 0.3) { estado = "Ambiente muy seco"; cText = Colors.orange[400]!; cBg = const Color(0xFFFFF3E0); cLiq = Colors.lightBlue[200]!; } 
    else if (intensidad < 0.6) { estado = "Humedad confortable"; cText = Colors.blue[600]!; cBg = const Color(0xFFE3F2FD); cLiq = Colors.blue; } 
    else { estado = "Ambiente muy húmedo"; cText = Colors.blue[900]!; cBg = const Color(0xFFCFD8DC); cLiq = Colors.indigo[400]!; }
    return Container(color: cBg, child: Stack(children: [Center(child: SizedBox(width: 180, height: 280, child: HumidityAnimationWidget(porcentaje: intensidad, colorLiquido: cLiq))), _buildInfoCard(valor, info, estado, cText)]));
  }

  Widget _buildWater(double valor, SensorInfo info) {
    double maxP = info.limites[1]; if (maxP <= 0) maxP = 100.0; double intensidad = (valor / maxP).clamp(0.0, 1.0);
    String estado = "Agua cristalina"; Color cText = Colors.blue[800]!;
    if (intensidad >= 0.1 && intensidad < 0.4) { estado = "Ligeramente turbia"; cText = Colors.teal[800]!; } else if (intensidad >= 0.4 && intensidad < 0.7) { estado = "Agua turbia (Sedimentos)"; cText = Colors.brown[600]!; } else if (intensidad >= 0.7) { estado = "Agua muy sucia / Lodo"; cText = Colors.brown[900]!; }
    return Container(color: Color.lerp(const Color(0xFFB3E5FC), const Color(0xFF8D6E63), intensidad)!, child: Stack(children: [Positioned.fill(child: WaterParticulateAnimationWidget(intensidad: intensidad)), _buildInfoCard(valor, info, estado, cText)]));
  }

  Widget _buildSoil(double valor, SensorInfo info) {
    double minS = info.limites[0], maxS = info.limites[1]; if (minS >= maxS) { minS = 0; maxS = 100; } double intensidad = ((valor - minS) / (maxS - minS)).clamp(0.0, 1.0);
    String estado = "Seco"; if (intensidad < 0.2) estado = "Suelo muy seco"; else if (intensidad < 0.4) estado = "Ligeramente húmedo"; else if (intensidad < 0.8) estado = "Humedad ideal"; else estado = "Suelo saturado / Barro";
    return Container(color: const Color(0xFFE1F5FE), child: Stack(children: [Positioned.fill(child: SoilAnimationWidget(intensidad: intensidad)), _buildInfoCard(valor, info, estado, Colors.brown[700]!)]));
  }

  Widget _buildSun(double valor, SensorInfo info) {
    double intensidad = (valor / 2500.0).clamp(0.0, 1.0); String estado = "Oscuridad total";
    if (intensidad >= 0.05 && intensidad < 0.3) estado = "Luz tenue"; else if (intensidad >= 0.3 && intensidad < 0.9) estado = "Luz de día"; else if (intensidad >= 0.9) estado = "¡Luz muy intensa!";
    return Container(color: Color.lerp(const Color(0xFF0A1128), const Color(0xFF64B5F6), intensidad)!, child: Stack(children: [Positioned.fill(child: SunAnimationWidget(intensidad: intensidad)), _buildInfoCard(valor, info, estado, Colors.orange)]));
  }

  Widget _buildTemp(double valor, SensorInfo info) {
    double minT = info.limites[0], maxT = info.limites[1]; if (minT >= maxT) { minT = 0; maxT = 50; } double porcentaje = ((valor - minT) / (maxT - minT)).clamp(0.0, 1.0);
    Color cTemp, cBg; String estado;
    if (valor <= 12) { estado = "Mucho frío"; cTemp = Colors.blue; cBg = const Color(0xFFB3E5FC); } else if (valor <= 20) { estado = "Fresco"; cTemp = Colors.lightBlue; cBg = const Color(0xFFD0EAFF); } else if (valor <= 26) { estado = "Agradable"; cTemp = Colors.green; cBg = const Color(0xFFC8E6C9); } else if (valor <= 32) { estado = "Caluroso"; cTemp = Colors.orange; cBg = const Color(0xFFFFE0B2); } else { estado = "¡Mucho calor!"; cTemp = Colors.red; cBg = const Color(0xFFFFCDD2); }
    return Container(color: cBg, child: Stack(children: [Center(child: SizedBox(width: 130, height: 300, child: ThermometerAnimationWidget(porcentaje: porcentaje, colorLiquido: cTemp))), _buildInfoCard(valor, info, estado, cTemp)]));
  }

  Widget _buildRain(double valor, SensorInfo info) {
    double maxL = info.limites[1]; if (maxL <= 0) maxL = 100; double intensidad = (valor / maxL).clamp(0.0, 1.0);
    String estado = "Sin precipitaciones"; if (intensidad >= 0.05 && intensidad < 0.3) estado = "Llovizna leve"; else if (intensidad >= 0.3 && intensidad < 0.7) estado = "Lluvia moderada"; else if (intensidad >= 0.7) estado = "¡Fuerte aguacero!";
    return Container(color: Color.lerp(const Color(0xFFD0EAFF), const Color(0xFF37474F), intensidad < 0.05 ? 0.0 : intensidad), child: Stack(children: [Positioned.fill(child: RainAnimationWidget(intensidad: intensidad)), _buildInfoCard(valor, info, estado, info.color)]));
  }

  Widget _buildFallbackChart(List<SensorSample> samples, SensorInfo info) {
    return _buildHistoricalChart(samples, info);
  }
}

// ======================================================================
// ==================== WIDGETS ANIMADOS (PINTADORES) ===================
// ======================================================================

// --- 1. ANIMACIÓN DEL LATIDO CARDÍACO ---
class HeartBeatAnimationWidget extends StatefulWidget { 
  final double bpm; 
  final Color colorCorazon; 
  const HeartBeatAnimationWidget({super.key, required this.bpm, required this.colorCorazon}); 
  
  @override 
  State<HeartBeatAnimationWidget> createState() => _HeartBeatAnimationWidgetState(); 
}

// ¡EL CAMBIO ESTÁ AQUÍ! Cambiamos SingleTickerProvider... por TickerProviderStateMixin
class _HeartBeatAnimationWidgetState extends State<HeartBeatAnimationWidget> with TickerProviderStateMixin { 
  AnimationController? _controller; 
  
  @override 
  void initState() { 
    super.initState(); 
    _setSpeed(); 
  } 
  
  @override 
  void didUpdateWidget(HeartBeatAnimationWidget oldWidget) { 
    super.didUpdateWidget(oldWidget); 
    // Cuando llega un nuevo valor UDP, actualizamos la velocidad
    if (oldWidget.bpm != widget.bpm) _setSpeed(); 
  } 
  
  void _setSpeed() { 
    _controller?.dispose(); // Borra el viejo
    
    // Crea el nuevo controlador con la velocidad actualizada
    int millis = widget.bpm > 20 ? (60000 / widget.bpm).round() : 1000; 
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: millis))..repeat(reverse: true); 
  } 
  
  @override 
  void dispose() { 
    _controller?.dispose(); 
    super.dispose(); 
  } 
  
  @override 
  Widget build(BuildContext context) { 
    return AnimatedBuilder(
      animation: _controller!, 
      builder: (context, child) { 
        double scale = 1.0 + (_controller!.value * 0.3); 
        return Center(
          child: Transform.scale(
            scale: scale, 
            child: Icon(Icons.favorite, size: 120, color: widget.colorCorazon.withOpacity(0.8))
          )
        ); 
      }
    ); 
  } 
}

// --- 2. ANIMACIÓN DE ONDAS DE RUIDO (NUEVO) ---
class NoiseAnimationWidget extends StatefulWidget { final double intensidad; final Color colorBase; const NoiseAnimationWidget({super.key, required this.intensidad, required this.colorBase}); @override State<NoiseAnimationWidget> createState() => _NoiseAnimationWidgetState(); }
class _NoiseAnimationWidgetState extends State<NoiseAnimationWidget> with SingleTickerProviderStateMixin { late AnimationController _controller; @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(); } @override void dispose() { _controller.dispose(); super.dispose(); } @override Widget build(BuildContext context) { return AnimatedBuilder(animation: _controller, builder: (context, child) => CustomPaint(painter: NoisePainter(intensidad: widget.intensidad, progreso: _controller.value, colorBase: widget.colorBase))); } }
class NoisePainter extends CustomPainter { final double intensidad, progreso; final Color colorBase; NoisePainter({required this.intensidad, required this.progreso, required this.colorBase}); @override void paint(Canvas canvas, Size size) { final centro = Offset(size.width / 2, size.height / 2.5); canvas.drawCircle(centro, 40, Paint()..color = colorBase); if (intensidad > 0.1) { double radioMax = 50 + (intensidad * 150); for (int i = 0; i < 3; i++) { double prog = (progreso + (i / 3.0)) % 1.0; double r = 40 + (prog * (radioMax - 40)); double opacidad = (1.0 - prog) * intensidad; canvas.drawCircle(centro, r, Paint()..color = colorBase.withOpacity(opacidad)..style = PaintingStyle.stroke..strokeWidth = 4 + (intensidad * 6)); } } } @override bool shouldRepaint(covariant NoisePainter oldDelegate) => true; }

// --- 3. ANIMACIÓN DE LA HUMEDAD AMBIENTE ---
class HumidityAnimationWidget extends StatefulWidget { final double porcentaje; final Color colorLiquido; const HumidityAnimationWidget({super.key, required this.porcentaje, required this.colorLiquido}); @override State<HumidityAnimationWidget> createState() => _HumidityAnimationWidgetState(); }
class _HumidityAnimationWidgetState extends State<HumidityAnimationWidget> with SingleTickerProviderStateMixin { late AnimationController _controller; late Animation<double> _animationAltura; double _oldPorcentaje = 0.0; @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(); _animationAltura = Tween<double>(begin: 0.0, end: widget.porcentaje).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)); _oldPorcentaje = widget.porcentaje; } @override void didUpdateWidget(HumidityAnimationWidget oldWidget) { super.didUpdateWidget(oldWidget); if (oldWidget.porcentaje != widget.porcentaje) { _animationAltura = Tween<double>(begin: _oldPorcentaje, end: widget.porcentaje).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)); _oldPorcentaje = widget.porcentaje; } } @override void dispose() { _controller.dispose(); super.dispose(); } @override Widget build(BuildContext context) { return AnimatedBuilder(animation: _controller, builder: (context, child) { return CustomPaint(painter: HumidityPainter(porcentaje: _animationAltura.value, tiempoOlas: _controller.value, colorLiquido: widget.colorLiquido)); }); } }
class HumidityPainter extends CustomPainter { final double porcentaje; final double tiempoOlas; final Color colorLiquido; HumidityPainter({required this.porcentaje, required this.tiempoOlas, required this.colorLiquido}); @override void paint(Canvas canvas, Size size) { Path dropPath = Path(); dropPath.moveTo(size.width / 2, 0); dropPath.cubicTo(size.width * 1.3, size.height * 0.5, size.width * 0.9, size.height, size.width / 2, size.height); dropPath.cubicTo(size.width * 0.1, size.height, size.width * -0.3, size.height * 0.5, size.width / 2, 0); canvas.drawPath(dropPath, Paint()..color = Colors.white.withOpacity(0.5)..style = PaintingStyle.fill); canvas.drawPath(dropPath, Paint()..color = Colors.blue[300]!..style = PaintingStyle.stroke..strokeWidth = 4); canvas.save(); canvas.clipPath(dropPath); if (porcentaje > 0.0) { Path waterPath = Path(); double fillHeight = size.height - (size.height * porcentaje); waterPath.moveTo(0, size.height); waterPath.lineTo(0, fillHeight); for (double x = 0; x <= size.width; x++) { double waveY = fillHeight + sin((x / size.width * 2 * pi) + (tiempoOlas * 2 * pi)) * 8; waterPath.lineTo(x, waveY); } waterPath.lineTo(size.width, size.height); waterPath.close(); canvas.drawPath(waterPath, Paint()..color = colorLiquido.withOpacity(0.8)); } canvas.restore(); } @override bool shouldRepaint(covariant HumidityPainter oldDelegate) => true; }

// --- 4. ANIMACIÓN DE PARTÍCULAS EN EL AGUA ---
class WaterParticulateAnimationWidget extends StatefulWidget { final double intensidad; const WaterParticulateAnimationWidget({super.key, required this.intensidad}); @override State<WaterParticulateAnimationWidget> createState() => _WaterParticulateAnimationWidgetState(); }
class _WaterParticulateAnimationWidgetState extends State<WaterParticulateAnimationWidget> with SingleTickerProviderStateMixin { late AnimationController _controller; List<WaterParticle> _particles = []; @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(); } @override void dispose() { _controller.dispose(); super.dispose(); } void _generateParticles(Size size) { int targetParticles = 5 + (300 * widget.intensidad).toInt(); if (_particles.length < targetParticles) { final random = Random(); for (int i = _particles.length; i < targetParticles; i++) { double r = random.nextDouble(); Color pColor = r > 0.5 ? Colors.brown[700]! : Colors.brown[400]!; if (r > 0.8) pColor = Colors.green[800]!; _particles.add(WaterParticle(x: random.nextDouble() * size.width, y: random.nextDouble() * size.height, vx: (random.nextDouble() - 0.5) * 2, vy: (random.nextDouble() - 0.5) * 2, radius: 1.5 + random.nextDouble() * 4, color: pColor.withOpacity(0.6 + random.nextDouble() * 0.4))); } } else if (_particles.length > targetParticles) { _particles.removeRange(targetParticles, _particles.length); } } @override Widget build(BuildContext context) { return LayoutBuilder(builder: (context, constraints) { final size = Size(constraints.maxWidth, constraints.maxHeight); _generateParticles(size); return AnimatedBuilder(animation: _controller, builder: (context, child) { for (var p in _particles) { p.x += p.vx; p.y += p.vy; if (p.x < 0) p.x = size.width; if (p.x > size.width) p.x = 0; if (p.y < 0) p.y = size.height; if (p.y > size.height) p.y = 0; } return CustomPaint(size: size, painter: WaterParticulatePainter(particles: _particles)); }); }); } }
class WaterParticle { double x, y, vx, vy, radius; Color color; WaterParticle({required this.x, required this.y, required this.vx, required this.vy, required this.radius, required this.color}); }
class WaterParticulatePainter extends CustomPainter { final List<WaterParticle> particles; WaterParticulatePainter({required this.particles}); @override void paint(Canvas canvas, Size size) { final paint = Paint()..style = PaintingStyle.fill; for (var p in particles) { paint.color = p.color; canvas.drawCircle(Offset(p.x, p.y), p.radius, paint); } } @override bool shouldRepaint(covariant WaterParticulatePainter oldDelegate) => true; }

// --- 5. ANIMACIÓN DE LA TIERRA Y LA PLANTA ---
class SoilAnimationWidget extends StatefulWidget { final double intensidad; const SoilAnimationWidget({super.key, required this.intensidad}); @override State<SoilAnimationWidget> createState() => _SoilAnimationWidgetState(); }
class _SoilAnimationWidgetState extends State<SoilAnimationWidget> with SingleTickerProviderStateMixin { late AnimationController _controller; @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(); } @override void dispose() { _controller.dispose(); super.dispose(); } @override Widget build(BuildContext context) { return AnimatedBuilder(animation: _controller, builder: (context, child) => CustomPaint(painter: SoilPainter(intensidad: widget.intensidad, tiempoViento: _controller.value))); } }
class SoilPainter extends CustomPainter { final double intensidad, tiempoViento; SoilPainter({required this.intensidad, required this.tiempoViento}); @override void paint(Canvas canvas, Size size) { final pathTierra = Path()..moveTo(0, size.height * 0.6)..quadraticBezierTo(size.width / 2, size.height * 0.45, size.width, size.height * 0.6)..lineTo(size.width, size.height)..lineTo(0, size.height)..close(); canvas.drawPath(pathTierra, Paint()..color = Color.lerp(const Color(0xFFD7CCC8), const Color(0xFF4E342E), intensidad)!); double salud = intensidad, alturaTallo = 80 + (salud * 60), marchitez = (1.0 - salud) * 80, balanceo = sin(tiempoViento * 2 * pi) * (10 + salud * 10); Offset basePlanta = Offset(size.width / 2, size.height * 0.53), puntoControl = Offset(size.width / 2 + (balanceo / 2) + marchitez, size.height * 0.53 - (alturaTallo / 2)), puntaPlanta = Offset(size.width / 2 + balanceo + (marchitez * 1.5), size.height * 0.53 - alturaTallo + marchitez); Color colorPlanta = Color.lerp(const Color(0xFFA1887F), const Color(0xFF43A047), salud)!; canvas.drawPath(Path()..moveTo(basePlanta.dx, basePlanta.dy)..quadraticBezierTo(puntoControl.dx, puntoControl.dy, puntaPlanta.dx, puntaPlanta.dy), Paint()..color = colorPlanta..strokeWidth = 6 + (salud * 3)..style = PaintingStyle.stroke..strokeCap = StrokeCap.round); final paintHoja = Paint()..color = colorPlanta..style = PaintingStyle.fill; canvas.save(); canvas.translate(puntoControl.dx, puntoControl.dy); canvas.rotate(-pi / 4 + (marchitez * 0.02)); canvas.drawOval(Rect.fromCenter(center: const Offset(-15, 0), width: 35, height: 18), paintHoja); canvas.restore(); canvas.save(); canvas.translate(puntoControl.dx + 5, puntoControl.dy - 20); canvas.rotate(pi / 4 + (marchitez * 0.02)); canvas.drawOval(Rect.fromCenter(center: const Offset(15, 0), width: 35, height: 18), paintHoja); canvas.restore(); } @override bool shouldRepaint(covariant SoilPainter oldDelegate) => true; }

// --- 6. ANIMACIÓN DEL SOL ---
class SunAnimationWidget extends StatefulWidget { final double intensidad; const SunAnimationWidget({super.key, required this.intensidad}); @override State<SunAnimationWidget> createState() => _SunAnimationWidgetState(); }
class _SunAnimationWidgetState extends State<SunAnimationWidget> with SingleTickerProviderStateMixin { late AnimationController _controller; @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(); } @override void dispose() { _controller.dispose(); super.dispose(); } @override Widget build(BuildContext context) { return AnimatedBuilder(animation: _controller, builder: (context, child) => CustomPaint(painter: SunPainter(intensidad: widget.intensidad, rotacion: _controller.value * 2 * pi))); } }
class SunPainter extends CustomPainter { final double intensidad, rotacion; SunPainter({required this.intensidad, required this.rotacion}); @override void paint(Canvas canvas, Size size) { final centro = Offset(size.width / 2, size.height / 3); if (intensidad < 0.05) { canvas.drawCircle(centro, 30, Paint()..color = Colors.white.withOpacity(0.5)); return; } canvas.drawCircle(centro, 40 + (intensidad * 50), Paint()..color = Colors.orangeAccent.withOpacity(0.3 + (intensidad * 0.4))..maskFilter = MaskFilter.blur(BlurStyle.normal, 20 + (intensidad * 50))); canvas.drawCircle(centro, 40 + (intensidad * 40), Paint()..color = Color.lerp(Colors.orangeAccent, Colors.yellowAccent, intensidad)!); final rayosPaint = Paint()..color = Colors.yellowAccent.withOpacity(0.6 + (intensidad * 0.4))..strokeWidth = 4 + (intensidad * 6)..strokeCap = StrokeCap.round; for (int i = 0; i < 12; i++) { double a = (i * 2 * pi / 12) + rotacion, rI = 50 + (intensidad * 45), rE = rI + 10 + (intensidad * 80); canvas.drawLine(Offset(centro.dx + cos(a) * rI, centro.dy + sin(a) * rI), Offset(centro.dx + cos(a) * rE, centro.dy + sin(a) * rE), rayosPaint); } } @override bool shouldRepaint(covariant SunPainter oldDelegate) => true; }

// --- 7. ANIMACIÓN DEL TERMÓMETRO ---
class ThermometerAnimationWidget extends StatefulWidget { final double porcentaje; final Color colorLiquido; const ThermometerAnimationWidget({super.key, required this.porcentaje, required this.colorLiquido}); @override State<ThermometerAnimationWidget> createState() => _ThermometerAnimationWidgetState(); }
class _ThermometerAnimationWidgetState extends State<ThermometerAnimationWidget> with SingleTickerProviderStateMixin { late AnimationController _controller; late Animation<double> _animation; double _oldPorcentaje = 0.0; @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1)); _animation = Tween<double>(begin: 0.0, end: widget.porcentaje).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)); _oldPorcentaje = widget.porcentaje; _controller.forward(); } @override void didUpdateWidget(ThermometerAnimationWidget oldWidget) { super.didUpdateWidget(oldWidget); if (oldWidget.porcentaje != widget.porcentaje) { _animation = Tween<double>(begin: _oldPorcentaje, end: widget.porcentaje).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)); _oldPorcentaje = widget.porcentaje; _controller.forward(from: 0.0); } } @override void dispose() { _controller.dispose(); super.dispose(); } @override Widget build(BuildContext context) { return AnimatedBuilder(animation: _animation, builder: (context, child) => CustomPaint(painter: ThermometerPainter(porcentaje: _animation.value, colorLiquido: widget.colorLiquido))); } }
class ThermometerPainter extends CustomPainter { final double porcentaje; final Color colorLiquido; ThermometerPainter({required this.porcentaje, required this.colorLiquido}); @override void paint(Canvas canvas, Size size) { double bR = 35.0, sW = 30.0, sH = size.height - (bR * 2); Offset bC = Offset(size.width / 2, size.height - bR); Rect sR = Rect.fromCenter(center: Offset(size.width / 2, size.height - bR - (sH / 2)), width: sW, height: sH + 10); final pG = Paint()..color = Colors.white.withOpacity(0.6)..style = PaintingStyle.fill; final pGB = Paint()..color = Colors.white..strokeWidth = 4..style = PaintingStyle.stroke; canvas.drawRRect(RRect.fromRectAndRadius(sR, Radius.circular(sW / 2)), pG); canvas.drawRRect(RRect.fromRectAndRadius(sR, Radius.circular(sW / 2)), pGB); canvas.drawCircle(bC, bR, pG); canvas.drawCircle(bC, bR, pGB); final pL = Paint()..color = colorLiquido..style = PaintingStyle.fill; canvas.drawCircle(bC, bR - 6, pL); double lH = sH * porcentaje; if (lH > 0) { canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(sR.left + 8, sR.bottom - lH - 10, sR.right - 8, sR.bottom), Radius.circular((sW - 16) / 2)), pL); } for (int i = 1; i <= 5; i++) { double y = sR.bottom - (sH / 6) * i; canvas.drawLine(Offset(sR.left + 2, y), Offset(sR.left + 10, y), Paint()..color = Colors.black26..strokeWidth = 2); } } @override bool shouldRepaint(covariant ThermometerPainter oldDelegate) => true; }

// --- 8. ANIMACIÓN DE LA LLUVIA ---
class RainAnimationWidget extends StatefulWidget { final double intensidad; const RainAnimationWidget({super.key, required this.intensidad}); @override State<RainAnimationWidget> createState() => _RainAnimationWidgetState(); }
class _RainAnimationWidgetState extends State<RainAnimationWidget> with SingleTickerProviderStateMixin { late AnimationController _controller; List<RainDrop> _drops = []; @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(); } @override void dispose() { _controller.dispose(); super.dispose(); } @override Widget build(BuildContext context) { if (widget.intensidad < 0.05) return const SizedBox(); return LayoutBuilder(builder: (context, constraints) { final size = Size(constraints.maxWidth, constraints.maxHeight); int tD = widget.intensidad < 0.05 ? 0 : (150 * widget.intensidad).toInt(); if (widget.intensidad >= 0.05 && tD < 5) tD = 5; if (_drops.length < tD) { final r = Random(); for (int i = _drops.length; i < tD; i++) { _drops.add(RainDrop(x: r.nextDouble() * size.width, y: r.nextDouble() * size.height, speed: 8 + r.nextDouble() * 10 + (widget.intensidad * 10), length: 15 + r.nextDouble() * 20)); } } else if (_drops.length > tD) { _drops.removeRange(tD, _drops.length); } return AnimatedBuilder(animation: _controller, builder: (context, child) { for (var d in _drops) { d.y += d.speed; if (d.y > size.height) { d.y = -d.length; d.x = Random().nextDouble() * size.width; } } return CustomPaint(size: size, painter: RainPainter(drops: _drops)); }); }); } }
class RainDrop { double x, y, speed, length; RainDrop({required this.x, required this.y, required this.speed, required this.length}); }
class RainPainter extends CustomPainter { final List<RainDrop> drops; RainPainter({required this.drops}); @override void paint(Canvas canvas, Size size) { final p = Paint()..color = Colors.lightBlueAccent.withOpacity(0.8)..strokeWidth = 2.5..strokeCap = StrokeCap.round; for (var d in drops) canvas.drawLine(Offset(d.x, d.y), Offset(d.x, d.y + d.length), p); } @override bool shouldRepaint(covariant RainPainter oldDelegate) => true; }
