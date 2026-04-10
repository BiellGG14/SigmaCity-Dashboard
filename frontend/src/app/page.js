import Link from "next/link";
import styles from "./page.module.css";

const stats = [
  ["54", "documentos incluídos"],
  ["664", "itens identificados"],
  ["83", "diretrizes do Produto II"],
];

export default function Home() {
  return (
    <div className={styles.container}>
      <section className={styles.heroSection}>
        <div className={styles.heroCopy}>
          <span className="eyebrow">SigmaCity Dashboard</span>
          <h1>Inteligência analítica para legislação AAM e UAM</h1>
          <p>
            Consulte documentos normativos, critérios de seleção, análises PESTEL e diretrizes municipais em uma arquitetura moderna com R Plumber no backend e Next.js no frontend.
          </p>
          <div className={styles.actionGroup}>
            <Link href="/produto-i" className="button-primary">Explorar Produto I</Link>
            <Link href="/dashboard-pii" className="button-secondary">Abrir Produto II</Link>
          </div>
        </div>

        <div className={styles.heroVisual}>
          <div className={styles.logoStrip}>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src="/imagens/ita.png" alt="ITA" />
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src="/imagens/sigma.png" alt="Sigma" />
          </div>
          <div className={styles.statGrid}>
            {stats.map(([value, label]) => (
              <div key={label} className={styles.statCard}>
                <strong>{value}</strong>
                <span>{label}</span>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className={styles.featuresGrid} aria-label="Acessos principais">
        <FeatureCard
          title="Produto I"
          description="Inventário legislativo, contexto do projeto, objetivos, fundamentos PESTEL e análise detalhada dos documentos processados."
          href="/produto-i"
          label="Ver Produto I"
        />
        <FeatureCard
          title="Biblioteca Dinâmica"
          description="Acesse normas, portarias e regulamentos com resumo, estatísticas textuais, nuvens de palavras e radar PESTEL."
          href="/documentos"
          label="Explorar Biblioteca"
        />
        <FeatureCard
          title="Produto II"
          description="Explore temas, questões técnicas, diretrizes normativas e cobertura PESTEL para gestores municipais."
          href="/dashboard-pii"
          label="Abrir Dashboard PII"
        />
      </section>
    </div>
  );
}

function FeatureCard({ title, description, href, label }) {
  return (
    <article className={styles.featureCard}>
      <h3>{title}</h3>
      <p>{description}</p>
      <Link href={href} className={styles.cardLink}>{label}</Link>
    </article>
  );
}
