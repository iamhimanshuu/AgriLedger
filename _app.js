import "@/styles/globals.css";

import { TrackingProvider } from "@/Context/Tracking.js";
import { Navbar, Footer} from "@/Components";

export default function App({ Component, pageProps }) {
  return (
      <TrackingProvider>
      <Navbar />
      <Component {...pageProps} />
      <Footer />
      </TrackingProvider>

  );
}
