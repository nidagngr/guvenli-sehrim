class RepositoryResponse<T> {
  const RepositoryResponse({
    required this.data,
    required this.fromCache,
    required this.lastUpdated,
  });

  final T data;
  final bool fromCache;
  final DateTime lastUpdated;
}
