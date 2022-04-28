import { Flex, Link } from "@chakra-ui/react";

const NavBar = () => {
  const LinkMarginAmount = 2;
  const Links: { name: string; href: string; external?: boolean }[] = [
    { name: "Home", href: "/" },
    { name: "Project", href: "/info" },
    {
      name: "Code",
      href: "https://github.com/AlfieRan/A-Level-Project",
      external: true,
    },
    { name: "Wallet", href: "/wallet" },
    { name: "Download", href: "/download" },
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
          isExternal={data.external ? true : false}
        >
          {data.name}
        </Link>
      ))}
    </Flex>
  );
};

export default NavBar;
