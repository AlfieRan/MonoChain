import {
  AspectRatio,
  Center,
  Flex,
  Grid,
  GridItem,
  Link,
  Spacer,
  Text,
} from "@chakra-ui/react";
import Image from "next/image";
import React from "react";

const index = () => {
  const gridItems: gridItemProps[] = [
    {
      link: "/wallet",
      title: "Wallet",
      subtitle: "Create and manage your wallet.",
    },
    {
      link: "/info",
      title: "Learn More",
      subtitle: "Learn more about the MonoChain.",
    },
    {
      link: "/download",
      title: "Setup a Node",
      subtitle:
        "Download a node to support the MonoChain in exchange for a fee.",
    },
    {
      link: "https://github.com/AlfieRan/A-Level-Project",
      title: "View the Code",
      subtitle: "View the open source code for the default Node and webportal.",
    },
  ];

  return (
    <Flex flexDir="column" pb={"100px"}>
      <AspectRatio maxH="5%" ratio={5 / 1}>
        <Image src="/index/nodes-banner.png" layout="fill" priority />
      </AspectRatio>
      <Flex
        w={"100vw"}
        h={"full"}
        flexDir={"column"}
        color={"black"}
        px={2}
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
            <Flex
              fontSize={"lg"}
              flexDir="column"
              p="3%"
              textAlign={["center", "right"]}
            >
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
        <Spacer />
        <Center flexDir={"column"} width={"100%"}>
          <Text fontSize={"2xl"} mb="10px" fontWeight={"semibold"}>
            Use the Monochain
          </Text>
          <Center w={"100%"} overflow={"hidden"} textAlign={"center"}>
            <Grid gridTemplateColumns={["repeat(1, 1fr)", "repeat(2, 1fr)"]}>
              {gridItems.map((item) => (
                <GridItem
                  key={item.title}
                  m={2}
                  maxW={"100%"}
                  w={["4xs", "md"]}
                  h={["2xs", "xs"]}
                >
                  <Link
                    href={item.link}
                    _hover={{ textDecoration: "none" }}
                    w={"100%"}
                    h={"100%"}
                  >
                    <Center
                      w={"100%"}
                      h={"100%"}
                      p={2}
                      bg={"rgba(100,100,255,0.2)"}
                      transitionDuration={"0.15s"}
                      _hover={{
                        bg: "rgba(100,100,255,0.3)",
                        transform: "scale(1.03)",
                      }}
                      _active={{
                        bg: "rgba(100,100,255,0.1)",
                        transform: "scale(0.97)",
                      }}
                      borderRadius={"xl"}
                      flexDir={"column"}
                    >
                      <Text fontSize={"2xl"} fontWeight={"semibold"}>
                        {item.title}
                      </Text>
                      <Text fontSize={"lg"}>{item.subtitle}</Text>
                    </Center>
                  </Link>
                </GridItem>
              ))}
            </Grid>
          </Center>
        </Center>
      </Flex>
    </Flex>
  );
};

type gridItemProps = {
  link: string;
  title: string;
  subtitle: string;
};

// Images are stored in the /public/index folder
export default index;
