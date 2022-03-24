import { Flex, Link } from "@chakra-ui/react";

const NavBar = () => {
  const LinkMarginAmount = 2;
  const Links: { name: string; href: string }[] = [
    { name: "Home", href: "/" },
    { name: "Info", href: "/info" },
    { name: "Code", href: "https://github.com/AlfieRan/A-Level-Project" },
    { name: "Wallet", href: "/wallet" },
  ];

  return (
    <Flex
      w={"100vw"}
      bg={"rgba(17,17,17,0.1)"}
      justifyContent={"center"}
      px={5}
    >
      {Links.map((data) => (
        <Link
          key={data.name}
          href={data.href}
          mx={LinkMarginAmount}
          fontSize={"xl"}
        >
          {data.name}
        </Link>
      ))}
    </Flex>
  );
};

export default NavBar;
