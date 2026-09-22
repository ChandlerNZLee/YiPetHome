// lib/models/appointment/appointment-response.dart
import 'appointment-model.dart';

class ServiceListResponse {
  final List<ServiceModel> services;
  final List<ServiceModel> premiums;
  final List<ServiceModel> addons;

  const ServiceListResponse({
    required this.services,
    required this.premiums,
    required this.addons,
  });

  factory ServiceListResponse.fromJson(List<dynamic> json) {
    return ServiceListResponse(
      services: json
          .where((item) => (item as Map<String, dynamic>)['type'] == 0)
          .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      premiums: json
          .where(
            (item) =>
                (item as Map<String, dynamic>)['type'] == 1 ||
                item['type'] == 2,
          )
          .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      addons: json
          .where((item) => (item as Map<String, dynamic>)['type'] == 3)
          .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GroomerListResponse {
  final List<GroomerModel> groomers;

  const GroomerListResponse({required this.groomers});

  factory GroomerListResponse.fromJson(List<dynamic> json) {
    return GroomerListResponse(
      groomers: json
          .map((item) => GroomerModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AvailabilityResponse {
  final List<AppointmentSlotModel> slots;

  const AvailabilityResponse({required this.slots});

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponse(
      slots: (json['slots'] as List<dynamic>)
          .map(
            (item) =>
                AppointmentSlotModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class AppointmentResponse {
  final AppointmentModel appointment;

  const AppointmentResponse({required this.appointment});

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(appointment: AppointmentModel.fromJson(json));
  }
}
