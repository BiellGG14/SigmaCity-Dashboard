import { Inter, Outfit } from "next/font/google";
import "./globals.css";
import Navbar from "../components/Navbar";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });
const outfit = Outfit({ subsets: ["latin"], variable: "--font-outfit" });

export const metadata = {
  title: "SigmaCity Dashboard",
  description: "Dashboard interativo de análise de legislação - SigmaCity",
};

export default function RootLayout({ children }) {
  return (
    <html lang="pt-BR">
      <body className={`${inter.variable} ${outfit.variable}`}>
        <Navbar />
        <main style={{ paddingTop: '100px', minHeight: '100vh', paddingBottom: '40px' }}>
          {children}
        </main>
      </body>
    </html>
  );
}
