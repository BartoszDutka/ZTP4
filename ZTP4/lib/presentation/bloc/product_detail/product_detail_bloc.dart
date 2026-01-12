import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../domain/models/product.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

/// BLoC do zarządzania szczegółami produktu
/// Obsługuje pobieranie szczegółów pojedynczego produktu
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository repository;

  ProductDetailBloc({required this.repository}) : super(ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
  }

  /// Obsługuje ładowanie szczegółów produktu
  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());

    try {
      final product = await repository.getProductById(event.productId);
      emit(ProductDetailLoaded(product: product));
    } on NotFoundException catch (e) {
      emit(ProductDetailError(message: e.message));
    } on NetworkException catch (e) {
      emit(ProductDetailError(message: e.message));
    } on ServerException catch (e) {
      emit(ProductDetailError(message: e.message));
    } on AppException catch (e) {
      emit(ProductDetailError(message: e.message));
    } catch (e) {
      emit(ProductDetailError(message: 'Wystąpił nieoczekiwany błąd'));
    }
  }
}
