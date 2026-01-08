import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor_core/model/membership_model.dart';
import 'package:sponsor_core/model/product_model.dart';

abstract class ProductRepository {

  Future<Result<ProductModel, Exception>> getYear();

  Future<Result<ProductModel, Exception>> getMonth();

  Stream<Result<bool, Exception>> purchaseYear();

  Stream<Result<bool, Exception>> purchaseMonth();
}
