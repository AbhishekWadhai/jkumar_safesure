import 'dart:convert';

class SafetyReportModel {
  final String id;
  final Project project;
  final num totalAvgManpower;
  final num totalManHoursWorked;
  final num fatality;
  final num ltiCases;
  final num mtiCases;
  final num fac;
  final num majorEnvironmentalCases;
  final num animalAndInsectBiteCases;
  final num dangerousOccurrences;
  final num nearMissIncidents;
  final num fireCases;
  final num manDaysLost;
  final num fr;
  final num sr;
  final num safeLtiFreeDays;
  final num safeLtiFreeManHours;
  final num ncrPenaltyWarnings;
  final num suggestionsReceived;
  final num uaUcReportedClosed;
  final num tbtMeetingHours;
  final num personsSafetyInducted;
  final num specificSafetyTrainingHours;
  final num totalTrainingHours;
  final num safetyItemsInspections;
  final num safetyCommitteeMeetings;
  final num internalAudits;
  final num externalAudits;
  final num awardsAndAppreciations;
  final num safetyAwardRatingHighest;
  final num safetyAwardRatingLowest;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  SafetyReportModel({
    required this.id,
    required this.project,
    required this.totalAvgManpower,
    required this.totalManHoursWorked,
    required this.fatality,
    required this.ltiCases,
    required this.mtiCases,
    required this.fac,
    required this.majorEnvironmentalCases,
    required this.animalAndInsectBiteCases,
    required this.dangerousOccurrences,
    required this.nearMissIncidents,
    required this.fireCases,
    required this.manDaysLost,
    required this.fr,
    required this.sr,
    required this.safeLtiFreeDays,
    required this.safeLtiFreeManHours,
    required this.ncrPenaltyWarnings,
    required this.suggestionsReceived,
    required this.uaUcReportedClosed,
    required this.tbtMeetingHours,
    required this.personsSafetyInducted,
    required this.specificSafetyTrainingHours,
    required this.totalTrainingHours,
    required this.safetyItemsInspections,
    required this.safetyCommitteeMeetings,
    required this.internalAudits,
    required this.externalAudits,
    required this.awardsAndAppreciations,
    required this.safetyAwardRatingHighest,
    required this.safetyAwardRatingLowest,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SafetyReportModel.fromRawJson(String str) =>
      SafetyReportModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SafetyReportModel.fromJson(Map<String, dynamic> json) {
    try {
      return SafetyReportModel(
        id: json["_id"] as String? ?? '',
        project: Project.fromJson(json["project"] as Map<String, dynamic>? ?? {}),
        totalAvgManpower: json["totalAvgManpower"] as num? ?? 0,
        totalManHoursWorked: json["totalManHoursWorked"] as num? ?? 0,
        fatality: json["fatality"] as num? ?? 0,
        ltiCases: json["ltiCases"] as num? ?? 0,
        mtiCases: json["mtiCases"] as num? ?? 0,
        fac: json["fac"] as num? ?? 0,
        majorEnvironmentalCases: json["majorEnvironmentalCases"] as num? ?? 0,
        animalAndInsectBiteCases: json["animalAndInsectBiteCases"] as num? ?? 0,
        dangerousOccurrences: json["dangerousOccurrences"] as num? ?? 0,
        nearMissIncidents: json["nearMissIncidents"] as num? ?? 0,
        fireCases: json["fireCases"] as num? ?? 0,
        manDaysLost: json["manDaysLost"] as num? ?? 0,
        fr: json["fr"] as num? ?? 0,
        sr: json["sr"] as num? ?? 0,
        safeLtiFreeDays: json["safeLtiFreeDays"] as num? ?? 0,
        safeLtiFreeManHours: json["safeLtiFreeManHours"] as num? ?? 0,
        ncrPenaltyWarnings: json["ncrPenaltyWarnings"] as num? ?? 0,
        suggestionsReceived: json["suggestionsReceived"] as num? ?? 0,
        uaUcReportedClosed: json["uaUcReportedClosed"] as num? ?? 0,
        tbtMeetingHours: json["tbtMeetingHours"] as num? ?? 0,
        personsSafetyInducted: json["personsSafetyInducted"] as num? ?? 0,
        specificSafetyTrainingHours: json["specificSafetyTrainingHours"] as num? ?? 0,
        totalTrainingHours: json["totalTrainingHours"] as num? ?? 0,
        safetyItemsInspections: json["safetyItemsInspections"] as num? ?? 0,
        safetyCommitteeMeetings: json["safetyCommitteeMeetings"] as num? ?? 0,
        internalAudits: json["internalAudits"] as num? ?? 0,
        externalAudits: json["externalAudits"] as num? ?? 0,
        awardsAndAppreciations: json["awardsAndAppreciations"] as num? ?? 0,
        safetyAwardRatingHighest: json["safetyAwardRatingHighest"] as num? ?? 0,
        safetyAwardRatingLowest: json["safetyAwardRatingLowest"] as num? ?? 0,
        createdAt: DateTime.parse(json["createdAt"] as String? ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updatedAt"] as String? ?? DateTime.now().toIso8601String()),
        v: json["__v"] as int? ?? 0,
      );
    } catch (e) {
      throw FormatException('Failed to parse SafetyReportModel: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "project": project.toJson(),
        "totalAvgManpower": totalAvgManpower,
        "totalManHoursWorked": totalManHoursWorked,
        "fatality": fatality,
        "ltiCases": ltiCases,
        "mtiCases": mtiCases,
        "fac": fac,
        "majorEnvironmentalCases": majorEnvironmentalCases,
        "animalAndInsectBiteCases": animalAndInsectBiteCases,
        "dangerousOccurrences": dangerousOccurrences,
        "nearMissIncidents": nearMissIncidents,
        "fireCases": fireCases,
        "manDaysLost": manDaysLost,
        "fr": fr,
        "sr": sr,
        "safeLtiFreeDays": safeLtiFreeDays,
        "safeLtiFreeManHours": safeLtiFreeManHours,
        "ncrPenaltyWarnings": ncrPenaltyWarnings,
        "suggestionsReceived": suggestionsReceived,
        "uaUcReportedClosed": uaUcReportedClosed,
        "tbtMeetingHours": tbtMeetingHours,
        "personsSafetyInducted": personsSafetyInducted,
        "specificSafetyTrainingHours": specificSafetyTrainingHours,
        "totalTrainingHours": totalTrainingHours,
        "safetyItemsInspections": safetyItemsInspections,
        "safetyCommitteeMeetings": safetyCommitteeMeetings,
        "internalAudits": internalAudits,
        "externalAudits": externalAudits,
        "awardsAndAppreciations": awardsAndAppreciations,
        "safetyAwardRatingHighest": safetyAwardRatingHighest,
        "safetyAwardRatingLowest": safetyAwardRatingLowest,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Project {
  final String workpermitAllow;
  final String id;
  final String projectId;
  final String projectName;
  final String siteLocation;
  final String startDate;
  final String endDate;
  final String status;
  final String description;
  final String company;
  final int v;

  Project({
    required this.workpermitAllow,
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.siteLocation,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.description,
    required this.company,
    required this.v,
  });

  factory Project.fromRawJson(String str) => Project.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Project.fromJson(Map<String, dynamic> json) {
    try {
      return Project(
        workpermitAllow: json["workpermitAllow"] as String? ?? '',
        id: json["_id"] as String? ?? '',
        projectId: json["projectId"] as String? ?? '',
        projectName: json["projectName"] as String? ?? '',
        siteLocation: json["siteLocation"] as String? ?? '',
        startDate: json["startDate"] as String? ?? '',
        endDate: json["endDate"] as String? ?? '',
        status: json["status"] as String? ?? '',
        description: json["description"] as String? ?? '',
        company: json["company"] as String? ?? '',
        v: json["__v"] as int? ?? 0,
      );
    } catch (e) {
      throw FormatException('Failed to parse Project: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        "workpermitAllow": workpermitAllow,
        "_id": id,
        "projectId": projectId,
        "projectName": projectName,
        "siteLocation": siteLocation,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "description": description,
        "company": company,
        "__v": v,
      };
}