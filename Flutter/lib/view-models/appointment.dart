// lib/view-models/appointment.dart
import 'package:flutter/material.dart';

import '../models/appointment/appointment-model.dart';
import 'pet.dart';
import 'shop.dart';

class ServiceData {
  final int id;
  final int type;
  final String name;
  final String description;
  final String image;
  final double price;
  final int duration;

  const ServiceData({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.duration,
  });

  factory ServiceData.fromModel(ServiceModel model) {
    return ServiceData(
      id: model.id,
      type: model.type,
      name: model.name,
      description: model.description,
      image: model.image,
      price: model.price,
      duration: model.duration,
    );
  }
}

class GroomingFeature {
  final String label;
  final IconData icon;

  const GroomingFeature({required this.label, required this.icon});
}

class AppointmentServiceColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF687089);
  static const border = Color(0xFFE9EDE8);
}

class AddonColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF344267);
  static const border = Color(0xFFE8ECE8);
}

enum GroomerCategory { senior, standard }

class GroomerData {
  final int id;
  final String name;
  final GroomerCategory category;
  final int experience;
  final int customers;
  final String description;
  final double price;
  final String imagePath;

  const GroomerData({
    required this.id,
    required this.name,
    required this.category,
    required this.experience,
    required this.customers,
    required this.description,
    required this.price,
    required this.imagePath,
  });

  factory GroomerData.fromModel(GroomerModel model) {
    return GroomerData(
      id: model.id,
      name: model.name,
      category: model.type == 0
          ? GroomerCategory.senior
          : GroomerCategory.standard,
      experience: model.experience,
      customers: model.customers,
      description: model.description,
      price: model.price,
      imagePath: model.avatar,
    );
  }
}

class CalendarDayData {
  final DateTime date;
  final bool currentMonth;

  const CalendarDayData({required this.date, required this.currentMonth});
}

class PaymentAppointmentData {
  final PetData pet;
  final ServiceData service;
  final ServiceData? styling;
  final ServiceData? spa;
  final ShopData shop;
  final GroomerData groomer;
  final DateTime date;
  final String time;
  final String notes;
  final List<ServiceData> addons;

  const PaymentAppointmentData({
    required this.pet,
    required this.service,
    this.styling,
    this.spa,
    required this.shop,
    required this.groomer,
    required this.date,
    required this.time,
    required this.notes,
    required this.addons,
  });
}

enum AppointmentStatus { upcoming, completed, cancelled }

extension AppointmentStatusExtension on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class AppointmentAddOnData {
  final String name;
  final double price;

  const AppointmentAddOnData({required this.name, required this.price});
}

class AppointmentDetailData {
  final String id;
  final AppointmentStatus status;
  final String serviceName;
  final String date;
  final String time;
  final String duration;
  final String storeName;
  final String storeAddress;
  final String petName;
  final String petBreed;
  final String petGender;
  final String petAge;
  final String petWeight;
  final String petImagePath;
  final String groomerName;
  final String groomerLevel;
  final String groomerRating;
  final int groomerReviews;
  final String groomerExperience;
  final String groomerImagePath;
  final List<AppointmentAddOnData> addOns;
  final String notes;
  final double servicePrice;

  const AppointmentDetailData({
    required this.id,
    required this.status,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.duration,
    required this.storeName,
    required this.storeAddress,
    required this.petName,
    required this.petBreed,
    required this.petGender,
    required this.petAge,
    required this.petWeight,
    required this.petImagePath,
    required this.groomerName,
    required this.groomerLevel,
    required this.groomerRating,
    required this.groomerReviews,
    required this.groomerExperience,
    required this.groomerImagePath,
    required this.addOns,
    required this.notes,
    required this.servicePrice,
  });

  AppointmentDetailData copyWith({
    String? id,
    AppointmentStatus? status,
    String? serviceName,
    String? date,
    String? time,
    String? duration,
    String? storeName,
    String? storeAddress,
    String? petName,
    String? petBreed,
    String? petGender,
    String? petAge,
    String? petWeight,
    String? petImagePath,
    String? groomerName,
    String? groomerLevel,
    String? groomerRating,
    int? groomerReviews,
    String? groomerExperience,
    String? groomerImagePath,
    List<AppointmentAddOnData>? addOns,
    String? notes,
    double? servicePrice,
  }) {
    return AppointmentDetailData(
      id: id ?? this.id,
      status: status ?? this.status,
      serviceName: serviceName ?? this.serviceName,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      petName: petName ?? this.petName,
      petBreed: petBreed ?? this.petBreed,
      petGender: petGender ?? this.petGender,
      petAge: petAge ?? this.petAge,
      petWeight: petWeight ?? this.petWeight,
      petImagePath: petImagePath ?? this.petImagePath,
      groomerName: groomerName ?? this.groomerName,
      groomerLevel: groomerLevel ?? this.groomerLevel,
      groomerRating: groomerRating ?? this.groomerRating,
      groomerReviews: groomerReviews ?? this.groomerReviews,
      groomerExperience: groomerExperience ?? this.groomerExperience,
      groomerImagePath: groomerImagePath ?? this.groomerImagePath,
      addOns: addOns ?? this.addOns,
      notes: notes ?? this.notes,
      servicePrice: servicePrice ?? this.servicePrice,
    );
  }
}
