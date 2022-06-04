import express from "express";
import cors from "cors";

const api = express();
api.use(express.json());
api.use(cors({
    origin: false,
    credentials: true,
}))

const port = 8001 // this should be changed to abide by the config file at a later date.
const message = "Hello, world!";

api.get("/", (req: any, res: any) => {
    res.send(message);
});


(async () => {
    api.listen(port || 8001, () => {
        console.log(`server started at http://localhost:${port}`);
    });
})().catch((e) => {
    console.error(e);
});