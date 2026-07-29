import 'dart:io' show Platform;

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// De dónde viene la foto elegida — mapea 1:1 a las dos primeras
/// opciones del selector estilo WhatsApp en `PerfilEditarScreen`.
enum FuenteFoto { camara, galeria }

/// Foto ya leída en memoria, lista para `MultipartFile.fromBytes`.
///
/// Se leen los bytes acá (no se guarda el `XFile`/su `path`) porque en
/// Flutter Web `XFile.path` es un blob URL, no una ruta de archivo real
/// — leer los bytes es lo único que funciona igual en mobile y en web.
class FotoSeleccionada {
  const FotoSeleccionada({required this.bytes, required this.nombreArchivo});

  final List<int> bytes;
  final String nombreArchivo;
}

/// Envuelve `image_picker`/`image_cropper` (paquetes externos) para que
/// el resto de la app dependa de un tipo propio, testeable sin tocar el
/// platform channel real — mismo criterio que `AuthSessionService` para
/// Supabase.
class FotoPickerService {
  FotoPickerService([ImagePicker? picker, ImageCropper? cropper])
    : _picker = picker ?? ImagePicker(),
      _cropper = cropper ?? ImageCropper();

  final ImagePicker _picker;
  final ImageCropper _cropper;

  /// Abre cámara o galería según [fuente] y, si el usuario elige una
  /// imagen, la recorta estilo WhatsApp (círculo fijo, 1:1) antes de
  /// devolverla. `null` si el usuario cancela en cualquiera de los dos
  /// pasos (selección o recorte).
  Future<FotoSeleccionada?> seleccionarYRecortar(FuenteFoto fuente) async {
    final xFile = await _picker.pickImage(
      source: fuente == FuenteFoto.camara
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: 85,
    );
    if (xFile == null) return null;

    // El recorte usa un platform channel nativo sin implementación en
    // Windows Desktop (Android/iOS/Web sí lo soportan) — Windows solo se
    // usa acá para verificaciones visuales manuales durante desarrollo
    // (`docs/PROJECT_STATUS.md`), así que en cualquier plataforma que no
    // sea Android/iOS se sube la imagen elegida tal cual, sin recortar.
    if (!(Platform.isAndroid || Platform.isIOS)) {
      final bytes = await xFile.readAsBytes();
      return FotoSeleccionada(bytes: bytes, nombreArchivo: xFile.name);
    }

    final recortada = await _cropper.cropImage(
      sourcePath: xFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar foto',
          cropStyle: CropStyle.circle,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Recortar foto',
          cropStyle: CropStyle.circle,
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    if (recortada == null) return null;

    final bytes = await recortada.readAsBytes();
    // El recorte siempre comprime a JPG (formato por defecto de
    // `image_cropper`) — el nombre debe reflejar esa extensión real,
    // no la del archivo original, para que
    // `MultipartFile.lookupMediaType` en `subirFoto` infiera el
    // `Content-Type` correcto.
    return FotoSeleccionada(bytes: bytes, nombreArchivo: 'foto_recortada.jpg');
  }
}
