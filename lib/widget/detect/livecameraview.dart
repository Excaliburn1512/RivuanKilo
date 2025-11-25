import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:rivu_v1/colors.dart';

class LiveCameraView extends StatefulWidget {
  final String deviceId;
  const LiveCameraView({Key? key, required this.deviceId}) : super(key: key);
  @override
  State<LiveCameraView> createState() => _LiveCameraViewState();
}

class _LiveCameraViewState extends State<LiveCameraView> {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  String _statusMessage = "Menghubungkan...";
  Uint8List? _currentFrame;
  int _retryAttempt = 0;
  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  void _connectWebSocket() {
    if (widget.deviceId.isEmpty) {
      setState(() => _statusMessage = "Device ID tidak valid");
      return;
    }
    setState(() {
      _statusMessage = "Menghubungkan ke Server...";
      _isConnected = false;
    });
    try {
      final wsUrl = Uri.parse('wss://rivu.web.id/api/v1/ws');
      _channel = WebSocketChannel.connect(wsUrl);
      _sendHandshake();
      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          print("WebSocket Error: $error");
          _handleDisconnect("Koneksi Error");
        },
        onDone: () {
          print("WebSocket Closed");
          _handleDisconnect("Koneksi Terputus");
        },
      );
    } catch (e) {
      _handleDisconnect("Gagal Inisialisasi: $e");
    }
  }

  void _sendHandshake() {
    final handshake = jsonEncode({
      "type": "APP_VIEWER",
      "targetId": widget.deviceId,
    });
    print("Mengirim Handshake: $handshake");
    _channel?.sink.add(handshake);
  }

  void _handleMessage(dynamic message) {
    if (message is List<int>) {
      if (mounted) {
        setState(() {
          _currentFrame = Uint8List.fromList(message);
          _isConnected = true;
          _statusMessage = "Live";
        });
      }
    } else if (message is String) {
      try {
        final data = jsonDecode(message);
        if (data['status'] == 'CONNECTED') {
          setState(() {
            _isConnected = true;
            _statusMessage = "Menunggu Stream...";
          });
        } else if (data['status'] == 'ERROR') {
          _handleDisconnect(data['msg'] ?? "Error dari Server");
        }
      } catch (e) {
        print("Pesan teks bukan JSON: $message");
      }
    }
  }

  void _handleDisconnect(String reason) {
    if (mounted) {
      setState(() {
        _isConnected = false;
        _statusMessage = reason;
        _currentFrame = null;
      });
      if (_retryAttempt < 5) {
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            _retryAttempt++;
            _connectWebSocket();
          }
        });
      }
    }
  }

  void _manualReconnect() {
    _channel?.sink.close();
    _retryAttempt = 0;
    _connectWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: 250,
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_currentFrame != null)
              Image.memory(
                _currentFrame!,
                gaplessPlayback: true,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_statusMessage.contains("Terputus") &&
                      !_statusMessage.contains("Gagal"))
                    const CircularProgressIndicator(color: Colors.white)
                  else
                    Icon(Icons.videocam_off, color: Colors.grey, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    _statusMessage,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!_isConnected) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _manualReconnect,
                      icon: Icon(Icons.refresh, size: 16),
                      label: Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _isConnected ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isConnected ? "LIVE" : "OFFLINE",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "CAM: ${widget.deviceId}",
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _manualReconnect,
                      tooltip: "Refresh Stream",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
