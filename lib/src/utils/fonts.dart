import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Fonts {
  static final TextTheme textTheme = GoogleFonts.latoTextTheme();

  static final bigTitle = GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static final title = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final regular = GoogleFonts.lato(
    fontWeight: FontWeight.w600,
  );

  static final normal = GoogleFonts.lato(
    fontWeight: FontWeight.w300,
  );
}
