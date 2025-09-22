# --- Flutter core ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# --- Firebase ---
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- Google Play Services ---
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# --- Play Core (dynamic features / deferred components) ---
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# --- Keep all annotations (safe for Firestore / Gson) ---
-keepattributes *Annotation*

# --- Silence notes ---
-dontnote
