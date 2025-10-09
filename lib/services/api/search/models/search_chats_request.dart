class SearchChatsRequest {
  final String query;

  const SearchChatsRequest({required this.query});

  Map<String, dynamic> toJson() {
    return {'Query': query};
  }

  bool get isValid => query.isNotEmpty && query.trim().isNotEmpty;
}
