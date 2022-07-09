import { Center, Flex, Link, Text } from "@chakra-ui/react";
import { download_button } from "../styles/buttons";

const Download = () => (
  <Center w={"100%"} minH={"80vh"} flexDir={"column"} maxW="100%">
    <Flex m={5}>
      <Text fontSize={["3xl", "5xl"]}>Downloads</Text>
    </Flex>
    <Flex
      flexDir={"column"}
      textAlign={"center"}
      maxW={["inherit", "3xl"]}
      p={3}
    >
      <Text fontSize={"3xl"}>Node (Mining software)</Text>
      <Text p="lg">
        This is an example node software written in Vlang, it is recommended
        that you clone the git repository and compile it yourself so that you
        can edit any pieces of code you wish to and to ensure that it runs
        properly on your system as V compiles to an executable that will be
        different for different systems.
        <br />
        The below zip file contains an arm64 macOS executable called
        "node-native" (native because that's the native OS for the laptop I do
        the dev for this project on) and an x86 windows executable called
        "node-windows". If you don't use either of these systems then you must
        clone the git repo and use the v compiler to compiler to project
        yourself.
      </Text>
      <Center p={5} justifyContent={"space-evenly"} flexWrap={"wrap"}>
        <Link download href={"node.zip"} css={download_button}>
          <Text color={"#3535c7"} m={2}>
            Download Node Software
          </Text>
        </Link>
        <Link
          href="https://github.com/AlfieRan/A-Level-Project/"
          css={download_button}
        >
          <Text color={"#3535c7"} m={2}>
            Clone the repo
          </Text>
        </Link>
      </Center>
    </Flex>
  </Center>
);

export default Download;
