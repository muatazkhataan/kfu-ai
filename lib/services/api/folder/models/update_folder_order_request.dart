class UpdateFolderOrderRequest {
  final List<String> folderIds;

  const UpdateFolderOrderRequest({required this.folderIds});

  Map<String, dynamic> toJson() {
    return {'FolderIds': folderIds};
  }

  bool get isValid => folderIds.isNotEmpty;
}
