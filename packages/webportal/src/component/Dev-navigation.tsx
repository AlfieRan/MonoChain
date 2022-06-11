import { Links } from "../utils/types";
import { Center, Link } from "@chakra-ui/react";

const DevNavigation = (props: { hidden?: boolean }) => {
  const LinkMarginAmount = 3;
  const values: Links[] = [
    {
      name: "Download",
      href: "/download",
    },
  ];

  if (props.hidden) return null;

  return (
    <Center
      p={3}
      flexDir={"row"}
      w={"full"}
      bg={"#c0c0c0"}
      borderBottomRadius={"md"}
    >
      {values.map((value) => {
        if (value.type === "component") {
          return;
        } else {
          return (
            <Link
              key={value.name}
              href={value.href}
              mx={LinkMarginAmount}
              fontSize={"xl"}
              isExternal={!!value.external}
            >
              {value.name}
            </Link>
          );
        }
      })}
    </Center>
  );
};

export default DevNavigation;
