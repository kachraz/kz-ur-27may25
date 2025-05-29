import { Button } from "@/components/ui/button"
import { Card } from "./components/ui/card"

function App() {
  return (
    <>
      <div className="flex flex-col items-center justify-center min-h-svh">
        <h1 className="text-2xl font-bold mb-4">Welcome to Vite UI</h1>
        <Button>Click me</Button>
        <Card className="w-96">
          <Card.Header>
            <Card.Title>Card Title</Card.Title>
            <Card.Description>
              This is a description of the card.
            </Card.Description>
          </Card.Header>
          <Card.Content>
            <p>This is the main content of the card.</p>
          </Card.Content>
          <Card.Footer>
            <Button variant="outline">Action</Button>
          </Card.Footer>
        </Card>
      </div>
    </>
  )
}

export default App
