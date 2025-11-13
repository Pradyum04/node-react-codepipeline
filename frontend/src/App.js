import React, { useEffect, useState } from "react";

function App() {
  const [message, setMessage] = useState("");

  useEffect(() => {
    fetch("http://localhost:5000/api/hello")
      .then(res => res.json())
      .then(data => setMessage(data.message))
      .catch(err => console.error("Error fetching:", err));
  }, []);
  

  return (
    <div style={{ textAlign: "center", marginTop: "50px" }}>
      <h1>Hello from React!</h1>
      <h2>{message}</h2>
    </div>
  );
}

export default App;
