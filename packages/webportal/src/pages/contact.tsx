import { Center, Link, ListItem, Text, UnorderedList } from "@chakra-ui/react";
import { subTitle } from "../styles/text";

const Contact = () => {
    const contactInfo: { name: string; link: string }[] = [
        {
            name: "Email",
            link: "mailto:hi@alfieranstead.com",
        },
        {
            name: "Website",
            link: "https://alfieranstead.com",
        },
        {
            name: "Github",
            link: "https://github.com/alfieran",
        },
    ];
    return (
        <Center w={"100%"} h={"80vh"} flexDir={"column"} fontSize={"lg"}>
            <Text css={subTitle("3")}>Get in Touch</Text>
            <Center maxW={"700px"} flexDir={"column"}>
                <Text mb={3} textAlign={"center"}>
                    The creator and lead developer of this project is Alfie
                    Ranstead, who can be contacted via the links below:
                </Text>
                <UnorderedList flexDir={"column"}>
                    {contactInfo.map((info) => (
                        <ListItem key={info.name}>
                            <Link href={info.link} isExternal>
                                <Text>{info.name}</Text>
                            </Link>
                        </ListItem>
                    ))}
                </UnorderedList>
            </Center>
        </Center>
    );
};

export default Contact;
