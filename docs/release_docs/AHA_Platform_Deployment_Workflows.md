# AHA Platform Deployment Workflows

## AHA-PROD-CI-CD

**Trigger Mode:** On-Demand

**Note:** This workflow can be triggered on demand and does not require any additional parameters to execute. It employs two distinct jobs, namely `Android-App-Release-Prod` and `iOS-App-Release-Prod`, to facilitate the deployment of the `rean-health-guru` release into the `aha-prod` environment.

### AHA Production Release Workflow

The diagram below illustrates the workflow of the release process:

![AHA Production Workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/aha_prod_workflow.png?raw=true)

The execution of the GitHub Action workflow is depicted below:

![AHA Production GitHub Workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/aha_prod_githubjob.png?raw=true)

### Jobs

#### Android-App-Release-Prod

The `Android-App-Release-Prod` job executes the following steps:

- Sets up the environment for Fastlane.
- Facilitates the transition of the Android app from the beta release track to the production release track on the Google Play Store.
- Automates the process of promoting a thoroughly tested and approved beta version of the app to the production environment.

#### iOS-App-Release-Prod

The `iOS-App-Release-Prod` job performs the subsequent steps:

- Configures the environment for Fastlane.
- Promotes the iOS app to the App Store for review and eventual release.
- Publishes a new GitHub release along with the generated release notes.

## AHA-UAT-CI-CD

**Trigger Mode:** On-Demand

**Parameters:**

- `Tag_name`: The user is required to provide the GitHub tag name for deployment (e.g., `v1.8.245`).

This workflow is responsible for deploying the `rean-health-guru` release to the `aha-uat` environment.

### AHA UAT Release Workflow

The following diagram represents the workflow for the UAT release process:

![AHA UAT Workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/aha_uat_workflow.png?raw=true)

The execution of the GitHub Action workflow is illustrated here:

![AHA UAT GitHub Workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/aha_uat_githubjob.png?raw=true)

### Jobs

#### Gitguardian-scanning

The `Gitguardian-scanning` job includes the following steps:

- Utilizes [gitguardian-scanning](https://github.com/GitGuardian/ggshield-action).
- Executes the GitGuardian shield CLI application to scan and identify potential secrets, code issues, security vulnerabilities, and policy violations within the codebase.

#### Github-ECR-Tag-Check

The `Github-ECR-Tag-Check` job encompasses the subsequent steps:

- Designed to verify the existence of a specific tag within the repository.
- If the specified tag is not found, the job will result in a failure.

#### CodeScan-FlutterAnalyze

The `CodeScan-FlutterAnalyze` job involves the following steps:

- Sets up the Flutter environment.
- Configures AWS credentials.
- Downloads an environment file.
- Performs static code analysis using Flutter's built-in analysis tools to enhance code quality and maintain consistency within the Flutter project.

#### Android-BuildApp

The `Android-BuildApp` job performs the following steps:

- Utilizes [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact) for artifact upload.
- Configures the environment for Flutter and Fastlane.
- Sets up dependencies.
- Builds the Android app in the "uat" flavor.
- Uploads the resulting app bundle as an artifact for further utilization in workflows and deployment processes.

#### Android-Release-Alpha

The `Android-Release-Alpha` job involves the subsequent steps:

- Configures Fastlane.
- Downloads build artifacts from the `Android-BuildApp` job.
- Publishes the Android App Bundle (AAB) to the alpha release track on the Google Play Store.

#### iOS-BuildApp

The `iOS-BuildApp` job includes the following steps:

- Utilizes [upload-artifact@v2](https://github.com/marketplace/actions/upload-a-build-artifact) for artifact upload.
- Configures the environment for Flutter and Fastlane.
- Sets up dependencies.
- Builds the iOS app in the "uat" flavor.
- Signs the build using Fastlane.
- Uploads the artifacts for further utilization in workflows and deployment processes.

#### iOS-Release-Alpha

The `iOS-Release-Alpha` job encompasses the subsequent steps:

- Check out the code.
- Configures Fastlane.
- Downloads previously built artifacts.
- Utilizes Fastlane to upload the app build to TestFlight for the UAT environment.
- Specifies the "uat" flavor and release mode.
- Utilizes various environment variables for authentication and configuration, including the App Store Connect key ID, issuer ID, API key, and demo user credentials.
