import Link from 'next/link';
import styles from './page.module.css';

export default function PortalPage() {
  return (
    <div className={styles.container}>
      {/* Hero Section */}
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
          <h1 className={styles.heroTitle}>Estudos para Aviação de Hoje e do Amanhã</h1>
          <p className={styles.heroSubtitle}>
            Explore os produtos desenvolvidos pelo projeto SigmaCity em parceria com a Secretaria de Aviação Civil (SAC) e o Instituto Tecnológico de Aeronáutica (ITA).
          </p>
        </div>
      </div>

      <h1 className={styles.produtosTitle}>Nossos Produtos</h1>

      {/* Grid de Produtos */}
      <div className={styles.produtosGrid}>
        
        {/* Produto I */}
        <div className={`glass-panel ${styles.produtoCard} ${styles.cardDisponivel}`}>
          <div className={`${styles.badge} ${styles.badgeDisponivel}`}>Disponível</div>
          <div className={styles.produtoNumero}>I</div>
          <h2 className={styles.produtoTitleText}>
            Inventário das legislações que exercem impacto nas operações de UAM (envolvendo eVTOL) no contexto do planejamento urbano
          </h2>
          <div className={styles.produtoAcoes}>
            <Link href="/" className={`${styles.btnPortal} ${styles.btnPrimary}`}>
              <span className={styles.btnIcon}>📊</span> Dashboard Interativo
            </Link>
            <Link href="/produtos/produto01" className={`${styles.btnPortal} ${styles.btnSecondary}`}>
              <span className={styles.btnIcon}>📄</span> Documento Completo
            </Link>
          </div>
          <div className={styles.produtoFooter}>
            📅 Entrega: Novembro 2025
          </div>
        </div>

        {/* Produto II */}
        <div className={`glass-panel ${styles.produtoCard} ${styles.cardAndamento}`}>
          <div className={`${styles.badge} ${styles.badgeAndamento}`}>Em Andamento</div>
          <div className={styles.produtoNumero}>II</div>
          <h2 className={styles.produtoTitleText}>
            Relatório de diretrizes e parâmetros normativos no âmbito da UAM com os requisitos legais estabelecidos
          </h2>
          <div className={styles.produtoAcoes}>
            <Link href="/dashboard-pii" className={`${styles.btnPortal} ${styles.btnWarning}`}>
               <span className={styles.btnIcon}>📊</span> Dashboard Interativo (PII)
            </Link>
            <Link href="/produtos/produto02" className={`${styles.btnPortal} ${styles.btnWarning}`}>
              <span className={styles.btnIcon}>📄</span> Documento Completo
            </Link>
            <Link href="/produtos/guam" className={`${styles.btnPortal} ${styles.btnWarning}`}>
               <span className={styles.btnIcon}>📘</span> Guia Ilustrativo GUAM
            </Link>
          </div>
          <div className={styles.produtoFooter}>
            ⏳ Previsão: Março 2026
          </div>
        </div>

        {/* Produto III */}
        <div className={`glass-panel ${styles.produtoCard} ${styles.cardDesenvolvimento}`}>
          <div className={`${styles.badge} ${styles.badgeDesenvolvimento}`}>Em Desenvolvimento</div>
          <div className={styles.produtoNumero}>III</div>
          <h2 className={styles.produtoTitleText}>
            Relatório abordando uma revisão da literatura sobre metodologias de integração de vertiportos
          </h2>
          <div className={styles.produtoAcoes}>
            <button className={`${styles.btnPortal} ${styles.btnDisabled}`} disabled>
              <span className={styles.btnIcon}>📄</span> Em Breve
            </button>
          </div>
          <div className={styles.produtoFooter}>
            ⏳ Previsão: 2026
          </div>
        </div>

        {/* Produto IV */}
        <div className={`glass-panel ${styles.produtoCard} ${styles.cardDesenvolvimento}`}>
          <div className={`${styles.badge} ${styles.badgeDesenvolvimento}`}>Em Desenvolvimento</div>
          <div className={styles.produtoNumero}>IV</div>
          <h2 className={styles.produtoTitleText}>
            Manual metodológico de integração estratégica de locais a sistemas municipais de mobilidade
          </h2>
          <div className={styles.produtoAcoes}>
            <button className={`${styles.btnPortal} ${styles.btnDisabled}`} disabled>
              <span className={styles.btnIcon}>📄</span> Em Breve
            </button>
          </div>
          <div className={styles.produtoFooter}>
            ⏳ Previsão: 2026
          </div>
        </div>

      </div>
    </div>
  );
}
