import 'package:flutter_bloc/flutter_bloc.dart';

class pageControllerCubit extends Cubit<int> {
  pageControllerCubit() : super(1);

  void nextPage() {
    int page = state;
    page++;
    emit(page);
  }

  void previousPage() {
    int page = state;
    page--;
    emit(page);
  }

  void resetPage() {
    int page = state;
    page = 1;
    emit(page);
  }
}
