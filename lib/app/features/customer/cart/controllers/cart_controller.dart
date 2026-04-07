import 'package:get/get.dart';
import 'package:litera/app/data/models/cart_model.dart';
import 'package:litera/app/data/repositories/cart_repository.dart';

class CartController extends GetxController {
  final CartRepository repository;
  CartController(this.repository);

  final RxList<CartModel> cartList = <CartModel>[].obs;
  final RxBool isLoading = false.obs;

  double get totalPrice {
    return cartList
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + (item.product?.price ?? 0));
  }

  @override
  void onInit() {
    super.onInit();
    fetchCarts();
  }

  Future<void> fetchCarts() async {
    try {
      isLoading.value = true;
      final data = await repository.getCarts();
      cartList.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat keranjang: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelect(int index) {
    cartList[index].isSelected = !cartList[index].isSelected;
    cartList.refresh();
  }

  void toggleSelectAll() {
    final allSelected = cartList.every((item) => item.isSelected);
    for (final item in cartList) {
      item.isSelected = !allSelected;
    }
    cartList.refresh();
  }

  Future<void> removeItem(int cartId) async {
    try {
      await repository.deleteCart(cartId);
      cartList.removeWhere((item) => item.id == cartId);
      Get.snackbar('Berhasil', 'Item dihapus dari keranjang');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus item: $e');
    }
  }

  int get selectedCount => cartList.where((item) => item.isSelected).length;
}