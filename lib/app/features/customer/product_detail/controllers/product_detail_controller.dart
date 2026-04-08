import 'package:get/get.dart';
import 'package:litera/app/data/repositories/product_repository.dart';
import 'package:litera/app/core/services/download_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/repositories/cart_repository.dart';
import '../../../../data/repositories/book_access_repository.dart';
import '../../../../routes/app_pages.dart';

class ProductDetailController extends GetxController {
  final CartRepository cartRepository;
  final BookAccessRepository bookAccessRepository;

  final ProductRepository productRepository = Get.find<ProductRepository>();
  final downloadService = DownloadService.to;

  ProductDetailController(this.cartRepository, this.bookAccessRepository);

  final isExpanded = false.obs;

  var isOwned = false.obs;
  var isLoadingOwnership = true.obs;
  var isDownloading = false.obs;

  late final ProductModel product;
  late final String imageUrl;
  late final String descriptionText;

  // Reactive getter untuk isDownloaded dari DownloadService
  Rx<bool> get isDownloaded =>
      Rx<bool>(downloadService.isDownloaded(product.id.toString()))
        ..listen((_) => update(['download_status']));

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map?;
    final argProduct = args?['product'];

    if (argProduct is! ProductModel) {
      throw Exception('Product not found');
    }

    product = argProduct;

    final argUrl = args?['imageUrl'] as String?;
    imageUrl = _resolveImageUrl(product.image, argUrl);

    final description = product.description?.trim();
    descriptionText = (description != null && description.isNotEmpty)
        ? description
        : "Deskripsi belum tersedia.";
    _checkOwnershipStatus();
  }

  Future<void> _checkOwnershipStatus() async {
    final token = await SecureStorage.getToken();

    if (token == null || token.isEmpty) {
      isOwned.value = false;
      isLoadingOwnership.value = false;
      return;
    }

    try {
      isOwned.value = await productRepository.checkOwnership(product.id);
      if (isOwned.value) {
        _checkDownloadStatus();
      }
    } catch (e) {
      Get.log("Gagal mengecek kepemilikan: $e");
    } finally {
      isLoadingOwnership.value = false;
    }
  }

  void _checkDownloadStatus() {
    // Status akan diambil dari DownloadService secara otomatis
    // via getter yang reactive
    update(['download_status']);
  }

  void toggleExpanded() => isExpanded.value = !isExpanded.value;

  void goToReadBook() {
    Get.toNamed(
      Routes.bookAccess,
      arguments: {'product_id': product.id, 'title': product.title},
    );
  }

  Future<void> handleBuyNow() async {
    if (!await _ensureLoggedIn()) return;
    await Get.toNamed(
      Routes.checkout,
      arguments: {'source': 'direct', 'product': product},
    );
  }

  Future<void> handleAddToCart() async {
    if (!await _ensureLoggedIn()) return;

    try {
      await cartRepository.addToCart(product.id);
      Get.snackbar(
        'Berhasil',
        'Produk ditambahkan ke keranjang',
        snackPosition: SnackPosition.TOP,
      );
      await Get.toNamed(Routes.cart);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan ke keranjang: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> handleCartIcon() async {
    if (!await _ensureLoggedIn()) return;
    await Get.toNamed(Routes.cart);
  }

  Future<void> handleLoveTap() async {
    if (!await _ensureLoggedIn()) return;
  }

  Future<void> handleDownloadEbook() async {
    isDownloading.value = true;
    try {
      final safeFileName = '${product.title.replaceAll(' ', '_')}.pdf';
      bool success = await bookAccessRepository.downloadPdfToDevice(
        product.id,
        safeFileName,
      );

      if (success) {
        // Gunakan DownloadService untuk sinkronisasi global
        await downloadService.markAsDownloaded(product.id.toString());
        update(['download_status']);
        Get.snackbar(
          'Berhasil',
          'E-book berhasil diunduh',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal mengunduh e-book',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengunduh: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> handleDeleteDownload() async {
    try {
      // Gunakan DownloadService untuk sinkronisasi global
      await downloadService.removeDownload(product.id.toString());
      update(['download_status']);
      Get.snackbar(
        'Berhasil',
        'Unduhan berhasil dihapus',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menghapus: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<bool> _ensureLoggedIn() async {
    final token = await SecureStorage.getToken();
    if (token != null && token.isNotEmpty) return true;

    Get.snackbar(
      "Perlu login",
      "Silakan login atau daftar untuk melanjutkan.",
      snackPosition: SnackPosition.BOTTOM,
    );

    await Get.toNamed(
      Routes.login,
      arguments: {
        'redirect': Routes.productDetail,
        'redirectArgs': Get.arguments,
      },
    );
    return false;
  }

  String _resolveImageUrl(String? image, String? argUrl) {
    if (argUrl != null && argUrl.isNotEmpty) {
      return argUrl;
    }

    if (image == null || image.isEmpty) return '';

    if (image.startsWith('http')) return image;

    final baseUrl = ApiClient.baseUrl.replaceAll('/api', '');
    final cleanImageName = image.replaceAll('public/', '');

    if (cleanImageName.startsWith('storage/')) {
      return "$baseUrl/$cleanImageName";
    }

    return "$baseUrl/storage/$cleanImageName";
  }
}
