import 'package:flutter/material.dart';

class SearchResultList<T> extends StatelessWidget {
  final List<T> result;
  final Widget Function(T) itemBuilder;

  const SearchResultList({
    super.key,
    required this.result,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: result.length,
      itemBuilder: (context, index) {
        return itemBuilder(result[index]);
      },
    );
  }
}