import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:rivu_v1/colors.dart'; // Pastikan import ini ada jika menggunakan AppColors

class LiveCameraView extends StatefulWidget {
  // URL RTSP dari ESP32-CAM
  final String rtspUrl;

  const LiveCameraView({
    Key? key,
    // Default URL jika tidak ada yang dipassing, sesuaikan IP dengan ESP32 Anda
    this.rtspUrl = 'rtsp://192.168.1.10:8554/mjpeg/1',
  }) : super(key: key);

  @override
  State<LiveCameraView> createState() => _LiveCameraViewState();
}

class _LiveCameraViewState extends State<LiveCameraView> {
  late VlcPlayerController _videoPlayerController;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      widget.rtspUrl,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([VlcAdvancedOptions.networkCaching(2000)]),
        rtp: VlcRtpOptions([VlcRtpOptions.rtpOverRtsp(true)]),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.stopRendererScanning();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: 220, // Sedikit diperbesar agar controller terlihat jelas
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VlcPlayer(
              controller: _videoPlayerController,
              aspectRatio:
                  4 / 3, // Sesuaikan dengan rasio kamera ESP32 (biasanya 4:3)
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
            // Overlay kontrol sederhana (Opsional)
            Container(
              color: Colors.black45,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                      if (_isPlaying) {
                        _videoPlayerController.play();
                      } else {
                        _videoPlayerController.pause();
                      }
                    },
                  ),
                  Text(
                    "Live Stream",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      // Reload stream jika macet
                      _videoPlayerController.stop();
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _videoPlayerController.play();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
