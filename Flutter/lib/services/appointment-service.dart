// lib/services/appointment-service.dart
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api-client.dart';
import '../models/appointment/appointment-response.dart';

class AppointmentService {
  AppointmentService._();

  static final AppointmentService instance = AppointmentService._();

  final ApiClient _api = ApiClient.instance;

  Future<ServiceListResponse> getServiceAndAddonList() async {
    final prefs = await SharedPreferences.getInstance();
    final petId = prefs.getInt('pet_id');

    final result = await _api.get<ServiceListResponse>(
      '/services/pet/$petId',
      parser: (data) {
        return ServiceListResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }

  Future<GroomerListResponse> getGroomerList() async {
    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getInt('shop_id');

    final result = await _api.get<GroomerListResponse>(
      '/groomers/shop/$shopId',
      parser: (data) {
        return GroomerListResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }

  Future<AvailabilityResponse> getAvailability(
    int shopId,
    int groomerId,
    List<int> servicePriceIds,
    String date,
  ) async {
    final result = await _api.get<AvailabilityResponse>(
      '/appointments/availability',
      queryParameters: {
        'shopId': shopId,
        'groomerId': groomerId,
        'servicePriceIds': servicePriceIds.join(','),
        'date': date,
      },
      parser: (data) {
        return AvailabilityResponse.fromJson(data);
      },
    );

    return result;
  }

  Future<AppointmentResponse> createAppointment(
    Map<String, dynamic> appointment,
  ) async {
    final result = await _api.post<AppointmentResponse>(
      '/appointments',
      data: appointment,
      parser: (data) {
        return AppointmentResponse.fromJson(data);
      },
    );

    return result;
  }
}
