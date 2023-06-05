# AHA Platform Deployment Workflows

## AHA-PROD-CI-CD
Mode of trigger: ```On-Demand```

This workflow uses two jobs: Android-App-Release-Prod and iOS-App-Release-Prod to deploy ```rean-health-guru``` release to ```aha-prod``` environment

### AHA Prod Release Workflow

Release Process Workflow Diagram.
![aha-wokflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/aha_prod_workflow.png?raw=true)

GitHub Action Workflow run.
![aah_prod-github](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/aha_prod_githubjob.png?raw=true)

### JOBS

#### Android-App-Release-Prod

Android-App-Release-Prod job will be performing the following steps.

* This job sets up Fastlane and promotes the Android app from the beta release track to the production release track on the Google Play Store. It automates the process of promoting a tested and approved beta version of the app to the production environment

#### iOS-App-Release-Prod

iOS-App-Release-Prod job will be performing the following steps.

* This job sets up Fastlane, promotes the app to the App Store for review and release, and publishes a new github release with generated release notes. 


## AHA-UAT-CI-CD
Mode of trigger: ```On-Demand```

This workflow deploy ```rean-health-guru``` release to ```aha-uat``` environment

### AHA UAT Release Workflow

Release Process Workflow Diagram..
![AHA-uat](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/aha_uat_workflow.png?raw=true)

GitHub Action Workflow run
![aha-uat-workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/aha_uat_githubjob.png?raw=true)

### JOBS

#### Gitguardian-scanning

Git Guardian-scanning job will be performing the following steps.

* This job uses [gitguardian-scanning](https://github.com/GitGuardian/ggshield-action)
* The GitGuardian shield CLI application will scan and detect potential secrets or issues in the code, as well as other potential security vulnerabilities or policy breaks.

#### CodeScan-FlutterAnalyze

CodeScan FlutterAnalyze job will be performing the following steps.

* This job sets up the Flutter environment, configures AWS credentials, downloads an environment file, and performs static code analysis using Flutter's built-in analysis tools. It helps ensure code quality and consistency within the Flutter project.


#### Android-BuildApp

Android BuildApp job will be performing the following steps.

* For uploading artifact this job uses [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact)
* This job sets up the build environment, including Flutter and Fastlane configurations, configures dependencies, and builds the Android app in the "uat" flavor. The resulting app bundle is then uploaded as an artifact for further use in the workflow or deployment processes


#### Android-Release-Alpha

Android-Release-Alpha job will be performing the following steps.

* this job sets up Fastlane, downloads the build artifacts from the "Android-BuildApp" job, and publishes the Android App Bundle (AAB) to the alpha release track on the Google Play Store.


#### iOS-BuildApp

iOS-BuildApp job will be performing the following steps.

* For uploading artifact this job uses [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact)
* This job sets up the build environment, including Flutter and Fastlane configurations, configures dependencies, and builds the IOS app in the "uat" flavor, signs the build using Fastlane, and uploads the artifacts for further use in the workflow or deployment processes


#### iOS-Release-Alpha

iOS-Release-Alpha job will be performing the following steps.

* This job checks out the code, sets up Fastlane, downloads the previously built artifacts, Uses Fastlane to upload the app build to TestFlight for the UAT environment. It specifies the "uat" flavor and release mode and uses various environment variables for authentication and configuration, including the App Store Connect key ID, issuer ID, API key, and demo user credentials.

