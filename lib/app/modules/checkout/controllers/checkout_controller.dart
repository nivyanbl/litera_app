import 'package:get/get.dart';
import 'package:litera/app/data/repositories/checkout_repository.dart';
import 'package:litera/app/modules/cart/controllers/cart_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutController extends GetxController {
  final CheckoutRepository repository;

  CheckoutController(this.repository);

  final CartController cartC = Get.find<CartController>();
  final RxBool isLoading = false.obs;

  Future<void> prosesCheckout() async {
    // ✅ Validasi minimal 1 item
    if (cartC.selectedCount == 0) {
      Get.snackbar('Peringatan', 'Pilih minimal 1 buku yang ingin dibeli');
      return;
    }

    try {
      isLoading.value = true;

      final result = await repository.postCheckout();

      // ✅ Debug (optional, boleh dihapus nanti)
      print("URL Checkout: ${result.invoiceUrl}");

      final url = Uri.parse(result.invoiceUrl);

      if (result.invoiceUrl.isNotEmpty) {
        try {
          // ✅ Langsung launch tanpa canLaunchUrl
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );

          // ✅ Refresh cart setelah checkout
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