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
          Sadly, you cannot currently create a wallet as the node software that
          will process any transactions and store the contents of your wallet is
          still in early enough development that I don't want anyone to start
          attaching anything of any kind of value to it. <br /> However, once I
          have a stable node that has been through a full and thorough testing
          phase, You will be able to create a wallet on this page, so that you
          can start using the MonoChain from a web browser!
        </Text>
      </Center>
    </Center>
  );
};

export default Wallet;
