import 'package:flutter/material.dart';
import 'package:band_management_app/sql_helper.dart';
import 'package:band_management_app/widgets/widgets.dart';
import 'package:band_management_app/screens/screens.dart';
import 'dart:async';

class BandDetailsScreen extends StatefulWidget {
  final int id;
  final List<Map<String, dynamic>> members;
  final List<Map<String, dynamic>> songs;

  const BandDetailsScreen({
    super.key,
    required this.id,
    required this.members,
    required this.songs,
  });

  @override
  State<BandDetailsScreen> createState() => _BandDetailsScreenState();
}

class _BandDetailsScreenState extends State<BandDetailsScreen> {
  String _title = '';
  String _genre = '';

  List<Map<String, dynamic>> _band = [];
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _songs = [];

  bool _membersExpanded = false;

  // Band: Get the band's name
  void _getBand() async {
    final data = await SQLHelper.getBand(widget.id);
    setState(() {
      _band = data;
      _title = _band[0]['name'];
      _genre = _band[0]['genre'];
    });
  }

  // Members: Get the band's members from the given ID
  void _getMembers() async {
    final data = await SQLHelper.getMembers(widget.id);
    setState(() {
      _members = data;
    });
  }

  // Songs: Get the band's songs from the given ID
  void _getSongs() async {
    final data = await SQLHelper.getSongs(widget.id);
    setState(() {
      _songs = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _getBand();
    _members = widget.members;
    _songs = widget.songs;
  }

  // Band: Delete the band
  void _deleteBand() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm deletion',
          ),
          content: const Text(
            'Are you really sure you want to delete this band? All members and songs in this band will also be deleted.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await SQLHelper.deleteBand(widget.id);

                Future.delayed(Duration.zero).then((value) => {
                  Navigator.of(context).pop(),
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Band has been succesfully deleted'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                });
              }
            ),
          ],
        );
      }
    );
  }

  // Members: Delete a member
  void _deleteMember(int id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm deletion',
          ),
          content: const Text('Are you sure you want to delete this member?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await SQLHelper.deleteMember(id);

                Future.delayed(Duration.zero).then((value) => {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Band member has been succesfully deleted'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                  _getMembers(),
                });
              }
            ),
          ],
        );
      }
    );
  }

  // Songs: Delete a song
  void _deleteSong(int id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm deletion',
          ),
          content: const Text('Are you sure you want to delete this song?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await SQLHelper.deleteSong(id);

                Future.delayed(Duration.zero).then((value) => {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Song has been succesfully deleted'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                  _getSongs(),
                });
              }
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          _genre == 'Rock' ? 'assets/genre/rock.jpg'
                          : _genre == 'Metal' ? 'assets/genre/metal.jpg'
                          : _genre == 'K-pop' ? 'assets/genre/kpop.jpg'
                          : _genre == 'Acoustic' ? 'assets/genre/acoustic.jpg'
                          : _genre == 'OPM' ? 'assets/genre/opm.jpg'
                          : _genre == 'Hip-hop' ? 'assets/genre/hiphop.jpg'
                          : 'assets/genre/none.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: const EdgeInsets.only(left: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.background.withOpacity(0.65),
                          Theme.of(context).colorScheme.background,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title,
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                        Text(
                          _genre,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            actions: [
              IconButton(
                onPressed: () async {
                  var reload = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BandEntryScreen(id: widget.id))
                  );
                  if (reload == true) {
                    _getBand();
                  }
                },
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => _deleteBand(),
                icon: const Icon(Icons.delete_outlined),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Members',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          _members.isNotEmpty ? Stack(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: _members.length > 5 ? _membersExpanded ? _members.length : 5 : _members.length,
                                itemBuilder:(context, index) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(vertical: -3),
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                    child: Image.asset(
                                      _members[index]['instrument'] == 'Vocal' ? 'assets/instruments/vocal.png'
                                      : _members[index]['instrument'] == 'Guitar' ? 'assets/instruments/guitar.png'
                                      : _members[index]['instrument'] == 'Bass' ? 'assets/instruments/bass.png'
                                      : _members[index]['instrument'] == 'Keyboard' ? 'assets/instruments/keyboard.png'
                                      : _members[index]['instrument'] == 'Drums' ? 'assets/instruments/drums.png'
                                      : 'assets/instruments/vocal.png',
                                      width: 28,
                                      height: 28,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 48,
                                    child: Row(
                                      children: [
                                        PopupMenuButton(
                                          onSelected: (value) async {
                                            if (value == 0) {
                                              var reload = await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>
                                                  BandMemberEntryScreen(
                                                    bandId: widget.id,
                                                    memberId: _members[index]['id'],
                                                  ),
                                                ),
                                              );
                                              if (reload == true) {
                                                _getMembers();
                                              }
                                            }
                                            else if (value == 1) {
                                              _deleteMember(_members[index]['id']);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Theme.of(context).colorScheme.inverseSurface,
                                          ),
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 0,
                                              child: Text('Edit member'),
                                            ),
                                            const PopupMenuItem(
                                              value: 1,
                                              child: Text('Delete member'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: Text(
                                    _members[index]['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(_members[index]['instrument']),
                                ),
                              ),
                              _members.length > 5 && !_membersExpanded ? Positioned(
                                right: -32,
                                bottom: 0,
                                width: MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _membersExpanded = true;
                                  }),
                                  child: Container(
                                    height: 100,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Theme.of(context).colorScheme.background.withOpacity(0),
                                          Theme.of(context).colorScheme.background,
                                        ],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.expand_more
                                    ),
                                  ),
                                ),
                              ) : Container(),
                            ],
                          ) : const ItemIndicator(
                            icon: Icons.person_outline_outlined,
                            title: 'No members yet!',
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                var reload = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                    BandMemberEntryScreen(
                                      bandId: widget.id,
                                    ),
                                  ),
                                );
                                if (reload == true) {
                                  _getMembers();
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add band member'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Songs',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          _songs.isNotEmpty ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: _songs.length,
                            itemBuilder:(context, index) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(vertical: -3),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.music_note_outlined,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 48,
                                child: Row(
                                  children: [
                                    PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == 0) {
                                          var reload = await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                              SongEntryScreen(
                                                bandId: widget.id,
                                                songId: _songs[index]['id'],
                                              ),
                                            ),
                                          );
                                          if (reload == true) {
                                            _getSongs();
                                          }
                                        }
                                        else if (value == 1) {
                                          _deleteSong(_songs[index]['id']);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Theme.of(context).colorScheme.inverseSurface,
                                      ),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 0,
                                          child: Text('Edit song'),
                                        ),
                                        const PopupMenuItem(
                                          value: 1,
                                          child: Text('Delete song'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              title: Text(
                                _songs[index]['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(_songs[index]['year']),
                            ),
                          ) : const ItemIndicator(
                            icon: Icons.music_note_outlined,
                            title: 'No songs yet!',
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                var reload = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                    SongEntryScreen(
                                      bandId: widget.id
                                    ),
                                  ),
                                );
                                if (reload == true) {
                                  _getSongs();
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add song'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}