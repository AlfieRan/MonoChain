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
        Project Documentation
      </Text>
      <Flex flexDir={"column"} maxW={"3xl"}>
        <Text>
          The MonoChain stores all transactions and data in JSON format.
        </Text>
      </Flex>
    </Center>
  );
};

export default Info;
