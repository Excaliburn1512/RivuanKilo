import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/core/services/bluetooth_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
class PairingDialog extends ConsumerStatefulWidget {
  const PairingDialog({super.key});
  @override
  ConsumerState<PairingDialog> createState() => _PairingDialogState();
}
class _PairingDialogState extends ConsumerState<PairingDialog>
    with TickerProviderStateMixin {
  bool _isScanning = false;
  String? _error;
  bool _isConnecting = false;
  final List<BluetoothDevice> _discoveredDevices = [];
  Timer? _scanTimer;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late final BluetoothService _bluetoothService;
  @override
  void initState() {
    super.initState();
    _bluetoothService = ref.read(bluetoothServiceProvider);
    _startScan();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }
  @override
  void dispose() {
    _scanTimer?.cancel();
    _bluetoothService.stopScan();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
  Future<void> _stopScan() async {
    _scanTimer?.cancel();
    _scanTimer = null;
    await _bluetoothService.stopScan();
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }
  Future<void> _startScan() async {
    await _stopScan();
    setState(() {
      _isScanning = true;
      _error = null;
      _discoveredDevices.clear();
    });
    if (await Permission.bluetoothScan.request().isDenied ||
        await Permission.bluetoothConnect.request().isDenied ||
        await Permission.location.request().isDenied) {
      setState(() {
        _error = "Izin Bluetooth & Lokasi diperlukan";
        _isScanning = false;
      });
      return;
    }
    try {
      await _bluetoothService.startScan();
      _scanTimer = Timer(const Duration(seconds: 8), () {
        print("Scan timeout, stopping scan.");
        _stopScan();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isScanning = false;
      });
    }
  }
  Future<void> _onDeviceSelected(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
      _error = null;
    });
    try {
      _bluetoothService.stopScan();
      final deviceIdentifier = await _bluetoothService.connectToDevice(device);
      if (!mounted) return;
      Navigator.of(context).pop(deviceIdentifier);
    } catch (e) {
      setState(() {
        _error = "Gagal terhubung: ${e.toString()}";
        _isConnecting = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    ref.listen(bluetoothScanProvider, (previous, next) {
      if (next.hasValue) {
        final device = next.value!;
        if (device.name != null && device.name!.isNotEmpty) {
          final exists = _discoveredDevices.any(
            (d) => d.address == device.address,
          );
          if (!exists) {
            setState(() {
              _discoveredDevices.add(device);
            });
          }
        }
      }
    });
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.primary, 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isScanning ? _pulseAnimation.value : 1.0,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.bluetooth_searching,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pairing Perangkat",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Cari dan hubungkan perangkat ESP32",
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: (_isScanning || _isConnecting)
                                ? null
                                : _startScan,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: AnimatedRotation(
                                turns: _isScanning ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: Icon(
                                  Icons.refresh_rounded,
                                  color: (_isScanning || _isConnecting)
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isScanning) ...[
                        _buildScanningStatus(colorScheme),
                        const SizedBox(height: 20),
                      ],
                      if (_error != null && !_isScanning) ...[
                        _buildErrorStatus(colorScheme),
                        const SizedBox(height: 16),
                      ],
                      if (_isConnecting) ...[
                        _buildConnectingStatus(colorScheme),
                        const SizedBox(height: 20),
                      ],
                      if (!_isConnecting)
                        _discoveredDevices.isEmpty
                            ? _buildEmptyState(colorScheme)
                            : _buildDeviceList(colorScheme),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _stopScan();
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Batal",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildScanningStatus(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5), 
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF10B981).withOpacity(0.1),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF10B981),
                    ),
                  ),
                ),
                const Icon(
                  Icons.bluetooth_searching,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Mencari perangkat ESP32...",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Pastikan Bluetooth aktif dan perangkat dalam jangkauan",
            style: GoogleFonts.inter(color: Colors.black54, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildErrorStatus(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), 
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _error!,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _startScan,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Coba Lagi",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildConnectingStatus(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5), 
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF10B981).withOpacity(0.1),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF10B981),
                    ),
                  ),
                ),
                const Icon(
                  Icons.bluetooth_connected,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Menyambungkan...",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Mohon tunggu sebentar",
            style: GoogleFonts.inter(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }
  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bluetooth_disabled_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _isScanning
                ? "..."
                : (_error == null
                      ? "Tidak ada perangkat ditemukan"
                      : "Gagal memuat perangkat"),
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          if (!_isScanning)
            Text(
              "Tekan tombol refresh untuk scan ulang",
              style: GoogleFonts.inter(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
  Widget _buildDeviceList(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "Perangkat Tersedia",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: _discoveredDevices.length,
          itemBuilder: (context, index) {
            final device = _discoveredDevices[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: (_isScanning || _isConnecting)
                      ? null
                      : () => _onDeviceSelected(device),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.bluetooth_rounded,
                            color: Color(0xFF10B981),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device.name ?? "Unknown Device",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                device.address,
                                style: GoogleFonts.inter(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
