import 'package:flutter/material.dart';
import '../../config/chat_module.dart';
import '../../data/models/models.dart';

/// Group settings screen — manage name, members, roles, leave/delete.
class GroupSettingsScreen extends StatefulWidget {
  const GroupSettingsScreen({
    super.key,
    required this.room,
    this.onRoomDeleted,
    this.onRoomLeft,
  });

  final ChatRoom room;
  final VoidCallback? onRoomDeleted;
  final VoidCallback? onRoomLeft;

  @override
  State<GroupSettingsScreen> createState() => _GroupSettingsScreenState();
}

class _GroupSettingsScreenState extends State<GroupSettingsScreen> {
  late TextEditingController _nameCtrl;
  late ChatRoom _room;
  bool _editingName = false;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _nameCtrl = TextEditingController(text: _room.name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  bool get _isAdmin => _room.participants.any(
        (p) =>
            p.chatUserId == ChatModule.currentUserId &&
            (p.role == 'ADMIN' || p.role == 'CREATOR'),
      );

  Future<void> _saveName() async {
    try {
      await ChatModule.rooms.updateName(_room.id, _nameCtrl.text.trim());
      setState(() {
        _room = _room.copyWith(name: _nameCtrl.text.trim());
        _editingName = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _kickMember(ChatParticipant p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Retirer ${p.username} ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child:
                  const Text('Retirer', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true) {
      await ChatModule.rooms.kickParticipant(_room.id, p.chatUserId);
      setState(() {
        _room = _room.copyWith(
          participants:
              _room.participants.where((x) => x.id != p.id).toList(),
        );
      });
    }
  }

  Future<void> _toggleRole(ChatParticipant p) async {
    final newRole = p.role == 'ADMIN' ? 'MEMBER' : 'ADMIN';
    await ChatModule.rooms.updateRole(_room.id, p.chatUserId, newRole);
    setState(() {
      _room = _room.copyWith(
        participants: _room.participants
            .map((x) => x.id == p.id ? x.copyWith(role: newRole) : x)
            .toList(),
      );
    });
  }

  Future<void> _leave() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quitter le groupe ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Quitter',
                  style: TextStyle(color: Colors.orange))),
        ],
      ),
    );
    if (ok == true) {
      await ChatModule.rooms.leave(_room.id);
      widget.onRoomLeft?.call();
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer le groupe ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true && _room.groupId != null) {
      await ChatModule.rooms.deleteGroup(_room.groupId!);
      widget.onRoomDeleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        iconTheme: IconThemeData(color: theme.appBarTextColor),
        title: Text('Paramètres du groupe',
            style: TextStyle(color: theme.appBarTextColor)),
      ),
      body: ListView(
        children: [
          // Group avatar + name
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.primaryColor.withOpacity(0.2),
                  backgroundImage: _room.avatar != null
                      ? NetworkImage(_room.avatar!)
                      : null,
                  child: _room.avatar == null
                      ? Text(_room.name[0].toUpperCase(),
                          style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold))
                      : null,
                ),
                const SizedBox(height: 16),
                if (_editingName)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameCtrl,
                          autofocus: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                          onPressed: _saveName, icon: const Icon(Icons.check)),
                      IconButton(
                          onPressed: () =>
                              setState(() => _editingName = false),
                          icon: const Icon(Icons.close)),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_room.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      if (_isAdmin)
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () => setState(() => _editingName = true),
                        ),
                    ],
                  ),
                Text('${_room.participants.length} membres',
                    style: TextStyle(color: theme.secondaryTextColor)),
              ],
            ),
          ),
          const Divider(height: 8, color: Color(0xFFF0F0F0)),

          // Members section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text('Membres',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryTextColor,
                    fontSize: 13)),
          ),
          ..._room.participants.map((p) {
            final isMe = p.chatUserId == ChatModule.currentUserId;
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    p.avatar != null ? NetworkImage(p.avatar!) : null,
                child: p.avatar == null
                    ? Text(p.username[0].toUpperCase())
                    : null,
              ),
              title: Text(isMe ? '${p.username} (moi)' : p.username),
              subtitle: Text(p.role.toLowerCase()),
              trailing: (!isMe && _isAdmin)
                  ? PopupMenuButton<String>(
                      onSelected: (action) {
                        if (action == 'role') _toggleRole(p);
                        if (action == 'kick') _kickMember(p);
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'role',
                          child: Text(p.role == 'ADMIN'
                              ? 'Rétrograder membre'
                              : 'Promouvoir admin'),
                        ),
                        const PopupMenuItem(
                          value: 'kick',
                          child: Text('Retirer du groupe',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                  : null,
            );
          }),

          const Divider(height: 8, color: Color(0xFFF0F0F0)),

          // Actions
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.orange),
            title: const Text('Quitter le groupe',
                style: TextStyle(color: Colors.orange)),
            onTap: _leave,
          ),
          if (_isAdmin)
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Supprimer le groupe',
                  style: TextStyle(color: Colors.red)),
              onTap: _delete,
            ),
        ],
      ),
    );
  }
}
