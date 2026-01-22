import 'dart:async';

import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor_core/model/product_model.dart';
import 'package:sponsor_core/repository/product_repository.dart';

class FossProductRepository extends ProductRepository {
  static final FossProductRepository _singleton =
      FossProductRepository._internal();

  factory FossProductRepository() {
    return _singleton;
  }

  FossProductRepository._internal();

  @override
  bool hasProducts() {
    return false;
  }

  @override
  Future<Result<ProductModel, Exception>> getMonth() {
    return Future.value(Result.error(Exception("Not supported!")));
  }

  @override
  Future<Result<ProductModel, Exception>> getYear() {
    return Future.value(Result.error(Exception("Not supported!")));
  }

  @override
  Stream<Result<bool, Exception>> purchaseMonth() {
    return Stream.value(Result.error(Exception("Not supported!")));
  }

  @override
  Stream<Result<bool, Exception>> purchaseYear() {
    return Stream.value(Result.error(Exception("Not supported!")));
  }
}
