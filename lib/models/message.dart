class Message {
  Message({
    required this.toId,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromId,
    required this.msg,
  });
  late final String msg;
  late final String toId;
  late final String read;
  late final Type type;
  late final String sent;
  late final String fromId;

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    toId = json['toId'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromId = json['fromId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['toId'] = toId;
    _data['msg'] = msg;
    _data['read'] = read;
    _data['type'] = type.name;
    _data['sent'] = sent;
    _data['fromId'] = fromId;
    return _data;
  }
}

enum Type { image, text }
