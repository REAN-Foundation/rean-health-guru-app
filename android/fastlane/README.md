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
## Android
### android publish_to_browserstack
```
fastlane android publish_to_browserstack
```

### android publish_to_firebase
```
fastlane android publish_to_firebase
```

### android build_release
```
fastlane android build_release
```
Builds the release app
### android release_alpha_build
```
fastlane android release_alpha_build
```
Upload Alpha Build to PlayStore
### android release_beta_build
```
fastlane android release_beta_build
```
Upload Beta Build to PlayStore
### android promote_beta_to_production
```
fastlane android promote_beta_to_production
```
Promote Beta to Production

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
