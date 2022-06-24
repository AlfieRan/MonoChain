import {
  Button,
  Flex,
  Interpolation,
  Link,
  Collapse,
  Text,
  css,
  Center,
  Slide,
  Box,
} from "@chakra-ui/react";
import { Links } from "../utils/types";
import DevNavigation from "./Dev-navigation";
import React, { useState, useEffect } from "react";
import useWindowSize from "../utils/window";

const LinkHover: Interpolation<{}> = {
  background: "",
  color: "#4343dc",
};

const NavBar = () => {
  const [devShowing, setDevShowing] = useState<boolean>(false);

  const window = useWindowSize();
  const breakpoint = 700;

  const [mobile, setMobile] = useState<boolean>(true);
  const [showingMenu, setShowingMenu] = useState<boolean>(!mobile);

  const [shownInfo, setShownInfo] = useState<boolean>(true);
  const [showingInfo, setShowingInfo] = useState<boolean>(false);

  useEffect(() => {
    setShownInfo(localStorage.getItem("shownInfo") === "true");
    setShowingInfo(!shownInfo);
  }, [shownInfo]);

  function hideInfo() {
    setShowingInfo(false);
    setShownInfo(true);
    localStorage.setItem("shownInfo", "true");
  }

  useEffect(() => {
    if ((window.width || 0) < breakpoint) {
      setMobile(true);
    } else if ((window.width || 0) > breakpoint) {
      setMobile(false);
    }
    console.log(window.width, mobile, (window.width || 0) < breakpoint);
  }, [window.width]);

  const LinkMarginAmount = 6;
  const Links: Links[] = [
    { name: "Home", href: "/" },
    { name: "Learn More", href: "/info" },
    {
      name: "Developers",
      comp: DevNavigation,
      state: { change: setDevShowing, value: devShowing },
      type: "component",
    },
    { name: "Wallet", href: "/wallet" },
  ];

  return (
    <Box w={"100%"}>
      <div hidden={mobile}>
        <Flex css={NavBarCss}>
          {Links.map((data) => {
            if (data.type === "component") {
              return (
                <Flex flexDir={"column"} key={data.name}>
                  <Button
                    bg={""}
                    my={0}
                    mx={LinkMarginAmount}
                    p={0}
                    _hover={LinkHover}
                    _active={LinkHover}
                    onClick={() => {
                      data.state.change(!data.state.value);
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
        {Links.filter((item) => item.type === "component").map((data) => {
          if (data.type === "component") {
            return (
              <Collapse key={data.name} in={data.state.value} dir="top">
                <data.comp />
              </Collapse>
            );
          }
        })}
      </div>
      <div hidden={!mobile}>
        <Flex css={NavBarCss}>
          <Text>Home</Text>
        </Flex>
      </div>
      <Slide direction="bottom" in={showingInfo} style={{ zIndex: 10 }}>
        <Center
          bg={"#5b5be1"}
          color={"white"}
          p={3}
          fontSize={"lg"}
          flexWrap={"wrap"}
        >
          <Text flexDir={"column"} maxW={"700px"} textAlign={"left"}>
            Please be Aware That This Website is in Early Development and is not
            a Full Representation of the Final Project.
          </Text>
          <Button
            onClick={() => {
              hideInfo();
            }}
            bg={"rgba(0,0,0,0.2)"}
            _hover={{ bg: "rgba(0,0,0,0.4)" }}
            _active={{ bg: "rgba(0,0,0,0.2)" }}
            mx={2}
          >
            <Text>Close</Text>
          </Button>
        </Center>
      </Slide>
    </Box>
  );
};

export default NavBar;

const NavBarCss = css({
  w: "full",
  bg: "rgba(17,17,17,0.1)",
  justifyContent: "center",
  fontSize: "xl",
  px: 5,
  pb: 2,
  pt: 4,
});
