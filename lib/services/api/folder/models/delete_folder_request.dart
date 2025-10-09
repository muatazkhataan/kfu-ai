class DeleteFolderRequest {
  final String folderId;

  const DeleteFolderRequest({required this.folderId});

  Map<String, dynamic> toJson() {
    return {'folderId': folderId};
  }

  bool get isValid => folderId.isNotEmpty;
}
