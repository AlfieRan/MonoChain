import { Box, Center, Flex, Text } from "@chakra-ui/react";
import React from "react";

const Info = () => {
  return (
    <Center
      w={"100vw"}
      h={"full"}
      flexDir={"column"}
      textAlign={"center"}
      px={10}
    >
      <Text fontSize={"3xl"} my={5} textAlign={"center"}>
        Info
      </Text>
      <Flex flexDir={"column"} maxW={"3xl"}>
        <Text>
          The MonoChain stores all transactions and data in JSON format.
        </Text>
        <Text mt={5}>
          This means that not only does the MonoChain support cryptocurrencies
          and traditional nfts (links to images stored on other external
          databases and servers), but also ownership certificates from other
          sites if they choose to support MonoChain.
        </Text>
        <Text mt={5}>
          This would allow for other, external sites, that have nothing to do
          with the MonoChain, to build their entire storage directories on the
          MonoChain, provided they are willing to run their own nodes on the
          network to process their transactions, or pay fees to willing nodes to
          run these stores of data instead.
        </Text>
      </Flex>
    </Center>
  );
};

export default Info;
