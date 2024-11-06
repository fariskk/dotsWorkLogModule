class Attachments {
  Attachments({
    required this.name,
    required this.path,
  });
  late String name;
  late String path;

  Attachments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['path'] = path;
    return data;
  }
}
