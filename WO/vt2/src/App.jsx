import { useState } from "react"
import "./App.css"
import gLogo from "./assets/g.svg"
import reactLogo from "./assets/react.svg"
import Footer from "./comps/footer"
import Header from "./comps/hea"
import useIpAddress from "./comps/ipaddy"
import viteLogo from "/vite.svg"

function App() {
  //env
  const greeting = import.meta.env.VITE_RAPE

  const [count, setCount] = useState(0)

  // React Hookss have to be set at the top level of the component
  const ipAddress = useIpAddress()

  return (
    <>
      <Header />
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={gLogo} className="logo react" alt="React logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h3>Ur Ip {ipAddress}</h3>
      <h1>Vite + React</h1>
      <h2>{greeting}</h2>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
      <Footer />
    </>
  )
}

export default App
