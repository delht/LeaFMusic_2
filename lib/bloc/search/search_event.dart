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
