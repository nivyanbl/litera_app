import 'package:get/get.dart';
import 'package:litera/app/data/models/cart_model.dart';
import 'package:litera/app/data/models/product_model.dart';
import 'package:litera/app/data/repositories/checkout_repository.dart';
import 'package:litera/app/modules/cart/controllers/cart_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutController extends GetxController {
  final CheckoutRepository repository;

  CheckoutController(this.repository);

  late final CartController cartC;
  final RxBool isLoading = false.obs;
  final RxList<CartModel> checkoutItems = <CartModel>[].obs;
  final RxString checkoutSource = 'cart'.obs;

  bool get isDirectCheckout => checkoutSource.value == 'direct';

  double get totalPrice => checkoutItems.fold(
    0.0,
    (sum, item) => sum + (item.product?.price ?? 0) * item.quantity,
  );

  @override
  void onInit() {
    super.onInit();
    cartC = Get.find<CartController>();
    _initializeCheckoutItems();
  }

  void _initializeCheckoutItems() {
    final args = Get.arguments;
    final source = args is Map ? (args['source'] as String?) : null;

    if (source == 'direct') {
      final product = args?['product'];
      if (product is ProductModel) {
        checkoutSource.value = 'direct';
        checkoutItems.assignAll([
          CartModel(
            id: null,
            userId: 0,
            productId: product.id,
            quantity: 1,
            product: product,
            isSelected: true,
          ),
        ]);
        return;
      }
    }

    checkoutSource.value = 'cart';
    checkoutItems.assignAll(
      cartC.cartList.where((item) => item.isSelected),
    );
  }

  bool _hasCheckoutItems() => checkoutItems.isNotEmpty;

  Map<String, dynamic>? _buildCheckoutPayload() {
    if (isDirectCheckout) {
      final first = checkoutItems.isEmpty ? null : checkoutItems.first;
      if (first == null) return null;

      return {
        'source': 'direct',
        'product_id': first.productId,
        'quantity': first.quantity,
      };
    }

    final selectedCartIds = checkoutItems
        .map((item) => item.id)
        .whereType<int>()
        .toList();

    if (selectedCartIds.isEmpty) return null;

    return {
      'source': 'cart',
      'cart_ids': selectedCartIds,
    };
  }

  Future<void> prosesCheckout() async {
    if (!_hasCheckoutItems()) {
      Get.snackbar('Peringatan', 'Pilih minimal 1 buku yang ingin dibeli');
      return;
    }

    try {
      isLoading.value = true;
      final payload = _buildCheckoutPayload();

      final result = await repository.postCheckout(data: payload);

      final url = Uri.parse(result.invoiceUrl);

      if (result.invoiceUrl.isNotEmpty) {
        try {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );

          await cartC.fetchCarts();

          Get.snackbar('Sukses', result.message);
        } catch (e) {
          Get.snackbar('Error', 'Tidak dapat membuka link pembayaran');
        }
      } else {
        Get.snackbar('Error', 'URL pembayaran kosong');
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Checkout',
        e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }
}