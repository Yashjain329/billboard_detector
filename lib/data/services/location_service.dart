import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  String? _currentAddress;

  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permissions
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permissions
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Get current position
  Future<Position?> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceDisabledException();
      }

      // Check permissions
      LocationPermission permission = await checkLocationPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestLocationPermission();
        if (permission == LocationPermission.denied) {
          throw PermissionDeniedException('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw PermissionDeniedException(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: const Duration(seconds: 15),
      );

      // Get address from coordinates
      if (_currentPosition != null) {
        _currentAddress = await getAddressFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }

      return _currentPosition;
    } catch (e) {
      debugPrint('❌ Error getting current position: $e');
      rethrow;
    }
  }

  /// Get address from coordinates
  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return _formatAddress(place);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting address from coordinates: $e');
      return null;
    }
  }

  /// Format address from placemark
  String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    if (place.name != null && place.name!.isNotEmpty) {
      addressParts.add(place.name!);
    }
    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      addressParts.add(place.postalCode!);
    }

    return addressParts.join(', ');
  }

  /// Calculate distance between two points in meters
  double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}

/// Custom exceptions
class LocationServiceDisabledException implements Exception {
  final String message;
  LocationServiceDisabledException([this.message = 'Location services are disabled']);

  @override
  String toString() => 'LocationServiceDisabledException: $message';
}

class PermissionDeniedException implements Exception {
  final String message;
  PermissionDeniedException([this.message = 'Location permission denied']);

  @override
  String toString() => 'PermissionDeniedException: $message';
}