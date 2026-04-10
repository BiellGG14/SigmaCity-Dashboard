"use client";

import styles from './page.module.css';
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Tooltip, ResponsiveContainer } from 'recharts';

export default function DocumentDetail({ docData, pestelData, documentId }) {
  const stats = docData.estatisticas || {};
  const resumo = Array.isArray(docData.resumo) ? docData.resumo.join("\n") : (docData.resumo || "Resumo indisponível");
  
  // Imagem servida pelo Plumber na porta 8000
  const cloudUrl = docData.nome_imagem_base ? 
    `http://127.0.0.1:8000/api/imagens/${encodeURIComponent(docData.nome_imagem_base + '_nuvem.png')}` : null;

  return (
    <div className={styles.gridContainer}>
      {/* Coluna Esquerda: Resumo e Estatísticas */}
      <div className={styles.mainColumn}>
        
        {/* Painel de Resumo */}
        <div className={`glass-panel ${styles.card}`}>
          <h3 className={styles.cardTitle}>Resumo NLP</h3>
          <p className={styles.summaryText}>{resumo}</p>
        </div>

        {/* Panel de Estatísticas Dinâmico */}
        <div className={styles.statsGrid}>
          <StatBox icon="📊" title="Total de Palavras" value={stats.total_palavras || 0} />
          <StatBox icon="✨" title="Palavras Únicas" value={stats.palavras_unicas || 0} />
          <StatBox icon="📏" title="Tamanho Médio (Letras)" value={Number(stats.tamanho_medio_palavra || 0).toFixed(1)} />
          <StatBox icon="📝" title="Sentenças" value={stats.num_sentencas || 0} />
        </div>

        {/* Justificativas do PESTEL */}
        <div className={`glass-panel ${styles.card}`} style={{ marginTop: '20px' }}>
           <h3 className={styles.cardTitle}>Fundamento da Análise PESTEL</h3>
           <div className={styles.pestelJustifications}>
              {pestelData.map((item, index) => (
                 <div key={index} className={styles.pestelItem}>
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

      {/* Coluna Direita: Nuvens e Gráficos */}
      <div className={styles.sideColumn}>
        
        {/* Gráfico Radar - Recharts */}
        <div className={`glass-panel ${styles.card} ${styles.chartContainer}`}>
          <h3 className={styles.cardTitle}>Análise PESTEL (Radar)</h3>
          {pestelData.length > 0 ? (
            <div style={{ width: '100%', height: 300 }}>
              <ResponsiveContainer width="100%" height="100%">
                <RadarChart cx="50%" cy="50%" outerRadius="70%" data={pestelData}>
                  <PolarGrid stroke="#e2e8f0" />
                  <PolarAngleAxis dataKey="fator" tick={{ fill: 'var(--text-dark)', fontSize: 12, fontWeight: 600 }} />
                  <PolarRadiusAxis angle={30} domain={[0, 5]} tick={false} axisLine={false} />
                  <Radar name="Pontuação PESTEL" dataKey="pontuacao" stroke="var(--primary-blue)" fill="var(--secondary-cyan)" fillOpacity={0.6} />
                  <Tooltip 
                    contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 15px rgba(0,0,0,0.1)' }}
                  />
                </RadarChart>
              </ResponsiveContainer>
            </div>
          ) : (
             <p style={{ textAlign: 'center', color: 'var(--text-light)', marginTop: '40px' }}>Sem dados de PESTEL</p>
          )}
        </div>

        {/* Nuvem de Palavras vindo do Backend Plumber */}
        <div className={`glass-panel ${styles.card}`}>
          <h3 className={styles.cardTitle}>Nuvem de Palavras Frequentes</h3>
          {cloudUrl ? (
             <div className={styles.imageWrapper}>
               {/* eslint-disable-next-line @next/next/no-img-element */}
               <img src={cloudUrl} alt={`Nuvem de palavras para ${docData.nome}`} className={styles.cloudImage} />
             </div>
          ) : (
             <div className={styles.noImage}>
                Nuvem não disponível para este documento
             </div>
          )}
        </div>

      </div>
    </div>
  );
}

function StatBox({ icon, title, value }) {
  return (
    <div className={`glass-panel ${styles.statBox}`}>
      <div className={styles.statIcon}>{icon}</div>
      <div className={styles.statValue}>{value}</div>
      <div className={styles.statTitle}>{title}</div>
    </div>
  );
}
