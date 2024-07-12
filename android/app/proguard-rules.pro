#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class androidx.lifecycle.** { *; }
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**


-keepattributes *Annotation*
-keep public class androidx.health.** {
  public protected private *;
}
-dontwarn androidx.health.**
 #https://github.com/flutter/flutter/issues/58479
 #https://medium.com/@swav.kulinski/flutter-and-android-obfuscation-8768ac544421