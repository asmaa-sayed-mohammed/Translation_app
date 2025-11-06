// Model for API translation response
import 'dart:convert';

TranslationService translationServiceFromJson(String str) =>
    TranslationService.fromJson(json.decode(str));

String translationServiceToJson(TranslationService data) =>
    json.encode(data.toJson());

class TranslationService {
  final ResponseData responseData;
  final bool quotaFinished;
  final dynamic mtLangSupported;
  final String responseDetails;
  final int responseStatus;
  final dynamic responderId;
  final dynamic exceptionCode;
  final List<Match> matches;

  TranslationService({
    required this.responseData,
    required this.quotaFinished,
    required this.mtLangSupported,
    required this.responseDetails,
    required this.responseStatus,
    required this.responderId,
    required this.exceptionCode,
    required this.matches,
  });

  factory TranslationService.fromJson(Map<String, dynamic> json) =>
      TranslationService(
        responseData: ResponseData.fromJson(json["responseData"]),
        quotaFinished: json["quotaFinished"],
        mtLangSupported: json["mtLangSupported"],
        responseDetails: json["responseDetails"],
        responseStatus: json["responseStatus"],
        responderId: json["responderId"],
        exceptionCode: json["exception_code"],
        matches:
        List<Match>.from(json["matches"].map((x) => Match.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "responseData": responseData.toJson(),
    "quotaFinished": quotaFinished,
    "mtLangSupported": mtLangSupported,
    "responseDetails": responseDetails,
    "responseStatus": responseStatus,
    "responderId": responderId,
    "exception_code": exceptionCode,
    "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
  };
}

class Match {
  final String id;
  final String segment;
  final String translation;
  final String source;
  final String target;
  final int quality;
  final dynamic reference;
  final int usageCount;
  final String subject;
  final String createdBy;
  final String lastUpdatedBy;
  final DateTime createDate;
  final DateTime lastUpdateDate;
  final double match;
  final int penalty;

  Match({
    required this.id,
    required this.segment,
    required this.translation,
    required this.source,
    required this.target,
    required this.quality,
    required this.reference,
    required this.usageCount,
    required this.subject,
    required this.createdBy,
    required this.lastUpdatedBy,
    required this.createDate,
    required this.lastUpdateDate,
    required this.match,
    required this.penalty,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    id: json["id"].toString(),
    segment: json["segment"].toString(),
    translation: json["translation"].toString(),
    source: json["source"].toString(),
    target: json["target"].toString(),
    quality: int.tryParse(json["quality"].toString()) ?? 0,
    reference: json["reference"],
    usageCount: int.tryParse(json["usage-count"].toString()) ?? 0,
    subject: json["subject"].toString(),
    createdBy: json["created-by"].toString(),
    lastUpdatedBy: json["last-updated-by"].toString(),
    createDate:
    DateTime.tryParse(json["create-date"].toString()) ?? DateTime.now(),
    lastUpdateDate: DateTime.tryParse(json["last-update-date"].toString()) ??
        DateTime.now(),
    match: double.tryParse(json["match"].toString()) ?? 0.0,
    penalty: int.tryParse(json["penalty"].toString()) ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "segment": segment,
    "translation": translation,
    "source": source,
    "target": target,
    "quality": quality,
    "reference": reference,
    "usage-count": usageCount,
    "subject": subject,
    "created-by": createdBy,
    "last-updated-by": lastUpdatedBy,
    "create-date": createDate.toIso8601String(),
    "last-update-date": lastUpdateDate.toIso8601String(),
    "match": match,
    "penalty": penalty,
  };
}

class ResponseData {
  final String translatedText;
  final double match;

  ResponseData({
    required this.translatedText,
    required this.match,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    translatedText: json["translatedText"],
    match: (json["match"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "translatedText": translatedText,
    "match": match,
  };
}
