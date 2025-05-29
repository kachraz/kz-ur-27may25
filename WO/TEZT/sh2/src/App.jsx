import { CardDemo } from "./components/ui/cardform"
import { CalendarDemo } from "./components/ui/mycalendar"

function App() {
  return (
    <>
      <div className="flex flex-col items-center justify-center min-h-svh">
        <h1 className="text-2xl font-bold mb-4">Welcome to Vite UI</h1>
        <CardDemo />
        <CalendarDemo />
        <p className="text-gray-600 mt-4">
          This is a simple example of a Vite application using Tailwind CSS and
          custom components.
        </p>
      </div>
    </>
  )
}

export default App
