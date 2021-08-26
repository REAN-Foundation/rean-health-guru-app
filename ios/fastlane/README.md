fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios update_signing_profiles
```
fastlane ios update_signing_profiles
```
Re-recreate development,adhoc and appstore profiles and necessary certificates if any of them is invalid or expired
### ios get_signing_profiles
```
fastlane ios get_signing_profiles
```
Install App Store Certificates and Profiles
### ios build
```
fastlane ios build
```
Build the ipa file as per the flavor
### ios export_simulator_build
```
fastlane ios export_simulator_build
```
Export Simulator Build
### ios publish_to_browserstack
```
fastlane ios publish_to_browserstack
```

### ios publish_to_firebase
```
fastlane ios publish_to_firebase
```

### ios upload_build_to_testflight
```
fastlane ios upload_build_to_testflight
```
Upload Build to TestFlight
### ios submit_beta_to_app_store
```
fastlane ios submit_beta_to_app_store
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
