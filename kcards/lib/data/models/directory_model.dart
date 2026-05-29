class DirectoryModel {
  final String id;
  final String name;
  final String? parentId;
  final DateTime createdAt;

  const DirectoryModel({
    required this.id,
    required this.name,
    this.parentId,
    required this.createdAt,
  });
}
