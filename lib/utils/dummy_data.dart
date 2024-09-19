//TODO: convert priority to small letters
DotsModel dotsData = DotsModel();

class DotsModel {
  List<Works> works = [];

  final List<SubWorks> subWorks = [];
}

class Works {
  Works({
    required this.id,
    required this.type,
    required this.progress,
    required this.client,
    required this.taskName,
    required this.assignedBy,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.status,
    required this.attachments,
    required this.comments,
    required this.dependencies,
  });
  late String id;
  late String type;
  late int progress;
  late String client;
  late String company;
  late String createdDate;
  late String taskName;
  late String assignedBy;
  late String startDate;
  late String endDate;
  late String priority;
  late String status;
  late List<Attachments> attachments;
  late String comments;
  late String subWork;
  late String dependencies;

  Works.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    progress = json['progress'];
    client = json['client'];
    company = json['company'];
    taskName = json['taskName'];
    createdDate = json['createdDate'];
    assignedBy = json['assignedBy'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    priority = json['priority'];
    subWork = json['subWork'];
    status = json['status'];
    attachments = List.from(json['attachments'])
        .map((e) => Attachments.fromJson(e))
        .toList();
    comments = json['comments'];

    dependencies = json['dependencies'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['progress'] = progress;
    data['client'] = client;
    data['company'] = company;
    data['subWork'] = subWork;
    data['createdDate'] = createdDate;
    data['taskName'] = taskName;
    data['assignedBy'] = assignedBy;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['priority'] = priority;
    data['status'] = status;
    data['attachments'] = attachments.map((e) => e.toJson()).toList();
    data['comments'] = comments;
    data['dependencies'] = dependencies;
    return data;
  }
}

class Attachments {
  Attachments({
    required this.name,
    required this.path,
  });
  late String name;
  late String path;

  Attachments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['path'] = path;
    return data;
  }
}

class SubWorks {
  SubWorks({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalTime,
    required this.taskName,
    required this.taskDecription,
    required this.status,
    required this.attachments,
    required this.notes,
    required this.id,
    required this.blockersAndChallanges,
  });
  late String date;
  late String startTime;
  late String endTime;
  late double totalTime;
  late String taskName;
  late String id;
  late String taskDecription;
  late String status;
  late List<Attachments> attachments;

  late String notes;
  late String blockersAndChallanges;
  late String submittedBy;

  SubWorks.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    totalTime = json['totalTime'];
    id = json['Id'];
    taskName = json['taskName'];
    taskDecription = json['taskDecription'];
    status = json['status'];
    attachments = List.from(json['attachments'])
        .map((e) => Attachments.fromJson(e))
        .toList();

    notes = json['notes'];
    blockersAndChallanges = json['blockersAndChallanges'];
    submittedBy = json['submittedBy'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['totalTime'] = totalTime;
    data['Id'] = id;
    data['taskName'] = taskName;
    data['taskDecription'] = taskDecription;
    data['status'] = status;
    data['attachments'] = attachments.map((e) => e.toJson()).toList();

    data['notes'] = notes;
    data['blockersAndChallanges'] = blockersAndChallanges;
    data['submittedBy'] = submittedBy;
    return data;
  }
}
