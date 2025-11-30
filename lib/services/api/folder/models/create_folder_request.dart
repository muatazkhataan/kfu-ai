class CreateFolderRequest {
  final String name;
  final String icon;
  final String? color;

  const CreateFolderRequest({
    required this.name,
    required this.icon,
    this.color,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'Name': name,
      'Icon': icon,
    };
    if (color != null) {
      json['Color'] = color;
    }
    return json;
  }

  bool get isValid => name.isNotEmpty;
}
