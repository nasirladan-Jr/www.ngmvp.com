import type { Metadata } from "next";
import "./globals.css";
import Link from "next/link";
export const metadata: Metadata = { title: "NGMVP | Vote Protection", description: "The Next Generation Movement Vote Protection — civic election observation, incident reporting and voter education in Nigeria.", metadataBase: new URL("https://example.org") };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
 const ngmUrl = process.env.NEXT_PUBLIC_NGM_SITE_URL || "/movement";
 return <html lang="en"><body><header className="topbar"><Link href="/" className="brand"><span className="brandmark">NG</span><span><b>NGMVP</b><small>THE NEXT GENERATION MOVEMENT</small></span></Link><nav><Link href="/vote-protection">Vote Protection</Link><Link href="/report">Report an Incident</Link><Link href="/observer">Become an Observer</Link><a href={ngmUrl}>NGM Main Website ↗</a></nav></header>{children}<footer><div><b>NGMVP · The Next Generation Movement Vote Protection</b><p>Non-partisan civic participation. Observe peacefully. Report responsibly. Verify before sharing.</p></div><div className="footlinks"><Link href="/privacy">Privacy & Safety</Link><Link href="/movement">About NGM</Link></div><small>Independent reports are not official election results and are not automatically verified.</small></footer></body></html>;
}
