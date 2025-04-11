import 'package:flutter/material.dart';
import 'package:band_management_app/sql_helper.dart';
import 'package:band_management_app/screens/screens.dart';
import 'package:band_management_app/widgets/widgets.dart';

class SearchBandsScreen extends StatefulWidget {
  const SearchBandsScreen({super.key});

  @override
  State<SearchBandsScreen> createState() => _SearchBandsScreenState();
}

class _SearchBandsScreenState extends State<SearchBandsScreen> {
  List<Map<String, dynamic>> _bands = [];
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _songs = [];
  List _filteredData = [];
  
  bool _showClear = false;

  final _searchBandsController = TextEditingController();

  // Bands: Get bands
  void _getBands() async {
    final data = await SQLHelper.getBands();
    setState(() {
      _bands = data;
    });
  }

  // Members: Get the band's members from the given ID
  void _getMembers() async {
    final data = await SQLHelper.getAllMembers();
    setState(() {
      _members = data;
    });
  }

  // Songs: Get the band's songs from the given ID
  void _getSongs() async {
    final data = await SQLHelper.getAllSongs();
    setState(() {
      _songs = data;
    });
  }
  @override
  void initState() {
    super.initState();
    _getBands();
    _getMembers();
    _getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchBandsController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search bands',
            border: InputBorder.none,
          ),
          onChanged: (value) => {
            setState(() {
              _filteredData = _bands.where((element) => element['name'].toString().toLowerCase().contains(value.toLowerCase())).toList();

              if (_searchBandsController.text.isNotEmpty) {
                _showClear = true;
              }
              else {
                _showClear = false;
              }
            })
          },
        ),
        actions: _showClear ? [
          IconButton(
            onPressed: () {
              _searchBandsController.text = '';
              _filteredData = _bands;
              setState(() {
                _showClear = false;
              });
            },
            icon: const Icon(Icons.clear),
          )
        ] : null,
      ),
      body: _filteredData.isNotEmpty ? ListView.builder(
        itemCount: _filteredData.length,
        padding: const EdgeInsets.all(8),
        itemBuilder:(context, index) => ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BandDetailsScreen(
                id: _filteredData[index]['id'],
                members: _members.where((element) => element['band_id'] == _filteredData[index]['id']).toList(),
                songs: _songs.where((element) => element['band_id'] == _filteredData[index]['id']).toList(),
              )),
            );
            _getBands();
            _getMembers();
            _getSongs();
          },
          title: Text(
            _filteredData[index]['name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(_filteredData[index]['genre']),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            child: Icon(
              Icons.album,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
          ),
        ),
      ) : const ItemIndicator(
        icon: Icons.search,
        title: 'No results',
      ),
    );
  }
}