import 'package:flutter/material.dart';
import 'package:band_management_app/sql_helper.dart';
import 'package:band_management_app/widgets/widgets.dart';
import 'package:band_management_app/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _bands = [];
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _songs = [];

  // Bands: Refresh bands
  void _refreshBands() async {
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
    _refreshBands();
    _getMembers();
    _getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 10),
            Image.asset(
              Theme.of(context).colorScheme.brightness == Brightness.light ?
              'assets/logo/logo.png' : 'assets/logo/logo_dark.png',
              width: 36,
              height: 36,
            ),
            const SizedBox(width: 12),
            const Text('bandmate'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchBandsScreen())
              );
              _refreshBands();
            },
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _bands.isNotEmpty ? ListView.builder(
        itemCount: _bands.length,
        padding: const EdgeInsets.all(8),
        itemBuilder:(context, index) => ListTile(
          visualDensity: const VisualDensity(vertical: -2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BandDetailsScreen(
                id: _bands[index]['id'],
                members: _members.where((element) => element['band_id'] == _bands[index]['id']).toList(),
                songs: _songs.where((element) => element['band_id'] == _bands[index]['id']).toList(),
              )),
            );
            _refreshBands();
            _getMembers();
            _getSongs();
          },
          title: Text(
            _bands[index]['name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(_bands[index]['genre']),
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
        icon: Icons.piano,
        title: 'No bands yet!',
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add band'),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BandEntryScreen()),
          );
          _refreshBands();
          _getMembers();
          _getSongs();
        },
      ),
    );
  }
}
