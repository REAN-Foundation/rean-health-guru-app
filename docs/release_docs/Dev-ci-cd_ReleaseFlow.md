## Dev-CI-CD
![dev workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/DevWorkflow.png?raw=true)

### Ways to trigger Dev Workflow

* By pushing code into develop branch
* By raising Pull Requests against develop branch

## Jobs

### gitguardian-scanning

Git Guardian-scanning job will be performing the following steps.

* The GitGuardian shield CLI application will scan and detect potential secrets or issues in the code, as well as other potential security vulnerabilities or policy breaks.
* This job uses [gitguardian-scanning](https://github.com/GitGuardian/ggshield-action)

### CodeScan-FlutterAnalyze

CodeScan FlutterAnalyze job will be performing the following steps.

* This job sets up the Flutter environment, configures AWS credentials, downloads an environment file, and performs static code analysis using Flutter's built-in analysis tools. It helps ensure code quality and consistency within the Flutter project.

### Android-BuildApp

Android BuildApp job will be performing the following steps

* This job sets up the development environment for Android app building, including Flutter and Fastlane configurations. It retrieves AWS credentials and environment files, imports build dependencies, builds the Android APK for the dev flavor, and finally uploads the generated artifacts for further use.
* For uploading artifact this job uses [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact)

### Android-PublishAppInternally

Android Publish AppInternally job will be performing the following steps. 

* This job sets up Fastlane, publishes the app to Firebase, and performs app distribution and testing, For Smoke Testing it will publishes the app to TestProject.io It uploads the app with specific parameters, such as the project ID, app ID, app name, and app path. The app is uploaded for smoke testing purposes, which is conditionally triggered based on the branch name being different from 'develop', For regression it will executed only when the branch name is 'develop'.

 
