class AddClubPlayerRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? country;
  String? experienceLevel;
  String? consistency;
  String? dob;
  String? nationality;
  String? roNationality;
  String? position;
  String? roPosition;
  String? height;
  String? weight;
  String? preferredFoot;
  String? roPreferredFoot;
  String? currentClub;
  String? competitionLevel;
  String? roCompetitionLevel;
  String? squadNumber;
  String? contractStart;
  String? contractEnd;
  String? transferStatus;
  String? matchesPlayed;
  String? goals;
  String? assists;
  String? minutes;
  String? callUps;
  String? caps;
  String? passCompletion;
  String? duelsWon;
  String? passAccuracy;
  String? shotsOnTarget;
  String? dribblesCompleted;
  String? privacy;
  String? club;
  String? season;
  String? matches;
  List<String>? youtubeLinks;
  List<Career>? career;
  List<Trophies>? trophies;
  Files? files;
  List<String>? secondaryPosition;
  List<String>? technicalAttributes;
  List<String>? playingStyle;
  String? county;

  AddClubPlayerRequest(
      {this.firstName,
        this.lastName,
        this.email,
        this.countryCode,
        this.country,
        this.experienceLevel,
        this.consistency,
        this.dob,
        this.nationality,
        this.roNationality,
        this.position,
        this.roPosition,
        this.height,
        this.weight,
        this.preferredFoot,
        this.roPreferredFoot,
        this.currentClub,
        this.competitionLevel,
        this.roCompetitionLevel,
        this.squadNumber,
        this.contractStart,
        this.contractEnd,
        this.transferStatus,
        this.matchesPlayed,
        this.goals,
        this.assists,
        this.minutes,
        this.callUps,
        this.caps,
        this.passCompletion,
        this.duelsWon,
        this.passAccuracy,
        this.shotsOnTarget,
        this.dribblesCompleted,
        this.privacy,
        this.club,
        this.season,
        this.matches,
        this.youtubeLinks,
        this.career,
        this.trophies,
        this.files,
        this.secondaryPosition,
        this.technicalAttributes,
        this.playingStyle,
        this.county,

      });

  AddClubPlayerRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    countryCode = json['countryCode'];
    country = json['country'];
    experienceLevel = json['experienceLevel'];
    consistency = json['consistency'];
    dob = json['dob'];
    nationality = json['nationality'];
    roNationality = json['roNationality'];
    position = json['position'];
    roPosition = json['roPosition'];
    height = json['height'];
    weight = json['weight'];
    preferredFoot = json['preferredFoot'];
    roPreferredFoot = json['roPreferredFoot'];
    currentClub = json['currentTeam'];
    competitionLevel = json['competitionLevel'];
    roCompetitionLevel = json['roCompetitionLevel'];
    squadNumber = json['squadNumber'];
    contractStart = json['contractStart'];
    contractEnd = json['contractEnd'];
    transferStatus = json['transferStatus'];
    matchesPlayed = json['matchesPlayed'];
    goals = json['goals'];
    assists = json['assists'];
    minutes = json['minutes'];
    callUps = json['callUps'];
    caps = json['caps'];
    passCompletion = json['passCompletion'];
    duelsWon = json['duelsWon'];
    passAccuracy = json['passAccuracy'];
    shotsOnTarget = json['shotsOnTarget'];
    dribblesCompleted = json['dribblesCompleted'];
    privacy = json['privacy'];
    club = json['club'];
    season = json['season'];
    matches = json['matches'];
    youtubeLinks = json['youtubeLinks'].cast<String>();
    if (json['career'] != null) {
      career = <Career>[];
      json['career'].forEach((v) {
        career!.add(Career.fromJson(v));
      });
    }
    if (json['trophies'] != null) {
      trophies = <Trophies>[];
      json['trophies'].forEach((v) {
        trophies!.add(new Trophies.fromJson(v));
      });
    }
    files = json['files'] != null ? new Files.fromJson(json['files']) : null;
    secondaryPosition = json['secondaryPosition'] != null
        ? List<String>.from(json['secondaryPosition'])
        : null;
    technicalAttributes = json['technicalAttributes'] != null
        ? List<String>.from(json['technicalAttributes'])
        : null;
    playingStyle = json['playingStyle'] != null
        ? List<String>.from(json['playingStyle'])
        : null;
    county = json['county'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['countryCode'] = countryCode;
    data['country'] = country;
    data['experienceLevel'] = experienceLevel;
    data['consistency'] = consistency;
    data['dob'] = dob;
    data['nationality'] = nationality;
    data['roNationality'] = roNationality;
    data['position'] = position;
    data['roPosition'] = roPosition;
    data['height'] = height;
    data['weight'] = weight;
    data['preferredFoot'] = preferredFoot;
    data['roPreferredFoot'] = roPreferredFoot;
    data['currentTeam'] = currentClub;
    data['competitionLevel'] = competitionLevel;
    data['roCompetitionLevel'] = roCompetitionLevel;
    data['squadNumber'] = squadNumber;
    data['contractStart'] = contractStart;
    data['contractEnd'] = contractEnd;
    data['transferStatus'] = transferStatus;
    data['matchesPlayed'] = matchesPlayed;
    data['goals'] = goals;
    data['assists'] = assists;
    data['minutes'] = minutes;
    data['callUps'] = callUps;
    data['caps'] = caps;
    data['passCompletion'] = passCompletion;
    data['duelsWon'] = duelsWon;
    data['passAccuracy'] = passAccuracy;
    data['shotsOnTarget'] = shotsOnTarget;
    data['dribblesCompleted'] = dribblesCompleted;
    data['privacy'] = privacy;
    data['club'] = club;
    data['season'] = season;
    data['matches'] = matches;
    data['youtubeLinks'] = youtubeLinks;
    if (career != null) {
      data['career'] = career!.map((v) => v.toJson()).toList();
    }
    if (trophies != null) {
      data['trophies'] = trophies!.map((v) => v.toJson()).toList();
    }
    if (files != null) {
      data['files'] = files!.toJson();
    }
    data['secondaryPosition'] = this.secondaryPosition;
    data['technicalAttributes'] = this.technicalAttributes;
    data['playingStyle'] = this.playingStyle;
    data['county'] = county;

    return data;
  }
}

class Career {
  String? season;
  String? club;
  String? matches;
  String? goals;
  String? minutes;
  String? assists;

  Career(
      {this.season,
        this.club,
        this.matches,
        this.goals,
        this.minutes,
        this.assists});

  Career.fromJson(Map<String, dynamic> json) {
    season = json['season'];
    club = json['club'];
    matches = json['matches'];
    goals = json['goals'];
    minutes = json['minutes'];
    assists = json['assists'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['season'] = season;
    data['club'] = club;
    data['matches'] = matches;
    data['goals'] = goals;
    data['minutes'] = minutes;
    data['assists'] = assists;
    return data;
  }
}

class Trophies {
  String? name;
  String? year;
  String? icon;

  Trophies({this.name, this.year, this.icon});

  Trophies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    year = json['year'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['year'] = year;
    data['icon'] = icon;
    return data;
  }
}

class Files {
  String? avatar;
  String? cv;
  String? medicalCertificate;

  Files({this.avatar, this.cv, this.medicalCertificate});

  Files.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    cv = json['cv'];
    medicalCertificate = json['medicalCertificate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['cv'] = cv;
    data['medicalCertificate'] = medicalCertificate;
    return data;
  }
}
