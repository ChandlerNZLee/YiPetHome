// lib/view-models/my-appointments.dart

enum AppointmentStatus { upcoming, completed, cancelled }

enum AppointmentFilter { all, upcoming, completed, cancelled }

class AppointmentListData {
  final String id;
  final String serviceName;
  final DateTime date;
  final String time;
  final String duration;
  final String storeName;
  final String petName;
  final String petImagePath;
  final String? groomerName;
  final String? groomerImagePath;
  final bool isSeniorGroomer;
  final AppointmentStatus status;

  const AppointmentListData({
    required this.id,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.duration,
    required this.storeName,
    required this.petName,
    required this.petImagePath,
    required this.status,
    this.groomerName,
    this.groomerImagePath,
    this.isSeniorGroomer = false,
  });
}
