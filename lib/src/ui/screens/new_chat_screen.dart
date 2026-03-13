import 'dart:async';
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
  final _selectedNames = <int, String>{};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
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
            Tab(text: 'Bots'),
          ],
        ),
        actions: [
          if (_loading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: theme.appBarTextColor)),
            )
          else if (_tabs.index != 2)
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
          _DirectTab(
            onSelectUser: (id, name) {
              setState(() {
                _selectedIds.clear();
                _selectedNames.clear();
                _selectedIds.add(id);
                _selectedNames[id] = name;
              });
            },
            selectedId: _selectedIds.isEmpty ? null : _selectedIds.first,
            selectedName: _selectedIds.isEmpty
                ? null
                : _selectedNames[_selectedIds.first],
          ),
          _GroupTab(
            nameCtrl: _nameCtrl,
            selectedIds: _selectedIds,
            selectedNames: _selectedNames,
            onToggleUser: (id, name) {
              setState(() {
                if (_selectedIds.contains(id)) {
                  _selectedIds.remove(id);
                  _selectedNames.remove(id);
                } else {
                  _selectedIds.add(id);
                  _selectedNames[id] = name;
                }
              });
            },
          ),
          _BotTab(onRoomCreated: widget.onRoomCreated),
        ],
      ),
    );
  }
}

// ─── Direct Tab ──────────────────────────────────────────────────────────────

class _DirectTab extends StatefulWidget {
  const _DirectTab({
    required this.onSelectUser,
    this.selectedId,
    this.selectedName,
  });
  final Function(int userId, String name) onSelectUser;
  final int? selectedId;
  final String? selectedName;

  @override
  State<_DirectTab> createState() => _DirectTabState();
}

class _DirectTabState extends State<_DirectTab> {
  final _ctrl = TextEditingController();
  List<ChatUserResult> _results = [];
  bool _searching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    if (q.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _searching = true);
      try {
        final results = await ChatModule.users.searchUsers(q.trim());
        if (mounted) setState(() => _results = results);
      } catch (_) {
      } finally {
        if (mounted) setState(() => _searching = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _ctrl,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Rechercher un contact...',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : null,
            ),
          ),
          if (widget.selectedId != null && widget.selectedName != null) ...[
            const SizedBox(height: 12),
            Chip(
              avatar: CircleAvatar(
                radius: 12,
                backgroundColor: theme.primaryColor.withOpacity(0.2),
                child: Text(
                  widget.selectedName![0].toUpperCase(),
                  style: TextStyle(fontSize: 10, color: theme.primaryColor),
                ),
              ),
              label: Text(widget.selectedName!),
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (_, i) {
                final r = _results[i];
                final isSelected = widget.selectedId == r.id;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        r.photo != null ? NetworkImage(r.photo!) : null,
                    backgroundColor: theme.primaryColor.withOpacity(0.2),
                    child: r.photo == null
                        ? Text((r.name ?? '?')[0].toUpperCase(),
                            style: TextStyle(color: theme.primaryColor))
                        : null,
                  ),
                  title: Text(r.name ?? ''),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: theme.primaryColor)
                      : null,
                  onTap: () => widget.onSelectUser(r.id, r.name ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Group Tab ───────────────────────────────────────────────────────────────

class _GroupTab extends StatelessWidget {
  const _GroupTab({
    required this.nameCtrl,
    required this.selectedIds,
    required this.selectedNames,
    required this.onToggleUser,
  });
  final TextEditingController nameCtrl;
  final List<int> selectedIds;
  final Map<int, String> selectedNames;
  final Function(int userId, String name) onToggleUser;

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
          if (selectedIds.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: selectedIds
                  .map((id) => Chip(
                        label: Text(selectedNames[id] ?? 'User #$id'),
                        onDeleted: () =>
                            onToggleUser(id, selectedNames[id] ?? ''),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: _MemberSearchField(
              selectedIds: selectedIds,
              onToggle: onToggleUser,
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberSearchField extends StatefulWidget {
  const _MemberSearchField({
    required this.selectedIds,
    required this.onToggle,
  });
  final List<int> selectedIds;
  final Function(int userId, String name) onToggle;

  @override
  State<_MemberSearchField> createState() => _MemberSearchFieldState();
}

class _MemberSearchFieldState extends State<_MemberSearchField> {
  final _ctrl = TextEditingController();
  List<ChatUserResult> _results = [];
  bool _searching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    if (q.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _searching = true);
      try {
        final results = await ChatModule.users.searchUsers(q.trim());
        if (mounted) setState(() => _results = results);
      } catch (_) {
      } finally {
        if (mounted) setState(() => _searching = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;
    return Column(
      children: [
        TextField(
          controller: _ctrl,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Rechercher des membres...',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person_search),
            suffixIcon: _searching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: _results.length,
            itemBuilder: (_, i) {
              final r = _results[i];
              final isSelected = widget.selectedIds.contains(r.id);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      r.photo != null ? NetworkImage(r.photo!) : null,
                  backgroundColor: theme.primaryColor.withOpacity(0.2),
                  child: r.photo == null
                      ? Text((r.name ?? '?')[0].toUpperCase(),
                          style: TextStyle(color: theme.primaryColor))
                      : null,
                ),
                title: Text(r.name ?? ''),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: theme.primaryColor)
                    : const Icon(Icons.add_circle_outline),
                onTap: () => widget.onToggle(r.id, r.name ?? ''),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Bot Tab ─────────────────────────────────────────────────────────────────

class _BotTab extends StatefulWidget {
  const _BotTab({required this.onRoomCreated});
  final Function(ChatRoom room) onRoomCreated;

  @override
  State<_BotTab> createState() => _BotTabState();
}

class _BotTabState extends State<_BotTab> {
  List<ChatBot> _bots = [];
  bool _loading = true;
  String? _error;
  int? _starting;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final bots = await ChatModule.api.getBots();
      if (mounted) setState(() {
        _bots = bots.where((b) => b.active).toList();
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _start(ChatBot bot) async {
    if (_starting != null) return;
    setState(() => _starting = bot.id);
    try {
      final room = await ChatModule.api.startBotChat(
          bot.id, ChatModule.currentUserId);
      if (mounted) widget.onRoomCreated(room);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() => _starting = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;

    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    if (_bots.isEmpty) {
      final theme = ChatModule.theme;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy_outlined, size: 56, color: theme.hintColor),
            const SizedBox(height: 12),
            Text('Aucun bot disponible',
                style: TextStyle(color: theme.hintColor)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _bots.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 72),
      itemBuilder: (_, i) {
        final bot = _bots[i];
        final isStarting = _starting == bot.id;
        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: theme.botIndicatorColor.withOpacity(0.15),
            child: isStarting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: theme.botIndicatorColor))
                : Icon(Icons.smart_toy,
                    color: theme.botIndicatorColor, size: 26),
          ),
          title: Text(bot.name,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 15)),
          subtitle: bot.topicDescription != null
              ? Text(bot.topicDescription!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13, color: theme.secondaryTextColor))
              : Text('Assistant IA',
                  style: TextStyle(
                      fontSize: 13, color: theme.secondaryTextColor)),
          trailing: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Démarrer',
                style: TextStyle(
                    color: theme.appBarTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
          onTap: isStarting ? null : () => _start(bot),
        );
      },
    );
  }
}
