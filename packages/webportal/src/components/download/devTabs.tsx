import { AspectRatio, Button, Center, Flex, Text } from "@chakra-ui/react";
import { useState } from "react";
import Image from "next/image";

const CreateConfigFile = () => (
	<Center mx={"20px"} flexDir={"column"} textAlign={"center"}>
		<Text fontSize={"3xl"}>Setup a Node</Text>
		<Text>
			Once you've downloaded the node software or compiled it directly,
			you will need to setup a configuration file.
		</Text>
		<Text>
			The simplest way of doing this is by first running the program once
			with no config file.
		</Text>
		<Text mt={"5px"}>
			The program will then ask you if you wish to generate a new config
			file which can be accepted by typing 'y' and then pressing enter.
			This will generate the file under the path './monochain/config.json'
			in the same directory as the executable.
		</Text>
		<Text mt={"5px"}>
			Assuming you also do not have a keypair file, the program will then
			ask if you would like to generate a new keypair file which can be
			accepted by typing 'y' and then pressing enter. This will generate
			under the path "./monochain/keys.config" and can then be replaced
			with your own keypair if you already have one.
		</Text>
		<AspectRatio
			ratio={1032 / 540}
			maxW={"1000px"}
			w={"max(300px, 25vw)"}
			m={"10px"}
		>
			<Image src={"/download/config.png"} layout={"fill"} />
		</AspectRatio>
	</Center>
);

const SetupConfigFile = () => {
	return (
		<Center
			mx={"20px"}
			flexDir={"column"}
			textAlign={"center"}
			verticalAlign="middle"
		>
			<Text fontSize={"2xl"}>
				Changing the config file to match your node
			</Text>
			<Text mt="10px">
				You need the config file to match your node setup otherwise your
				node won't function properly. To do this you can only currently
				change the values in the generated config file manually.
			</Text>
		</Center>
	);
};

export default function DevTabs() {
	const [tabIndex, setTabIndex] = useState(0);
	const pages: { title: string; component: JSX.Element }[] = [
		{ title: "Create the Config File", component: <CreateConfigFile /> },
		{ title: "Editing the Config File", component: <SetupConfigFile /> },
	];

	return (
		<Flex
			w={"max(500px, 80vw)"}
			maxW={"1200px"}
			m={"10px"}
			flexDir={"column"}
			borderRadius={"xl"}
			bg={"rgba(100, 100, 255, 0.2)"}
		>
			<Flex w={"100%"} flexDir={"row"}>
				{pages.map((item, index) => (
					<Button
						key={item.title}
						p={"10px"}
						w={"100%"}
						h={"100%"}
						flexDir={"column"}
						alignItems={"center"}
						justifyContent={"center"}
						borderTopLeftRadius={index === 0 ? "xl" : "none"}
						borderTopRightRadius={
							index === pages.length - 1 ? "xl" : "none"
						}
						borderBottomRadius={"none"}
						bg={
							tabIndex === index
								? "transparent"
								: "rgba(100,100,255,0.2)"
						}
						transitionDuration={"0.15s"}
						_hover={{
							bg:
								tabIndex === index
									? "rgba(100,100,255,0.4)"
									: "rgba(100,100,255,0.3)",
						}}
						_active={{
							bg: "rgba(100,100,255,0.1)",
						}}
						onClick={() => setTabIndex(index)}
					>
						<Text fontSize={"2xl"} fontWeight={"semibold"}>
							{item.title}
						</Text>
					</Button>
				))}
			</Flex>
			<Flex w={"100%"} minH={"500px"} flexDir={"column"} p={"15px"}>
				{pages[tabIndex].component}
			</Flex>
		</Flex>
	);
}
