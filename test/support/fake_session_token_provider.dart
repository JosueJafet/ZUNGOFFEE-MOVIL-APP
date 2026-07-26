import 'package:zungofee_mobile/core/api/session_token_provider.dart';

/// Pasa un token para simular una sesión iniciada, o ninguno (`null` por
/// defecto) para los tests que nunca llegan a inspeccionarlo — mismo
/// fake reutilizado en tests de datasource, de router y en
/// `test/core/api/api_client_test.dart`.
class FakeSessionTokenProvider implements SessionTokenProvider {
  FakeSessionTokenProvider([this.accessToken]);

  @override
  String? accessToken;
}
