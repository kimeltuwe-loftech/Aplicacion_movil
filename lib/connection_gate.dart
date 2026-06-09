import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'util/udp.dart';
import 'loading_screen.dart';

class ConnectionGate extends StatelessWidget {
  final Widget child;

  const ConnectionGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnySensorConnectionNotifier>(
      create: (ctx) =>
          AnySensorConnectionNotifier(ctx.read<UdpSensorReceiver>()),
      child: Consumer<AnySensorConnectionNotifier>(
        child: child, // <- this will NOT rebuild
        builder: (_, status, child) {
          return status.isConnected ? child! : LoadingScreen();
        },
      ),
    );
  }
}
