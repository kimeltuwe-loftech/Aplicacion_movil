import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../globals/game_rounds.dart';

class VideoScreen extends StatelessWidget {
  final VoidCallback onNext;
  final SensorRound sensorRound;

  const VideoScreen({
    super.key,
    required this.onNext,
    required this.sensorRound,
  });

  @override
  Widget build(BuildContext context) {
    // final YoutubePlayerController _controller = YoutubePlayerController(
    //   initialVideoId: YoutubePlayer.convertUrlToId(sensorRound.videoUrl) ?? "",
    //   flags: YoutubePlayerFlags(
    //     autoPlay: false,
    //     showLiveFullscreenButton: false,
    //     mute: false,
    //   ),
    // );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Listen to the educator!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            // YoutubePlayer(
            //   controller: _controller,
            //   showVideoProgressIndicator: true,
            //   progressIndicatorColor: Colors.red,
            // ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: onNext, child: Text('Continuar')),
          ],
        ),
      ),
    );
  }
}
