import Link from 'next/link';
import DocumentDetail from './DocumentDetail';

export default async function DocumentoPage({ params }) {
  const { id } = params;
  
  // Realiza o Fetch passando o nome do documento via query params
  let docData = null;
  let apiError = false;

  try {
    const res = await fetch(`http://127.0.0.1:8000/api/documentos/detalhe?nome_doc=${encodeURIComponent(id)}`, { cache: 'no-store' });
    if (res.ok) {
      docData = await res.json();
    } else {
      apiError = true;
    }
  } catch (err) {
    console.error("Erro na comunicação com Plumber:", err);
    apiError = true;
  }

  // Fallback visual em caso de documento não encontrado
  if (apiError || !docData) {
    return (
      <div style={{ maxWidth: '800px', margin: '40px auto', textAlign: 'center' }}>
        <div className="glass-panel" style={{ padding: '40px' }}>
          <h2>Documento não localizado</h2>
          <p style={{ marginTop: '15px', color: 'var(--text-light)' }}>
            O documento <b>{id}</b> não foi encontrado no banco de dados JSON ou a API está offline.
          </p>
          <Link href="/documentos" style={{ display: 'inline-block', marginTop: '20px', color: 'var(--primary-blue)', fontWeight: 'bold' }}>
            ← Voltar para a Biblioteca
          </Link>
        </div>
      </div>
    );
  }

  // Prepara os dados do PESTEL para enviar ao Client Component de Gráficos
  const pestelData = docData.pestel?.fatores.map((fator, index) => ({
    fator: fator,
    pontuacao: docData.pestel.pontuacoes[index],
    justificativa: docData.pestel.justificativas[index]
  })) || [];

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto', padding: '0 20px' }}>
      <div style={{ marginBottom: '30px' }}>
        <Link href="/documentos" style={{ color: 'var(--text-light)', textDecoration: 'none', fontWeight: 600 }}>
          ← Voltar à Biblioteca
        </Link>
      </div>
      
      <header style={{ marginBottom: '40px' }}>
        <h1 className="title-gradient" style={{ fontSize: '3rem', fontFamily: 'var(--font-outfit)' }}>
          {docData.nome || id}
        </h1>
        {docData.disponivel ? (
          <span style={{ display: 'inline-block', marginTop: '10px', padding: '6px 12px', background: '#d4edda', color: '#155724', borderRadius: '12px', fontWeight: 'bold', fontSize: '13px' }}>
            ✓ Disponível
          </span>
        ) : (
          <span style={{ display: 'inline-block', marginTop: '10px', padding: '6px 12px', background: '#f8d7da', color: '#721c24', borderRadius: '12px', fontWeight: 'bold', fontSize: '13px' }}>
            ⚒ Em Processamento
          </span>
        )}
      </header>

      {/* Grid Principal - Renderizado via Client Component de Detalhe */}
      <DocumentDetail 
        docData={docData} 
        pestelData={pestelData} 
        documentId={id}
      />
    </div>
  );
}
