class RssGeneratedAhaContent {
  RssGeneratedAhaContent({
    Rss? rss,
    String? omitxmldeclaration,
  }) {
    _rss = rss;
    _omitxmldeclaration = omitxmldeclaration;
  }

  RssGeneratedAhaContent.fromJson(dynamic json) {
    _rss = json['rss'] != null ? Rss.fromJson(json['rss']) : null;
    _omitxmldeclaration = json['#omit-xml-declaration'];
  }

  Rss? _rss;
  String? _omitxmldeclaration;

  Rss? get rss => _rss;

  String? get omitxmldeclaration => _omitxmldeclaration;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_rss != null) {
      map['rss'] = _rss?.toJson();
    }
    map['#omit-xml-declaration'] = _omitxmldeclaration;
    return map;
  }
}

class Rss {
  Rss({
    String? xmlnsa10,
    Channel? channel,
  }) {
    _channel = channel;
  }

  Rss.fromJson(dynamic json) {
    _channel =
        json['channel'] != null ? Channel.fromJson(json['channel']) : null;
  }

  Channel? _channel;

  Channel? get channel => _channel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_channel != null) {
      map['channel'] = _channel?.toJson();
    }
    return map;
  }
}

class Channel {
  Channel({
    String? title,
    String? description,
    String? copyright,
    String? lastBuildDate,
    String? generator,
    Image? image,
    String? a10id,
    List<Item>? item,
  }) {
    _title = title;
    _description = description;
    _copyright = copyright;
    _lastBuildDate = lastBuildDate;
    _generator = generator;
    _image = image;
    _a10id = a10id;
    _item = item;
  }

  Channel.fromJson(dynamic json) {
    _title = json['title'];
    _description = json['description'];
    _copyright = json['copyright'];
    _lastBuildDate = json['lastBuildDate'];
    _generator = json['generator'];
    _image = json['image'] != null ? Image.fromJson(json['image']) : null;
    _a10id = json['a10:id'];
    if (json['item'] != null) {
      _item = [];
      json['item'].forEach((v) {
        _item?.add(Item.fromJson(v));
      });
    }
  }

  String? _title;
  String? _description;
  String? _copyright;
  String? _lastBuildDate;
  String? _generator;
  Image? _image;
  String? _a10id;
  List<Item>? _item;

  String? get title => _title;

  String? get description => _description;

  String? get copyright => _copyright;

  String? get lastBuildDate => _lastBuildDate;

  String? get generator => _generator;

  Image? get image => _image;

  String? get a10id => _a10id;

  List<Item>? get item => _item;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['description'] = _description;
    map['copyright'] = _copyright;
    map['lastBuildDate'] = _lastBuildDate;
    map['generator'] = _generator;
    if (_image != null) {
      map['image'] = _image?.toJson();
    }
    if (_item != null) {
      map['item'] = _item?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Item {
  Item({
    Guid? guid,
    String? link,
    String? title,
    String? description,
    String? a10updated,
  }) {
    _guid = guid;
    _link = link;
    _title = title;
    _description = description;
    _a10updated = a10updated;
  }

  Item.fromJson(dynamic json) {
    _guid = json['guid'] != null ? Guid.fromJson(json['guid']) : null;
    _link = json['link'];
    _title = json['title'];
    _description = json['description'];
    _a10updated = json['a10:updated'];
  }

  Guid? _guid;
  String? _link;
  String? _title;
  String? _description;
  String? _a10updated;

  Guid? get guid => _guid;

  String? get link => _link;

  String? get title => _title;

  String? get description => _description;

  String? get a10updated => _a10updated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_guid != null) {
      map['guid'] = _guid?.toJson();
    }
    map['link'] = _link;
    map['title'] = _title;
    map['description'] = _description;
    map['a10:updated'] = _a10updated;
    return map;
  }
}

/// -isPermaLink : "false"
/// #text : "0D5C128DC3CE42A2B0DB54960DCE6BD7"

class Guid {
  Guid({
    String? isPermaLink,
    String? text,
  }) {
    _isPermaLink = isPermaLink;
    _text = text;
  }

  Guid.fromJson(dynamic json) {
    _isPermaLink = json['-isPermaLink'];
    _text = json['#text'];
  }

  String? _isPermaLink;
  String? _text;

  String? get isPermaLink => _isPermaLink;

  String? get text => _text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['-isPermaLink'] = _isPermaLink;
    map['#text'] = _text;
    return map;
  }
}

class Image {
  Image({
    String? url,
    String? title,
    Link? link,
  }) {
    _url = url;
    _title = title;
    _link = link;
  }

  Image.fromJson(dynamic json) {
    _url = json['url'];
    _title = json['title'];
    _link = json['link'] != null ? Link.fromJson(json['link']) : null;
  }

  String? _url;
  String? _title;
  Link? _link;

  String? get url => _url;

  String? get title => _title;

  Link? get link => _link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = _url;
    map['title'] = _title;
    if (_link != null) {
      map['link'] = _link?.toJson();
    }
    return map;
  }
}

/// -self-closing : "true"

class Link {
  Link({
    String? selfclosing,
  }) {
    _selfclosing = selfclosing;
  }

  Link.fromJson(dynamic json) {
    _selfclosing = json['-self-closing'];
  }

  String? _selfclosing;

  String? get selfclosing => _selfclosing;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['-self-closing'] = _selfclosing;
    return map;
  }
}
