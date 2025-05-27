// get Ip address

import { useEffect, useState } from "react"

export default function useIpAddress() {
  const [ipAddress, setIpAddress] = useState("")

  useEffect(() => {
    fetch(`${import.meta.env.VITE_API_URL}?format=json`)
      .then((response) => response.json())
      .then((data) => {
        setIpAddress(data.ip)
      })
      .catch((error) => {
        console.error("Error fetching IP address:", error)
      })
  }, [])

  return ipAddress
}
