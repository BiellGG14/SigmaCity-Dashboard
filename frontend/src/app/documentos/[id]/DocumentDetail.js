"use client";

import { useState } from "react";
import styles from "./page.module.css";
import { getWordCloudUrl } from "@/lib/api";
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Tooltip, ResponsiveContainer } from "recharts";

export default function DocumentDetail({ docData, pestelData, documentId }) {
  const [activeTab, setActiveTab] = useState("analysis");
  const stats = docData.estatisticas || {};
  const resumo = Array.isArray(docData.resumo) ? docData.resumo.join("\n") : (docData.resumo || "Resumo indisponível");
  const cloudUrl = getWordCloudUrl(docData.nome_imagem_base || documentId);
  const sourceUrl = docData.url;

  return (
    <section className={styles.analysisShell}>
      {sourceUrl ? (
        <div className={styles.sourceBar}>
          <div>
            <span>Arquivo original</span>
            <p>Acesse a fonte oficial usada no processamento deste documento.</p>
          </div>
          <a href={sourceUrl} target="_blank" rel="noreferrer" className={styles.sourceButton}>
            Abrir documento original
          </a>
        </div>
      ) : null}

      <div className={styles.tabs} aria-label="Análise do documento">
        <button
          className={`${styles.tabButton} ${activeTab === "analysis" ? styles.activeTab : ""}`}
          type="button"
          onClick={() => setActiveTab("analysis")}
        >
          Análise bruta e detalhada
        </button>
        <button
          className={`${styles.tabButton} ${activeTab === "cloud" ? styles.activeTab : ""}`}
          type="button"
          onClick={() => setActiveTab("cloud")}
        >
          Nuvem de palavras
        </button>
      </div>

      {activeTab === "analysis" ? (
        <div className={styles.analysisTab}>
          <div className={styles.statsGrid}>
            <StatBox title="Total de Palavras" value={stats.total_palavras || 0} />
            <StatBox title="Palavras Únicas" value={stats.palavras_unicas || 0} />
            <StatBox title="Sentenças" value={stats.num_sentencas || 0} />
          </div>

          <div className={styles.analysisGrid}>
            <div className={`glass-panel ${styles.card}`}>
              <h3 className={styles.cardTitle}>Resumo NLP</h3>
              <p className={styles.summaryText}>{resumo}</p>
            </div>

            <div className={`glass-panel ${styles.card} ${styles.chartContainer}`}>
              <h3 className={styles.cardTitle}>Análise PESTEL (Radar)</h3>
              {pestelData.length > 0 ? (
                <div className={styles.radarBox}>
                  <ResponsiveContainer width="100%" height="100%">
                    <RadarChart cx="50%" cy="50%" outerRadius="70%" data={pestelData}>
                      <PolarGrid stroke="#dbe5ef" />
                      <PolarAngleAxis dataKey="fator" tick={{ fill: "var(--text-dark)", fontSize: 12, fontWeight: 700 }} />
                      <PolarRadiusAxis angle={30} domain={[0, 5]} tick={false} axisLine={false} />
                      <Radar name="Pontuação PESTEL" dataKey="pontuacao" stroke="var(--primary-blue)" fill="var(--secondary-cyan)" fillOpacity={0.58} />
                      <Tooltip contentStyle={{ borderRadius: "8px", border: "1px solid var(--border-soft)", boxShadow: "0 12px 28px rgba(18,58,99,0.14)" }} />
                    </RadarChart>
                  </ResponsiveContainer>
                </div>
              ) : (
                <p className={styles.emptyState}>Sem dados de PESTEL</p>
              )}
            </div>
          </div>

          <div className={`glass-panel ${styles.card}`}>
            <h3 className={styles.cardTitle}>Fundamento da Análise PESTEL</h3>
            <div className={styles.pestelJustifications}>
              {pestelData.map((item) => (
                <div key={item.fator} className={styles.pestelItem}>
                  <div className={styles.pestelHeader}>
                    <strong>{item.fator}</strong>
                    <span className={styles.pestelScore}>{item.pontuacao}/5</span>
                  </div>
                  <p>{item.justificativa}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      ) : (
        <div className={`glass-panel ${styles.card} ${styles.cloudCard}`}>
          <div className={styles.cloudHeader}>
            <div>
              <span className="eyebrow">Visualização textual</span>
              <h3 className={styles.cloudTitle}>Nuvem de palavras frequentes</h3>
            </div>
            <p>Termos de maior recorrência no documento, exibidos em uma área ampliada para leitura e apresentação.</p>
          </div>

          {cloudUrl ? (
            <div className={styles.imageWrapper}>
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={cloudUrl} alt={`Nuvem de palavras para ${docData.nome}`} className={styles.cloudImage} />
            </div>
          ) : (
            <div className={styles.noImage}>Nuvem não disponível para este documento</div>
          )}
        </div>
      )}
    </section>
  );
}

function StatBox({ title, value }) {
  return (
    <div className={`glass-panel ${styles.statBox}`}>
      <div className={styles.statValue}>{value}</div>
      <div className={styles.statTitle}>{title}</div>
    </div>
  );
}
