import { Links } from "../../utils/types";
import { Center, Link } from "@chakra-ui/react";

const DevNavigation = (props: { hidden?: boolean }) => {
  const LinkMarginAmount = 10;
  const values: Links[] = [
    {
      name: "Get in touch",
      href: "/contact",
    },
    {
      name: "Downloads",
      href: "/download",
    },
  ];

  if (props.hidden) return null;

  return (
    <Center
      p={3}
      flexDir={"row"}
      w={"full"}
      bg={"rgb(156,156,255)"}
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
