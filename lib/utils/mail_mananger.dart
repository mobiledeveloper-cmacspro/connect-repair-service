import 'package:flutter_mailer/flutter_mailer.dart';

class MailModel {
  List<String> attachments;
  List<String> recipients;
  String subject;
  String body;

  MailModel(
      {this.attachments = const [],
      this.recipients = const ["connect-app@schueco.com"],
      this.subject,
      this.body});
}

class MailManager {
  static Future<String> sendEmail(MailModel model) async {
    try {
      final attachments =
          model.attachments.where((a) => a?.isNotEmpty == true).toList();
      final MailOptions options = MailOptions(
          recipients: model.recipients,
          body: model.body,
          subject: model.subject,
          isHTML: true,
          attachments: attachments);
      await FlutterMailer.send(options);
      return 'OK';
    } catch (ex) {
      return "Error";
    }
  }
}
