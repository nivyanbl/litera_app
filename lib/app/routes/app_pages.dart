import 'package:get/get.dart';
import 'package:litera/app/features/admin/admin_produk/views/product_list_view.dart';

import '../features/admin/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../features/admin/admin_dashboard/views/admin_dashboard_view.dart';
import '../features/customer/book_access/bindings/book_access_binding.dart';
import '../features/customer/book_access/views/book_access_view.dart';
import '../features/customer/cart/bindings/cart_binding.dart';
import '../features/customer/cart/views/cart_view.dart';
import '../features/customer/checkout/bindings/checkout_binding.dart';
import '../features/customer/checkout/views/checkout_view.dart';
import '../features/customer/home/bindings/home_binding.dart';
import '../features/customer/home/views/home_view.dart';
import '../features/customer/order_history/bindings/order_history_binding.dart';
import '../features/customer/order_history/views/order_history_view.dart';
import '../features/customer/product_detail/bindings/product_detail_binding.dart';
import '../features/customer/product_detail/views/product_detail_view.dart';
import '../features/customer/profile/bindings/profile_binding.dart';
import '../features/customer/profile/views/edit_profile_view.dart';
import '../features/customer/profile/views/profile_view.dart';
import '../features/login/bindings/login_binding.dart';
import '../features/login/views/login_view.dart';
import '../features/register/bindings/register_binding.dart';
import '../features/register/views/register_view.dart';
import '../features/admin/admin_produk/bindings/admin_produk_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_HISTORY,
      page: () => const OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_ACCESS,
      page: () => const BookAccessView(),
      binding: BookAccessBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(name: '/edit-profile', page: () => const EditProfileView()),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PRODUK,
      page: () => const ProductListView(),
      binding: AdminProdukBinding(),
    ),
  ];
}
