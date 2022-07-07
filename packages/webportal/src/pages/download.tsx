import { Center, Flex, Link, Text } from "@chakra-ui/react";

const Download = () => (
    <Center w={"full"} h={"full"} flexDir={"column"} p={5}>
        <Flex m={5}>
            <Text fontSize={"4xl"}>Downloads</Text>
        </Flex>
        <Flex flexDir={"column"} textAlign={"center"} maxW={"3xl"}>
            <Text fontSize={"3xl"}>Node (Mining software)</Text>
            <Text>
                This is an example node software written in Vlang, it is
                recommended that you clone the git repository and compile it
                yourself so that you can edit any pieces of code you wish for
                and to ensure that it runs properly on your system as V compiles
                to an executable that will be different for different systems.
                <br />
                The below zip file contains an arm64 macOS executable called
                "node-native" (native because that's the native OS for the
                laptop I do the dev for this project on) and an x86 windows
                executable called "node-windows". If you don't use either of
                these systems then you must clone and compile the git repo
                yourself.
            </Text>
            <Center>
                <Link download href={"node.zip"} mt={3} mr={3} fontSize={"xl"}>
                    <Text color={"#3535c7"}>Download Node Software</Text>
                </Link>
                <Link
                    href="https://github.com/AlfieRan/A-Level-Project/"
                    mt={3}
                    ml={2}
                    fontSize={"xl"}
                >
                    <Text color={"#3535c7"}>Clone the repo</Text>
                </Link>
            </Center>
        </Flex>
    </Center>
);

export default Download;
