import {
  Button,
  Drawer,
  DrawerBody,
  DrawerContent,
  DrawerFooter,
  DrawerHeader,
  DrawerOverlay,
  Flex,
  Link,
  Text,
  useDisclosure,
} from "@chakra-ui/react";
import { NavBarCss } from "../../styles/navBar";
import { scaling_button } from "../../styles/buttons";
import React from "react";

const MobileNav = (props: { hidden?: boolean }) => {
  const Links: { name: string; href: string }[] = [
    { name: "Home", href: "/" },
    { name: "Wallet", href: "/wallet" },
    { name: "Setup a Node", href: "/download" },
    { name: "Learn More", href: "/info" },
    { name: "Contact", href: "/contact" },
  ];

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
        <Flex css={scaling_button()} pl={2}>
          <Link _hover={{ textDecoration: "none" }} href={"/"}>
            <Text m={2}>Home</Text>
          </Link>
        </Flex>
        <Button css={scaling_button()} onClick={menuOnOpen} px={3}>
          <Text m={2}>Menu</Text>
        </Button>
      </Flex>

      <Drawer placement="right" onClose={menuOnClose} isOpen={menuOpen}>
        <DrawerOverlay />
        <DrawerContent>
          <DrawerHeader borderBottomWidth="2px">
            <Flex
              dir={"row"}
              w={"100%"}
              justifyContent={"space-between"}
              alignItems={"center"}
            >
              <Text>MonoChain</Text>
              <Button css={scaling_button()} onClick={menuOnClose}>
                X
              </Button>
            </Flex>
          </DrawerHeader>
          <DrawerBody>
            {Links.map((linkObj) => (
              <Link
                href={linkObj.href}
                _hover={{ textDecoration: "none" }}
                key={linkObj.name}
              >
                <Flex
                  borderWidth={"2px"}
                  borderRadius={"lg"}
                  my={3}
                  p={2}
                  fontSize={"lg"}
                  bg={"rgba(0,0,0,0.1)"}
                  _active={{ bg: "rgba(0,0,0,0.2)" }}
                >
                  <Text>{linkObj.name}</Text>
                </Flex>
              </Link>
            ))}
          </DrawerBody>
          <DrawerFooter>
            <Link href={"https://alfieranstead.com"} _hover={{}} isExternal>
              <Text>By Alfie Ranstead</Text>
            </Link>
          </DrawerFooter>
        </DrawerContent>
      </Drawer>
    </>
  );
};

export default MobileNav;
