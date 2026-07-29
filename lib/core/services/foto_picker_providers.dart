import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'foto_picker_service.dart';

/// Instancia única de [FotoPickerService] para toda la app.
final fotoPickerServiceProvider = Provider<FotoPickerService>((ref) {
  return FotoPickerService();
});
