import 'package:flutter/material.dart';
import 'agenda.dart';
import 'agenda_service.dart';

class AgendaForm extends StatefulWidget {
  final Agenda? agenda;
  const AgendaForm({super.key, this.agenda});

  @override
  State<AgendaForm> createState() => _AgendaFormState();
}

class _AgendaFormState extends State<AgendaForm> {
  final _formKey = GlobalKey<FormState>();
  final _judul = TextEditingController();
  final _ket = TextEditingController();
  final _tang = TextEditingController();
  final _service = AgendaService();

  @override
  void initState() {
    super.initState();
    if (widget.agenda != null) {
      _judul.text = widget.agenda!.judul;
      _ket.text = widget.agenda!.keterangan;
      _tang.text = widget.agenda!.tanggal;
    }
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tang.text =
            picked.toIso8601String().split('T')[0]; // Format: yyyy-MM-dd
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final agenda = Agenda(
        id: widget.agenda?.id,
        judul: _judul.text,
        keterangan: _ket.text,
        tanggal: _tang.text,
      );
      try {
        if (widget.agenda == null) {
          await _service.create(agenda);
        } else {
          await _service.update(agenda.id!, agenda);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal simpan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agenda == null ? 'Tambah Agenda' : 'Edit Agenda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judul,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Wajib isi judul' : null,
              ),
              TextFormField(
                controller: _ket,
                decoration: const InputDecoration(labelText: 'Keterangan'),
              ),
              TextFormField(
                controller: _tang,
                decoration: const InputDecoration(
                    labelText: 'Tanggal', hintText: 'YYYY-MM-DD'),
                readOnly: true,
                onTap: _pickDate,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Wajib isi tanggal' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
