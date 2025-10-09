class CreateFolderRequest {
  final String name;
  final String icon;

  const CreateFolderRequest({required this.name, required this.icon});

  Map<String, dynamic> toJson() {
    return {'Name': name, 'Icon': icon};
  }

  bool get isValid => name.isNotEmpty;
}
