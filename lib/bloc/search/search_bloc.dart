import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({required this.searchRepository}) : super(SearchInitial()) {
    on<LoadSearch>(_onLoadSearch);
  }

  void _onLoadSearch(LoadSearch event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final result = await searchRepository.search(event.keyword);

      print('Search result: ${result.toString()}'); // Thêm log để kiểm tra dữ liệu trả về

      emit(SearchLoaded(result));
    } catch (e) {
      print('Error occurred: $e'); // In lỗi khi có lỗi xảy ra
      emit(SearchError("Tìm kiếm thất bại"));
    }
  }



}
