import { CardDemo } from "./components/ui/cardform"
import { CalendarDemo } from "./components/ui/mycalendar"

function App() {
  return (
    <>
      <div className="flex flex-col items-center justify-center min-h-svh">
        <h1 className="text-2xl font-bold mb-4">Welcome to Vite UI</h1>
        <div className="grid grid-cols-2 gap-x-8 gap-y-1 mt-16">
          <CardDemo />
          <CalendarDemo />
        </div>
      </div>
    </>
  )
}

export default App
