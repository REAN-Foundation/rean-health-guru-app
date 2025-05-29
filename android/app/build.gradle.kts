import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // id("com.google.firebase.crashlytics") // Enable if needed
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val flutterProperties = Properties().apply {
    load(rootProject.file("local.properties").inputStream())
}

val versionCodeProp = flutterProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
val versionNameProp = flutterProperties.getProperty("flutter.versionName") ?: "1.0.0"


android {
    compileSdk = flutter.compileSdkVersion
    namespace = "org.reanfoundation.patient"

    defaultConfig {
        applicationId = "org.reanfoundation.patient"
        minSdk = 28
        targetSdk = 35
        versionCode = versionCodeProp
        versionName = versionNameProp
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        multiDexEnabled = true
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
        }
    }

    flavorDimensions += "app"
    productFlavors {
        create("dev") {
            dimension = "app"
            applicationId = "org.reanfoundation.patient.dev"
        }
        create("aha_sac") {
            dimension = "app"
            applicationId = "org.heart.lipidprofile"
        }
        create("aha") {
            dimension = "app"
            applicationId = "org.heart.hfpatient"
        }
        create("aha_uat") {
            dimension = "app"
            applicationId = "org.heart.hfpatient.uat"
        }
        create("uat") {
            dimension = "app"
            applicationId = "org.reanfoundation.patient.uat"
        }
        create("prod") {
            dimension = "app"
            applicationId = "org.reanfoundation.patient"
        }
    }

    signingConfigs {
        create("release") {
            val propsFile = rootProject.file("key.properties")
            if (propsFile.exists()) {
                val props = Properties().apply {
                    load(propsFile.inputStream())
                }
                keyAlias = props.getProperty("keyAlias")
                keyPassword = props.getProperty("keyPassword")
                storeFile = file(props.getProperty("storeFile"))
                storePassword = props.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        getByName("debug") {
            // Use default debug signing config
        }
    }

    lint {
        disable.add("InvalidPackage")
        checkReleaseBuilds = false
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets["main"].java.srcDirs("src/main/kotlin")
}

val kotlinVersion = "1.8.21"

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlinVersion")
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test:runner:1.6.2")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.6.1")
    implementation("com.google.firebase:firebase-messaging:24.1.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}