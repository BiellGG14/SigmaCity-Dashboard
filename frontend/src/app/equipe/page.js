import styles from './page.module.css';

const equipe = [
  {
    nome: "Prof. Dr. Cláudio Jorge Pinto Alves",
    foto: "/imagens/claudio_jorge.png",
    linkedin: "https://www.linkedin.com/in/claudio-jorge-pinto-alves-78149010/",
    role: "Pesquisador ITA"
  },
  {
    nome: "Prof. Dr. Marcelo Xavier Guterres",
    foto: "/imagens/marcelo_guterres.png",
    linkedin: "https://www.linkedin.com/in/profguterres/",
    role: "Pesquisador ITA"
  },
  {
    nome: "Prof. Dr. Flávio Mendes Neto",
    foto: "/imagens/flavio_mendes.png",
    linkedin: "https://www.linkedin.com/in/ffllaavviioo/",
    role: "Pesquisador ITA"
  },
  {
    nome: "Profa. Dra. Mayara Condé Rocha Murça",
    foto: "/imagens/mayara_conde.png",
    linkedin: "https://www.linkedin.com/in/mayara-condé-rocha-murça-a4a8482ba/",
    role: "Pesquisadora ITA"
  },
  {
    nome: "Prof. Dr. Daniel Alberto Pamplona",
    foto: "/imagens/daniel_pamplona.png",
    linkedin: "https://www.linkedin.com/in/daniel-pamplona-024389140/",
    role: "Pesquisador ITA"
  },
  {
    nome: "MSc. Marcelo Saraiva Peres",
    foto: "/imagens/marcelo_saraiva.png",
    linkedin: "https://www.linkedin.com/in/marcelo-saraiva-peres-563a8b104/",
    role: "Pesquisador ITA"
  },
  {
    nome: "Gabriel Luiz Goulart Rufino",
    foto: "/imagens/gabriel_goulart.png",
    linkedin: "https://www.linkedin.com/in/gabriel-luiz-11294919b/",
    role: "Pesquisador Assistente"
  },
  {
    nome: "Rodrigo Mollo Furlan",
    foto: "/imagens/rodrigo_mollo.png",
    linkedin: "https://www.linkedin.com/in/rodrigo-furlan-67b264209/",
    role: "Pesquisador Assistente"
  }
];

export default function EquipePage() {
  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1 className="title-gradient">Equipe Institucional SigmaCity</h1>
        <p className={styles.subtitle}>
          Conheça os profissionais e pesquisadores responsáveis pela arquitetura e classificação das normativas aéreas UAM (Meta 2 | Etapa 8).
        </p>
      </div>

      <div className={styles.teamGrid}>
        {equipe.map((membro, idx) => (
          <div key={idx} className={`glass-panel animate-fade-in-up ${styles.memberCard}`} style={{ animationDelay: `${idx * 0.1}s` }}>
            <a href={membro.linkedin} target="_blank" rel="noreferrer" className={styles.imageContainer}>
              <div className={styles.imageBorder}>
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img 
                  src={membro.foto} 
                  alt={membro.nome} 
                  className={styles.memberPhoto}
                  onError={(e) => { e.target.src = '/imagens/sigma.png'; }}
                />
              </div>
            </a>
            
            <div className={styles.memberInfo}>
              <h3 className={styles.memberName}>{membro.nome}</h3>
              <p className={styles.memberRole}>{membro.role}</p>
              
              <a href={membro.linkedin} target="_blank" rel="noreferrer" className={styles.linkedinBtn} title={`LinkedIn - ${membro.nome}`}>
                in
              </a>
            </div>
          </div>
        ))}
      </div>

      <div className={styles.footer}>
        <div style={{ display: 'flex', justifyContent: 'center', gap: '40px', alignItems: 'center' }}>
           <a href="http://www.ita.br/" target="_blank" rel="noreferrer">
             {/* eslint-disable-next-line @next/next/no-img-element */}
             <img src="/imagens/ita.png" alt="ITA Logo" style={{ height: '70px', opacity: 0.8 }} />
           </a>
           <a href="https://sigma.ita.br" target="_blank" rel="noreferrer">
             {/* eslint-disable-next-line @next/next/no-img-element */}
             <img src="/imagens/sigma.png" alt="Sigma Logo" style={{ height: '70px', opacity: 0.8 }} />
           </a>
        </div>
      </div>
    </div>
  );
}
