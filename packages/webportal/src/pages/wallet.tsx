import { Center, Flex, Text } from "@chakra-ui/react";
import { subTitle } from "../styles/text";

const Wallet = () => {
  return (
    <Center
      w={"full"}
      h={"80vh"}
      textAlign={"center"}
      px={10}
      flexDir={"column"}
    >
      <Center maxW={"3xl"} flexDir={"column"}>
        <Text css={subTitle("3")}>Wallet</Text>
        <Text>
          As soon as our full and thorough testing phase is completed you will
          be able to create a wallet on this page allowing you to begin using
          the MonoChain from a web browser.
        </Text>
      </Center>
    </Center>
  );
};

export default Wallet;
