import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/chat_module.dart';

class PresenceState {
  const PresenceState({required this.online, this.lastSeen});
  final bool online;
  final String? lastSeen;
}

/// Polls presence for a given chatUserId.
class PresenceCubit extends Cubit<PresenceState> {
  PresenceCubit(this._chatUserId)
      : super(const PresenceState(online: false)) {
    _poll();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _poll());
  }

  final int _chatUserId;
  Timer? _timer;

  Future<void> _poll() async {
    try {
      final data = await ChatModule.users.getPresence(_chatUserId);
      emit(PresenceState(
        online: data['online'] == true,
        lastSeen: data['lastSeen'] as String?,
      ));
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
