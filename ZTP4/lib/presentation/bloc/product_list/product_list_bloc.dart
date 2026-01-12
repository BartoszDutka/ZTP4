import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../domain/models/product.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

/// BLoC do zarządzania listą produktów
/// Obsługuje ładowanie i odświeżanie listy produktów
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository repository;

  ProductListBloc({required this.repository}) : super(ProductListInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  /// Obsługuje ładowanie produktów
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    await _fetchProducts(emit);
  }

  /// Obsługuje odświeżanie produktów
  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductListState> emit,
  ) async {
    await _fetchProducts(emit);
  }

  /// Pobiera produkty z repozytorium
  Future<void> _fetchProducts(Emitter<ProductListState> emit) async {
    try {
      final products = await repository.getProducts();
      emit(ProductListLoaded(products: products));
    } on NetworkException catch (e) {
      emit(ProductListError(message: e.message));
    } on ServerException catch (e) {
      emit(ProductListError(message: e.message));
    } on AppException catch (e) {
      emit(ProductListError(message: e.message));
    } catch (e) {
      emit(ProductListError(message: 'Wystąpił nieoczekiwany błąd'));
    }
  }
}
