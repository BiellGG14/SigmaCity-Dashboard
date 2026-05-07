import Link from "next/link";
import styles from "./Navbar.module.css";

export default function Navbar() {
  return (
    <nav className={styles.navbar}>
      <div className={styles.navContainer}>
        <Link href="/portal" className={styles.brand}>
          <span className={styles.logoMark}>S</span>
          <span className={styles.logoText}>Sigma<span className={styles.logoHighlight}>City</span></span>
        </Link>

        <div className={styles.navLinks}>
          <Link href="/portal" className={styles.navItem}>Portal</Link>
          <Link href="/documentos" className={styles.navItem}>Biblioteca</Link>
          <Link href="/equipe" className={styles.navItem}>Equipe</Link>
        </div>
      </div>
    </nav>
  );
}
