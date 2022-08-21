import React from "react";
import { AppProps } from "next/app";
import { ChakraProvider } from "@chakra-ui/provider";
import { extendTheme } from "@chakra-ui/react";
import { SWRConfig } from "swr";
import { fetcher } from "../utils/fetcher";
import NavBar from "../component/NavBar";

const theme = extendTheme({
  styles: {
    global: {
      "html, body": {
        // color: "textColour",
        background: "background" /* fallback for old browsers */,
        overscrollBehaviorY: "none",
      },
    },
  },
  colors: {
    background: "#FFF",
    subHover: "#ccced7",
    subColour: "white",
    textColour: "black",
    confirmColourMain: "#2545e3",
    confirmColourHover: "#505bec",
    confirmColourClick: "#1f289a",
  },
});

export default function App({ Component, pageProps }: AppProps) {
  return (
    <SWRConfig
      value={{
        fetcher(url) {
          return fetcher("GET", url).then((res) => res.data);
        },
        refreshInterval: 5 * 1000,
      }}
    >
      <ChakraProvider theme={theme}>
        <NavBar />
        <Component {...pageProps} />
      </ChakraProvider>
    </SWRConfig>
  );
}
