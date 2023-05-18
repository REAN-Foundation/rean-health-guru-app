## Dev-CI-CD
![dev workflow](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/DevWorkflow.png?raw=true)

### Ways to trigger Dev Workflow

* By pushing code into develop branch
* By raising Pull Requests against develop branch

## Jobs

### gitguardian-scanning

Git Guardian-scanning job will be performing the following steps

* The GitGuardian shield CLI application will scan and detect potential secrets or issues in the code, as well as other potential security vulnerabilities or policy breaks.
* This job uses [gitguardian-scanning](https://github.com/GitGuardian/ggshield-action)
