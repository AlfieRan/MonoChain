# 2.2.1 Cycle 1

## Design

### Objectives

In this first cycle I am to build out the frameworks for my project. This will include: a web portal for showcasing the project, letting users create wallets and send/receive data to and from their wallets, explaining the rules of the blockchain and the interfaces that can be used to interact with it; a node program that will act as a program that users can download and run to host the blockchain on their device and contribute to the project; and a utils package that holds code and types needed by both the web-portal and the node.

Because of the fact that this relies on three separate packages and it may need additional packages in the future the ideal solution for this code base is a monorepo, therefore the first thing I will need to do is set up a monorepo that allows the packages to be built and used separately, to do this I will be using yarn workspaces and lerna.

* [x] Setup a monorepo for hosting the packages in a single repository.
* [x] Build a very basic initial version of the web-portal for testing deployment.
* [x] Deploy the initial version of the web-portal.
* [x] Build a very basic version of the node program that says "hello world" in the console
* [x] Figure out the best way to let users download and run the node program.
* [ ] Attach a way to download the node program to the web-portal.
* [ ] Successfully download and run the node program from the webportal.

### Usability Features

* Easy to read text - the web portal will be built using a white background and black text, this contrasts the two greatly and makes the text a lot easier to read.
* Navigation - when using either the node software or the web portal the controls should be easy to understand and navigate, in the web portal's case it's important everything a user could want should be accessible within as few clicks as possible.

### Key Variables

| Variable Name                          | Use                                                                                                                                                   |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| workspaces (/package.json)             | Tells lerna and yarn workspaces where the packages directory is and therefore where to build programs from.                                           |
| references (/tsconfig.json)            | Tells typescript where references across packages should occour - allows web portal and node to share types and interfaces through the utils package. |
| href (within web-portal download page) | Tells the browser where the node package download is hosted, and therefore what file to download                                                      |

### Pseudocode

Demo Node program:&#x20;

```
OUTPUT "hello world!" //outputs a string to the console to confirm it's running
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

Most of the development for this cycle was just setup, to get everything I need for this project up and running and building out the structure of the codebase in order to make the actual programming as smooth as possible.

### Outcome

#### Web Portal

In the pages directory I have created four primary web pages:

* [download.tsx](https://github.com/Marling-CS-Projects/AlfieRanstead-alevel-project/blob/686db5c2250bcc9c4430567baf9e29df5bb36b4b/packages/webportal/src/pages/download.tsx)
* [index.tsx](https://github.com/Marling-CS-Projects/AlfieRanstead-alevel-project/blob/686db5c2250bcc9c4430567baf9e29df5bb36b4b/packages/webportal/src/pages/index.tsx)
* [info.tsx](https://github.com/Marling-CS-Projects/AlfieRanstead-alevel-project/blob/686db5c2250bcc9c4430567baf9e29df5bb36b4b/packages/webportal/src/pages/info.tsx)
* [wallet.tsx](https://github.com/Marling-CS-Projects/AlfieRanstead-alevel-project/blob/686db5c2250bcc9c4430567baf9e29df5bb36b4b/packages/webportal/src/pages/wallet.tsx)

#### Node Software

### Challenges

The main challenge I faced in this cycle of development was deciding how to make the node software available for download, originally I attempted to setup a file server and upload files to that in order to download the software easily, however I soon realised that this would be a lot of setup to just host one file.

Luckily I soon realised that you can download files very easily from websites using the "download" flag in chakra-ui (the component package I'm using - it's very similar for html) and because I had setup the repositories in a monorepo it was possible to build and zip the node software from the node's package, then copy it into the public folder in the website's package and have the download link from the website just point to the zipped software within it's own public folder.

This then means that upon building the node software, the typescript in which it is written is compiled to javascript within the "dist" folder (dist meaning distribution), this dist folder is then zipped and finally the zipped folder is copied to the web portal's public folder.



This is done using yarn commands which effectively just let you string together a series of bash commands that are local to your project, the commands themselves can be found within the "package.json" file within the node package. (The current package.json is shown below)

```
{
  "name": "@namespace/node",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "start": "node dist/code/index.js",
    "clean": "rimraf dist/code && rimraf tsconfig.tsbuildinfo && mkdir dist/code && echo \"cleaned dist/code\"",
    "clean-zip": "rimraf node.zip && echo \"cleaned node.zip\"",
    "prepack": "yarn build",
    "build": "yarn clean && yarn clean-zip && yarn compile && yarn zip && echo \"zipped node\"",
    "compile": "tsc && cp \"./package.json\" ./dist/code/ && echo \"compiled\"",
    "zip": "zip ../webportal/public/node.zip -9r ./dist/ && echo \"zipped\"",
    "lint": "eslint \"./src/**/*.{ts,tsx}\" --max-warnings=0"
  }
}
```

By following this code we can see that once "yarn build" is run it runs:&#x20;

1. "yarn clean" - which removes the last code distribution and typescript build info from the file system, then recreate the distribution code file structure before echoing that it has finished cleaning the distribution files.
2. "yarn clean-zip" - which removes the previous zip file and then echoes that the command has successfully run
3. "yarn compile" - which compiles the typescript to javascript, copies the current package.json to the distribution folder and echoes to let us know it's successfully completed.
4. "yarn zip" - which zips the newly compiled distribution folder to the webportal's public folder and echoes to

## Testing

**Test 1 - Web portal running on localhost:**

![Web portal running as expected on localhost:3000 when "yarn next" is ran in /packages/webportal](<../.gitbook/assets/image (3) (1) (1).png>)

![Console output for the webportal.](<../.gitbook/assets/image (4) (1) (1).png>)

**Test 2 - Deploy and Run the webportal on an external server:**

![Vercel successfully running the webportal on https://monochain.network](<../.gitbook/assets/image (2) (1) (1).png>)

### Tests

| Test | Instructions                                                                           | What I expect                                                                                                  | What actually happens | Pass/Fail |
| ---- | -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | --------------------- | --------- |
| 1    | Run the webportal on localhost.                                                        | Webportal launches and text is displayed on the screen                                                         | As expected           | Pass      |
| 2    | Deploy the web-portal by git pushing to Github and Vercel should automatically deploy. | Website launches successfully on frontend server and when navigated to displays the same text as on localhost. | As expected           | Pass      |
| 3    | Run node program.                                                                      | An output of "hello world"                                                                                     |                       |           |
| 4    | Download the node program by clicking on the download button on the web-portal         | The Node program should be downloaded to the test computer                                                     |                       |           |

### Evidence
