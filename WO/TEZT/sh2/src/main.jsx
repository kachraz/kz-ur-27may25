import { ThemeProvider } from "@/components/theme-provider.jsx"
import { StrictMode } from "react"
import { createRoot } from "react-dom/client"
import App from "./App.jsx"
import "./index.css"

createRoot(document.getElementById("root")).render(
  <ThemeProvider defaultTheme="dark" storageKey="vite-ui-theme">
    <StrictMode>
      <App />
    </StrictMode>
  </ThemeProvider>
)
