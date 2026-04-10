import LegislacaoTabs from './LegislacaoTabs';

// Página SRR (Server Side Rendered) que busca os dados da Plumber API
export default async function LegislacaoPage() {
  let identData = [];
  let elegData = [];
  let incData = [];

  try {
    const [resIdent, resEleg, resInc] = await Promise.all([
      fetch('http://127.0.0.1:8000/api/legislacao/identificacao', { cache: 'no-store' }),
      fetch('http://127.0.0.1:8000/api/legislacao/elegibilidade', { cache: 'no-store' }),
      fetch('http://127.0.0.1:8000/api/legislacao/inclusao', { cache: 'no-store' })
    ]);

    if(resIdent.ok) identData = await resIdent.json();
    if(resEleg.ok) elegData = await resEleg.json();
    if(resInc.ok) incData = await resInc.json();

  } catch (error) {
    console.error("Falha ao buscar dados da Legislação na API Plumber:", error);
  }

  return (
    <div style={{ maxWidth: '1400px', margin: '0 auto', padding: '0 20px' }}>
      <header style={{ marginBottom: '40px' }}>
        <h1 className="title-gradient" style={{ fontSize: '2.5rem', marginBottom: '10px', fontFamily: 'var(--font-outfit)' }}>
          Comparativo de Legislação AAM
        </h1>
        <p style={{ color: 'var(--text-light)', fontSize: '1.1rem' }}>
          Análise sistemática: Identificação, Elegibilidade e Inclusão de normativas.
        </p>
      </header>
      
      {/* Container do Funil/Dashboard */}
      <div style={{
        display: 'flex', gap: '20px', marginBottom: '40px', justifyContent: 'center', flexWrap: 'wrap'
      }}>
        <FunnelCard number={identData.length || 0} label="Identificadas" borderColor="#004aad" bgColor="#e6f0ff" textColor="#003580" />
        <Arrow />
        <FunnelCard number={elegData.length || 0} label="Elegíveis" borderColor="#5de0e6" bgColor="#eaffff" textColor="#008a93" />
        <Arrow />
        <FunnelCard number={incData.length || 0} label="Incluídas" borderColor="#28a745" bgColor="#eaffef" textColor="#166528" />
      </div>

      {/* Componente Interativo de Abas (Client Component) */}
      <LegislacaoTabs identData={identData} elegData={elegData} incData={incData} />
    </div>
  );
}

function FunnelCard({ number, label, borderColor, bgColor, textColor }) {
  return (
    <div style={{
      flex: '1', minWidth: '180px', textAlign: 'center', padding: '20px 10px',
      backgroundColor: bgColor, borderRadius: 'var(--radius-md)', 
      borderTop: `5px solid ${borderColor}`, boxShadow: 'var(--shadow-sm)'
    }}>
      <span style={{ display: 'block', fontSize: '36px', fontWeight: 800, color: textColor, lineHeight: 1.1 }}>
        {number}
      </span>
      <span style={{
        display: 'block', fontSize: '12px', fontWeight: 700, color: textColor, 
        textTransform: 'uppercase', letterSpacing: '0.05em', marginTop: '4px'
      }}>
        {label}
      </span>
    </div>
  );
}

function Arrow() {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      fontSize: '24px', color: '#adb5bd', padding: '0 10px'
    }}>
      ➔
    </div>
  );
}
