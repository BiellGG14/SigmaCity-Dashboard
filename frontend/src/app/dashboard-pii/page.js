import Produto2Dashboard from "./Produto2Dashboard";
import { fetchApi } from "@/lib/api";

export const dynamic = "force-dynamic";

export default async function DashboardPIIPage() {
  let data = null;
  let error = null;

  try {
    data = await fetchApi("/api/produto2");
  } catch (err) {
    console.error("Falha ao buscar dados do Produto II:", err);
    error = err.message;
  }

  if (!data) {
    return (
      <div style={{ maxWidth: "900px", margin: "0 auto", padding: "0 20px" }}>
        <div className="glass-panel" style={{ padding: "40px", textAlign: "center" }}>
          <h1 style={{ marginBottom: "12px" }}>Dashboard PII indisponível</h1>
          <p style={{ color: "var(--text-light)" }}>
            Não foi possível carregar os dados do Produto II a partir do backend Plumber.
          </p>
          {error ? <p style={{ marginTop: "12px", color: "#721c24" }}>{error}</p> : null}
        </div>
      </div>
    );
  }

  return <Produto2Dashboard data={data} />;
}
