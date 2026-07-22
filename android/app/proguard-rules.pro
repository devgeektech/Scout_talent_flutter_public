-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
-dontwarn kotlinx.parcelize.Parceler$DefaultImpls
-dontwarn kotlinx.parcelize.Parceler
-dontwarn kotlinx.parcelize.Parcelize
# Keep Stripe classes
-keep class com.stripe.** { *; }

############################################
## STRIPE PAYMENT SDK
############################################

# Silence Stripe internal reflection warnings
-dontwarn com.stripe.android.pushProvisioning.**

# Keep Stripe SDK (reflection heavy)
-keep class com.stripe.android.** { *; }

# Kotlin parcelize used by Stripe
-dontwarn kotlinx.parcelize.**
-keep class kotlinx.parcelize.** { *; }



############################################
## MEDIA3 EXOPLAYER (DASH + HLS)
############################################

# Core Media3 player
-keep class androidx.media3.common.** { *; }
-keep class androidx.media3.exoplayer.** { *; }

# DASH / HLS manifest parsers use reflection
-keep class androidx.media3.exoplayer.dash.manifest.** { *; }
-keep class androidx.media3.exoplayer.hls.playlist.** { *; }

# XMLPullParser required for DASH
-keep class org.xmlpull.v1.** { *; }
-keep interface org.xmlpull.v1.** { *; }



############################################
## GOOGLE DRM / WIDEVINE (if used)
############################################

-keep class com.google.android.exoplayer2.drm.** { *; }



############################################
## REMOVE R8 WARNING NOISE
############################################

-dontwarn javax.annotation.**
-dontwarn org.jetbrains.annotations.**
