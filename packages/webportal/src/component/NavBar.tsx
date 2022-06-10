import { Button, Flex, Link, Text } from "@chakra-ui/react";
import { Links } from "../utils/types";
import DevNavigation from "./Dev-navigation";
import { useState } from "react";

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
      px={5}
      py={2}
    >
      {Links.map((data) => {
        if (data.type === "component") {
          return (
            <Button
              key={data.name}
              onClick={() => {
                setDevShowing(!devShowing);
              }}
            >
              <Text>{data.name}</Text>
              <data.comp hidden={!devShowing} />
            </Button>
          );
        } else {
          return (
            <Link
              key={data.name}
              href={data.href}
              mx={LinkMarginAmount}
              fontSize={"xl"}
              isExternal={!!data.external}
            >
              {data.name}
            </Link>
          );
        }
      })}
    </Flex>
  );
};

export default NavBar;
