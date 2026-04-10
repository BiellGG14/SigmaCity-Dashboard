import Link from "next/link";
import styles from "./page.module.css";

const produtos = [
  {
    numero: "I",
    status: "Disponível",
    statusClass: styles.badgeDisponivel,
    cardClass: styles.cardDisponivel,
    titulo: "Inventário das legislações que exercem impacto nas operações de UAM envolvendo eVTOL no contexto do planejamento urbano",
    entrega: "Entrega: Novembro 2025",
    acoes: [
      { href: "/produto-i", label: "Dashboard Interativo", className: styles.btnPrimary },
      { href: "/produtos/produto01", label: "Documento Completo", className: styles.btnSecondary },
    ],
  },
  {
    numero: "II",
    status: "Em Andamento",
    statusClass: styles.badgeAndamento,
    cardClass: styles.cardAndamento,
    titulo: "Relatório de diretrizes e parâmetros normativos no âmbito da UAM com os requisitos legais estabelecidos",
    entrega: "Previsão: Março 2026",
    acoes: [
      { href: "/dashboard-pii", label: "Dashboard Interativo (PII)", className: styles.btnWarning },
      { href: "/produtos/produto02", label: "Documento Completo", className: styles.btnWarning },
      { href: "/produtos/guam", label: "Guia Ilustrativo GUAM", className: styles.btnWarning },
    ],
  },
  {
    numero: "III",
    status: "Em Desenvolvimento",
    statusClass: styles.badgeDesenvolvimento,
    cardClass: styles.cardDesenvolvimento,
    titulo: "Relatório abordando uma revisão da literatura sobre metodologias de integração de vertiportos",
    entrega: "Previsão: 2026",
    acoes: [],
  },
  {
    numero: "IV",
    status: "Em Desenvolvimento",
    statusClass: styles.badgeDesenvolvimento,
    cardClass: styles.cardDesenvolvimento,
    titulo: "Manual metodológico de integração estratégica de locais a sistemas municipais de mobilidade",
    entrega: "Previsão: 2026",
    acoes: [],
  },
];

export default function PortalPage() {
  return (
    <div className={styles.container}>
      <div className={styles.heroSection}>
        <div className={styles.heroContent}>
          <div className={styles.logosHeader}>
            <a href="http://www.ita.br/" target="_blank" rel="noreferrer">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src="/imagens/ita.png" alt="ITA" />
            </a>
            <a href="https://sigma.ita.br" target="_blank" rel="noreferrer">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src="/imagens/sigma.png" alt="Sigma" />
            </a>
          </div>
          <span className={styles.heroEyebrow}>Portal de Produtos</span>
          <h1 className={styles.heroTitle}>Estudos para Aviação de Hoje e do Amanhã</h1>
          <p className={styles.heroSubtitle}>
            Explore os produtos desenvolvidos pelo projeto SigmaCity em parceria com a Secretaria de Aviação Civil (SAC) e o Instituto Tecnológico de Aeronáutica (ITA).
          </p>
        </div>
      </div>

      <section className={styles.productsSection}>
        <div className={styles.sectionHeader}>
          <span className="eyebrow">Produção técnica</span>
          <h2>Nossos Produtos</h2>
          <p>Relatórios, dashboards e materiais de apoio organizados por etapa de entrega.</p>
        </div>

        <div className={styles.produtosGrid}>
          {produtos.map((produto) => (
            <article key={produto.numero} className={`glass-panel ${styles.produtoCard} ${produto.cardClass}`}>
              <div className={styles.cardHeader}>
                <span className={`${styles.badge} ${produto.statusClass}`}>{produto.status}</span>
                <div className={styles.produtoNumero}>{produto.numero}</div>
              </div>

              <div className={styles.cardBody}>
                <h3 className={styles.produtoTitleText}>{produto.titulo}</h3>
              </div>

              <div className={styles.produtoAcoes}>
                {produto.acoes.length ? produto.acoes.map((acao) => (
                  <Link key={acao.href} href={acao.href} className={`${styles.btnPortal} ${acao.className}`}>
                    {acao.label}
                  </Link>
                )) : (
                  <button className={`${styles.btnPortal} ${styles.btnDisabled}`} disabled type="button">
                    Em Breve
                  </button>
                )}
              </div>

              <div className={styles.produtoFooter}>{produto.entrega}</div>
            </article>
          ))}
        </div>
      </section>
    </div>
  );
}
