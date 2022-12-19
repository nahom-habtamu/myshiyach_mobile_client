import '../../../domain/enitites/product.dart';

abstract class ReportProductState {}

class ReportPostEmpty extends ReportProductState {}

class ReportPostLoading extends ReportProductState {}

class ReportPostNoNetwork extends ReportProductState {}

class ReportPostSuccessfull extends ReportProductState {
  final Product product;
  ReportPostSuccessfull(this.product);
}

class ReportPostError extends ReportProductState {
  final String message;
  ReportPostError({required this.message});
}
