# GitHub Actions for Okteto Cloud

## Automate your development workflows using Github Actions and Okteto Cloud
GitHub Actions gives you the flexibility to build an automated software development workflows. With GitHub Actions for Okteto Cloud you can create workflows to build, deploy and update your applications in [Okteto Cloud](https://cloud.okteto.com).

Get started today with a [free Okteto Cloud account](https://cloud.okteto.com)!

# Github Action for developers to trigger Okteto Pipelines from a GitHub Actions workflow

You can use this action to trigger an [Okteto Pipeline](https://okteto.com/blog/cloud-based-development-environments/) based on Github events.

You can use this action to enable your CI/CD workflow in [Okteto Cloud](https://cloud.okteto.com).

[This document](https://okteto.com/docs/tutorials/getting-started-with-pipelines/index.html) has more information on this workflow.

The [Deploy Pipeline](https://github.com/okteto/pipeline) [GitHub action](https://github.com/okteto/actions) deploys your application based on the [Okteto Pipeline](https://www.okteto.com/docs/cloud/okteto-pipeline/) manifest present in your repository. If you've not set up an Okteto Pipeline, the action will analyze the source code of your repository, looking for clues on how to deploy your application. You can read more about this [here](https://www.okteto.com/docs/cloud/deploy-from-git/#prerequisites). 

Your application will be deployed to the [Namespace](https://www.okteto.com/docs/cloud/namespaces/) on Okteto Cloud that you specified.

## Inputs

### `name`

The name of the pipeline.

### `namespace`

The Okteto namespace to use. If not specified it will use the namespace specified by the `namespace` action.

### `timeout`

The length of time to wait for completion. Values should contain a corresponding time unit e.g. 1s, 2m, 3h. If not specified it will use `5m`.

### `skipIfExists`

Skip the pipeline deployment if the pipeline already exists in the namespace (defaults to false)

### `variables`

A list of variables to be used by the pipeline. If several variables are present, they should be separated by commas e.g. VAR1=VAL1,VAR2=VAL2,VAR3=VAL3.

### `filename`

The relative path within the repository to the pipeline file. If not specified the [default pipeline](https://okteto.com/docs/cloud/okteto-pipeline#customize-the-okteto-pipeline) is executed.

# Example usage

This example runs the context action, activates a namespace, and triggers the Okteto pipeline

```yaml
# File: .github/workflows/workflow.yml
on:
  pull_request:
    branches:
      - master

name: example

jobs:
  devflow:
    runs-on: ubuntu-latest
    steps:
    - name: checkout
      uses: actions/checkout@master

    - name: context
      uses: okteto/context@latest
      with:
        token: ${{ secrets.OKTETO_TOKEN }}

    - name: "Activate Namespace"
      uses: okteto/namespace@latest
      with:
        name: cindylopez

    - name: "Trigger the pipeline"
      uses: okteto/pipeline@latest
      with:
        name: pr-${{ github.event.number }}
        timeout: 8m
        skipIfExists: true
        variables: "DB_HOST=mysql,CONFIG_PATH=/tmp/config.yaml"
```


## Advanced usage

 ### Custom Certification Authorities or Self-signed certificates

 You can specify a custom certificate authority or a self-signed certificate by setting the `OKTETO_CA_CERT` environment variable. When this variable is set, the action will install the certificate in the container, and then execute the action. 

 Use this option if you're using a private Certificate Authority or a self-signed certificate in your [Okteto Enterprise](http://okteto.com/enterprise) instance.  We recommend that you store the certificate as an [encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets), and that you define the environment variable for the entire job, instead of doing it on every step.


 ```yaml
 # File: .github/workflows/workflow.yml
 on: [push]

 name: example

 jobs:
   devflow:
     runs-on: ubuntu-latest
     env:
       OKTETO_CA_CERT: ${{ secrets.OKTETO_CA_CERT }}
     steps:
     
     - uses: okteto/context@latest
       with:
         token: ${{ secrets.OKTETO_TOKEN }}

    - name: "Activate Namespace"
      uses: okteto/namespace@latest
      with:
        name: cindylopez

    - name: "Trigger the pipeline"
      uses: okteto/pipeline@latest
      with:
        name: pr-${{ github.event.number }}
        timeout: 8m
        skipIfExists: true
        filename: .okteto/custom-pipeline.yaml
        variables: "DB_HOST=mysql,CONFIG_PATH=/tmp/config.yaml"
 ```