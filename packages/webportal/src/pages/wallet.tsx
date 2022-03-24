import { Center, Flex, Text } from "@chakra-ui/react";

const Wallet = () => {
  return (
    <Center
      w={"full"}
      h={"full"}
      textAlign={"center"}
      px={10}
      flexDir={"column"}
    >
      <Flex maxW={"3xl"} flexDir={"column"}>
        <Text fontSize={"3xl"} my={5}>
          Wallet
        </Text>
        <Text>
          This is the wallet page, I haven't made this yet but when it's
          finished you'll be able buy, sell and send data and digital items on
          the monochain
        </Text>
      </Flex>
    </Center>
  );
};

export default Wallet;
