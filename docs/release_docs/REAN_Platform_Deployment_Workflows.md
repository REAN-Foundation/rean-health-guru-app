# REAN Platform Deployment Workflows

## Dev-CI-CD 

**Mode of Trigger:** Automated

The Dev CI/CD workflow can be triggered in two ways:

1. By creating a Pull Request to merge into the `develop` branch.
2. Whenever any Pull Request is merged into the `develop` branch.

### Release Process Workflow Diagram
![dev workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/DevWorkflow.png?raw=true)

### GitHub Action Workflow Run
![dev_github](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/dev_github_job.png?raw=true)

### Jobs

#### GitGuardian Scanning
The GitGuardian Scanning job performs the following steps:
- Utilizes the [gitguardian-scanning](https://github.com/GitGuardian/ggshield-action) tool.
- Scans code for potential secrets, issues, security vulnerabilities, or policy breaches.

#### CodeScan Flutter Analyze
The CodeScan Flutter Analyze job performs the following steps:
- Sets up the Flutter environment, configures AWS credentials, and downloads an environment file.
- Conducts static code analysis using Flutter's built-in analysis tools to ensure code quality and consistency.

#### Android Build App
The Android Build App job performs the following steps:
- Utilizes [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact) for artifact upload.
- Set up the Android app development environment, configuring Flutter and Fastlane.
- Retrieves AWS credentials and environment files, imports build dependencies, and builds the Android APK for the development flavor.
- Upload the generated artifacts for further use.

#### Android Publish App Internally
The Android Publish App Internally job performs the following steps:
- Sets up Fastlane, publishes the app to Firebase, and conducts app distribution and testing.
- For smoke testing, publish the app to TestProject.io.
- Uploads the app with specific parameters based on the branch name (different from 'develop') for smoke testing and regression.

#### iOS Build App
The iOS Build App job performs the following steps:
- Utilizes [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact) for artifact upload.
- Sets up necessary tools like Fastlane and Flutter.
- Builds the iOS app using Flutter, and signs the build with Fastlane for the 'dev' flavor and release mode.
- Uploads the artifacts for further use.

#### iOS Publish App Internally
The iOS Publish App Internally job performs the following steps:
- Checks out the code, sets up Fastlane, and downloads previously built artifacts.
- Publishes the app to Firebase and uploads it to TestProject.io for smoke testing (conditionally based on branch name).

## UAT-CI-CD 

**Mode of Trigger:** Automated

The UAT Workflow has triggered automatically when developers push code into branches with a prefix of `release/**`.

### Release Process Workflow Diagram
![uat workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/uatWorkflow.png?raw=true)

### GitHub Action Workflow Run
![uat-github](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/uat_github_action.png?raw=true)

### Jobs

#### GitGuardian Scanning
Same as in the Dev CI/CD Workflow.

#### CodeScan Flutter Analyze
Same as in the Dev CI/CD Workflow.

#### Android Build App
Same as in the Dev CI/CD Workflow.

#### Android Release Alpha
The Android Release Alpha job performs the following steps:
- Sets up Fastlane, downloads build artifacts, and publishes the Android App Bundle (AAB) to the alpha release track on Google Play Store.

#### iOS Build App
Same as in the Dev CI/CD Workflow.

#### iOS Release Alpha
The iOS Release Alpha job performs the following steps:
- Checks out code, sets up Fastlane, downloads built artifacts, and uploads the app build to TestFlight for UAT environment.

## PROD-CI-CD 

**Mode of Trigger:** On-Demand

This workflow can be manually triggered and is used for building applications and deploying changes to the RF Platform Production environment.

### Release Process Workflow Diagram
![prod workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/prod_workflow.png?raw=true)

### GitHub Action Workflow Run
![prod_github](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/prod_github_action.png?raw=true)

### Jobs

#### Android App Release Prod
The Android App Release Prod job performs the following steps:
- Set up Fastlane to promote the Android app from the beta release track to the production release track on the Google Play Store.
- Automates the process of promoting a tested and approved beta version of the app to the production environment.

#### iOS App Release Prod
The iOS App Release Prod job performs the following steps:
- Set up Fastlane to promote the app to the App Store for review and release.
- Publishes a new GitHub release along with generated release notes.

#### GitHub Tag and Release
The GitHub Tag and Release job automates the process of tagging and releasing a project. It accomplishes the following steps:
- Fetches the code from the repository.
- Extract the version information from the "pubspec.yaml" file.
- Creates a new release draft with the obtained version tag.
- The release draft is then automatically published.
