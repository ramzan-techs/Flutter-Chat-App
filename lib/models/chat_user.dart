class ChatUser {
  ChatUser({
    required this.image,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.id,
    required this.email,
    required this.pushToken,
  });
  late final String image;
  late final String name;
  late final String about;
  late final String createdAt;
  late final String lastActive;
  late final bool isOnline;
  late final String id;
  late final String email;
  late final String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    name = json['name'] ?? "";
    about = json['about'] ?? "";
    createdAt = json['created_at'] ?? "";
    lastActive = json['last_active'] ?? "";
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? "";
    email = json['email'] ?? "";
    pushToken = json['push_token'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['name'] = name;
    _data['about'] = about;
    _data['created_at'] = createdAt;
    _data['last_active'] = lastActive;
    _data['is_online'] = isOnline;
    _data['id'] = id;
    _data['email'] = email;
    _data['push_token'] = pushToken;
    return _data;
  }
}
