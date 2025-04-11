import 'package:flutter/material.dart';
import 'package:band_management_app/sql_helper.dart';
import 'package:band_management_app/widgets/widgets.dart';

class BandMemberEntryScreen extends StatefulWidget {
  final int bandId;
  final int? memberId;

  const BandMemberEntryScreen({
    super.key,
    required this.bandId,
    this.memberId,
  });

  @override
  State<BandMemberEntryScreen> createState() => _BandMemberEntryScreenState();
}

class _BandMemberEntryScreenState extends State<BandMemberEntryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instrumentController = TextEditingController();

  final List<String> _instruments = [
    'Vocal',
    'Guitar',
    'Bass',
    'Keyboard',
    'Drums'
  ];

  int _selectedItem = 0;

  // Get the band member's details
  void _getMember() async {
    final data = await SQLHelper.getMember(widget.memberId!);
    setState(() {
      _nameController.text = data[0]['name'];
      _instrumentController.text = data[0]['instrument'];
      _selectedItem = _instruments.indexWhere((item) => item == data[0]['instrument']);
    });
  }

  // Add band member to the band
  Future<void> _addMember() async {
    await SQLHelper.createMember(
      _nameController.text,
      _instrumentController.text,
      widget.bandId
    );
  }

  // Update band member's information
  Future<void> _updateMember(int? id) async {
    await SQLHelper.updateMember(
      id,
      _nameController.text,
      _instrumentController.text
    );
  }

  @override
  void initState() {
    super.initState();
    _instrumentController.text = _instruments[_selectedItem];

    if (widget.memberId != null) {
      _getMember();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.memberId == null ? 'Add member' : 'Edit member'
        ),
      ),
      bottomNavigationBar: Container(
        height: 128,
        padding: const EdgeInsets.all(32),
        child: ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (widget.memberId != null) {
                await _updateMember(widget.memberId);
              }
              if (widget.memberId == null) {
                await _addMember();
              }
              Future.delayed(Duration.zero).then((value) {
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.memberId != null ? 'Member successfully updated!'
                      : 'Member successfully added!'
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            }
          },
          icon: Icon(
            widget.memberId != null ? Icons.refresh : Icons.add
          ),
          label: Text(
            widget.memberId != null ? 'Update member'
            : 'Add member'
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
                  hint: 'Member name',
                  label: 'Member name',
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
                  labelText: 'Instrument played',
                  items: _instruments,
                  selectedItem: _selectedItem,
                  onChanged: (value) {
                    _instrumentController.text = _instruments[value];
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
