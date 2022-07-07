import {
  Button,
  Drawer,
  DrawerBody,
  DrawerContent,
  DrawerHeader,
  DrawerOverlay,
  Flex,
  Text,
  useDisclosure,
} from "@chakra-ui/react";
import { NavBarCss } from "../styles/navBar";
import { scaling_button } from "../styles/buttons";
import React from "react";

const MobileNav = (props: { hidden?: boolean }) => {
  const {
    isOpen: menuOpen,
    onOpen: menuOnOpen,
    onClose: menuOnClose,
  } = useDisclosure();

  if (props.hidden) return null;
  return (
    <>
      <Flex
        css={NavBarCss}
        justifyContent={"space-between"}
        alignItems={"center"}
      >
        <Flex pl={2}>
          <Text>Home</Text>
        </Flex>
        <Button css={scaling_button()} onClick={menuOnOpen} px={3}>
          <Text m={2}>Menu</Text>
        </Button>
      </Flex>

      <Drawer placement="right" onClose={menuOnClose} isOpen={menuOpen}>
        <DrawerOverlay />
        <DrawerContent>
          <DrawerHeader
            borderBottomWidth="1px"
            flexDir={"row"}
            flexWrap={"wrap"}
            justifyContent={"space-between"}
          >
            <Text>Basic Drawer</Text>
            <Button css={scaling_button()} onClick={menuOnClose}>
              Close
            </Button>
          </DrawerHeader>
          <DrawerBody>
            <p>Some contents...</p>
            <p>Some contents...</p>
            <p>Some contents...</p>
          </DrawerBody>
        </DrawerContent>
      </Drawer>
    </>
  );
};

export default MobileNav;
