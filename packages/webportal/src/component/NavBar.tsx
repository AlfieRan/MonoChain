import {
    Button,
    Flex,
    Interpolation,
    Link,
    Collapse,
    Text,
    css,
} from "@chakra-ui/react";
import { Links } from "../utils/types";
import DevNavigation from "./Dev-navigation";
import React, { useState, useEffect } from "react";
import useWindowSize from "../utils/window";

const LinkHover: Interpolation<{}> = {
    background: "",
    color: "#4343dc",
};

const NavBar = () => {
    const [devShowing, setDevShowing] = useState<boolean>(false);

    const window = useWindowSize();
    const breakpoint = 700;

    const [mobile, setMobile] = useState<boolean>(true);
    const [showingMenu, setShowingMenu] = useState<boolean>(!mobile);

    useEffect(() => {
        if ((window.width || 0) < breakpoint) {
            setMobile(true);
        } else if ((window.width || 0) > breakpoint) {
            setMobile(false);
        }
        console.log(window.width, mobile, (window.width || 0) < breakpoint);
    }, [window.width]);

    const LinkMarginAmount = 6;
    const Links: Links[] = [
        { name: "Home", href: "/" },
        { name: "Learn More", href: "/info" },
        {
            name: "Developers",
            comp: DevNavigation,
            state: { change: setDevShowing, value: devShowing },
            type: "component",
        },
        { name: "Wallet", href: "/wallet" },
    ];

    return (
        <>
            <div hidden={mobile}>
                <Flex css={NavBarCss}>
                    {Links.map((data) => {
                        if (data.type === "component") {
                            return (
                                <Flex flexDir={"column"} key={data.name}>
                                    <Button
                                        bg={""}
                                        my={0}
                                        mx={LinkMarginAmount}
                                        p={0}
                                        _hover={LinkHover}
                                        _active={LinkHover}
                                        onClick={() => {
                                            data.state.change(
                                                !data.state.value
                                            );
                                        }}
                                    >
                                        <Text
                                            fontSize={"xl"}
                                            fontWeight={"normal"}
                                            h={"full"}
                                            w={"full"}
                                            lineHeight={"base"}
                                        >
                                            {data.name}
                                        </Text>
                                    </Button>
                                </Flex>
                            );
                        } else {
                            return (
                                <Link
                                    key={data.name}
                                    href={data.href}
                                    mx={LinkMarginAmount}
                                    isExternal={!!data.external}
                                    _hover={LinkHover}
                                >
                                    <Text fontSize={"xl"} h={"full"} w={"full"}>
                                        {data.name}
                                    </Text>
                                </Link>
                            );
                        }
                    })}
                </Flex>
                {Links.filter((item) => item.type === "component").map(
                    (data) => {
                        if (data.type === "component") {
                            return (
                                <Collapse
                                    key={data.name}
                                    in={data.state.value}
                                    dir="top"
                                >
                                    <data.comp />
                                </Collapse>
                            );
                        }
                    }
                )}
            </div>
            <div hidden={!mobile}>
                <Flex css={NavBarCss}>
                    <Text>Home</Text>
                </Flex>
            </div>
        </>
    );
};

export default NavBar;

const NavBarCss = css({
    w: "full",
    bg: "rgba(17,17,17,0.1)",
    justifyContent: "center",
    fontSize: "xl",
    px: 5,
    pb: 2,
    pt: 4,
});
