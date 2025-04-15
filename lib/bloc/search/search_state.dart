import 'package:equatable/equatable.dart';
import '../../models/search_result.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchResult result;

  const SearchLoaded(this.result);

  @override
  List<Object> get props => [result];

  // Thêm phương thức kiểm tra xem tất cả các kết quả có rỗng không
  bool get isEmpty =>
      result.songs.isEmpty && result.artists.isEmpty && result.albums.isEmpty;
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
