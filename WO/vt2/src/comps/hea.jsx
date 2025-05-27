// heaer component in react

export default function Header() {
  const ParaText = `
    This is a header component in React.
    It spans multiple lines.
    You can use it for detailed descriptions.
  `

  return (
    <>
      <h1> Headers </h1>
      <h3> {ParaText} </h3>
    </>
  )
}
