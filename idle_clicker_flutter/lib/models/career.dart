import 'package:flutter/material.dart';

class CareerLevel {
  final String id;
  final String title;
  final String emoji;
  final double baseWage; // Per work session
  final double promotionCost; // Cost to reach this level
  final int workSessionsRequired; // Min sessions at previous level

  const CareerLevel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.baseWage,
    required this.promotionCost,
    required this.workSessionsRequired,
  });

  static const List<CareerLevel> allLevels = [
    CareerLevel(
      id: 'unemployed',
      title: 'Unemployed',
      emoji: '😔',
      baseWage: 1.0,
      promotionCost: 0,
      workSessionsRequired: 0,
    ),
    CareerLevel(
      id: 'intern',
      title: 'Intern',
      emoji: '📋',
      baseWage: 2.0,
      promotionCost: 25,
      workSessionsRequired: 5,
    ),
    CareerLevel(
      id: 'entry',
      title: 'Entry Level',
      emoji: '💼',
      baseWage: 3.5,
      promotionCost: 100,
      workSessionsRequired: 15,
    ),
    CareerLevel(
      id: 'associate',
      title: 'Associate',
      emoji: '👔',
      baseWage: 6.0,
      promotionCost: 500,
      workSessionsRequired: 30,
    ),
    CareerLevel(
      id: 'senior',
      title: 'Senior Associate',
      emoji: '📊',
      baseWage: 10.0,
      promotionCost: 2000,
      workSessionsRequired: 60,
    ),
    CareerLevel(
      id: 'manager',
      title: 'Manager',
      emoji: '👨‍💼',
      baseWage: 18.0,
      promotionCost: 8000,
      workSessionsRequired: 100,
    ),
    CareerLevel(
      id: 'director',
      title: 'Director',
      emoji: '🎯',
      baseWage: 35.0,
      promotionCost: 30000,
      workSessionsRequired: 200,
    ),
    CareerLevel(
      id: 'vp',
      title: 'Vice President',
      emoji: '🏆',
      baseWage: 75.0,
      promotionCost: 100000,
      workSessionsRequired: 400,
    ),
    CareerLevel(
      id: 'executive',
      title: 'Executive',
      emoji: '👑',
      baseWage: 150.0,
      promotionCost: 500000,
      workSessionsRequired: 800,
    ),
  ];

  static CareerLevel getLevel(int index) {
    if (index < 0) return allLevels[0];
    if (index >= allLevels.length) return allLevels.last;
    return allLevels[index];
  }

  static CareerLevel? getById(String id) {
    try {
      return allLevels.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }
}
