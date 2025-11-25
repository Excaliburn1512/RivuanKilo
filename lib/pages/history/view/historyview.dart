import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/core/api/auth_api_client.dart';
import 'package:rivu_v1/core/services/firebase_service.dart';
import 'package:rivu_v1/models/history_model.dart';
import 'package:rivu_v1/widget/togglebar.dart';
import 'package:rivu_v1/widget/filtertab3.dart';
import 'package:rivu_v1/widget/listitem.dart';
import 'package:intl/intl.dart';
final historyLogProvider = FutureProvider.autoDispose<List<HistoryModel>>((
  ref,
) async {
  final systemId = ref.watch(currentSystemIdProvider);
  if (systemId == null) return [];
  return ref.watch(authApiClientProvider).getHistoryLogs(systemId);
});
class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});
  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}
class _HistoryViewState extends ConsumerState<HistoryView> {
  bool _isTanamanView = true;
  int _subFilterIndex = 0;
  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyLogProvider);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(historyLogProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              ToggleBar(
                title: "History",
                isTanamanView: _isTanamanView,
                onTanamanPressed: () => setState(() => _isTanamanView = true),
                onPompaPressed: () => setState(() => _isTanamanView = false),
              ),
              const SizedBox(height: 16),
              SubFilterBar(
                activeIndex: _subFilterIndex,
                onFilterPressed: (index) =>
                    setState(() => _subFilterIndex = index),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isTanamanView
                    ? _buildTanamanList() 
                    : historyAsync.when(
                        data: (logs) => _buildPompaListFromApi(logs),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            Center(child: Text('Error: $err')),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTanamanList() {
    final List<Map<String, String>> tanamanHistory = [
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
    ];
    return ListView.builder(
      key: ValueKey('tanaman_list'), 
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tanamanHistory.length,
      itemBuilder: (context, index) {
        return ListItem(
          title: tanamanHistory[index]['title']!,
          date: "27/10/2025",
          statusText: tanamanHistory[index]['status']!,
          isStatusActive: null,
        );
      },
    );
  }
  Widget _buildPompaListFromApi(List<HistoryModel> logs) {
    if (logs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Belum ada riwayat aktivitas."),
        ),
      );
    }
    return ListView.builder(
      key: const ValueKey('pompa_list_api'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final item = logs[index];
        String formattedDate = item.createdAt;
        try {
          final date = DateTime.parse(item.createdAt).toLocal();
          formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
        } catch (_) {}
        return ListItem(
          title: item.deviceName,
          date: formattedDate,
          statusText: item.status,
          isStatusActive: item.isActive, 
        );
      },
    );
  }
}
