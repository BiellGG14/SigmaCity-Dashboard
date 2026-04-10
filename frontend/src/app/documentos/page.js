import Link from "next/link";
import { fetchApi } from "@/lib/api";

export const dynamic = "force-dynamic";

export default async function DocumentosPage() {
  let documentos = [];
  let apiError = false;

  try {
    const data = await fetchApi("/api/documentos");
    documentos = data.documentos || [];
  } catch (error) {
    console.error("Erro ao conectar no Plumber:", error);
    apiError = true;
  }

  return (
    <div style={{ maxWidth: "1200px", margin: "0 auto", padding: "0 20px" }}>
      <h1 className="title-gradient" style={{ fontSize: "2.5rem", marginBottom: "20px", fontFamily: "var(--font-outfit)" }}>
        Biblioteca de Documentos
      </h1>
      <p style={{ marginBottom: "40px", color: "var(--text-light)", fontSize: "1.1rem" }}>
        Lista de documentos normativos lidos dinamicamente a partir do backend analítico em R Plumber.
      </p>

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(300px, 1fr))", gap: "20px" }}>
        {documentos.length > 0 ? documentos.map((doc, index) => (
          <Link
            key={doc.id}
            href={`/documentos/${encodeURIComponent(doc.id)}`}
            className="glass-panel"
            style={{
              padding: "25px",
              transition: "transform 0.2s",
              borderLeft: `5px solid ${doc.disponivel ? "var(--secondary-cyan)" : "#95a5a6"}`,
            }}
          >
            <span style={{ display: "block", color: "var(--primary-blue)", fontWeight: 800, marginBottom: "12px" }}>
              {String(index + 1).padStart(2, "0")}
            </span>
            <h3 style={{ marginBottom: "15px", color: "var(--text-dark)", lineHeight: 1.35 }}>{doc.nome}</h3>
            <span style={{ color: "var(--primary-blue)", fontWeight: 600, fontSize: "0.9rem" }}>
              Ver análise detalhada
            </span>
          </Link>
        )) : (
          <div className="glass-panel" style={{ padding: "40px", gridColumn: "1 / -1", textAlign: "center" }}>
            <h3 style={{ marginBottom: "10px" }}>{apiError ? "API indisponível" : "Nenhum documento encontrado"}</h3>
            <p style={{ color: "var(--text-light)" }}>
              Verifique se a API Plumber está executando e se a variável <strong>API_INTERNAL_URL</strong> aponta para o backend correto.
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
