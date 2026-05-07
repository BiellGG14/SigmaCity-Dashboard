"use client";

import { useMemo, useState } from "react";
import styles from "./page.module.css";

const sourceLabels = ["Normativo", "Científico", "Internacional"];

function normalizeText(value) {
  return String(value || "");
}

function normalizeSources(fontes) {
  if (Array.isArray(fontes)) {
    return fontes.filter(Boolean);
  }

  return fontes ? [fontes] : [];
}

export default function Produto2Dashboard({ data }) {
  const [activeView, setActiveView] = useState("visao");
  const [selectedThemeId, setSelectedThemeId] = useState(data.temas?.[0]?.id);
  const [query, setQuery] = useState("");
  const [sourceIndex, setSourceIndex] = useState(0);

  const temas = useMemo(() => data.temas || [], [data.temas]);
  const selectedTheme = temas.find((tema) => tema.id === selectedThemeId) || temas[0];

  const questions = useMemo(() => {
    const allQuestions = temas.flatMap((tema) => (
      (tema.questoes || []).map((questao) => ({ ...questao, temaId: tema.id, temaNome: tema.nome, temaCor: tema.cor }))
    ));

    if (!query.trim()) {
      return allQuestions;
    }

    const term = query.toLowerCase();
    return allQuestions.filter((questao) => (
      normalizeText(questao.txt).toLowerCase().includes(term) ||
      normalizeText(questao.dir).toLowerCase().includes(term) ||
      normalizeText(questao.temaNome).toLowerCase().includes(term)
    ));
  }, [query, temas]);

  return (
    <div className={styles.container}>
      <header className={styles.hero}>
        <span className={styles.kicker}>Sigma City - Produto II</span>
        <h1>Diretrizes para a Mobilidade Aérea Urbana</h1>
        <p>
          Análise integrada dos desafios técnicos, regulatórios, ambientais e socioeconômicos para orientar gestores municipais na implementação da UAM no Brasil.
        </p>
        <div className={styles.heroStats}>
          <div><strong>{temas.length}</strong><span>Temas</span></div>
          <div><strong>{data.total_questoes}</strong><span>Questões</span></div>
        </div>
      </header>

      <nav className={styles.viewTabs} aria-label="Navegação do Produto II">
        {[
          ["visao", "Visão Geral"],
          ["temas", "Temas"],
          ["questoes", "Questões"],
          ["pestel", "PESTEL"],
        ].map(([id, label]) => (
          <button key={id} type="button" className={activeView === id ? styles.activeTab : ""} onClick={() => setActiveView(id)}>
            {label}
          </button>
        ))}
      </nav>

      {activeView === "visao" ? (
        <Overview temas={temas} data={data} sourceIndex={sourceIndex} setSourceIndex={setSourceIndex} onSelectTheme={(id) => {
          setSelectedThemeId(id);
          setActiveView("temas");
        }} />
      ) : null}

      {activeView === "temas" && selectedTheme ? (
        <ThemeDetail theme={selectedTheme} temas={temas} setSelectedThemeId={setSelectedThemeId} />
      ) : null}

      {activeView === "questoes" ? (
        <QuestionsPanel questions={questions} query={query} setQuery={setQuery} setSelectedThemeId={setSelectedThemeId} />
      ) : null}

      {activeView === "pestel" ? (
        <PestelMatrix data={data} sourceIndex={sourceIndex} setSourceIndex={setSourceIndex} />
      ) : null}
    </div>
  );
}

function Overview({ temas, data, sourceIndex, setSourceIndex, onSelectTheme }) {
  return (
    <>
      <section className={styles.summaryGrid}>
        {temas.map((tema) => (
          <button key={tema.id} type="button" className={styles.summaryCard} style={{ "--accent": tema.cor }} onClick={() => onSelectTheme(tema.id)}>
            <span>{tema.nome}</span>
          </button>
        ))}
      </section>

      <section className={styles.contentPanel}>
        <h2>Questão Norteadora</h2>
        <blockquote>
          Quais são as diretrizes para que gestores municipais possam planejar e regular a Mobilidade Aérea Urbana com aeronaves eVTOL no território brasileiro?
        </blockquote>
        <h3>Objetivo Geral</h3>
        <p>
          Consolidar diretrizes normativas, científicas e internacionais capazes de orientar administrações municipais na preparação do ambiente regulatório, territorial, tecnológico e ambiental necessário para a implementação segura e equitativa da Mobilidade Aérea Urbana.
        </p>
      </section>

      <PestelMatrix data={data} sourceIndex={sourceIndex} setSourceIndex={setSourceIndex} compact />
    </>
  );
}

function ThemeDetail({ theme, temas, setSelectedThemeId }) {
  return (
    <section className={styles.contentPanel}>
      <div className={styles.themePicker}>
        {temas.map((tema) => (
          <button key={tema.id} type="button" className={tema.id === theme.id ? styles.selectedChip : ""} onClick={() => setSelectedThemeId(tema.id)}>
            {tema.nome}
          </button>
        ))}
      </div>

      <div className={styles.themeHeader} style={{ "--accent": theme.cor }}>
        <h2>{theme.nome}</h2>
        <p>{theme.desc}</p>
      </div>

      <div className={styles.questionGrid}>
        {(theme.questoes || []).map((questao) => (
          <QuestionCard key={questao.qid} question={{ ...questao, temaNome: theme.nome, temaCor: theme.cor }} />
        ))}
      </div>
    </section>
  );
}

function QuestionsPanel({ questions, query, setQuery }) {
  return (
    <section className={styles.contentPanel}>
      <div className={styles.searchBar}>
        <input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Buscar questão, diretriz ou tema..." />
        <span>{questions.length} resultados</span>
      </div>
      <div className={styles.questionGrid}>
        {questions.map((question) => (
          <QuestionCard key={`${question.temaId}-${question.qid}`} question={question} />
        ))}
      </div>
    </section>
  );
}

function QuestionCard({ question }) {
  const fontes = normalizeSources(question.fontes);

  return (
    <article className={styles.questionCard} style={{ "--accent": question.temaCor }}>
      <span>{question.temaNome} - {question.qid}</span>
      <h3>{question.txt}</h3>
      <p>{question.dir}</p>
      {fontes.length ? (
        <div className={styles.sourceList}>
          {fontes.map((fonte) => <small key={fonte}>{fonte}</small>)}
        </div>
      ) : null}
    </article>
  );
}

function PestelMatrix({ data, sourceIndex, setSourceIndex, compact = false }) {
  const temas = data.temas || [];
  const fatores = data.fatores || [];
  const coverage = data.pestel_cov || {};

  return (
    <section className={`${styles.contentPanel} ${compact ? styles.compactPanel : ""}`}>
      <div className={styles.panelHeader}>
        <div>
          <h2>Tema x Fator PESTEL</h2>
          <p>Selecione a dimensão de análise.</p>
        </div>
        <div className={styles.sourceTabs}>
          {sourceLabels.map((label, index) => (
            <button key={label} type="button" className={sourceIndex === index ? styles.selectedChip : ""} onClick={() => setSourceIndex(index)}>
              {label}
            </button>
          ))}
        </div>
      </div>

      <div className={styles.matrixWrapper}>
        <table className={styles.matrix}>
          <thead>
            <tr>
              <th>Área Temática</th>
              {fatores.map((fator) => <th key={fator.key}>{fator.label}</th>)}
              <th>Total</th>
            </tr>
          </thead>
          <tbody>
            {temas.map((tema) => {
              const row = coverage[tema.id] || {};
              const total = fatores.reduce((sum, fator) => sum + Number(row[fator.key]?.[sourceIndex] || 0), 0);

              return (
                <tr key={tema.id}>
                  <td>{tema.nome}</td>
                  {fatores.map((fator) => {
                    const covered = Number(row[fator.key]?.[sourceIndex] || 0) === 1;
                    return (
                      <td key={fator.key} style={{ background: covered ? fator.cor : "#f0f4f8", color: covered ? "white" : "#94a3b8" }}>
                        {covered ? "Sim" : "-"}
                      </td>
                    );
                  })}
                  <td><strong>{total}</strong></td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </section>
  );
}
