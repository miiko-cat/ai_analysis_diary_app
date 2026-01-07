import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final dialogServiceProvider = Provider.autoDispose<DialogService>((ref) {
  final service = DialogService();
  ref.onDispose(service.dispose);
  return service;
});

enum DialogType { signupSuccess, confirmLogout }

class DialogRequest {
  final DialogType type;

  DialogRequest(this.type);
}

class DialogService {
  final _controller = StreamController<DialogRequest>.broadcast();

  Stream<DialogRequest> get stream => _controller.stream;

  void show(DialogRequest request) {
    _controller.add(request);
  }

  void dispose() {
    _controller.close();
  }
}
