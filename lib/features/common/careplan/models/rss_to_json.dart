class Channel {
  Channel({List<Item>? item,}){
    _item = item;
}

  Channel.fromJson(dynamic json) {
    if (json['item'] != null) {
      _item = [];
      json['item'].forEach((v) {
        _item?.add(Item.fromJson(v));
      });
    }
  }

  List<Item>? _item;

  List<Item>? get item => _item;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_item != null) {
      map['item'] = _item?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Item {
  Item({
      String? link, 
      String? title}){
    _link = link;
    _title = title;
}

  Item.fromJson(dynamic json) {
    _link = json['link'];
    _title = json['title'];
  }
  String? _link;
  String? _title;

  String? get link => _link;
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['link'] = _link;
    map['title'] = _title;
    return map;
  }

}