## UAT-CI-CD

![uat workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/uatWorkflow.png?raw=true)

### Ways to trigger UAT Workflow

* By pushing code into branch with prefix of ``` release/** ``` .
* By raising Pull Request against main branch.

## Jobs

### Gitguardian-scanning

Git Guardian-scanning job will be performing the following steps.

* The GitGuardian shield CLI application will scan and detect potential secrets or issues in the code, as well as other potential security vulnerabilities or policy breaks.
* This job uses [gitguardian-scanning](https://github.com/GitGuardian/ggshield-action)

### CodeScan-FlutterAnalyze

CodeScan FlutterAnalyze job will be performing the following steps.

* This job sets up the Flutter environment, configures AWS credentials, downloads an environment file, and performs static code analysis using Flutter's built-in analysis tools. It helps ensure code quality and consistency within the Flutter project.

### Label_Checks

Label Checks job will be performing the following steps.

* On event Pull Request this job will check wheter the Pull Request have one of major, minor , patch label or not.
* This job uses [pull-request-label-checker](https://github.com/marketplace/actions/label-checker-for-pull-requests). 

### Android-BuildApp

Android BuildApp job will be performing the following steps.

* This job sets up the build environment, including Flutter and Fastlane configurations, configures dependencies, and builds the Android app in the "uat" flavor. The resulting app bundle is then uploaded as an artifact for further use in the workflow or deployment processes
* For uploading artifact this job uses [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact)

### Android-Release-Alpha

Android-Release-Alpha job will be performing the following steps.

* this job sets up Fastlane, downloads the build artifacts from the "Android-BuildApp" job, and publishes the Android App Bundle (AAB) to the alpha release track on the Google Play Store.

### iOS-BuildApp

iOS-BuildApp job will be performing the following steps.

* This job sets up the build environment, including Flutter and Fastlane configurations, configures dependencies, and builds the IOS app in the "uat" flavor, signs the build using Fastlane, and uploads the artifacts for further use in the workflow or deployment processes
* For uploading artifact this job uses [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact)

### iOS-Release-Alpha

iOS-Release-Alpha job will be performing the following steps.

* This job checks out the code, sets up Fastlane, downloads the previously built artifacts, Uses Fastlane to upload the app build to TestFlight for the UAT environment. It specifies the "uat" flavor and release mode and uses various environment variables for authentication and configuration, including the App Store Connect key ID, issuer ID, API key, and demo user credentials.
