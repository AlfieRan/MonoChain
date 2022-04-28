import { Center, Flex, Link, Text } from "@chakra-ui/react";

const Download = () => (
  <Center w={"full"} h={"full"} flexDir={"column"} p={5}>
    <Flex m={5}>
      <Text fontSize={"4xl"}>Downloads</Text>
    </Flex>
    <Flex flexDir={"column"} textAlign={"center"} maxW={"3xl"}>
      <Text fontSize={"3xl"}>Node (Mining software)</Text>
      <Text>
        Although it is recommended to either write your own miner or use a third
        party node program written in a lower level language, I have included a
        zipped node program that runs using javascript.
        <br />
        That means that to use this program you must first download node.js and
        unzip the file. It can then be started by navigating to where-ever you
        downloaded the node program to, opening the "dist" folder that should be
        created after it was unzipped and typing "node ./code/index.js" into
        your terminal.
      </Text>
      <Link download href={"node.zip"} mt={3} fontSize={"xl"}>
        <Text color={"#3535c7"}>Download Node Software</Text>
      </Link>
    </Flex>
  </Center>
);

export default Download;
