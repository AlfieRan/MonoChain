import {Box, Center, Flex, Text} from "@chakra-ui/react";
import React from "react";

const index = () => {
  return (
    <Center w={"100vw"} h={"full"} flexDir={"column"} color={"black"} px={10} textAlign={"center"}>
      <Text fontSize={"4xl"} my={5} textAlign={"center"}>MonoChain</Text>
      <Flex flexDir={"column"} maxW={"3xl"}>
      <Text>
        A blockchain based around the JSON format, allowing you to store and own any data that can be stored
        in a javascript object.
      </Text><Text mt={5}>
        This means that not only can MonoChain support small transactional data, but can also be used for large data storage.
      </Text>
      </Flex>
    </Center>
  )
}

export default index;