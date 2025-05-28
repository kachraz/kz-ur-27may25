// heaer component in react

export default function Header() {
  const ParaText =
    "This is a header component in React.\n It spans multiple lines. \n You can use it for detailed descriptions.  "

  return (
    <>
      <h1> Headers </h1>
      <p style={{ whiteSpace: "pre-line" }}>{ParaText}</p>
    </>
  )
}
