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

const updatedDocuments = [
  { id: "ALERTAn001_2023", nome: "Alerta aos Operadores de Aeródromos nº 001/2023" },
  { id: "Artatel_915", nome: "Ato ANATEL 915/2024 - Faixas de frequências associadas ao Serviço Limitado Privado" },
  { id: "D6780", nome: "Decreto nº 6.780/2009 - Política Nacional de Aviação Civil (PNAC)" },
  { id: "D99274", nome: "Decreto nº 99.274/1990 - Regulamenta a Política Nacional do Meio Ambiente" },
  { id: "MCA 100-20", nome: "ICA (MCA 100-20) - Procedimentos Operacionais para o Uso de Vigilância Dependente Automática-Contrato (ADS-C) no ATS" },
  { id: "ICA_100-12", nome: "ICA 100-12 - Regras do Ar" },
  { id: "ICA_100-31", nome: "ICA 100-31 - Requisitos dos Serviços de Tráfego Aéreo" },
  { id: "ICA_100-36", nome: "ICA 100-36 - Processo de Solicitação para o Uso Especial do Espaço Aéreo" },
  { id: "ICA 100-40_06.06.23", nome: "ICA 100-4 - Regras e Procedimentos Especiais de Tráfego Aéreo para Helicópteros" },
  { id: "ICA_100-4", nome: "ICA 100-4 - Regras e Procedimentos Especiais de Tráfego Aéreo para Helicópteros" },
  { id: "ICA_11-3", nome: "ICA 11-3 - Processos da Área de Aeródromos" },
  { id: "ICA_11-408", nome: "ICA 11-408 - Restrições aos objetos projetados" },
  { id: "ICA_53-8", nome: "ICA 53-8 - Serviços de Informação Aeronáutica" },
  { id: "ICA_63-19", nome: "ICA 63-19 - Critérios de Análise Técnica da Área de Aeródromos" },
  { id: "IS161", nome: "IS 161 - Projeto de Monitoramento de Ruído" },
  { id: "L10098", nome: "Lei 10.098/2000 - Acessibilidade" },
  { id: "L10257", nome: "Lei 10.257/2001 - Estatuto da Cidade" },
  { id: "L10636", nome: "Lei 10.636/2002 - Recursos originários CIDE" },
  { id: "L11182", nome: "Lei 11.182/2005 - Cria a ANAC" },
  { id: "L12187", nome: "Lei 12.187/2009 - Política Nacional sobre Mudança do Clima (PNMC)" },
  { id: "L12587", nome: "Lei 12.587/2012 - Política Nacional de Mobilidade Urbana" },
  { id: "L13116", nome: "Lei 13.116/2015 - Compartilhamento da infraestrutura de telecomunicações" },
  { id: "L13146", nome: "Lei 13.146/2015 - Estatuto da Pessoa com Deficiência" },
  { id: "L13465", nome: "Lei 13.465/2017 - Regularização Fundiária" },
  { id: "L15190", nome: "Lei 15.190/2025 - Lei Geral do Licenciamento Ambiental" },
  { id: "L6766", nome: "Lei 6.766/1979 - Parcelamento do Solo Urbano" },
  { id: "L6938", nome: "Lei 6.938/1981 - Política Nacional do Meio Ambiente" },
  { id: "L7565", nome: "Lei 7.565/1986 - Código Brasileiro de Aeronáutica" },
  { id: "L8078compilado", nome: "Lei 8.078/1990 - Código de Defesa do Consumidor" },
  { id: "L9074CONSOL", nome: "Lei 9.074/1995 - Concessões e permissões de serviços públicos" },
  { id: "L9427consol", nome: "Lei 9.427/1996 - Institui a ANEEL" },
  { id: "L9472", nome: "Lei 9.472/1997 - Lei Geral de Telecomunicações" },
  { id: "L9503Compilado", nome: "Lei 9.503/1997 - Código de Trânsito Brasileiro" },
  { id: "L12651", nome: "Lei N° 12.651/2012 - Código Florestal" },
  { id: "L12725", nome: "Lei nº 12.725/2012 - Controle da fauna nas imediações de aeródromos" },
  { id: "L6902", nome: "Lei nº 6.902/1981 - Criação de Estações Ecológicas e Áreas de Proteção Ambiental" },
  { id: "L7661", nome: "Lei nº 7.661/1988 - Plano Nacional de Gerenciamento Costeiro (PNGC)" },
  { id: "L9605", nome: "Lei nº 9.605/1998 - Crimes Ambientais" },
  { id: "PCA_351-7", nome: "PCA 351-7 - Concepção Operacional UAM Nacional" },
  { id: "PL743", nome: "Projeto de Lei 743/2025" },
  { id: "RBAC135", nome: "RBAC 135 - Operações de serviço de transporte aéreo com helicópteros" },
  { id: "RBAC139", nome: "RBAC 139 - Certificação Operacional de Aeroportos" },
  { id: "RBAC155", nome: "RBAC 155 - Helipontos" },
  { id: "CEF_RBAC_161", nome: "RBAC 161 - Planos de Zoneamento de Ruído de Aeródromos" },
  { id: "RBAC161EMD04", nome: "RBAC 161 - Planos de Zoneamento de Ruído de Aeródromos" },
  { id: "RBAC 91 EMD 05", nome: "RBAC nº 91 - Requisitos gerais de operação para aeronaves civis" },
  { id: "ResANAC775", nome: "Resolução ANAC 775/2025 - Sandbox Regulatório" },
  { id: "RESOLUCAO No 736, 09_02_2024 - Agencia Nacional de Aviacao Civil ANAC", nome: "Resolução ANAC nº 736/2024 - Operadores de Aeródromo" },
  { id: "RESOLUCAO No 653, 20_12_2021 - Agencia Nacional de Aviacao Civil ANAC", nome: "Resolução ANATEL 653/2021" },
  { id: "ResCONAMA001", nome: "Resolução CONAMA 1/1986" },
  { id: "CONAMA_RES_CONS_1990_002", nome: "Resolução CONAMA nº 2/1990 - Programa SILÊNCIO" },
  { id: "ResCONAMA237", nome: "Resolução CONAMA nº 2/1990 - Programa SILÊNCIO" },
  { id: "ANEEL1000", nome: "Resolução Normativa ANEEL nº 1.000/2021 - Regras de Prestação do Serviço Público de Distribuição de Energia Elétrica" },
  { id: "RESOLUCAO NORMATIVA ANEEL N 1.059", nome: "Resolução Normativa Aneel nº 1.059/2023 - Regras de Microgeração e Minigeração Distribuída" },
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

      <section className={styles.documentsSection}>
        <h2>Documentos Atualizados</h2>
        <div className={styles.documentsPanel}>
          <h3>Total de {updatedDocuments.length} Documentos</h3>
          <div className={styles.documentsGrid}>
            {updatedDocuments.map((doc, index) => (
              <Link key={doc.id} href={`/documentos/${encodeURIComponent(doc.id)}`} className={styles.documentItem}>
                <span>{index + 1}.</span>
                <strong>{doc.nome}</strong>
              </Link>
            ))}
          </div>
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
