import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fcm_service.dart';
import 'local_notifications_service.dart';

/// Instancia única de [FcmService] para toda la app.
final fcmServiceProvider = Provider<FcmService>((ref) => FcmService());

/// Instancia única de [LocalNotificationsService] para toda la app.
final localNotificationsServiceProvider = Provider<LocalNotificationsService>(
  (ref) => LocalNotificationsService(),
);
