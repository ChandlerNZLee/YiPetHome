// lib/view-models/pet.dart
import 'package:flutter/material.dart';

import 'dart:io';

import '../models/user/pet-model.dart';

enum HealthIndicatorType { line, slider, bar }

class HealthIndicatorData {
  final String title;
  final String value;
  final String status;
  final IconData icon;
  final Color iconColor;
  final Color background;
  final HealthIndicatorType type;

  const HealthIndicatorData({
    required this.title,
    required this.value,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.type,
  });
}

class PetRecordData {
  final String title;
  final String type;
  final String detail;
  final String date;
  final IconData icon;
  final Color color;

  const PetRecordData({
    required this.title,
    required this.type,
    required this.detail,
    required this.date,
    required this.icon,
    required this.color,
  });
}

class PetColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF777B84);
  static const border = Color(0xFFECEFEB);
  static const background = Color(0xFFFCFDFB);
}

class PetData {
  final int id;
  final String name;
  final String gender;
  final String breed;
  final String age;
  final int healthScore;
  final String healthLabel;
  final String imagePath;
  final String healthyDays;
  final double weight;
  final String activity;

  const PetData({
    required this.id,
    required this.name,
    required this.gender,
    required this.breed,
    required this.age,
    required this.healthScore,
    required this.healthLabel,
    required this.imagePath,
    required this.healthyDays,
    required this.weight,
    required this.activity,
  });

  static String calculateAge(String birthday) {
    final birthDate = DateTime.tryParse(birthday);

    if (birthDate == null) {
      return 'Unknown';
    }

    final now = DateTime.now();

    int years = now.year - birthDate.year;

    int months = now.month - birthDate.month;

    if (now.day < birthDate.day) {
      months--;
    }

    if (months < 0) {
      years--;

      months += 12;
    }

    if (years > 0) {
      return '${years}y ${months}m';
    }

    return '${months}m';
  }

  factory PetData.fromModel(PetModel model) {
    return PetData(
      id: model.id,
      name: model.name,
      gender: model.gender == 0 ? 'Male' : 'Female',
      breed: model.category == 0 ? 'Dog' : 'Cat',
      age: calculateAge(model.birthday),
      healthScore: 92,
      healthLabel: 'Good',
      imagePath: model.avatar,
      healthyDays: '8 days',
      weight: model.weight,
      activity: 'Active',
    );
  }
}

enum PetType { dog, cat, others }

extension PetTypeExtension on PetType {
  String get label {
    switch (this) {
      case PetType.dog:
        return 'Dog';
      case PetType.cat:
        return 'Cat';
      case PetType.others:
        return 'Others';
    }
  }

  IconData get icon {
    switch (this) {
      case PetType.dog:
        return Icons.pets_rounded;
      case PetType.cat:
        return Icons.pets_outlined;
      case PetType.others:
        return Icons.cruelty_free_rounded;
    }
  }
}

enum PetGender { male, female }

extension PetGenderExtension on PetGender {
  String get label {
    switch (this) {
      case PetGender.male:
        return 'Male';

      case PetGender.female:
        return 'Female';
    }
  }
}

class PetPersonalityTag {
  final String name;
  final PetTagColor colorType;

  const PetPersonalityTag({required this.name, required this.colorType});
}

enum PetTagColor { green, pink, yellow, purple }

extension PetTagColorExtension on PetTagColor {
  Color get backgroundColor {
    switch (this) {
      case PetTagColor.green:
        return const Color(0xFFEAF7E8);
      case PetTagColor.pink:
        return const Color(0xFFFFEFF2);
      case PetTagColor.yellow:
        return const Color(0xFFFFF7E5);
      case PetTagColor.purple:
        return const Color(0xFFF2EEFA);
    }
  }

  Color get textColor {
    switch (this) {
      case PetTagColor.green:
        return const Color(0xFF239337);
      case PetTagColor.pink:
        return const Color(0xFFC9667E);
      case PetTagColor.yellow:
        return const Color(0xFF9D7A20);
      case PetTagColor.purple:
        return const Color(0xFF7656A6);
    }
  }
}

class AddPetFormData {
  final String name;
  final PetType type;
  final String breed;
  final DateTime dateOfBirth;
  final PetGender gender;
  final double? weight;
  final String notes;
  final File? image;

  const AddPetFormData({
    required this.name,
    required this.type,
    required this.breed,
    required this.dateOfBirth,
    required this.gender,
    this.weight,
    required this.notes,
    this.image,
  });
}

class PetEditData {
  final String id;
  final String name;
  final PetType type;
  final String breed;
  final DateTime dateOfBirth;
  final PetGender gender;
  final double? weight;
  final String? size;
  final String? color;
  final String? neutered;
  final String? microchipId;
  final String? bloodType;
  final String? insurance;
  final String? about;
  final String? notes;
  final String imagePath;
  final File? localImage;

  const PetEditData({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.dateOfBirth,
    required this.gender,
    this.weight,
    this.size,
    this.color,
    this.neutered,
    this.microchipId,
    this.bloodType,
    this.insurance,
    this.about,
    this.notes,
    required this.imagePath,
    this.localImage,
  });

  PetEditData copyWith({
    String? id,
    String? name,
    PetType? type,
    String? breed,
    DateTime? dateOfBirth,
    PetGender? gender,
    double? weight,
    String? size,
    String? color,
    String? neutered,
    String? microchipId,
    String? bloodType,
    String? insurance,
    String? about,
    String? notes,
    String? imagePath,
    File? localImage,
  }) {
    return PetEditData(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      size: size ?? this.size,
      color: color ?? this.color,
      neutered: neutered ?? this.neutered,
      microchipId: microchipId ?? this.microchipId,
      bloodType: bloodType ?? this.bloodType,
      insurance: insurance ?? this.insurance,
      about: about ?? this.about,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      localImage: localImage ?? this.localImage,
    );
  }
}

enum EditPetResultType { updated, deleted }

class EditPetResult {
  final EditPetResultType type;

  final PetEditData? pet;
  final String? deletedPetId;

  const EditPetResult._({required this.type, this.pet, this.deletedPetId});

  factory EditPetResult.updated(PetEditData pet) {
    return EditPetResult._(type: EditPetResultType.updated, pet: pet);
  }

  factory EditPetResult.deleted(String petId) {
    return EditPetResult._(
      type: EditPetResultType.deleted,
      deletedPetId: petId,
    );
  }
}
