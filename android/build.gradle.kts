// 1. Plugin versions aligned with stable releases:
//    – Android Gradle Plugin 8.8.0 (Jan 2025) :contentReference[oaicite:0]{index=0}
//    – Google Services Gradle plugin 4.4.2 (May 2024) :contentReference[oaicite:1]{index=1}
plugins {
    id("com.android.application") version "8.7.0" apply false
    //id("com.android.library") version "8.7.0" apply false
    //id("kotlin-android") version "1.8.21" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 2. Move your build outputs out of the Android subfolder, unchanged
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val subprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(subprojectBuildDir)
    project.evaluationDependsOn(":app")
    /*plugins.withType<com.android.build.gradle.BasePlugin> {
        extensions.configure<com.android.build.gradle.BaseExtension> {
            compileSdkVersion(35)
        }
    }*/
    /*plugins.withId("com.android.application") {
        extensions.configure<com.android.build.gradle.AppExtension> {
            compileSdkVersion(35)
            defaultConfig {
                minSdk = 21
                targetSdk = 35
            }
        }
    }
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension> {
            compileSdkVersion(35)
            defaultConfig {
                minSdk = 21
                targetSdk = 35
            }
        }
    }*/
}

gradle.beforeProject {
    plugins.whenPluginAdded {
        if (this is com.android.build.gradle.AppPlugin || this is com.android.build.gradle.LibraryPlugin) {
            project.extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                compileSdkVersion(35)
                defaultConfig {
                    minSdk = 21
                    targetSdk = 33
                }
            }
        }
    }
}

// 3. Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}