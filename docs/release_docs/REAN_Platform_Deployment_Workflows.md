# REAN Platform Deployment workflows


## Dev-CI-CD
Mode of trigger: ```Automated```

There are two ways to use or trigger dev-CI-CD workflow
1. By creating a Pull Request to merge into develop branch
2. Whenever any PR is merged into the develop branch


Release Process Workflow Diagram.
![dev workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/DevWorkflow.png?raw=true)

GitHub Action Workflow run.
![dev_github](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/dev_github_job.png?raw=true)

### JOBS

#### gitguardian-scanning

Git Guardian-scanning job will be performing the following steps.

* This job uses [gitguardian-scanning](https://github.com/GitGuardian/ggshield-action)
* The GitGuardian shield CLI application will scan and detect potential secrets or issues in the code, as well as other potential security vulnerabilities or policy breaks.

#### CodeScan-FlutterAnalyze

CodeScan FlutterAnalyze job will be performing the following steps.

* This job sets up the Flutter environment, configures AWS credentials, downloads an environment file, and performs static code analysis using Flutter's built-in analysis tools. It helps ensure code quality and consistency within the Flutter project.

#### Android-BuildApp

Android BuildApp job will be performing the following steps

* For uploading artifact this job uses [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact)
* This job sets up the development environment for Android app building, including Flutter and Fastlane configurations. It retrieves AWS credentials and environment files, imports build dependencies, builds the Android APK for the dev flavor, and finally uploads the generated artifacts for further use.

#### Android-PublishAppInternally

Android Publish AppInternally job will be performing the following steps. 

* This job sets up Fastlane, publishes the app to Firebase, and performs app distribution and testing, For Smoke Testing it will publishes the app to TestProject.io It uploads the app with specific parameters, such as the project ID, app ID, app name, and app path. The app is uploaded for smoke testing purposes, which is conditionally triggered based on the branch name being different from 'develop', For regression it will executed only when the branch name is 'develop'.

#### iOS-BuildApp

iOS-BuildApp job will be performing the following steps. 
 
* For uploading artifact this job uses [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact)
* This job sets up the necessary tools like fastlane, flutter then builds the iOS app using Flutter, signs the build using Fastlane, specifying the "dev" flavor and release mode. It uses various environment variables for authentication and configuration, and uploads the artifacts for further use.

#### iOS-PublishAppInternally

iOS-PublishAppInternally job will be performing the following steps.

* This job checks out the code, sets up Fastlane, downloads the previously built artifacts, publishes the app to Firebase, and uploads it to TestProject.io, for smoke testing purposes which is conditionally triggered based on the branch name being different from 'develop', For regression it will executed only when the branch name is 'develop'.


## UAT-CI-CD
Mode of trigger: ```On-Demand``` ```Automated```

There are two ways to use or trigger uat-CI-CD workflow
* By pushing code into branch with prefix of ``` release/** ``` .
* By raising Pull Request against main branch.

Release Process Workflow Diagram.
![uat workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/uatWorkflow.png?raw=true)

GitHub Action Workflow run.
![uat-github](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/uat_github_action.png?raw=true)

### JOBS

#### Gitguardian-scanning

Git Guardian-scanning job will be performing the following steps.

* This job uses [gitguardian-scanning](https://github.com/GitGuardian/ggshield-action)
* The GitGuardian shield CLI application will scan and detect potential secrets or issues in the code, as well as other potential security vulnerabilities or policy breaks.

#### CodeScan-FlutterAnalyze

CodeScan FlutterAnalyze job will be performing the following steps.

* This job sets up the Flutter environment, configures AWS credentials, downloads an environment file, and performs static code analysis using Flutter's built-in analysis tools. It helps ensure code quality and consistency within the Flutter project.

#### Label_Checks

Label Checks job will be performing the following steps.

* This job uses [pull-request-label-checker](https://github.com/marketplace/actions/label-checker-for-pull-requests). 
* On event Pull Request this job will check wheter the Pull Request have one of major, minor , patch label or not.

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


## PROD-CI-CD
Mode of trigger: ```Automated```

Prod Workflow can be manually triggered. The workflow builds the applications and deploys the changes to the RF Platform Production environment.

Release Process Workflow Diagram.
![prod_workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/prod_workflow.png?raw=true)

GitHub Action Workflow run.
![prod_github](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/prod_github_action.png?raw=true)

### JOBS

#### Android-App-Release-Prod

Android-App-Release-Prod job will be performing the following steps.

* This job sets up Fastlane and promotes the Android app from the beta release track to the production release track on the Google Play Store. It automates the process of promoting a tested and approved beta version of the app to the production environment

#### iOS-App-Release-Prod

iOS-App-Release-Prod job will be performing the following steps.

* This job sets up Fastlane, promotes the app to the App Store for review and release, and publishes a new github release with generated release notes. 



 
 
 
 
