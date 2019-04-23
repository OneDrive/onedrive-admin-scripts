# Contribution Guidance

If you'd like to contribute to this repository, please read the following guidelines. Contributors are more than welcome to share your learnings with others from centralized location.

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information, see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Question or Problem?

Please do not open GitHub issues for general support questions as the GitHub list should be used for script requests and bug reports. This way we can more easily track actual issues or bugs from the scripts and keep the general discussion separate from the actual script samples.

## Typos, Issues, Bugs and contributions

Whenever you are submitting any changes to the OneDrive repositories, please follow these recommendations.

* Always fork repository to your own account for applying modifications
* Do not combine multiple changes to one pull request, please submit for example any samples and documentation updates using separate PRs
* If you are submitting multiple samples, please create specific PR for each of them
* If you are submitting typo or documentation fix, you can combine modifications to single PR where suitable

## Sample Naming and Structure Guidelines

When you are submitting a new sample, it has to follow up below guidelines

* You will need to have a README file for your contribution, which is based on [provided template](../samples/README-template.md) under the scripts folder. Please copy this template and update accordingly. README has to be named as README.md with capital letters.
  * Please include as much as possible information on the exact use case of your script. More information will help on others to understand the value of your script. You can add links and images as needed.

* README template contains specific tracking image as a final entry in the page with img tag by default to https://telemetry.sharepointpnp.com/onedrive-admin-scripts/scripts/readme-template. This is transparent image, which is used to track popularity of individual samples in GitHub.

  * Updated the image src element according with repository name and folder information. If your sample is for example in samples folder and named as known-folder-move, src element should be updated as https://telemetry.sharepointpnp.com/onedrive-admin-scripts/script/known-folder-move

* When you are submitting a new script, please name the sample solution folder accordingly
  * Do not use words "sample", "scro[t" or "onedrive" in the folder or sample name - these are scripts for OneDrive management, so no reason to repeat that in the name
  
* Do not use period/dot in the folder name of the provided sample

## Submitting Pull Requests

Here's a high level process for submitting new samples or updates to existing ones.

1. Sign the Contributor License Agreement (see below)
1. Fork this repository [OneDrive/onedrive-admin-scripts](https://github.com/OneDrive/onedrive-admin-scripts) to your GitHub account
1. Create a new branch off the `master` branch for your fork for the contribution
1. Include your changes to your branch
1. Commit your changes using descriptive commit message * These are used to track changes on the repositories for monthly communications
1. Create a pull request in your own fork and target `master` branch
1. Fill up the provided PR template with the requested details

Before you submit your pull request consider the following guidelines:

* Make sure you have a link in your local cloned fork to the [OneDrive/onedrive-admin-scripts](https://github.com/OneDrive/onedrive-admin-scripts):

  ```shell
  # check if you have a remote pointing to the Microsoft repo:
  git remote -v

  # if you see a pair of remotes (fetch & pull) that point to https://github.com/OneDrive/onedrive-admin-scripts, you're ok... otherwise you need to add one

  # add a new remote named "upstream" and point to the Microsoft repo
  git remote add upstream https://github.com/OneDrive/onedrive-admin-scripts.git
  ```

* Make your changes in a new git branch:

  ```shell
  git checkout -b my-awesome-script-name master
  ```

* Ensure your fork is updated and not behind the upstream **onedrive-admin-scripts** repo. Refer to these resources for more information on syncing your repo:
  * [GitHub Help: Syncing a Fork](https://help.github.com/articles/syncing-a-fork/)
  * [Keep Your Forked Git Repo Updated with Changes from the Original Upstream Repo](http://www.andrewconnell.com/blog/keep-your-forked-git-repo-updated-with-changes-from-the-original-upstream-repo)
  * For a quick cheat sheet:

    ```shell
    # assuming you are in the folder of your locally cloned fork....
    git checkout master

    # assuming you have a remote named `upstream` pointing official **onedrive-admin-scripts** repo
    git fetch upstream

    # update your local master to be a mirror of what's in the main repo
    git pull --rebase upstream master

    # switch to your branch where you are working, say "my-awesome-script-name"
    git checkout my-awesome-script-name

    # update your branch to update it's fork point to the current tip of master & put your changes on top of it
    git rebase master
    ```

* Push your branch to GitHub:

  ```shell
  git push origin my-awesome-script-name
  ```

## Merging your Existing Github Projects with this Repository

If the sample you wish to contribute is stored in your own Github repository, you can use the following steps to merge it with the this repository:

* Fork the `onedrive-admin-scripts` repository from GitHub
* Create a local git repository

    ```shell
    md onedrive-admin-scripts
    cd onedrive-admin-scripts
    git init
    ```

* Pull your forked copy of onedrive-admin-scripts into your local repository

    ```shell
    git remote add origin https://github.com/yourgitaccount/onedrive-admin-scripts.git
    git pull origin dev
    ```

* Pull your other project from github into the scripts folder of your local copy of onedrive-admin-scripts

    ```shell
    git subtree add --prefix=scripts/projectname https://github.com/yourgitaccount/projectname.git master
    ```

* Push the changes up to your forked repository

    ```shell
    git push origin master
    ```

## Signing the CLA

Before we can accept your pull requests you will be asked to sign electronically Contributor License Agreement (CLA), which is prerequisite for any contributions to PnP repository. This will be one time process, so for any future contributions you will not be asked to re-sign anything. After the CLA has been signed, our PnP core team members will have a look on your submission for final verification of the submission. Please do not delete your development branch until the submission has been closed.

You can find Microsoft CLA from the following address - https://cla.microsoft.com. 

Thank you for your contribution.

> Sharing is caring.