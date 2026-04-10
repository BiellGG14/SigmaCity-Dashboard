"use client";

import { useMemo, useState } from "react";
import styles from "./page.module.css";

const tabs = [
  { id: "identificacao", label: "Identificação" },
  { id: "elegibilidade", label: "Elegibilidade" },
  { id: "inclusao", label: "Inclusão" },
];

export default function LegislacaoTabs({ identData, elegData, incData }) {
  const [activeTab, setActiveTab] = useState("identificacao");
  const [searchTerm, setSearchTerm] = useState("");

  const activeData = useMemo(() => {
    const dataByTab = {
      identificacao: identData || [],
      elegibilidade: elegData || [],
      inclusao: incData || [],
    };

    const current = dataByTab[activeTab] || [];
    if (!searchTerm.trim()) {
      return current;
    }

    const term = searchTerm.toLowerCase();
    return current.filter((row) => Object.values(row).some((val) => String(val).toLowerCase().includes(term)));
  }, [activeTab, elegData, identData, incData, searchTerm]);

  if ((!identData || identData.length === 0) && (!elegData || elegData.length === 0) && (!incData || incData.length === 0)) {
    return (
      <div className="glass-panel" style={{ padding: "40px", textAlign: "center" }}>
        <h3>API indisponível ou sem dados</h3>
        <p>Verifique se os arquivos CSV estão na pasta <code>/documentos</code> e se o Plumber está em execução.</p>
      </div>
    );
  }

  const columns = activeData.length > 0 ? Object.keys(activeData[0]) : [];

  return (
    <div className={`glass-panel ${styles.tabsContainer}`}>
      <div className={styles.tabHeader}>
        {tabs.map((tab) => (
          <button
            key={tab.id}
            className={`${styles.tabBtn} ${activeTab === tab.id ? styles.active : ""}`}
            onClick={() => setActiveTab(tab.id)}
            type="button"
          >
            {tab.label}
          </button>
        ))}
      </div>

      <div className={styles.searchContainer}>
        <input
          type="text"
          placeholder={`Pesquisar na tabela de ${activeTab}...`}
          value={searchTerm}
          onChange={(event) => setSearchTerm(event.target.value)}
          className={styles.searchInput}
        />
        <span className={styles.searchCount}>{activeData.length} resultados</span>
      </div>

      <div className={styles.tableWrapper}>
        <table className={styles.modernTable}>
          <thead>
            <tr>
              {columns.map((col) => (
                <th key={col}>{col === "Documentos" ? "Documento" : col}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {activeData.length > 0 ? (
              activeData.map((row, rowIndex) => (
                <tr key={`${activeTab}-${rowIndex}`}>
                  {columns.map((col) => {
                    const cellValue = row[col];
                    let cellClass = "";
                    const normalizedValue = String(cellValue).toLowerCase();

                    if (col === "Aceitação") {
                      if (normalizedValue === "aceito") cellClass = styles.badgeAceito;
                      if (normalizedValue === "rejeitado") cellClass = styles.badgeRejeitado;
                    } else if (col === "Status") {
                      cellClass = normalizedValue === "aceito" ? styles.badgeAceito : styles.badgeStatus;
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
                <td colSpan={columns.length || 1} style={{ textAlign: "center", padding: "40px" }}>
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
