import 'package:flutter/material.dart';
import '../../config/chat_module.dart';
import '../../data/models/models.dart';

/// Screen to start a new direct chat or create a group.
class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key, required this.onRoomCreated});
  final Function(ChatRoom room) onRoomCreated;

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  bool _isGroup = false;
  final _nameCtrl = TextEditingController();
  final _selectedIds = <int>[];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() => setState(() => _isGroup = _tabs.index == 1));
  }

  @override
  void dispose() {
    _tabs.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_loading) return;

    if (!_isGroup && _selectedIds.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sélectionnez un contact')));
      return;
    }
    if (_isGroup && _selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sélectionnez au moins un membre')));
      return;
    }
    if (_isGroup && _nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entrez un nom de groupe')));
      return;
    }

    setState(() => _loading = true);
    try {
      ChatRoom room;
      if (_isGroup) {
        room = await ChatModule.rooms.createGroupRoom(
          userId: ChatModule.currentUserId,
          groupName: _nameCtrl.text.trim(),
          participantIds: _selectedIds,
        );
      } else {
        room = await ChatModule.rooms.createDirectRoom(
          ChatModule.currentUserId,
          _selectedIds.first,
        );
      }
      if (mounted) {
        widget.onRoomCreated(room);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        iconTheme: IconThemeData(color: theme.appBarTextColor),
        title: Text('Nouvelle discussion',
            style: TextStyle(color: theme.appBarTextColor)),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: theme.appBarTextColor,
          labelColor: theme.appBarTextColor,
          tabs: const [
            Tab(text: 'Direct'),
            Tab(text: 'Groupe'),
          ],
        ),
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)),
            )
          else
            TextButton(
              onPressed: _create,
              child: Text('Créer',
                  style: TextStyle(
                      color: theme.appBarTextColor,
                      fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          // Direct tab — enter userId manually or pick from list
          _DirectTab(
            onSelectUser: (userId) {
              setState(() {
                _selectedIds.clear();
                _selectedIds.add(userId);
              });
            },
            selectedId: _selectedIds.isEmpty ? null : _selectedIds.first,
          ),
          // Group tab
          _GroupTab(
            nameCtrl: _nameCtrl,
            selectedIds: _selectedIds,
            onToggleUser: (userId) {
              setState(() {
                if (_selectedIds.contains(userId)) {
                  _selectedIds.remove(userId);
                } else {
                  _selectedIds.add(userId);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class _DirectTab extends StatefulWidget {
  const _DirectTab({required this.onSelectUser, this.selectedId});
  final Function(int userId) onSelectUser;
  final int? selectedId;

  @override
  State<_DirectTab> createState() => _DirectTabState();
}

class _DirectTabState extends State<_DirectTab> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Entrez l\'ID utilisateur du contact :',
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'User ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final id = int.tryParse(_ctrl.text.trim());
                  if (id != null) widget.onSelectUser(id);
                },
                child: const Text('Sélect.'),
              ),
            ],
          ),
          if (widget.selectedId != null) ...[
            const SizedBox(height: 16),
            Chip(
              avatar: const Icon(Icons.person, size: 16),
              label: Text('User #${widget.selectedId}'),
            ),
          ],
        ],
      ),
    );
  }
}

class _GroupTab extends StatelessWidget {
  const _GroupTab({
    required this.nameCtrl,
    required this.selectedIds,
    required this.onToggleUser,
  });
  final TextEditingController nameCtrl;
  final List<int> selectedIds;
  final Function(int userId) onToggleUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nom du groupe',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.group),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Membres (entrez les IDs séparés par virgule) :',
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          _AddMemberField(onAdd: onToggleUser),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: selectedIds
                .map((id) => Chip(
                      label: Text('User #$id'),
                      onDeleted: () => onToggleUser(id),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AddMemberField extends StatefulWidget {
  const _AddMemberField({required this.onAdd});
  final Function(int userId) onAdd;

  @override
  State<_AddMemberField> createState() => _AddMemberFieldState();
}

class _AddMemberFieldState extends State<_AddMemberField> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ctrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Ajouter par User ID',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: () {
            final id = int.tryParse(_ctrl.text.trim());
            if (id != null) {
              widget.onAdd(id);
              _ctrl.clear();
            }
          },
        ),
      ],
    );
  }
}
