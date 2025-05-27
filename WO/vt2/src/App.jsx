import { useState } from "react"
import "./App.css"
import gLogo from "./assets/g.svg"
import reactLogo from "./assets/react.svg"
import Footer from "./comps/footer"
import Header from "./comps/hea"
import viteLogo from "/vite.svg"

function App() {
  //env
  const greeting = import.meta.env.VITE_RAPE

  const [count, setCount] = useState(0)

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
      ASDASasdasdasd
      <Footer />
    </>
  )
}

export default App
