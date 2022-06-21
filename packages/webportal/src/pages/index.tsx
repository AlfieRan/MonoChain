import { Image, Center, Flex, Text } from "@chakra-ui/react";
import React from "react";

const index = () => {
    return (
        <Flex flexDir="column">
            <Flex maxH="5%" borderRadius={"lg"}>
                <Image src="/index/nodes.png" />
            </Flex>
            <Flex
                w={"100vw"}
                h={"full"}
                flexDir={"column"}
                color={"black"}
                px={10}
                maxW="1500px"
                m="auto"
            >
                <Center
                    fontSize={"2xl"}
                    flexDir="column"
                    p="5%"
                    pt="0"
                    textAlign={"center"}
                >
                    <Text fontSize={"5xl"} mb="10px">
                        Welcome to the MonoChain
                    </Text>
                    <Flex maxW="2xl">
                        <Text>
                            The MonoChain is a new generation of decentralised
                            computing built alongside the "Proof of Trust"
                            protocol.
                        </Text>
                    </Flex>
                </Center>
                <Center flexDir="row" w="100%" my="5%" flexWrap={"wrap"}>
                    <Flex px="1%" maxW="600px">
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
                                protocol that uses a "trust" parameter in order
                                to be faster and eco-friendlier than "Proof of
                                Work" whilst having much lower entry
                                requirements than "Proof of Stake".
                            </Text>
                        </Flex>
                    </Flex>
                    <Flex px="1%" maxW="600px">
                        <Flex w="100%" mt="1%" borderRadius={"lg"}>
                            <Image src={"/index/proof-of-trust.png"} />
                        </Flex>
                    </Flex>
                </Center>
            </Flex>
        </Flex>
    );
};

export default index;
