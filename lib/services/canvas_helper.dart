import 'dart:ui';

bool tapWithinOffset(Offset tapOffset, Offset offsetToCheck, double radius) =>
    tapOffset.dx - radius <= offsetToCheck.dx &&
    tapOffset.dx + radius >= offsetToCheck.dx &&
    tapOffset.dy - radius <= offsetToCheck.dy &&
    tapOffset.dy + radius >= offsetToCheck.dy;
