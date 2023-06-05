# About Release FLow

1. For general guidance about using GitHub actions, you can take a look at [Github Actions Guide](https://docs.github.com/en/actions/guides). 
2. We have a total of 5 active release workflows. These are located under [Workflows](https://github.com/REAN-Foundation/reancare-service/tree/develop/.github/workflows).


## Branching Strategy

We are using GitFlow Branching [here](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).

* ```main``` : The main branch serves as the stable and production-ready branch, where all the changes from release branches are merged and tested before deployment.
* ```develop``` : The develop branch, where all the changes from feature branches are merged 
* ```feature/*``` : The feature branch, individual features or enhancements are developed on separate branches, allowing for isolated development and easy collaboration before merging.
* ```release/*``` : The release branch is a branch used for allowing isolated testing and preparation of the release before merging it into the main branch.
* ```hotfix/*``` : The hotfix branch, hotfixes for critical issues are handled separately by creating dedicated branches and merging them directly into the main branch.

# Release Workflows 
 
There are different types of workflows designed for the type of source branch used based on the GitFlow workflow and the deployment targets as explained below

### REAN Foundation Platform Workflows

* [Dev-CI-CD](./release_docs/REAN_Platform_Deployment_Workflows.md#Dev-CI-CD).
* [UAT-CI-CD](./release_docs/REAN_Platform_Deployment_Workflows.md#UAT-CI-CD).
* [PROD-CI-CD](./release_docs/REAN_Platform_Deployment_Workflows.md#PROD-CI-CD).

### Customer Workflows

* [AHA-UAT-CI-CD](./release_docs/AHA_Platform_Deployment_Workflows.md#AHA-UAT-CI-CD).
* [AHA-PROD-CI-CD](./release_docs/AHA_Platform_Deployment_Workflows.md#AHA-UAT-CI-CD#AHA-PROD-CI-CD).
