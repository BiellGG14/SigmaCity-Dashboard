import Link from "next/link";
import styles from "./page.module.css";

const objectives = [
  "Levantar normas, planos diretores, instrumentos urbanísticos e atos regulatórios que dialogam com infraestruturas UAM/eVTOL.",
  "Classificar legislações e instrumentos segundo fatores PESTEL, evidenciando restrições e condicionantes ao uso urbano-aeronáutico.",
  "Analisar impactos urbanos, ambientais e tecnológicos das exigências normativas sobre vertiportos, rotas e integração urbana.",
  "Avaliar aderência das legislações às demandas emergentes da mobilidade aérea urbana e apontar lacunas regulatórias.",
];

const pestel = [
  ["Político", "Autonomia regulatória, políticas públicas, sandbox regulatório, coordenação federativa e harmonização internacional.", "#004aad"],
  ["Econômico", "Custos, financiamento, atratividade para investimentos, integração multimodal e desenvolvimento de cadeia produtiva.", "#d88912"],
  ["Social", "Aceitação pública, acessibilidade, inclusão, ruído percebido, comunicação de risco e equidade no acesso.", "#20a464"],
  ["Tecnológico", "CNS/ATM, 5G/6G, vertiportos, recarga, gêmeos digitais e integração de sistemas operacionais.", "#2bb8c5"],
  ["Ambiental", "Pegada de carbono, poluição sonora, licenciamento, biodiversidade, rotas e integração ao planejamento urbano.", "#168a72"],
  ["Legal", "Hierarquia normativa, segurança jurídica, força vinculante e relação entre leis, decretos e atos administrativos.", "#123a63"],
];

export default function ProdutoIPage() {
  return (
    <div className={styles.container}>
      <section className={styles.hero}>
        <div>
          <span className="eyebrow">Produto I</span>
          <h1>Inventário legislativo para operações UAM envolvendo eVTOL</h1>
          <p>
            Conteúdo legado do dashboard Shiny consolidado em uma rota dedicada, com contexto do projeto, objetivos, fundamentos PESTEL e acesso à biblioteca processada pelo backend em R.
          </p>
          <div className={styles.actions}>
            <Link href="/documentos" className="button-primary">Ver documentos analisados</Link>
            <Link href="/legislacao" className="button-secondary">Abrir comparativo legal</Link>
          </div>
        </div>
        <div className={styles.heroImage}>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src="/imagens/PESTEL.png" alt="Diagrama PESTEL" />
        </div>
      </section>

      <section className={styles.contextGrid}>
        <article className={styles.panel}>
          <h2>Contexto do Projeto</h2>
          <p>
            O Produto I do projeto SigmaCity foi desenvolvido no âmbito da Meta 2 | Etapa 8 do Instituto Tecnológico de Aeronáutica (ITA), no TED n. 1525720240005-003882/2024 firmado entre a Secretaria de Aviação Civil (SAC) e o ITA.
          </p>
        </article>
        <article className={styles.panel}>
          <h2>Questão Norteadora</h2>
          <blockquote>
            Como identificar as legislações vigentes de planejamento urbano que impactam as operações UAM envolvendo eVTOL?
          </blockquote>
        </article>
      </section>

      <section className={styles.panel}>
        <div className={styles.sectionHeader}>
          <span className="eyebrow">Objetivo Geral</span>
          <h2>Identificar legislações vigentes de planejamento urbano que impactam operações UAM envolvendo eVTOL.</h2>
        </div>
        <div className={styles.objectiveGrid}>
          {objectives.map((objective, index) => (
            <div key={objective} className={styles.objectiveCard}>
              <strong>{String(index + 1).padStart(2, "0")}</strong>
              <p>{objective}</p>
            </div>
          ))}
        </div>
      </section>

      <section className={styles.panel}>
        <div className={styles.sectionHeader}>
          <span className="eyebrow">Ferramenta de Análise</span>
          <h2>Fatores PESTEL: definições e impactos na UAM</h2>
          <p>
            A ferramenta PESTEL organiza os condicionantes externos capazes de acelerar, limitar ou orientar a implementação da Mobilidade Aérea Urbana no Brasil.
          </p>
        </div>
        <div className={styles.pestelGrid}>
          {pestel.map(([title, description, color]) => (
            <article key={title} className={styles.pestelCard} style={{ "--accent": color }}>
              <h3>{title}</h3>
              <p>{description}</p>
            </article>
          ))}
        </div>
      </section>
    </div>
  );
}
