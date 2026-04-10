import Link from "next/link";

const productPdfs = {
  produto01: {
    title: "Produto I - Relatório Completo",
    pdfFile: "/pdfs/Produto01.pdf",
  },
  produto02: {
    title: "Produto II - Relatório Completo",
    pdfFile: "/pdfs/Produto02.pdf",
  },
  guam: {
    title: "Guia Ilustrativo UAM",
    pdfFile: "/pdfs/GUAM.pdf",
  },
};

export default async function PdfViewer({ params }) {
  const { prodId } = await params;
  const product = productPdfs[prodId] || {
    title: "Documento",
    pdfFile: `/pdfs/${prodId}.pdf`,
  };

  return (
    <div style={{ maxWidth: "1400px", margin: "0 auto", padding: "0 20px", display: "flex", flexDirection: "column", height: "calc(100vh - 100px)" }}>
      <header style={{ marginBottom: "20px", display: "flex", justifyContent: "space-between", alignItems: "center", gap: "20px", flexWrap: "wrap" }}>
        <div>
          <Link href="/portal" style={{ color: "var(--text-light)", fontWeight: 600, display: "inline-block", marginBottom: "10px" }}>
            Voltar para o Portal
          </Link>
          <h1 className="title-gradient" style={{ fontSize: "2rem", fontFamily: "var(--font-outfit)" }}>
            {product.title}
          </h1>
        </div>
        <a href={product.pdfFile} download className="glass-panel" style={{ padding: "10px 20px", color: "var(--primary-blue)", fontWeight: 600, borderRadius: "8px" }}>
          Baixar PDF
        </a>
      </header>

      <div className="glass-panel" style={{ flexGrow: 1, padding: "10px", borderRadius: "8px", overflow: "hidden" }}>
        <iframe
          src={`${product.pdfFile}#view=FitH`}
          width="100%"
          height="100%"
          style={{ border: "none", borderRadius: "8px" }}
          title={product.title}
        >
          Seu navegador não suporta a visualização nativa de PDFs. Faça o download usando o botão acima.
        </iframe>
      </div>
    </div>
  );
}
