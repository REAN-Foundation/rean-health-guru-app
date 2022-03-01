class FAQChatModelPojo {
  String text;
  DateTime timeStamp;
  String sender;
  bool hasAnnounced = false;

  FAQChatModelPojo(this.text, this.timeStamp, this.sender);
}
