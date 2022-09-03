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
  Drawer,
  useDisclosure,
  DrawerOverlay,
  DrawerContent,
  DrawerCloseButton,
  DrawerHeader,
  DrawerBody,
  DrawerFooter,
} from "@chakra-ui/react";
import { Links } from "../utils/types";
import DevNavigation from "./Dev-navigation";
import React, { useState, useEffect, useRef } from "react";
import useWindowSize from "../utils/window";
import { scaling_button } from "../styles/buttons";
import { NavBarCss } from "../styles/navBar";
import MobileNav from "./MobileNav";

const LinkHover: Interpolation<{}> = {
  background: "",
  color: "#4343dc",
};

const NavBar = () => {
  const [devShowing, setDevShowing] = useState<boolean>(false);

  const window = useWindowSize();
  const breakpoint = 700;

  const navbarRef = useRef(null);
  const [navbarHeight, setNavbarHeight] = useState<number | null>(null);

  const [mobile, setMobile] = useState<boolean>(true);

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
  }, [window.width]);

  useEffect(() => {
    setNavbarHeight((navbarRef.current ?? { clientHeight: null }).clientHeight);
  }, [navbarHeight]);

  const LinkMarginAmount = 6;
  const Links: Links[] = [
    { name: "Home", href: "/" },
    { name: "Learn More", href: "/info" },
    {
      name: "Contribute",
      comp: DevNavigation,
      state: { change: setDevShowing, value: devShowing },
      type: "component",
    },
    { name: "Wallet", href: "/wallet" },
  ];

  return (
    <>
      <Box
        w={"100%"}
        position={"fixed"}
        zIndex={1000}
        ref={navbarRef}
        color={"white"}
      >
        <div hidden={mobile}>
          <Flex css={NavBarCss} justifyContent={"center"}>
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
                        pt={1.5}
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
                    <Text fontSize={"xl"} h={"full"} w={"full"} pt={1.5}>
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
        <MobileNav hidden={!mobile} />
        <Slide direction="bottom" in={showingInfo} style={{ zIndex: 10 }}>
          <Center
            bg={"#5b5be1"}
            color={"white"}
            p={3}
            fontSize={"lg"}
            flexWrap={"wrap"}
          >
            <Text flexDir={"column"} maxW={"700px"} textAlign={"left"}>
              Please be aware that this website is in early development and is
              not a full representation of the final project.
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
      <Box h={`${(navbarHeight ?? 45) - 10}px`} />
    </>
  );
};

export default NavBar;
