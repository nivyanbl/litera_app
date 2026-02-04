import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/product_model.dart';

class ProductDetailController extends GetxController {
  final isExpanded = false.obs;

  late final ProductModel product;
  late final String imageUrl;
  late final String descriptionText;

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
  }

  void toggleExpanded() => isExpanded.value = !isExpanded.value;

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
