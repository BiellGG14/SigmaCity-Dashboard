"use client";

import { useState } from 'react';
import styles from './page.module.css';

export default function LegislacaoTabs({ identData, elegData, incData }) {
  const [activeTab, setActiveTab] = useState('identificacao');
  const [searchTerm, setSearchTerm] = useState('');

  // Seleciona o dataset com base na aba ativa
  const getActiveData = () => {
    switch (activeTab) {
      case 'identificacao': return identData;
      case 'elegibilidade': return elegData;
      case 'inclusao': return incData;
      default: return [];
    }
  };

  let data = getActiveData() || [];

  if (searchTerm.trim() !== '') {
    data = data.filter(row => 
      Object.values(row).some(val => 
        String(val).toLowerCase().includes(searchTerm.toLowerCase())
      )
    );
  }

  // Se não houver dados
  if ((!identData || identData.length === 0) && (!elegData || elegData.length === 0)) {
    return (
      <div className="glass-panel" style={{ padding: '40px', textAlign: 'center' }}>
        <h3>⚠️ API Indisponível ou sem Dados</h3>
        <p>Verifique se os arquivos CSV estão na pasta <code>/documentos</code> e se o Plumber está em execução.</p>
      </div>
    );
  }

  // Extrair as chaves para criar as colunas dinâmicas (usando o primeiro item)
  const columns = data.length > 0 ? Object.keys(data[0]) : [];

  return (
    <div className={`glass-panel ${styles.tabsContainer}`}>
      
      {/* Menus / Abas */}
      <div className={styles.tabHeader}>
        <button 
          className={`${styles.tabBtn} ${activeTab === 'identificacao' ? styles.active : ''}`}
          onClick={() => setActiveTab('identificacao')}
        >
          📄 Identificação
        </button>
        <button 
          className={`${styles.tabBtn} ${activeTab === 'elegibilidade' ? styles.active : ''}`}
          onClick={() => setActiveTab('elegibilidade')}
        >
          ✅ Elegibilidade
        </button>
        <button 
          className={`${styles.tabBtn} ${activeTab === 'inclusao' ? styles.active : ''}`}
          onClick={() => setActiveTab('inclusao')}
        >
          📌 Inclusão
        </button>
      </div>

      {/* Caixa de Pesquisa Minimalista */}
      <div className={styles.searchContainer}>
        <input 
          type="text" 
          placeholder={`Pesquisar na tabela de ${activeTab}...`} 
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className={styles.searchInput}
        />
        <span className={styles.searchCount}>{data.length} resultados</span>
      </div>

      {/* Tabela de Dados */}
      <div className={styles.tableWrapper}>
        <table className={styles.modernTable}>
          <thead>
            <tr>
              {columns.map(col => (
                <th key={col}>{col === "Documentos" ? "Documento" : col}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {data.length > 0 ? (
              data.map((row, rowIndex) => (
                <tr key={rowIndex}>
                  {columns.map(col => {
                    const cellValue = row[col];
                    // Formatação condicional idêntica ao dash.Rmd
                    let cellClass = '';
                    if (col === 'Aceitação') {
                      if (cellValue === 'Aceito') cellClass = styles.badgeAceito;
                      if (cellValue === 'Rejeitado') cellClass = styles.badgeRejeitado;
                    } else if (col === 'Status') {
                      cellClass = styles.badgeStatus;
                    }

                    return (
                      <td key={col}>
                        {cellClass ? (
                          <span className={`${styles.badge} ${cellClass}`}>{cellValue}</span>
                        ) : (
                          cellValue
                        )}
                      </td>
                    );
                  })}
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan={columns.length || 1} style={{ textAlign: 'center', padding: '40px' }}>
                  Nenhum registro encontrado.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

    </div>
  );
}
