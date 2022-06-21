import { Box, Center, Flex, Text } from "@chakra-ui/react";
import React from "react";

const index = () => {
    return (
        <Flex
            w={"100vw"}
            h={"full"}
            flexDir={"column"}
            color={"black"}
            px={10}
            maxW="1500px"
            m="auto"
        >
            <Flex
                h="md"
                w="full"
                bg="rgba(0,0,0,0.1)"
                mt="1%"
                borderRadius={"lg"}
                p="0.5%"
            >
                <Text>Image goes here</Text>
            </Flex>
            <Center
                fontSize={"2xl"}
                flexDir="column"
                p="5%"
                pt="2%"
                textAlign={"center"}
            >
                <Text fontSize={"4xl"} mb="10px">
                    Welcome to the MonoChain
                </Text>
                <Flex w="2xl">
                    <Text>
                        The MonoChain is a new generation of decentralised
                        computing built alongside the "Proof of Trust" protocol.
                    </Text>
                </Flex>
            </Center>
            <Center flexDir="row" w="100%" mb="5%">
                <Flex w="60%" px="3%">
                    <Flex
                        fontSize={"xl"}
                        flexDir="column"
                        p="3%"
                        textAlign={"right"}
                    >
                        <Text fontSize={"2xl"} mb="10px">
                            What is Proof of Trust?
                        </Text>
                        <Text>
                            "Proof of Trust" is a custom built consensus
                            protocol that uses a "trust" parameter in order to
                            be faster and eco friendlier than "Proof of Work"
                            whilst having much lower entry requirements than
                            "Proof of Stake".
                        </Text>
                    </Flex>
                </Flex>
                <Flex w="40%" px="3%">
                    <Flex
                        w="md"
                        h="xs"
                        bg="rgba(0,0,0,0.1)"
                        mt="1%"
                        borderRadius={"lg"}
                        p="0.5%"
                    >
                        <Text>Image goes here</Text>
                    </Flex>
                </Flex>
            </Center>
        </Flex>
    );
};

export default index;
