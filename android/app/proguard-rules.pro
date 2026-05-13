# ML Kit text recognition — keep all script option classes referenced at runtime
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**

# Flutter / general
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
