import { css } from "@chakra-ui/react";

export const subTitle = (size?: "4" | "3" | "2" | "1") => {
  const fontSize = size || "2";
  return css({
    fontSize: `var(--chakra-fontSizes-${fontSize}xl)`,
    mt: `var(--chakra-sizes-10)`,
    textAlign: "center",
    fontWeight: "bold",
  });
};

export const bodyText = css({
  textAlign: "center",
});
