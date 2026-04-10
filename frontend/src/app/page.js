import Link from 'next/link';
import styles from './page.module.css';

export default function Home() {
  return (
    <div className={styles.container}>
      <div className={styles.heroSection}>
        <div className={styles.heroContent}>
          <h1 className="title-gradient animate-fade-in-up">
            Inteligência Analítica em Legislação AAM
          </h1>
          <p className={`${styles.subtitle} animate-fade-in-up`} style={{ animationDelay: '0.1s' }}>
            Plataforma avançada de consolidação e análise da legislação de Advanced Air Mobility (AAM), projetada para simplificar a tomada de decisão através de dados interativos.
          </p>
          <div className={`${styles.actionGroup} animate-fade-in-up`} style={{ animationDelay: '0.2s' }}>
            <Link href="/documentos" className={styles.primaryBtn}>
              Acessar Biblioteca
            </Link>
            <Link href="/legislacao" className={styles.secondaryBtn}>
              Painel Comparativo
            </Link>
          </div>
        </div>
      </div>

      <div className={styles.featuresGrid}>
        <div className={`glass-panel ${styles.featureCard} animate-fade-in-up`} style={{ animationDelay: '0.3s' }}>
          <div className={styles.cardIcon}>📄</div>
          <h3>Biblioteca Dinâmica</h3>
          <p>Acesse centenas de normas, portarias e regulamentos RBAC/ICA. Inclui análise semântica e Extração de Entidades Nomeadas (NER).</p>
          <Link href="/documentos" className={styles.cardLink}>Explorar Documentos ➔</Link>
        </div>

        <div className={`glass-panel ${styles.featureCard} animate-fade-in-up`} style={{ animationDelay: '0.4s' }}>
          <div className={styles.cardIcon}>⚖️</div>
          <h3>Tabelas de Legislação</h3>
          <p>Consulte critérios de Elegibilidade, Identificação e Inclusão para cenários específicos de AAM em uma interface fluída.</p>
          <Link href="/legislacao" className={styles.cardLink}>Ver Comparativos ➔</Link>
        </div>

        <div className={`glass-panel ${styles.featureCard} animate-fade-in-up`} style={{ animationDelay: '0.5s' }}>
          <div className={styles.cardIcon}>👥</div>
          <h3>Time de Especialistas</h3>
          <p>Conheça os pesquisadores e profissionais por trás da estruturação do conhecimento legal aeroespacial do projeto.</p>
          <Link href="/equipe" className={styles.cardLink}>Ver Equipe ➔</Link>
        </div>
      </div>
    </div>
  );
}
