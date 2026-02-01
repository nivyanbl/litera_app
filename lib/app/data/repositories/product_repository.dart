import 'package:litera/app/data/models/product_model.dart';
import 'package:litera/app/data/providers/product_provider.dart';

class ProductRepository {
  final ProductProvider productProvider;

  ProductRepository({required this.productProvider});

  Future<List<ProductModel>> getProducts({String? search, int? categoryId}) async {
    return await productProvider.getProducts(
      search: search,
      categoryId: categoryId,
    );
  }
  Future<ProductModel> getProductDetail(String idOrSlug) async {
    return await productProvider.getProductDetail(idOrSlug);
  }

}