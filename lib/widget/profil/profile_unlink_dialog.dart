
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/auth/model/system_model.dart';
import 'package:rivu_v1/colors.dart';
void showPutuskanPerangkatDialog(BuildContext context, WidgetRef ref) {
  final authState = ref.read(authControllerProvider);
  final List<SystemModel> systems = authState.valueOrNull?.systems ?? [];
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
                color: AppColors.errortext.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.link_off, size: 32, color: AppColors.errortext),
            ),
            const SizedBox(height: 16),
            Text(
              'Putuskan Perangkat',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih perangkat yang ingin Anda putuskan',
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
                        return _buildDeviceTile(context, ref, system);
                      },
                    ),
            ),
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
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey[300]!),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).pop(); 
          _showConfirmUnlinkDialog(context, ref, system);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.errortext.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.developer_board,
                  color: AppColors.errortext,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      system.systemName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${system.systemId.toString().substring(0, 8)}...',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.errortext.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever,
                  color: AppColors.errortext,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
Widget _buildEmptyState(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        Icon(Icons.link_off, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'Tidak Ada Perangkat',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tidak ada perangkat yang dapat diputuskan',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
void _showConfirmUnlinkDialog(
  BuildContext context,
  WidgetRef ref,
  SystemModel system,
) {
  showDialog(
    context: context,
    builder: (confirmContext) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.errortext.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 40,
                color: AppColors.errortext,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Anda Yakin?',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Anda akan memutuskan kaitan dengan "${system.systemName}". Anda harus mendaftarkan ulang perangkat ini jika ingin menghubungkannya kembali.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(confirmContext).pop(),
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
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(confirmContext).pop(); 
                      try {
                        await ref
                            .read(authControllerProvider.notifier)
                            .unlinkDevice(system.systemId.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '"${system.systemName}" berhasil diputuskan.',
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.error, color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(child: Text('Gagal: ${e.toString()}')),
                              ],
                            ),
                            backgroundColor: AppColors.errortext,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errortext,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Putuskan',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
