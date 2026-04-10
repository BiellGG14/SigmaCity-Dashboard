import Link from 'next/link';
import styles from './Navbar.module.css';

export default function Navbar() {
  return (
    <nav className={styles.navbar}>
      <div className={styles.navContainer}>
        <Link href="/" className={styles.brand}>
          {/* O logo real será adicionado dps, usando um placeholder com o nome */}
          <span className={styles.logoText}>Sigma<span className={styles.logoHighlight}>City</span></span>
        </Link>
        
        <div className={styles.navLinks}>
          <Link href="/documentos" className={styles.navItem}>
            Biblioteca
          </Link>
          <Link href="/legislacao" className={styles.navItem}>
            Legislação
          </Link>
          <Link href="/equipe" className={styles.navItem}>
            Equipe
          </Link>
        </div>
        
        <div className={styles.navActions}>
          <a href="https://sigma.ita.br" target="_blank" rel="noreferrer" className={styles.primaryButton}>
            Portal ITA
          </a>
        </div>
      </div>
    </nav>
  );
}
