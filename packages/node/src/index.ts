// import required web server modules
import express from "express";
import cors from "cors";

// create the web server and configure it to allow all cors connections
// and that connections should include credentials if they have any
const api = express();
api.use(express.json());
api.use(
  cors({
    origin: false,
    credentials: true,
  })
);

// setup some initial constants
const port = 8001; // this should be changed to abide by the config file at a later date.
const message = "Hello, world!";

// set the message to be delivered to any connection request
api.get("/", (req: any, res: any) => {
  res.send(message);
});

// start the server and log in the console if anything has gone wrong.
(async () => {
  api.listen(port || 8001, () => {
    console.log(`server started at http://localhost:${port}`);
  });
})().catch((e) => {
  console.error(e);
});
