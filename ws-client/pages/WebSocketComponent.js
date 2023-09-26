import React, { useEffect, useState } from "react";

export default function WebSocketComponent({ wsUrl }) {
  const [message, setMessage] = useState("");
  useEffect(() => {
    const ws = new WebSocket(wsUrl);

    ws.onmessage = (event) => {
      setMessage(event.data);
    };

    return () => {
      ws.close();
    };
  }, [wsUrl]);

  return (
    <div>
      <h1>WebSocket Component</h1>
      <h3>URL:{wsUrl}</h3>
      <p>Received message: {message}</p>
    </div>
  );
}
