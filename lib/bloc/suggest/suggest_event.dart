import 'package:equatable/equatable.dart';

abstract class SuggestEvent extends Equatable {
  const SuggestEvent();

  @override
  List<Object> get props => [];
}


class LoadSuggestedSongs extends SuggestEvent {
  final List<int> artistIds;
  final List<int> genreIds;

  const LoadSuggestedSongs({
    required this.artistIds,
    required this.genreIds,
  });

  @override
  List<Object> get props => [artistIds, genreIds];
}

