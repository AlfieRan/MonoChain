# 2.2.1 Cycle 1

## Design

### Objectives

In this first cycle I am to build out the frameworks for my project. This will include: a web portal for showcasing the project, letting users create wallets and send/receive data to and from their wallets, explaining the rules of the blockchain and the interfaces that can be used to interact with it; a node program that will act as a program that users can download and run to host the blockchain on their device and contribute to the project; and a utils package that holds code and types needed by both the web-portal and the node.

Because of the fact that this relies on three separate packages and it may need additional packages in the future the ideal solution for this code base is a monorepo, therefore the first thing I will need to do is set up a monorepo that allows the packages to be built and used separately, to do this I will be using yarn workspaces and lerna.

* [x] Setup a monorepo for hosting the packages in a single repository.
* [x] Build a very basic initial version of the web-portal for testing deployment.
* [x] Deploy the initial version of the web-portal.
* [ ] Figure out the best way to let users download and run the node program.
* [ ] Attach a way to download the node program to the web-portal.

### Usability Features

### Key Variables

| Variable Name                          | Use                                                                                                                                                   |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| workspaces (/package.json)             | Tells lerna and yarn workspaces where the packages directory is and therefore where to build programs from.                                           |
| references (/tsconfig.json)            | Tells typescript where references across packages should occour - allows web portal and node to share types and interfaces through the utils package. |
| href (within web-portal download page) | Tells the browser where the node package download is hosted, and therefore what file to download                                                      |

### Pseudocode

Demo Node program:&#x20;

```
OUTPUT "hello world!" //does what is says on the tin
```

Download Feature on webportal:

```
<React component> // This refers to the page of which the download button exists
    <Link href="https://path/to/node/download" download> 
    // The Link paired with the download flag above ^ tells the browser 
    // to download the file referenced in the 'href' field to the users computer. 
        
        <Text>
            Download Node
        <End Text>
        // The text component just shows some text within the link box to the user
        
    <End Link>
<End React component>
```

## Development

### Outcome

### Challenges

Description of challenges

## Testing

Evidence for testing

### Tests

| Test | Instructions                                                                           | What I expect                                              | What actually happens | Pass/Fail |
| ---- | -------------------------------------------------------------------------------------- | ---------------------------------------------------------- | --------------------- | --------- |
| 1    | Deploy the web-portal by git pushing to Github and Vercel should automatically deploy. | Website launches successfully on frontend server.          | As expected           | Pass      |
| 2    | Run node program.                                                                      | An output of "hello world"                                 |                       |           |
| 3    | Download the node program by clicking on the download button on the web-portal         | The Node program should be downloaded to the test computer |                       |           |

### Evidence
