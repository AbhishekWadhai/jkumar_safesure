import 'dart:convert';

class IncidentReport {
    TypeOfIncident typeOfIncident;
    DetailsOfInjuryPerson detailsOfInjuryPerson;
    UndersignedBy undersignedBy;
    String id;
    String projectName;
    String area;
    String date;
    String time;
    bool nameOfProjectManager;
    bool nameOfWorkAreaStaff;
    int v;

    IncidentReport({
        required this.typeOfIncident,
        required this.detailsOfInjuryPerson,
        required this.undersignedBy,
        required this.id,
        required this.projectName,
        required this.area,
        required this.date,
        required this.time,
        required this.nameOfProjectManager,
        required this.nameOfWorkAreaStaff,
        required this.v,
    });

    factory IncidentReport.fromRawJson(String str) => IncidentReport.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory IncidentReport.fromJson(Map<String, dynamic> json) => IncidentReport(
        typeOfIncident: TypeOfIncident.fromJson(json["typeOfIncident"]),
        detailsOfInjuryPerson: DetailsOfInjuryPerson.fromJson(json["detailsOfInjuryPerson"]),
        undersignedBy: UndersignedBy.fromJson(json["undersignedBy"]),
        id: json["_id"],
        projectName: json["projectName"],
        area: json["area"],
        date: json["date"],
        time: json["time"],
        nameOfProjectManager: json["nameOfProjectManager"],
        nameOfWorkAreaStaff: json["nameOfWorkAreaStaff"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "typeOfIncident": typeOfIncident.toJson(),
        "detailsOfInjuryPerson": detailsOfInjuryPerson.toJson(),
        "undersignedBy": undersignedBy.toJson(),
        "_id": id,
        "projectName": projectName,
        "area": area,
        "date": date,
        "time": time,
        "nameOfProjectManager": nameOfProjectManager,
        "nameOfWorkAreaStaff": nameOfWorkAreaStaff,
        "__v": v,
    };
}

class DetailsOfInjuryPerson {
    String name;
    String trade;
    int age;
    String natureOfInjury;
    String witnessedBy;
    String briefDescriptionOfIncident;
    String photo;
    String immediateActionTaken;
    String rca;
    String correctiveAndPreventiveAction;
    String anyOthers;

    DetailsOfInjuryPerson({
        required this.name,
        required this.trade,
        required this.age,
        required this.natureOfInjury,
        required this.witnessedBy,
        required this.briefDescriptionOfIncident,
        required this.photo,
        required this.immediateActionTaken,
        required this.rca,
        required this.correctiveAndPreventiveAction,
        required this.anyOthers,
    });

    factory DetailsOfInjuryPerson.fromRawJson(String str) => DetailsOfInjuryPerson.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DetailsOfInjuryPerson.fromJson(Map<String, dynamic> json) => DetailsOfInjuryPerson(
        name: json["name"],
        trade: json["trade"],
        age: json["age"],
        natureOfInjury: json["natureOfInjury"],
        witnessedBy: json["witnessedBy"],
        briefDescriptionOfIncident: json["briefDescriptionOfIncident"],
        photo: json["photo"],
        immediateActionTaken: json["immediateActionTaken"],
        rca: json["rca"],
        correctiveAndPreventiveAction: json["correctiveAndPreventiveAction"],
        anyOthers: json["anyOthers"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "trade": trade,
        "age": age,
        "natureOfInjury": natureOfInjury,
        "witnessedBy": witnessedBy,
        "briefDescriptionOfIncident": briefDescriptionOfIncident,
        "photo": photo,
        "immediateActionTaken": immediateActionTaken,
        "rca": rca,
        "correctiveAndPreventiveAction": correctiveAndPreventiveAction,
        "anyOthers": anyOthers,
    };
}

class TypeOfIncident {
    bool firstAid;
    bool nearMiss;
    bool propertyDamage;
    bool snakeBite;
    bool anyOthers;

    TypeOfIncident({
        required this.firstAid,
        required this.nearMiss,
        required this.propertyDamage,
        required this.snakeBite,
        required this.anyOthers,
    });

    factory TypeOfIncident.fromRawJson(String str) => TypeOfIncident.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TypeOfIncident.fromJson(Map<String, dynamic> json) => TypeOfIncident(
        firstAid: json["firstAid"],
        nearMiss: json["nearMiss"],
        propertyDamage: json["propertyDamage"],
        snakeBite: json["snakeBite"],
        anyOthers: json["anyOthers"],
    );

    Map<String, dynamic> toJson() => {
        "firstAid": firstAid,
        "nearMiss": nearMiss,
        "propertyDamage": propertyDamage,
        "snakeBite": snakeBite,
        "anyOthers": anyOthers,
    };
}

class UndersignedBy {
    String siteSupEngineer;
    String safetyOfficer;
    String projectManager;

    UndersignedBy({
        required this.siteSupEngineer,
        required this.safetyOfficer,
        required this.projectManager,
    });

    factory UndersignedBy.fromRawJson(String str) => UndersignedBy.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UndersignedBy.fromJson(Map<String, dynamic> json) => UndersignedBy(
        siteSupEngineer: json["siteSupEngineer"],
        safetyOfficer: json["safetyOfficer"],
        projectManager: json["projectManager"],
    );

    Map<String, dynamic> toJson() => {
        "siteSupEngineer": siteSupEngineer,
        "safetyOfficer": safetyOfficer,
        "projectManager": projectManager,
    };
}
