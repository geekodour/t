import { Hono } from "hono";
import { serve } from "@hono/node-server";

const app = new Hono();

app.get("/hello", (c) => {
  return c.json({
    message: "Hello, hola!",
  });
});

export default app;

serve(
  {
    fetch: app.fetch,
    port: 3000,
  },
  (info) => {
    console.log(`Server is running on http://localhost:${info.port}`);
  },
);
