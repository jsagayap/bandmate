import 'package:flutter/material.dart';
import 'package:band_management_app/sql_helper.dart';
import 'package:band_management_app/widgets/widgets.dart';

class SongEntryScreen extends StatefulWidget {
  final int bandId;
  final int? songId;

  const SongEntryScreen({
    super.key,
    required this.bandId,
    this.songId,
  });

  @override
  State<SongEntryScreen> createState() => _SongEntryScreenState();
}

class _SongEntryScreenState extends State<SongEntryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // Get the song's details
  void _getSong() async {
    final data = await SQLHelper.getSong(widget.songId!);
    setState(() {
      _nameController.text = data[0]['name'];
      _yearController.text = data[0]['year'];
    });
  }

  // Add song to the band
  Future<void> _addSong() async {
    await SQLHelper.createSong(
      _nameController.text,
      _yearController.text,
      widget.bandId
    );
  }

  // Update song information
  Future<void> _updateSong(int? id) async {
    await SQLHelper.updateSong(
      id,
      _nameController.text,
      _yearController.text
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.songId != null) {
      _getSong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.songId == null ? 'Add song' : 'Edit song'
        ),
      ),
      bottomNavigationBar: Container(
        height: 128,
        padding: const EdgeInsets.all(32),
        child: ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (widget.songId != null) {
                await _updateSong(widget.songId);
              }
              if (widget.songId == null) {
                await _addSong();
              }
              Future.delayed(Duration.zero).then((value) {
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.songId != null ? 'Song successfully updated!'
                      : 'Song successfully added!'
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            }
          },
          icon: Icon(
            widget.songId != null ? Icons.refresh : Icons.add
          ),
          label: Text(
            widget.songId != null ? 'Update song'
            : 'Add song'
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                BandTextField(
                  hint: 'Song name',
                  label: 'Song name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                BandTextField(
                  hint: 'Release Year',
                  label: 'Release Year',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: _yearController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
