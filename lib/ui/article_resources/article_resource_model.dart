enum MediaActions { NEW, RECORDING, RECORDED, PLAYING }

enum MemoType { Note, Audio, Video }

abstract class MemoModel {
  String id;
  double yPos;
  double xPos;
}

class MemoNoteModel extends MemoModel {
  String description;

  MemoNoteModel({
    this.description = "",
  });
}

class MemoAudioModel extends MemoModel {
  String filePath;

  MemoAudioModel({this.filePath = ""});
}

class MemoVideoModel extends MemoModel {
  String filePath;

  MemoVideoModel({this.filePath = ""});
}
