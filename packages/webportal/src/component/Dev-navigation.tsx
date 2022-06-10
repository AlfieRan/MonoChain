import { Links } from "../utils/types";
import { Center, Flex, Link } from "@chakra-ui/react";

const DevNavigation = (props: { hidden?: boolean }) => {
  const LinkMarginAmount = 3;
  const values: Links[] = [
    {
      name: "test",
      href: "/",
    },
  ];

  if (props.hidden) return null;

  return (
    <Center pos={"absolute"} p={3} flexDir={"column"}>
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
