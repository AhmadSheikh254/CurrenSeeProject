import 'dart:convert';
import 'package:flutter/material.dart';

ImageProvider getUserAvatarProvider(String? photoUrl) {
  const fallback = 'https://api.dicebear.com/7.x/lorelei/png?seed=CurrenSee';
  if (photoUrl == null || photoUrl.isEmpty) {
    return const NetworkImage(fallback);
  }
  if (photoUrl.startsWith('data:image') && photoUrl.contains('base64,')) {
    try {
      final base64Str = photoUrl.split('base64,')[1];
      return MemoryImage(base64Decode(base64Str));
    } catch (e) {
      return const NetworkImage(fallback);
    }
  }
  return NetworkImage(photoUrl);
}
