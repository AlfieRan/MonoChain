import { AspectRatio, Center, Flex, Spacer, Text } from "@chakra-ui/react";
import Image from "next/image";
import React from "react";

const index = () => {
  return (
    <Flex flexDir="column">
      <AspectRatio maxH="5%" ratio={5 / 1}>
        <Image src="/index/nodes-banner.png" layout="fill" />
      </AspectRatio>
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
          fontSize={"xl"}
          flexDir="column"
          p="5%"
          pt="0"
          textAlign={"center"}
        >
          <Text fontSize={"4xl"} mb="10px" fontWeight={"semibold"}>
            Welcome to the MonoChain
          </Text>
          <Flex maxW="2xl">
            <Text>
              The MonoChain is a new generation of decentralised computing built
              alongside the "Proof of Trust" protocol.
            </Text>
          </Flex>
        </Center>
        <Spacer />
        <Center flexDir="row" w="100%" my="5%" flexWrap={"wrap"}>
          <Flex px="1%" maxW="600px">
            <Flex fontSize={"lg"} flexDir="column" p="3%" textAlign={"right"}>
              <Text fontSize={"2xl"} mb="10px" fontWeight={"semibold"}>
                What is Proof of Trust?
              </Text>
              <Text>
                "Proof of Trust" is a custom built consensus protocol that uses
                a "trust" parameter in order to be faster and eco-friendlier
                than "Proof of Work" whilst having much lower entry requirements
                than "Proof of Stake".
              </Text>
            </Flex>
          </Flex>
          <Flex px="1%" maxW="600px" w="100%">
            <AspectRatio w="100%" mt="1%" ratio={3 / 2}>
              <Image src={"/index/proof-of-trust.png"} layout="fill" />
            </AspectRatio>
          </Flex>
        </Center>
      </Flex>
    </Flex>
  );
};

// Images are stored in the /public/index folder

export default index;
