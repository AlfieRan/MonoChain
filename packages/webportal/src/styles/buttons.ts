import { css } from "@chakra-ui/react";

export const scaling_button = (props?: any) =>
  css({
    p: 2,
    m: 2,
    bg: "rgba(100,100,255,0.2)",
    transitionDuration: "0.15s",
    _hover: {
      bg: "rgba(100,100,255,0.3)",
      transform: "scale(1.03)",
      textDecoration: "none",
    },
    _active: {
      bg: "rgba(100,100,255,0.1)",
      transform: "scale(0.97)",
    },
    borderRadius: "5px",
    flexDir: "column",
    ...props,
  });

export const download_button = css(
  scaling_button({
    w: "250px",
    fontSize: "20px",
  })
);
