import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class LoadSearch extends SearchEvent {
  final String keyword;

  LoadSearch({required this.keyword});

  @override
  List<Object> get props => [keyword];
}


class LoadSearch2 extends SearchEvent {
  final String keyword;

  LoadSearch2({required this.keyword});

  @override
  List<Object> get props => [keyword];
}
