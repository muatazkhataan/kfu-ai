class UpdateFolderRequest {
  final String folderId;
  final String name;

  const UpdateFolderRequest({required this.folderId, required this.name});

  Map<String, dynamic> toJson() {
    return {'folderId': folderId, 'Name': name};
  }

  bool get isValid => folderId.isNotEmpty && name.isNotEmpty;
}
