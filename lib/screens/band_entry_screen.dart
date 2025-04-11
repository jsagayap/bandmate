import 'package:flutter/material.dart';
import 'package:band_management_app/sql_helper.dart';
import 'package:band_management_app/widgets/widgets.dart';

class BandEntryScreen extends StatefulWidget {
  final int? id;

  const BandEntryScreen({
    super.key,
    this.id,
  });

  @override
  State<BandEntryScreen> createState() => _BandEntryScreenState();
}

class _BandEntryScreenState extends State<BandEntryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();

  final List<String> _genres = [
    'Rock',
    'Metal',
    'K-pop',
    'Acoustic',
    'OPM',
    'Hip-hop',
  ];

  int _selectedItem = 0;

  // Get the band member's details
  void _getBand() async {
    final data = await SQLHelper.getBand(widget.id!);
    setState(() {
      _nameController.text = data[0]['name'];
      _genreController.text = data[0]['genre'];
      _selectedItem = _genres.indexWhere((item) => item == data[0]['genre']);
    });
  }

  Future<void> _addBand() async {
    await SQLHelper.createBand(
      _nameController.text,
      _genreController.text
    );
  }

  // Update band member's information
  Future<void> _updateBand() async {
    await SQLHelper.updateBand(
      widget.id,
      _nameController.text,
      _genreController.text
    );
  }

  @override
  void initState() {
    super.initState();
    _genreController.text = _genres[_selectedItem];
  
    if (widget.id != null) {
      _getBand();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id != null ? 'Edit band' : 'Add band'
        ),
      ),
      bottomNavigationBar: Container(
        height: 128,
        padding: const EdgeInsets.all(32),
        child: ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (widget.id != null) {
                await _updateBand();
              }
              if (widget.id == null) {
                await _addBand();
              }
              Future.delayed(Duration.zero).then((value) {
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.id != null ? 'Band successfully updated!'
                      : 'Band successfully added!'
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            }
          },
          icon: Icon(
            widget.id != null ? Icons.refresh : Icons.add
          ),
          label: Text(
            widget.id != null ? 'Update band' : 'Add band'
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
                  hint: 'Band name',
                  label: 'Band name',
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
                BandDropdownField(
                  labelText: 'Genre',
                  items: _genres,
                  selectedItem: _selectedItem,
                  onChanged: (value) {
                    _genreController.text = _genres[value];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}