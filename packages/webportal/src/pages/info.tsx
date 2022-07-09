import { Box, Center, Flex, Text } from "@chakra-ui/react";
import React from "react";
import { bodyText, subTitle } from "../styles/text";

const Info = () => {
  return (
    <Center
      w={"100vw"}
      h={"full"}
      flexDir={"column"}
      textAlign={"center"}
      px={10}
      py={10}
      mb={20}
    >
      <Center maxW={"1400px"} flexDir={"column"}>
        <Center flexDir={"column"} maxW={"4xl"}>
          <Text css={subTitle("4")}>The MonoChain Project</Text>
          <Text css={bodyText}>
            The MonoChain is a decentralized network built upon the proof of
            trust consensus protocol, designed and built by Alfie Ranstead, a
            computer scientist with a strong interest in complex problems and
            their solutions. Blockchain technology is just a natural part of
            this group of technology, but it is far from perfect, that's why the
            proof of trust protocol - and this project - exist.
          </Text>
          <Text css={subTitle("2")}>What is the Proof of Trust Protocol?</Text>
          <Text css={bodyText}>
            The proof of trust protocol is a custom built consensus protocol
            built in order to define how nodes [computers that contribute to the
            network] decide how to trust or not trust other nodes. It uses a
            system of parameters used to store both grudges and appreciations
            for other nodes, alongside a few other values, which help decide
            whether or not to re-process whatever information other nodes have
            sent to it. A key addition here is that nodes will also choose to
            randomly reprocess data that they have received, in order to make
            sure that the seemingly "trustworthy" nodes are still actually
            trustworthy and haven't been tampered with.
          </Text>
          <Text css={subTitle("2")}>
            Why is the Proof of Trust Protocol important?
          </Text>
          <Text css={bodyText}>
            The two most used consensus protocols are currently 'proof of work'
            and 'proof of stake', both of these protocols are fundamentally
            flawed, and as such are not suitable for use in a widely adopted,
            decentralised system. <br /> The 'proof of work' protocol requires
            nearly all the nodes on the network to calculate the same data, only
            to reward a singular node for it per block, which is not only
            heavily favouring nodes comprised of more expensive hardware, but is
            also terrible for the environment by wasting massive amounts of
            energy. <br /> The 'proof of stake' protocol requires the nodes to
            put forward a large amount of money to be able to stake, which is
            more energy efficient, but extremely favouring of nodes that have
            large backings and kind of defeats the point of a decentralised
            system, as it just gives power to those who have money - which is
            against a lot of the ideas of the decentralised system. <br /> This
            is where proof of trust comes in, as it is a consensus protocol that
            is more energy efficient than 'proof of work', and although it is
            not as energy efficient as 'proof of stake', it does allow anyone to
            use and operate a node, removing the need for a large amount of
            money to be staked.
          </Text>
          <Text css={subTitle("2")}>So Why the MonoChain?</Text>
          <Text css={bodyText}>
            The MonoChain is being developed as proof that behind all the hype,
            buzzwords and roller-coaster like evaluations of decentralised
            technologies, that the technology can still be used for some cool
            stuff. This project is not aiming to be the newest trend in the tech
            world, but rather to be a proof of concept of how a new technology
            can still be useful and that it shouldn't be thrown away as just
            some get quick rich scheme. <br /> Oh also because I needed an
            A-Level Project and I thought it would be fun to do.
          </Text>
        </Center>
      </Center>
    </Center>
  );
};

export default Info;
