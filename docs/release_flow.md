# About Release Flow

1. For general guidance about using GitHub actions, you can look at [Github Actions Guide](https://docs.github.com/en/actions/guides). 
2. We have a total of 5 active release workflows. These are located under [Workflows](https://github.com/REAN-Foundation/reancare-service/tree/develop/.github/workflows).


## Table Of Contents
- [Branching Strategy](#Branching-Strategy)
- [Develop to Main Branch Workflow](#Develop-to-Main-branch-Workflow)
  - [Develop Branch Workflow](#Develop-Branch-Workflow)
  - [Main branch Workflow](#Main-branch-Workflow)
- [Release Workflows](#Release-Workflows)
  - [REAN Foundation Platform Workflows](#REAN-Foundation-Platform-Workflows)
  - [Customer Workflows](#Customer-Workflows)
    

## Branching Strategy

We are following the GitFlow branching strategy. Please refer [here](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).

* ```main``` : The main branch serves as the stable and production-ready branch, where all the changes from release branches are merged and tested before deployment.
* ```develop``` : The develop branch, where all the changes from feature branches are merged 
* ```feature/*``` : The feature branch, individual features, or enhancements are developed on separate branches, allowing for isolated development and easy collaboration before merging.
* ```release/*``` : The release branch is a branch used for allowing isolated testing and preparation of the release before merging it into the main branch.
* ```hotfix/*``` : The hotfix branch, hotfixes for critical issues are handled separately by creating dedicated branches and merging them directly into the main branch.

## Develop to Main Branch Workflow

The diagram below explains the end-to-end process and stages for promoting the code from the develop branch to the master branch.

![workflow_diagram](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/res/images/release_docs_images/reanhealth-guru_workflow.png?raw=true)

### Develop Branch Workflow

1. The developer will create a Feature branch, create a Pull Request to the develop branch, or push code to the develop branch, Which will trigger the DEV-ci-cd workflow.

### Main branch Workflow

1. The developer will create a Release branch and create a Pull Request to the main branch which will trigger the UAT-ci-cd workflow.
2. After the Pull request merges into the main branch, the developer can manually trigger the Prod-CI-CD workflow.
 
 
# Release Workflows 
 
There are different types of workflows designed for the type of source branch used based on the GitFlow workflow and the deployment targets as explained below

### REAN Foundation Platform Workflows

* [Dev-CI-CD](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/docs/release_docs/REAN_Platform_Deployment_Workflows.md#dev-ci/cd).
* [UAT-CI-CD](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/docs/release_docs/REAN_Platform_Deployment_Workflows.md#uat-ci/cd).
* [PROD-CI-CD](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/docs/release_docs/REAN_Platform_Deployment_Workflows.md#prod-ci/cd).

### Customer Workflows

* [AHA-UAT-CI-CD](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/docs/release_docs/AHA_Platform_Deployment_Workflows.md#AHA-UAT-CI-CD).
* [AHA-PROD-CI-CD](https://github.com/REAN-Foundation/rean-health-guru-app/blob/feature/flow_documentation/docs/release_docs/AHA_Platform_Deployment_Workflows.md#AHA-PROD-CI-CD).
