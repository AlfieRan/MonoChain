import { Button, Flex, Interpolation, Link, Text } from "@chakra-ui/react";
import { Links } from "../utils/types";
import DevNavigation from "./Dev-navigation";
import { useState } from "react";

const LinkHover: Interpolation<{}> = {
  background: "",
  color: "#4343dc",
};

const NavBar = () => {
  const LinkMarginAmount = 6;
  const Links: Links[] = [
    { name: "Home", href: "/" },
    { name: "Learn More", href: "/info" },
    { name: "Developers", comp: DevNavigation, type: "component" },
    { name: "Wallet", href: "/wallet" },
  ];
  const [devShowing, setDevShowing] = useState<boolean>(false);

  return (
    <Flex
      w={"100vw"}
      bg={"rgba(17,17,17,0.1)"}
      justifyContent={"center"}
      fontSize={"xl"}
      px={5}
      pb={2}
      pt={4}
    >
      {Links.map((data) => {
        if (data.type === "component") {
          return (
            <Flex flexDir={"column"}>
              <Button
                key={data.name}
                bg={""}
                my={0}
                mx={LinkMarginAmount}
                p={0}
                _hover={LinkHover}
                _active={LinkHover}
                onClick={() => {
                  setDevShowing(!devShowing);
                }}
              >
                <Text
                  fontSize={"xl"}
                  fontWeight={"normal"}
                  h={"full"}
                  w={"full"}
                  lineHeight={"base"}
                >
                  {data.name}
                </Text>
              </Button>
              <data.comp hidden={!devShowing} />
            </Flex>
          );
        } else {
          return (
            <Link
              key={data.name}
              href={data.href}
              mx={LinkMarginAmount}
              isExternal={!!data.external}
              _hover={LinkHover}
            >
              <Text fontSize={"xl"} h={"full"} w={"full"}>
                {data.name}
              </Text>
            </Link>
          );
        }
      })}
    </Flex>
  );
};

export default NavBar;
