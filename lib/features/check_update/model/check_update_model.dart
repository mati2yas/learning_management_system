class AppUpdateStatus {
  String? code;
  LatestVersion? latestVersion;

  AppUpdateStatus({this.code, this.latestVersion});

  AppUpdateStatus.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    latestVersion = json['latest_version'] != null
        ? LatestVersion.fromJson(json['latest_version'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (latestVersion != null) {
      data['latest_version'] = latestVersion!.toJson();
    }
    return data;
  }
}

class LatestVersion {
  String? name;
  String? slug;
  String? description;
  bool? isCritical;

  LatestVersion({this.name, this.slug, this.description, this.isCritical});

  LatestVersion.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    isCritical = json['is_critical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['is_critical'] = isCritical;
    return data;
  }
}
