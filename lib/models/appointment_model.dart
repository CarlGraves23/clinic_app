class AppointmentModel {
  String? id;
  String? patientId;
  String? patientName;
  String? doctorId;
  String? doctorName;
  DateTime? appointmentDate;
  String? timeSlot;
  String? status;
  String? qrCode;
  String? symptoms;
  DateTime? createdAt;
  String? clinicLocation;

  AppointmentModel({
    this.id,
    this.patientId,
    this.patientName,
    this.doctorId,
    this.doctorName,
    this.appointmentDate,
    this.timeSlot,
    this.status,
    this.qrCode,
    this.symptoms,
    this.createdAt,
    this.clinicLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'appointmentDate': appointmentDate,
      'timeSlot': timeSlot,
      'status': status,
      'qrCode': qrCode,
      'symptoms': symptoms,
      'createdAt': createdAt,
      'clinicLocation': clinicLocation,
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      appointmentDate: json['appointmentDate'] != null ? (json['appointmentDate'] as DateTime) : null,
      timeSlot: json['timeSlot'],
      status: json['status'],
      qrCode: json['qrCode'],
      symptoms: json['symptoms'],
      createdAt: json['createdAt'] != null ? (json['createdAt'] as DateTime) : null,
      clinicLocation: json['clinicLocation'],
    );
  }
}