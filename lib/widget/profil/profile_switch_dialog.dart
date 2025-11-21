
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/auth/model/system_model.dart';
import 'package:rivu_v1/auth/view/pairing_dialog.dart';
import 'package:rivu_v1/auth/view/wifi_dialog.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/core/services/firebase_service.dart';
void showGantiPerangkatDialog(BuildContext context, WidgetRef ref) {
  final authState = ref.watch(authControllerProvider);
  final List<SystemModel> systems = authState.valueOrNull?.systems ?? [];
  final String? currentSystemId = ref.watch(currentSystemIdProvider);
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[50]!],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.devices, size: 32, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Pilih Perangkat',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih perangkat yang ingin Anda gunakan',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: systems.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: systems.length,
                      itemBuilder: (context, index) {
                        final system = systems[index];
                        final bool isCurrent =
                            system.systemId.toString() == currentSystemId;
                        return _buildDeviceTile(
                          context,
                          ref,
                          system,
                          isCurrent,
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            _buildAddDeviceButton(context, ref),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  'Batal',
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget _buildDeviceTile(
  BuildContext context,
  WidgetRef ref,
  SystemModel system,
  bool isCurrent,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: isCurrent
          ? Border.all(color: AppColors.primary, width: 2)
          : Border.all(color: Colors.grey[300]!),
      color: isCurrent ? AppColors.primary.withOpacity(0.05) : Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrent ? AppColors.primary : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.developer_board,
          color: isCurrent ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
      title: Text(
        system.systemName,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: isCurrent ? AppColors.primary : Colors.black87,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          'ID: ${system.systemId.toString().substring(0, 8)}...',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      ),
      trailing: isCurrent
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Aktif',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.check_circle, color: Colors.white, size: 16),
                ],
              ),
            )
          : Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
      onTap: () {
        ref.read(selectedSystemIdProvider.notifier).state = system.systemId
            .toString();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Beralih ke ${system.systemName}'),
              ],
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    ),
  );
}
Widget _buildEmptyState(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        Icon(Icons.device_hub_outlined, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'Belum ada perangkat',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tambahkan perangkat baru untuk memulai',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
Widget _buildAddDeviceButton(BuildContext context, WidgetRef ref) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
      color: AppColors.primary.withOpacity(0.05),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).pop();
          _startAddNewDeviceFlow(context, ref);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "Tambah Perangkat Baru",
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
Future<void> _startAddNewDeviceFlow(BuildContext context, WidgetRef ref) async {
  final deviceIdentifier = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => PairingDialog(),
  );
  if (deviceIdentifier == null || deviceIdentifier.isEmpty) return;
  if (!context.mounted) return;
  final deviceName = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => WifiDialog(),
  );
  if (deviceName == null || deviceName.isEmpty) return;
  if (!context.mounted) return;
  try {
    await ref
        .read(authControllerProvider.notifier)
        .provisionDevice(
          deviceIdentifier: deviceIdentifier,
          deviceName: deviceName,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perangkat "$deviceName" berhasil ditambahkan.'),
        backgroundColor: AppColors.primary,
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal menambahkan perangkat: $e'),
        backgroundColor: AppColors.errortext,
      ),
    );
  }
}
