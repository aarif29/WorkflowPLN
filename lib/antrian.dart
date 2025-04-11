import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'antrian_provider.dart';

class AntrianScreen extends ConsumerWidget {
  const AntrianScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final antrian = ref.watch(antrianProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrian Permohonan'),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildQueueCard(
                        'Antrian Survey',
                        antrian.surveyQueue,
                        'survey',
                        ref,
                      ),
                      _buildQueueCard(
                        'Antrian RAB',
                        antrian.rabQueue,
                        'rab',
                        ref,
                      ),
                      _buildQueueCard(
                        'Antrian AMS',
                        antrian.amsQueue,
                        'ams',
                        ref,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQueueCard(
    String title,
    List<Map<String, String?>> queue,
    String queueType,
    WidgetRef ref,
  ) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: _getQueueColor(queueType),
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            queue.isEmpty
                ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      'Tidak ada data',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: queue.length,
                  itemBuilder: (context, index) {
                    final permohonan = queue[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _getQueueColor(queueType),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getQueueColor(queueType),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          permohonan['name'] ?? 'No Name',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (permohonan['dateSurvey'] != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 1.0,
                                  bottom: 1.0,
                                ),
                                child: Text(
                                  'Survey: ${DateFormat('d MMMM y', 'id').format(DateTime.parse(permohonan['dateSurvey']!))}',
                                  style: TextStyle(
                                    color: _getQueueColor(queueType),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            if (permohonan['rabCompletionDate'] != null &&
                                queueType == 'ams')
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1.0,
                                ),
                                child: Text(
                                  'Selesai RAB: ${DateFormat('d MMMM y', 'id').format(DateTime.parse(permohonan['rabCompletionDate']!))}',
                                  style: TextStyle(
                                    color: _getQueueColor(queueType),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            if (permohonan['keterangan'] != null &&
                                permohonan['keterangan']?.isNotEmpty == true &&
                                queueType == 'ams')
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 1.0,
                                  bottom: 1.0,
                                ),
                                child: Text(
                                  'Catatan RAB: ${permohonan['keterangan']}',
                                  style: TextStyle(
                                    color: _getQueueColor(queueType),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onTap: () => _showDetailDialog(
                          context,
                          permohonan,
                          index,
                          queueType,
                          ref,
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(
    BuildContext context,
    Map<String, String?> permohonan,
    int index,
    String queueType,
    WidgetRef ref,
  ) {
    DateTime? selectedDate;
    DateTime? selectedRabCompletionDate;
    final _formKey = GlobalKey<FormState>();
    String? name = permohonan['name'];
    String? phone = permohonan['phone'];
    String? address = permohonan['address'];
    String? applicationType = permohonan['applicationType'];
    String? notes = permohonan['notes'];
    String? dateSurvey = permohonan['dateSurvey'];
    String? keterangan = permohonan['keterangan'];
    String? rabCompletionDate = permohonan['rabCompletionDate'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: _getQueueColor(queueType), width: 2.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Permohonan',
                          style: TextStyle(
                            color: _getQueueColor(queueType),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: name,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Nama',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _getQueueColor(queueType),
                              ),
                            ),
                          ),
                          onChanged: (value) => name = value,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Nomor HP',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _getQueueColor(queueType),
                              ),
                            ),
                          ),
                          onChanged: (value) => phone = value,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: address,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Alamat',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _getQueueColor(queueType),
                              ),
                            ),
                          ),
                          onChanged: (value) => address = value,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: applicationType,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Jenis Permohonan',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _getQueueColor(queueType),
                              ),
                            ),
                          ),
                          onChanged: (value) => applicationType = value,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: notes,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Catatan Survey',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _getQueueColor(queueType),
                              ),
                            ),
                          ),
                          onChanged: (value) => notes = value,
                        ),
                        const SizedBox(height: 8),
                        if (queueType == 'survey') ...[
                          ElevatedButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: Colors.blueAccent,
                                        onPrimary: Colors.white,
                                        surface: Colors.black,
                                        onSurface: Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDate = pickedDate;
                                  dateSurvey = pickedDate.toString();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: const Text(
                              'Set Tanggal Survey',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (selectedDate != null)
                            Text(
                              'Tanggal Survey: ${DateFormat('d MMMM y', 'id').format(selectedDate!)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(antrianProvider.notifier)
                                      .updatePermohonan(index, {
                                        'name': name,
                                        'phone': phone,
                                        'address': address,
                                        'applicationType': applicationType,
                                        'notes': notes,
                                        'dateSurvey': dateSurvey,
                                        'keterangan': keterangan,
                                      }, queueType);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(antrianProvider.notifier)
                                      .deleteFromQueue(index, queueType);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          if (dateSurvey != null) ...[
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(antrianProvider.notifier)
                                    .updatePermohonan(index, {
                                      'name': name,
                                      'phone': phone,
                                      'address': address,
                                      'applicationType': applicationType,
                                      'notes': notes,
                                      'dateSurvey': dateSurvey,
                                      'keterangan': keterangan,
                                    }, queueType);
                                ref
                                    .read(antrianProvider.notifier)
                                    .moveToRabQueue(index);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Center(
                                      child: Text(
                                        'Permohonan dipindahkan ke Antrian RAB',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    backgroundColor: Colors.orange,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text(
                                'Selesai Survey',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ],
                        if (queueType == 'rab') ...[
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: keterangan,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Keterangan RAB',
                              labelStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: _getQueueColor(queueType),
                                ),
                              ),
                            ),
                            onChanged: (value) => keterangan = value,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: Colors.orangeAccent,
                                        onPrimary: Colors.white,
                                        surface: Colors.black,
                                        onSurface: Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  selectedRabCompletionDate = pickedDate;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                            ),
                            child: const Text(
                              'Tanggal selesai RAB',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          if (selectedRabCompletionDate != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Tanggal Selesai: ${DateFormat('d MMMM y', 'id').format(selectedRabCompletionDate!)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(antrianProvider.notifier)
                                      .updatePermohonan(index, {
                                        'name': name,
                                        'phone': phone,
                                        'address': address,
                                        'applicationType': applicationType,
                                        'notes': notes,
                                        'dateSurvey': dateSurvey,
                                        'keterangan': keterangan,
                                      }, queueType);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(antrianProvider.notifier)
                                      .deleteFromQueue(index, queueType);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (selectedRabCompletionDate != null)
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(antrianProvider.notifier)
                                    .updatePermohonan(index, {
                                      'name': name,
                                      'phone': phone,
                                      'address': address,
                                      'applicationType': applicationType,
                                      'notes': notes,
                                      'dateSurvey': dateSurvey,
                                      'keterangan': keterangan,
                                      'status': 'completed',
                                      'rabCompletionDate':
                                          selectedRabCompletionDate.toString(),
                                    }, queueType);
                                ref
                                    .read(antrianProvider.notifier)
                                    .moveToAmsQueue(index);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Center(
                                      child: Text(
                                        'Permohonan dipindahkan ke Antrian AMS',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text(
                                'Selesai RAB',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                        if (queueType == 'ams') ...[
                          if (rabCompletionDate != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                border: Border.all(
                                  color: _getQueueColor(queueType),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: _getQueueColor(queueType),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Selesai RAB: ${DateFormat('d MMMM y', 'id').format(DateTime.parse(rabCompletionDate))}',
                                      style: TextStyle(
                                        color: _getQueueColor(queueType),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (keterangan != null &&
                              keterangan?.isNotEmpty == true) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                border: Border.all(
                                  color: _getQueueColor(queueType),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.note_alt,
                                        color: _getQueueColor(queueType),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Catatan RAB:',
                                        style: TextStyle(
                                          color: _getQueueColor(queueType),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    keterangan ?? '',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(antrianProvider.notifier)
                                    .deleteFromQueue(index, queueType);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getQueueColor(String queueType) {
    switch (queueType) {
      case 'survey':
        return Colors.blueAccent;
      case 'rab':
        return Colors.orangeAccent;
      case 'ams':
        return Colors.greenAccent;
      default:
        return Colors.white;
    }
  }
}
