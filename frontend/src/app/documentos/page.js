export default async function DocumentosPage() {
  // Chamada SSR (Server-Side Rendering) para a API R Plumber
  // Next.js efetua essa requisição no backend do Node.js
  let documentos = [];
  try {
    const res = await fetch('http://127.0.0.1:8000/api/documentos', { cache: 'no-store' });
    if (res.ok) {
      const data = await res.json();
      documentos = data.nomes || [];
    }
  } catch (error) {
    console.error("Erro ao conectar no Plumber:", error);
  }

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto', padding: '0 20px' }}>
      <h1 className="title-gradient" style={{ fontSize: '2.5rem', marginBottom: '20px', fontFamily: 'var(--font-outfit)' }}>
        Biblioteca de Documentos
      </h1>
      <p style={{ marginBottom: '40px', color: 'var(--text-light)', fontSize: '1.1rem' }}>
        Lista de documentos normativos lidos dinamicamente a partir do backend analítico em R Plumber.
      </p>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))', gap: '20px' }}>
        {documentos.length > 0 ? documentos.map(doc => (
          <div key={doc[0] || doc} className="glass-panel" style={{ padding: '25px', transition: 'transform 0.2s', cursor: 'pointer' }}>
            <h3 style={{ marginBottom: '15px', color: 'var(--text-dark)' }}>{doc[0] || doc}</h3>
            <span style={{ color: 'var(--primary-blue)', fontWeight: 600, fontSize: '0.9rem' }}>
              Ver Análise Detalhada ➔
            </span>
          </div>
        )) : (
          <div className="glass-panel" style={{ padding: '40px', gridColumn: '1 / -1', textAlign: 'center' }}>
            <h3 style={{ marginBottom: '10px' }}>⚠️ API Indisponível</h3>
            <p style={{ color: 'var(--text-light)' }}>
              Nenhum documento retornado. Certifique-se de que a API Plumber está executando em <strong>http://127.0.0.1:8000</strong>
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
