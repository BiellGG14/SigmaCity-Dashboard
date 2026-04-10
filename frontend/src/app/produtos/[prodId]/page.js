"use client";

import Link from 'next/link';

export default function PdfViewer({ params }) {
  // prodId pode ser "produto01", "produto02", ou "guam"
  const { prodId } = params;

  let title = "Documento";
  let pdfFile = "";

  if (prodId === "produto01") {
    title = "Produto I - Relatório Completo";
    pdfFile = "/pdfs/Produto01.pdf";
  } else if (prodId === "produto02") {
    title = "Produto II - Relatório Completo";
    pdfFile = "/pdfs/Produto02.pdf";
  } else if (prodId === "guam") {
    title = "Guia Ilustrativo UAM";
    pdfFile = "/pdfs/GUAM.pdf"; // Suponto que era guiam_viewer.pdf
  } else {
    // Parâmetro não mapeado
    pdfFile = `/pdfs/${prodId}.pdf`; 
  }

  return (
    <div style={{ maxWidth: '1400px', margin: '0 auto', padding: '0 20px', display: 'flex', flexDirection: 'column', height: 'calc(100vh - 100px)' }}>
      <header style={{ marginBottom: '20px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          <Link href="/portal" style={{ color: 'var(--text-light)', fontWeight: 600, display: 'inline-block', marginBottom: '10px' }}>
            ← Voltar para o Portal
          </Link>
          <h1 className="title-gradient" style={{ fontSize: '2rem', fontFamily: 'var(--font-outfit)' }}>
            {title}
          </h1>
        </div>
        <div>
          <a href={pdfFile} download className="glass-panel" style={{ padding: '10px 20px', color: 'var(--primary-blue)', fontWeight: 600 }}>
            Baixar PDF ⬇
          </a>
        </div>
      </header>

      <div className="glass-panel" style={{ flexGrow: 1, padding: '10px', borderRadius: '12px', overflow: 'hidden' }}>
        {/* Renderizador nativo de IFRAME para o PDF */}
        <iframe 
          src={`${pdfFile}#view=FitH`} 
          width="100%" 
          height="100%" 
          style={{ border: 'none', borderRadius: '8px' }}
          title={title}
        >
          Seu navegador não suporta a visualização nativa de PDFs. Por favor, faça o download usando o botão acima.
        </iframe>
      </div>
    </div>
  );
}
