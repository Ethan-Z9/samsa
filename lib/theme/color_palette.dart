// theme_palettes.dart
import 'package:flutter/material.dart';

// ========================
// 1. OCEAN THEME
// ========================
class OceanLight {
  static const primary = Color(0xFF1565C0);  // Deep blue
  static const secondary = Color(0xFF039BE5); // Bright blue
  static const accent = Color(0xFF00B4D8);   // Teal accent
  static const background = Color(0xFFE1F5FE); // Light sky
  static const text = Color(0xFF01579B);     // Navy text
  static const card = Color(0xFFB3E5FC);     // Cloud blue
  static const error = Color(0xFFD32F2F);    // Classic red
  // https://coolors.co/01579b-1565c0-039be5-00b4d8-b3e5fc-e1f5fe-d32f2f
}

class OceanDark {
  static const primary = Color(0xFF00B4D8);   // Teal primary
  static const secondary = Color(0xFF039BE5); // Bright blue
  static const accent = Color(0xFF1565C0);    // Deep blue accent
  static const background = Color(0xFF0A1E2E); // Midnight ocean
  static const text = Color(0xFFB3E5FC);      // Cloud blue
  static const card = Color(0xFF01579B);      // Deep water card
  static const error = Color(0xFFFF6659);     // Coral error
  // https://coolors.co/0a1e2e-01579b-1565c0-039be5-00b4d8-b3e5fc-d32f2f
}

// ========================
// 2. FOREST THEME
// ========================
class ForestLight {
  static const primary = Color(0xFF2E7D32);   // Forest green
  static const secondary = Color(0xFF66BB6A); // Leaf green
  static const accent = Color(0xFF43A047);    // Emerald
  static const background = Color(0xFFE8F5E9); // Mist
  static const text = Color(0xFF1B5E20);      // Dark green
  static const error = Color(0xFFC62828);     // Rust red
  static const card = Color(0xFFC8E6C9);      // Young leaf
  // https://coolors.co/1b5e20-2e7d32-43a047-66bb6a-c8e6c9-e8f5e9-c62828
}

class ForestDark {
  static const primary = Color(0xFF66BB6A);   // Leaf green
  static const secondary = Color(0xFF43A047); // Emerald
  static const accent = Color(0xFF2E7D32);    // Forest accent
  static const background = Color(0xFF121F13); // Deep woods
  static const text = Color(0xFFE8F5E9);      // Mist text
  static const error = Color(0xFFEF5350);     // Bright red
  static const card = Color(0xFF1B5E20);      // Canopy shade
}

// ========================
// 3. SUNSET THEME
// ========================
class SunsetLight {
  static const primary = Color(0xFFE65100);   // Burnt orange
  static const secondary = Color(0xFFFF9800); // Golden
  static const accent = Color(0xFFFF6D00);    // Vibrant orange
  static const background = Color(0xFFFFF3E0); // Cream
  static const text = Color(0xFFBF360C);      // Dark clay
  static const error = Color(0xFFD50000);     // Bright red
  static const card = Color(0xFFFFE0B2);      // Peach
}

class SunsetDark {
  static const primary = Color(0xFFFF6D00);   // Vibrant orange
  static const secondary = Color(0xFFFF9800); // Golden
  static const accent = Color(0xFFE65100);    // Burnt accent
  static const background = Color(0xFF1A0D00); // Nightfall
  static const text = Color(0xFFFFF3E0);      // Cream text
  static const error = Color(0xFFFF5252);     // Neon red
  static const card = Color(0xFF402010);      // Dusk shadow
}

// ========================
// 4. JEWEL THEME
// ========================
class JewelLight {
  static const primary = Color(0xFF6A1B9A);         // Royal purple
  static const secondary = Color(0xFF9C27B0);       // Amethyst
  static const accent = Color(0xFFAA00FF);          // Electric purple
  static const background = Color(0xFFF3E5F5);      // Lily
  static const text = Color(0xFF4A148C);            // Deep purple
  static const error = Color(0xFFAD1457);           // Ruby
  static const card = Color(0xFFE1BEE7);            // Lavender
}

class JewelDark {
  static const primary = Color(0xFFAA00FF);         // Electric purple
  static const secondary = Color(0xFF9C27B0);       // Amethyst
  static const accent = Color(0xFF6A1B9A);          // Royal accent
  static const background = Color(0xFF12071A);      // Velvet night
  static const text = Color(0xFFF3E5F5);            // Lily text
  static const error = Color(0xFFFF4081);           // Pink gem
  static const card = Color(0xFF4A148C);            // Crown purple
}

// ========================
// 5. EARTH THEME
// ========================
class EarthLight {
  static const primary = Color(0xFF5D4037);         // Brown
  static const secondary = Color(0xFF8D6E63);       // Clay
  static const accent = Color(0xFFA1887F);          // Sandstone
  static const background = Color(0xFFEFEBE9);      // Sand
  static const text = Color(0xFF3E2723);            // Dark earth
  static const error = Color(0xFFBF360C);           // Terracotta
  static const card = Color(0xFFD7CCC8);            // Pebble
}

class EarthDark {
  static const primary = Color(0xFFA1887F);         // Sandstone
  static const secondary = Color(0xFF8D6E63);       // Clay
  static const accent = Color(0xFF5D4037);          // Brown accent
  static const background = Color(0xFF1A1110);      // Deep soil
  static const text = Color(0xFFEFEBE9);            // Sand text
  static const error = Color(0xFFE64A19);           // Lava
  static const card = Color(0xFF3E2723);            // Dark earth
}

// ========================
// 6. RED ROBOT THEME
// ========================
class RedRobotLight {
  static const primary = Color(0xFFE53935);         // Robot's red armor
  static const secondary = Color(0xFF757575);       // Steel joints
  static const accent = Color(0xFFF44336);          // Power lights
  static const background = Color(0xFFFAFAFA);      // Lab white
  static const text = Color(0xFF212121);            // Dark engraving
  static const error = Color(0xFFFFEB3B);           // Warning Lights
  static const card = Color(0xFFEEEEEE);            // Aluminum panel
}

class RedRobotDark {
  static const primary = Color(0xFFE53935);         // Glowing red armor
  static const secondary = Color(0xFF9E9E9E);       // Brushed metal
  static const accent = Color(0xFFC62828);          // Amber optics
  static const background = Color(0xFF121212);      // Space station
  static const text = Color(0xFFE0E0E0);            // LCD display
  static const error = Color(0xFFFFC107);           // Warning Lights
  static const card = Color(0xFF424242);            // Carbon fiber
}

// ========================
// 7. BLUE ROBOT THEME
// ========================
class BlueRobotLight {
  static const primary = Color(0xFF1E88E5);         // Robot's blue armor
  static const secondary = Color(0xFF757575);       // Steel joints
  static const accent = Color(0xFF00E5FF);          // Power lights
  static const background = Color(0xFFFAFAFA);      // Lab white
  static const text = Color(0xFF212121);            // Dark engraving
  static const error = Color(0xFFFFEB3B);           // Warning Lights
  static const card = Color(0xFFEEEEEE);            // Aluminum panel (unchanged)
}

class BlueRobotDark {
  static const primary = Color(0xFF42A5F5);         // Glowing blue armor
  static const secondary = Color(0xFF9E9E9E);       // Brushed metal
  static const accent = Color(0xFF00B0FF);          // Cyan optics
  static const background = Color(0xFF121212);      // Space station
  static const text = Color(0xFFE0E0E0);            // LCD display
  static const error = Color(0xFFFFC107);           // Warning Lights
  static const card = Color(0xFF424242);            // Carbon fiber
}