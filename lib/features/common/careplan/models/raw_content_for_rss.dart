class RawContentForRss {
  RawContent({
    String? title,
    String? link,
  }) {
    _title = title;
    _link = link;
  }

  RawContentForRss.fromJson(dynamic json) {
    _title = json['Title'];
    _link = json['Link'];
  }

  String? _title;
  String? _link;

  String? get title => _title;

  String? get link => _link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Title'] = _title;
    map['Link'] = _link;
    return map;
  }
}
