// lib/view-models/settings-pets.dart
import 'package:flutter/material.dart';

class PetProfileData {
  final String id;
  final String name;
  final String breed;
  final String gender;
  final String ageText;
  final DateTime dateOfBirth;
  final String weight;
  final String neutered;
  final String color;
  final String microchipId;
  final String imagePath;
  final bool isPrimary;
  final String description;

  const PetProfileData({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.ageText,
    required this.dateOfBirth,
    required this.weight,
    required this.neutered,
    required this.color,
    required this.microchipId,
    required this.imagePath,
    required this.isPrimary,
    required this.description,
  });

  PetProfileData copyWith({
    String? id,
    String? name,
    String? breed,
    String? gender,
    String? ageText,
    DateTime? dateOfBirth,
    String? weight,
    String? neutered,
    String? color,
    String? microchipId,
    String? imagePath,
    bool? isPrimary,
    String? description,
  }) {
    return PetProfileData(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      ageText: ageText ?? this.ageText,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weight: weight ?? this.weight,
      neutered: neutered ?? this.neutered,
      color: color ?? this.color,
      microchipId: microchipId ?? this.microchipId,
      imagePath: imagePath ?? this.imagePath,
      isPrimary: isPrimary ?? this.isPrimary,
      description: description ?? this.description,
    );
  }
}

class PetInformationData {
  final IconData icon;
  final String label;
  final String value;

  const PetInformationData({
    required this.icon,
    required this.label,
    required this.value,
  });
}

String formatPetDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} '
      '${date.day}, ${date.year}';
}

enum PetHealthRecordFilter { all, vaccinations, checkups, medications }

enum PetHealthRecordType { vaccination, checkup, medication, test }

class PetHealthRecordData {
  final String id;
  final PetHealthRecordType type;
  final String typeLabel;
  final String title;
  final String subtitle;
  final String date;
  final String clinic;
  final bool success;

  const PetHealthRecordData({
    required this.id,
    required this.type,
    required this.typeLabel,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.clinic,
    this.success = false,
  });
}

class HealthSummaryData {
  final IconData icon;
  final String count;
  final String title;
  final String status;
  final Color color;
  final Color background;

  const HealthSummaryData({
    required this.icon,
    required this.count,
    required this.title,
    required this.status,
    required this.color,
    required this.background,
  });
}

enum PetAppointmentType { grooming, checkup, vaccination }

class PetAppointmentData {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String location;
  final String address;
  final PetAppointmentType type;
  final String status;

  const PetAppointmentData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.location,
    required this.address,
    required this.type,
    required this.status,
  });
}

class PetAppointmentStyle {
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const PetAppointmentStyle({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}

enum PetReminderFilter { all, dueSoon, upcoming, completed }

enum PetReminderType { vaccination, medication, healthCheck }

enum PetReminderStatus { dueSoon, upcoming, completed }

class PetReminderData {
  final String id;
  final String petName;
  final PetReminderType type;
  final String typeLabel;
  final String title;
  final String dueDate;
  final String repeatText;
  final PetReminderStatus status;
  final String remainingText;

  const PetReminderData({
    required this.id,
    required this.petName,
    required this.type,
    required this.typeLabel,
    required this.title,
    required this.dueDate,
    required this.repeatText,
    required this.status,
    required this.remainingText,
  });

  PetReminderData copyWith({
    String? id,
    String? petName,
    PetReminderType? type,
    String? typeLabel,
    String? title,
    String? dueDate,
    String? repeatText,
    PetReminderStatus? status,
    String? remainingText,
  }) {
    return PetReminderData(
      id: id ?? this.id,
      petName: petName ?? this.petName,
      type: type ?? this.type,
      typeLabel: typeLabel ?? this.typeLabel,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      repeatText: repeatText ?? this.repeatText,
      status: status ?? this.status,
      remainingText: remainingText ?? this.remainingText,
    );
  }
}
