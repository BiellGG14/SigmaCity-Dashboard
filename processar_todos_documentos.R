# ============================================================================
# GERADOR DE JSONs - ANÁLISE DE DOCUMENTOS LEGISLATIVOS UAM
# VERSÃO FINAL COMPLETA - 35 DOCUMENTOS
# TEXTO EXATAMENTE IGUAL AO DOCUMENTO LATEX - PALAVRA POR PALAVRA
# ============================================================================

# Carregar pacotes necessários
if (!require("pdftools")) install.packages("pdftools")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("tidytext")) install.packages("tidytext")
if (!require("jsonlite")) install.packages("jsonlite")
if (!require("stringr")) install.packages("stringr")

library(pdftools)
library(tidyverse)
library(tidytext)
library(jsonlite)
library(stringr)

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

pasta_documentos <- "documentos"
pasta_json <- "json"

if (!dir.exists(pasta_json)) {
  dir.create(pasta_json)
}

# Stopwords em português
stopwords_pt <- c(
  "a", "o", "as", "os", "um", "uma", "uns", "umas",
  "de", "do", "da", "dos", "das", "em", "no", "na", "nos", "nas",
  "por", "pelo", "pela", "pelos", "pelas", "para", "ao", "aos",
  "com", "sem", "sob", "sobre", "entre", "até", "desde",
  "e", "ou", "mas", "porém", "contudo", "que", "qual", "quando", "onde",
  "se", "não", "nem", "também", "já", "ainda", "mais", "menos",
  "muito", "pouco", "todo", "toda", "todos", "todas",
  "este", "esta", "esse", "essa", "aquele", "aquela",
  "meu", "minha", "seu", "sua", "nosso", "nossa",
  "eu", "tu", "ele", "ela", "nós", "eles", "elas",
  "ser", "estar", "ter", "haver", "fazer", "ir", "poder",
  "artigo", "art", "inciso", "parágrafo", "alínea", "item",
  "lei", "decreto", "medida", "provisória", "dispõe",
  "caput", "número", "único", "são", "fica", "ficam",
  "iii", "for", "como"
)

# ============================================================================
# BASE DE DADOS COMPLETA - 35 DOCUMENTOS COM TEXTO EXATO DO LATEX
# ============================================================================

obter_dados_documento <- function(nome_doc) {
  nome_limpo <- tolower(nome_doc)
  
  # ========================================================================
  # 1. ALERTA AOS OPERADORES DE AERÓDROMOS Nº 001/2023
  # ========================================================================
  if (str_detect(nome_limpo, "alerta|001_2023|alertan001")) {
    return(list(
      nome_completo = "Alerta aos Operadores de Aeródromos nº 001/2023",
      url = "https://www.gov.br/anac/pt-br/assuntos/regulados/aeroportos-e-aerodromos/arquivos/ALERTAn001_2023InfraestruturaparapousoedecolagemdeaeronaveseVTOL.pdf",
      resumo = c(
        "Base Regulatória Inicial: Recomenda que a infraestrutura para eVTOL siga, com adaptações, os requisitos do RBAC nº 155 (Helipontos).",
        "Dimensionamento de Áreas: Orienta o uso do parâmetro \"D\" (diâmetro do eVTOL) para definir as dimensões de componentes como FATO, TLOF e Área de Segurança.",
        "Foco em Propulsão Elétrica: O planejamento de emergência deve prever uma área designada para o manuseio de baterias, distanciada da FATO, TLOF e Área de Segurança.",
        "Contexto: Fornece diretrizes iniciais para o planejamento de vertiportos no âmbito da UAM, utilizando o Sandbox Regulatório para desenvolver futuras normas."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 2, 1, 5, 2),
        justificativas = c(
          "Demonstra proatividade regulatória através do Sandbox Regulatório da ANAC para desenvolver normas futuras, estabelecendo diretrizes governamentais preliminares para o ecossistema da UAM.",
          "Impacto indireto ao criar base infraestrutural para viabilizar operações, sem menção a modelos de negócio, financiamento, custos operacionais ou impacto econômico direto.",
          "Ausência de referência a aceitação pública, equidade, acessibilidade ou gestão de percepção de risco social. Foco exclusivo em aspectos técnicos operacionais.",
          "Impacto direto e abrangente ao definir parâmetros técnicos vinculantes para infraestrutura (FATO, TLOF, Área de Segurança baseadas no diâmetro \"D\"), sistemas de propulsão elétrica (baterias) e aplicação adaptada do RBAC nº 155, constituindo o \"sistema nervoso\" da UAM.",
          "Abordagem pontual ao exigir área distanciada para manuseio de baterias, mas sem menção a pegada de carbono, poluição sonora, integração ao planejamento urbano ou conformidade com marco legal ambiental."
        )
      )
    ))
  }
  
  # ========================================================================
  # 2. RESOLUÇÃO ANAC 775/2025 - SANDBOX REGULATÓRIO
  # ========================================================================
  if (str_detect(nome_limpo, "resanac775|775|res.*anac.*775")) {
    return(list(
      nome_completo = "Resolução ANAC 775/2025 - Sandbox Regulatório",
      url = "https://www.anac.gov.br/assuntos/legislacao/legislacao-1/resolucoes/2025/resolucao-775",
      resumo = c(
        "Institui o Ambiente Regulatório Experimental (Sandbox Regulatório)",
        "Estabelece condições diferenciadas ao marco regulatório vigente",
        "Permite autorização temporária para projetos inovadores na aviação civil",
        "Define critérios mediante Termo Específico de Admissão",
        "Objetiva incentivar inovação e modernização do setor",
        "Relaciona-se com a UAM ao autorizar projetos com novas tecnologias",
        "Cria ambiente para testes experimentais de mobilidade aérea urbana"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 4, 3, 5, 2),
        justificativas = c(
          "Impacto direto e abrangente ao instituir mecanismo inovador de governança regulatória (Sandbox), demonstrando proatividade da ANAC na formulação de políticas públicas para fomentar inovação na aviação civil.",
          "Impacto relevante ao criar ambiente para desenvolvimento de novos produtos e serviços, modernização do ambiente de negócios e viabilização de modelos de negócio inovadores, embora sem menção específica a incentivos fiscais ou financiamento.",
          "Impacto moderado ao prever testes de tecnologias que podem melhorar a mobilidade urbana, porém sem referência explícita a aceitação pública, equidade ou inclusão social.",
          "Impacto direto e abrangente ao autorizar temporariamente projetos com novas tecnologias, processos ou aplicações diferenciadas de tecnologias existentes, criando base legal para testes de sistemas avançados de UAM.",
          "Impacto pontual, pois a resolução foca em inovação tecnológica sem mencionar critérios ambientais específicos, avaliação de pegada de carbono ou mitigação de impactos ecológicos."
        )
      )
    ))
  }
  
  # ========================================================================
  # 3. PCA 351-7 - CONCEPÇÃO OPERACIONAL UAM NACIONAL
  # ========================================================================
  if (str_detect(nome_limpo, "pca.*351|351-7|351_7")) {
    return(list(
      nome_completo = "PCA 351-7 - Concepção Operacional UAM Nacional",
      url = "https://publicacoes.decea.mil.br/publicacao/PCA-351-7",
      resumo = c(
        "Propósito: Estabelecer a Concepção Operacional (CONOPS) nacional para a Mobilidade Aérea Urbana (UAM), sendo um documento evolutivo para orientar a implementação futura.",
        "Abordagem do Espaço Aéreo: Prioriza o compartilhamento do espaço aéreo (com requisitos) em detrimento de corredores exclusivos, considerado mais eficiente.",
        "Integração de Aeronaves: Foco na integração segura de novas aeronaves, como eVTOLs, ao espaço aéreo existente.",
        "Serviços Críticos: Criação do Plano Zona de Proteção do Voo (PZPV) para controle de obstáculos em vertiportos.",
        "Evolução por Níveis (UML): Implementação em fases: UML-2 (Operações iniciais e restritas); UML-3 (Expansão urbana condicionada a desempenho e ruído); UML-4 (Transporte regular em diversas metrópoles)"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 4, 5, 3),
        justificativas = c(
          "O documento estabelece a concepção operacional nacional, envolvendo múltiplas organizações do SISCEAB e prevendo coordenação com administrações municipais, demonstrando forte envolvimento governamental e estruturação federativa.",
          "Identifica benefícios econômicos como mitigação da saturação do transporte terrestre e geração de resultados econômicos, mas não detalha modelos de negócio, financiamento ou impactos macroeconômicos específicos.",
          "Aborda explicitamente a aceitação comunitária através da gestão de ruído, segurança das comunidades vizinhas e integração como modalidade de transporte, fatores críticos para a licença social para operar.",
          "Define requisitos técnicos abrangentes: serviços de cartografia com precisão para navegação em baixas altitudes, procedimentos de navegação baseados em grid, controle de obstáculos via PZPV e integração de eVTOLs no espaço aéreo.",
          "Menciona mitigação de impactos através de gestão de ruído e critérios ambientais para localização de vertiportos, porém não aborda pegada de carbono, eficiência energética ou conformidade com marco legal ambiental específico."
        )
      )
    ))
  }
  
  # ========================================================================
  # 4. LEI 7.565/1986 - CÓDIGO BRASILEIRO DE AERONÁUTICA
  # ========================================================================
  if (str_detect(nome_limpo, "l7565|7565")) {
    return(list(
      nome_completo = "Lei 7.565/1986 - Código Brasileiro de Aeronáutica",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l7565.htm",
      resumo = c(
        "Objeto da Lei: Regulamentação do Direito Aeronáutico no Brasil, complementando tratados internacionais e estabelecendo ordenação das atividades aeronáuticas no território nacional.",
        "Soberania sobre Espaço Aéreo: Define a jurisdição para o planejamento e controle de todas as operações aéreas dentro de suas fronteiras",
        "Zoneamento Aéreo: Possibilidade de fixação de zonas de tráfego proibido ou restrito, rotas específicas e delimitação de áreas para diferentes atividades aeronáuticas.",
        "Direito de Sobrevoo: Garantia de sobrevoo sobre propriedades privadas conforme normas vigentes, com previsão para pousos emergenciais e lançamento controlado de objetos.",
        "Infraestrutura Aeroportuária: Definições de aeródromos, helipontos, heliportos e suas áreas componentes, aplicáveis ao planejamento de vertiportos para UAM.",
        "Restrições Urbanísticas: Imposição de limitações a edificações e obstáculos no entorno de aeródromos mediante planos de proteção integrados ao zoneamento urbano municipal."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 2, 3, 3, 4),
        justificativas = c(
          "Estabelece a soberania nacional sobre o espaço aéreo e cria a estrutura fundamental de governança para toda atividade aeronáutica, demonstrando máxima influência estatal no setor.",
          "Define requisitos básicos para infraestrutura aeroportuária que impactam custos, mas não aborda modelos de negócio, financiamento ou incentivos específicos para UAM.",
          "Regula o direito de sobrevoo sobre propriedades privadas e estabelece restrições urbanísticas que afetam comunidades, com impacto moderado na relação sociedade-UAM.",
          "Define conceitos fundamentais de infraestrutura (aeródromos, heliportos) e planos de proteção que estabelecem bases técnicas, mas não especifica tecnologias avançadas para UAM.",
          "Estabelece Planos de Zoneamento de Ruído e Zoneamento de Proteção que integram requisitos ambientais ao planejamento urbano, com impacto relevante na gestão de impactos."
        )
      )
    ))
  }
  
  # ========================================================================
  # 5. LEI 11.182/2005 - CRIA A ANAC
  # ========================================================================
  if (str_detect(nome_limpo, "l11182|11182")) {
    return(list(
      nome_completo = "Lei 11.182/2005 - Cria a ANAC",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2004-2006/2005/Lei/L11182.htm",
      resumo = c(
        "Criação da ANAC como autarquia federal vinculada ao Ministério da Defesa",
        "Atribuições de regulação e fiscalização da aviação civil e infraestrutura aeroportuária",
        "Fiscalização de construção, reforma e ampliação de aeródromos",
        "Estabelecimento de normas para operação integrada entre aeródromos",
        "Adoção de medidas cautelares de segurança operacional"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 3, 2, 4, 2),
        justificativas = c(
          "Cria a principal agência reguladora da aviação civil com autonomia e competências abrangentes, estabelecendo a estrutura de governança estatal fundamental para todo o setor, incluindo UAM.",
          "Atribui à ANAC competências para fomentar a aviação civil e fiscalizar infraestrutura aeroportuária, impactando indiretamente a viabilidade econômica, mas sem menção a incentivos específicos.",
          "A atuação regulatória da ANAC inclui medidas de segurança que beneficiam a sociedade, mas o texto não aborda especificamente aceitação pública, equidade ou inclusão social.",
          "Concede competência para fiscalização técnica de construções aeroportuárias e normatização de operações integradas, estabelecendo bases para padrões técnicos da infraestrutura UAM.",
          "A fiscalização de construções de aeródromos pode incluir aspectos ambientais, mas o texto não menciona explicitamente requisitos ou impactos ambientais específicos."
        )
      )
    ))
  }
  
  # ========================================================================
  # 6. LEI 13.146/2015 - ESTATUTO DA PESSOA COM DEFICIÊNCIA
  # ========================================================================
  if (str_detect(nome_limpo, "l13146|13146")) {
    return(list(
      nome_completo = "Lei 13.146/2015 - Estatuto da Pessoa com Deficiência",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2015/lei/l13146.htm",
      resumo = c(
        "Estabelece o Estatuto da Pessoa com Deficiência",
        "Estabelece normas para transporte, mobilidade e acessibilidade"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 5, 4, 2),
        justificativas = c(
          "Estabelece política nacional de inclusão com força de lei, criando obrigações para todos os entes federativos e setores, incluindo transporte, com impacto relevante na governança da UAM.",
          "Implica custos adicionais para adequação de infraestruturas de transporte, impactando a viabilidade econômica, mas sem tratar especificamente de incentivos ou financiamento para UAM.",
          "Impacto direto e abrangente na inclusão social, estabelecendo requisitos obrigatórios de acessibilidade para transporte aéreo e infraestruturas, garantindo equidade no acesso à UAM.",
          "Exige concepção de produtos, ambientes e serviços com desenho universal, influenciando diretamente o desenvolvimento tecnológico de aeronaves e vertiportos para atender requisitos de acessibilidade.",
          "Foca principalmente em acessibilidade humana, com impacto ambiental indireto através da integração ao planejamento territorial, mas sem tratar especificamente de aspectos ecológicos."
        )
      )
    ))
  }
  
  # ========================================================================
  # 7. LEI 10.257/2001 - ESTATUTO DA CIDADE
  # ========================================================================
  if (str_detect(nome_limpo, "l10257|10257")) {
    return(list(
      nome_completo = "Lei 10.257/2001 - Estatuto da Cidade",
      url = "http://www.planalto.gov.br/ccivil_03/leis/leis_2001/l10257.htm",
      resumo = c(
        "Finalidade: Regulamenta os arts. 182 e 183 da Constituição Federal, estabelecendo diretrizes gerais da política urbana e normas de ordem pública e interesse social para regular o uso da propriedade urbana em prol do bem coletivo, da segurança, do bem-estar dos cidadãos e do equilíbrio ambiental.",
        "Instrumentos Principais: Inclui o Plano Diretor (obrigatório para cidades acima de 20 mil habitantes), o Estudo Prévio de Impacto de Vizinhança (EIV), as Operações Urbanas Consorciadas, a Outorga Onerosa do Direito de Construir e o Direito de Preempção (direito de preferência do município na compra de imóveis).",
        "Implicações para UAM: O Estatuto fornece o marco legal para integrar infraestruturas de UAM (como vertiportos) ao tecido urbano. O EIV avalia impactos no tráfego e na mobilidade, e o Plano Diretor define zonas e parâmetros para implantação de equipamentos urbanos, assegurando que a infraestrutura de UAM seja planejada de forma ordenada e sustentável."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 4, 2, 4),
        justificativas = c(
          "Estabelece diretrizes fundamentais da política urbana nacional, define instrumentos de gestão municipal (plano diretor, EIV) e confere ao Poder Público municipal preferência na aquisição de imóveis (direito de preempção), criando o marco governamental essencial para implementação de políticas de UAM.",
          "Impacto indireto ao criar condições para investimentos através do ordenamento do uso do solo e instrumentos como operações urbanas consorciadas, sem menção específica a incentivos fiscais ou modelos de negócio para UAM, mas estabelecendo base para viabilidade econômica de infraestruturas urbanas.",
          "Foca explicitamente no \"bem-estar dos cidadãos\", \"funções sociais da cidade\" e \"qualidade de vida da população\", exigindo no EIV análise de impactos na vizinhança e mobilidade urbana, fundamentais para aceitação social da UAM e mitigação de efeitos negativos sobre comunidades.",
          "Menção pontual à necessidade de infraestrutura urbana adequada e análise de demanda por transporte, sem especificar requisitos técnicos ou padrões tecnológicos para infraestruturas de UAM, focando principalmente no planejamento territorial convencional.",
          "Estabelece explicitamente \"equilíbrio ambiental\" como finalidade da lei e inclui no EIV a análise de impactos ambientais, além de orientar o planejamento urbano para sustentabilidade, criando base legal para avaliação ambiental de infraestruturas de UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 8. LEI 12.587/2012 - POLÍTICA NACIONAL DE MOBILIDADE URBANA
  # ========================================================================
  if (str_detect(nome_limpo, "l12587|12587")) {
    return(list(
      nome_completo = "Lei 12.587/2012 - Política Nacional de Mobilidade Urbana",
      url = "http://www.planalto.gov.br/ccivil_03/_ato2011-2014/2012/lei/l12587.htm",
      resumo = c(
        "Objeto da Lei: Instituir as diretrizes da Política Nacional de Mobilidade Urbana, integrando-a à política de desenvolvimento urbano para garantir o deslocamento de pessoas e cargas nos municípios.",
        "Sistema Nacional de Mobilidade Urbana: Conjunto organizado e coordenado dos modos de transporte (motorizados e não motorizados), serviços e infraestruturas que garantem os deslocamentos no território municipal.",
        "Princípios Orientadores: Acessibilidade universal, desenvolvimento sustentável, equidade no acesso ao transporte público, eficiência, segurança nos deslocamentos e justa distribuição de benefícios e ônus.",
        "Prioridade Modal: Estabelece a prioridade dos modos de transporte não motorizados sobre os motorizados e dos serviços de transporte público coletivo sobre o transporte individual motorizado.",
        "Plano de Mobilidade Urbana: Instrumento obrigatório para municípios com mais de 20 mil habitantes, que deve integrar os diferentes modos de transporte, infraestruturas, acessibilidade e mecanismos de financiamento.",
        "Integração com Novas Tecnologias: A lei cria o arcabouço para incorporação de modos inovadores, como a UAM, desde que alinhados aos princípios de acessibilidade, sustentabilidade e eficiência do sistema."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 4, 5, 3, 4),
        justificativas = c(
          "Estabelece a política nacional de mobilidade urbana com diretrizes abrangentes para todos os municípios, criando estrutura de governança obrigatória e integração com políticas setoriais, impactando diretamente a implementação da UAM.",
          "Define mecanismos de financiamento para sistemas de mobilidade e prioriza eficiência econômica, impactando a viabilidade financeira da UAM através da integração multimodal e planejamento de investimentos.",
          "Estabelece princípios de acessibilidade universal, equidade no acesso, inclusão social e segurança nos deslocamentos, com impacto direto e abrangente na integração social da UAM.",
          "Incentiva o desenvolvimento tecnológico e uso de energias renováveis, mas não especifica tecnologias avançadas para UAM, tendo impacto moderado no fator tecnológico.",
          "Prioriza desenvolvimento sustentável, mitigação de custos ambientais e energias renováveis, com impacto relevante na conformidade ambiental da UAM e integração ao planejamento urbano."
        )
      )
    ))
  }
  
  # ========================================================================
  # 9. LEI 10.098/2000 - ACESSIBILIDADE
  # ========================================================================
  if (str_detect(nome_limpo, "l10098|10098")) {
    return(list(
      nome_completo = "Lei 10.098/2000 - Acessibilidade",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l10098.htm",
      resumo = c(
        "Estabelece normas para promoção da acessibilidade em espaços públicos e privados",
        "Define critérios para eliminação de barreiras arquitetônicas e urbanísticas",
        "Regulamenta adaptações em vias públicas, edificações e transportes",
        "Estabelece requisitos técnicos baseados nas normas da ABNT",
        "Inclui disposições sobre comunicação e sinalização acessíveis"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 5, 3, 1),
        justificativas = c(
          "Estabelece política pública nacional de acessibilidade com caráter vinculante, exigindo que governos municipais e estaduais implementem as normas em espaços públicos e equipamentos urbanos, criando obrigações diretas para o poder público.",
          "Impacto econômico indireto ao estabelecer requisitos obrigatórios de adaptação que geram custos de implementação para infraestruturas públicas e privadas, sem mencionar incentivos fiscais ou financiamento específico para estas adaptações.",
          "Impacto direto e abrangente na inclusão social ao garantir acessibilidade para pessoas com deficiência e mobilidade reduzida em todos os espaços públicos, transportes e comunicações, sendo fundamental para evitar que a UAM se torne serviço de elite e promovendo equidade no acesso.",
          "Estabelece vinculação obrigatória às normas técnicas da ABNT para projetos urbanísticos e exige soluções técnicas específicas como sinalização tátil, criando parâmetros técnicos para infraestruturas terrestres de UAM, mas sem abordar tecnologias aeronáuticas específicas.",
          "Ausência de referência a impactos ecológicos, pegada de carbono ou requisitos ambientais, focando exclusivamente em aspectos de acessibilidade humana sem conexão com questões ambientais."
        )
      )
    ))
  }
  
  # ========================================================================
  # 10. LEI 9.503/1997 - CÓDIGO DE TRÂNSITO BRASILEIRO
  # ========================================================================
  if (str_detect(nome_limpo, "l9503|9503|ctb|código.*trânsito")) {
    return(list(
      nome_completo = "Lei 9.503/1997 - Código de Trânsito Brasileiro",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l9503.htm",
      resumo = c(
        "Regula direitos e deveres de quem participa do trânsito nas vias terrestres",
        "Estabelece conceitos como via pública, trânsito seguro e infraestrutura de transporte",
        "Define responsabilidades do poder público em garantir segurança no trânsito",
        "Prevê integração de modos de transporte urbano no planejamento municipal",
        "Cria obrigações para operadores de transporte público e privado"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(2, 2, 3, 1, 1),
        justificativas = c(
          "Estabelece responsabilidades do poder público no planejamento urbano e gestão da mobilidade, com impacto limitado à regulação terrestre sem menção específica a modais aéreos como UAM.",
          "Não aborda aspectos econômicos do setor de transporte, financiamento ou viabilidade de negócios, com impacto do CTB restrito ao transporte terrestre.",
          "Estabelece diretrizes para segurança e responsabilidade que beneficiam comunidades, com impacto moderado em percepção de risco e segurança, aplicável potencialmente à UAM em dimensão territorial.",
          "Não especifica requisitos tecnológicos avançados para transporte, limitando-se a conceitos gerais de infraestrutura viária, sem referência a comunicações, navegação ou sistemas autônomos.",
          "Ausência de referência a poluição atmosférica, emissões de carbono, ruído ou impactos ambientais de modais de transporte, com foco exclusivo em ordenamento viário terrestre."
        )
      )
    ))
  }
  
  # ========================================================================
  # 11. LEI 8.078/1990 - CÓDIGO DE DEFESA DO CONSUMIDOR
  # ========================================================================
  if (str_detect(nome_limpo, "l8078|8078|cdc|código.*consumidor")) {
    return(list(
      nome_completo = "Lei 8.078/1990 - Código de Defesa do Consumidor",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l8078.htm",
      resumo = c(
        "Estabelece proteção básica ao consumidor em operações de transporte e serviços",
        "Define direitos e deveres em relação a serviços prestados no mercado",
        "Cria obrigações de fornecedores em manter padrão de segurança e informação",
        "Estabelece responsabilidade por danos causados por produtos ou serviços"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(2, 1, 4, 1, 1),
        justificativas = c(
          "Cria modelo regulatório de proteção ao consumidor através do Estado, com envolvimento estatal moderado limitado a garantias de direitos básicos, sem políticas de fomento específicas.",
          "Impacto econômico indireto limitado às obrigações de segurança e responsabilidade civil que aumentam custos de operadores, sem mencionar investimentos, financiamento ou modelos de negócio.",
          "Impacto direto e abrangente ao garantir direitos de consumidores e construir confiança na prestação de serviços de transporte, elemento crítico para aceitação social da UAM como serviço comercial.",
          "Não especifica requisitos tecnológicos, mantendo-se no nível de obrigações genéricas de transparência e segurança aplicáveis a qualquer serviço.",
          "Ausência de consideração de impactos ambientais, sustentabilidade ou critérios ambientais em operações de transportes."
        )
      )
    ))
  }
  
  # ========================================================================
  # 12. LEI 13.465/2017 - REGULARIZAÇÃO FUNDIÁRIA
  # ========================================================================
  if (str_detect(nome_limpo, "l13465|13465")) {
    return(list(
      nome_completo = "Lei 13.465/2017 - Regularização Fundiária",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2017/lei/l13465.htm",
      resumo = c(
        "Define procedimentos para regularização de ocupações urbanas irregulares",
        "Estabelece conceitos como núcleo urbano informativo consolidado e reurbanização",
        "Institui competências das esferas administrativas para regularização de áreas",
        "Prevê compensação ambiental em processos de regularização",
        "Estabelece regimes simplificados para reconhecimento de posses",
        "Criação de diretrizes para ordenamento territorial em áreas ocupadas"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 2, 1, 3),
        justificativas = c(
          "Demonstra ação estatal em regulação de uso do solo urbano através de processos de regularização, delegando competências aos municípios, com impacto moderado em governança federativa para planejamento urbano.",
          "Implica custos para regularização e reurbanização que afetam valor de propriedades e viabilidade de projetos urbanos, com impacto moderado em viabilidade econômica de infraestruturas de UAM.",
          "Beneficia comunidades por regularizar ocupações, mas foca em populações de baixa renda sem tratar especificamente de inclusão ou equidade em novos modais de transporte.",
          "Não aborda tecnologias específicas de transporte, mantém foco em instrumentos legais tradicionais de ordenamento territorial.",
          "Exige compensação ambiental em processos de regularização, integrando considerações ambientais, com impacto moderado na sustentabilidade de projetos urbanos que possam incluir UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 13. RESOLUÇÃO ANATEL 653/2021
  # ========================================================================
  if (str_detect(nome_limpo, "res.*653|653|resanatel653")) {
    return(list(
      nome_completo = "Resolução ANATEL 653/2021",
      url = "https://www.anatel.gov.br/consumidor",
      resumo = c(
        "Regulamenta os serviços de comunicação eletrônica na banda UHF",
        "Estabelece diretrizes para uso compartilhado de infraestrutura de telecomunicações",
        "Define requisitos de cobertura para operadores de serviço público"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 4, 1, 2, 1),
        justificativas = c(
          "Estabelece política de compartilhamento de infraestrutura de telecomunicações, demostrando ação estatal na coordenação do setor para eficiência e redução de custos.",
          "Impacto relevante ao definir diretrizes que reduzem custos de implementação de infraestrutura de comunicações para operadores, viabilizando maior cobertura e acesso a serviços.",
          "Aborda questões de cobertura de serviços em comunidades, mas não trata especificamente de inclusão social ou equidade no acesso a serviços de transporte.",
          "Define requisitos técnicos para compartilhamento de infraestrutura de telecomunicações, com impacto moderado em viabilidade de redes de comunicação para UAM.",
          "Ausência de referência a impactos ambientais ou considerações de sustentabilidade relacionadas a infraestruturas de telecomunicações."
        )
      )
    ))
  }
          
  # ========================================================================
  # 14. LEI 9.605/1998 - CRIMES AMBIENTAIS
  # ========================================================================
  if (str_detect(nome_limpo, "l9605|9605|crimes.*ambientais")) {
    return(list(
      nome_completo = "Lei nº 9.605/1998 - Crimes Ambientais",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l9605.htm",
      resumo = c(
        "Tipificação de crimes contra fauna, flora, poluição, ordenamento urbano e patrimônio cultural",
        "Obrigatoriedade de licenciamento ambiental prévio para atividades potencialmente poluidoras",
        "Circunstâncias agravantes em áreas urbanas e assentamentos humanos",
        "Proteção de Unidades de Conservação, Áreas de Proteção Ambiental e bens tombados",
        "Regime de infrações administrativas com poder de polícia do SISNAMA",
        "Consideração de poluição atmosférica, hídrica e sonora como crimes ambientais",
        "Aplicabilidade a empreendimentos de infraestrutura urbana e territorial"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 1, 3, 1, 5),
        justificativas = c(
          "Estabelece obrigações de licenciamento e fiscalização ambiental pelo SISNAMA, criando um arcabouço regulatório que condiciona a implantação de infraestrutura UAM, mas não aborda políticas de fomento, incentivos ou coordenação federativa.",
          "O texto não contém referências a viabilidade financeira, modelos de negócio, investimentos, geração de empregos ou desenvolvimento regional; seu impacto econômico é apenas indireto por meio de custos de conformidade.",
          "Protege áreas urbanas e assentamentos humanos (art. 15), considera a saúde da população em crimes de poluição (art. 54) e resguarda o patrimônio cultural (arts. 62–65), elementos que influenciam a localização e aceitação social de vertiports e rotas UAM.",
          "O documento não menciona tecnologias de suporte, infraestrutura de comunicações, gêmeos digitais ou inovação; restringe-se a exigir licenciamento e estudo de impacto ambiental, sem especificações técnicas.",
          "A lei é o principal marco legal de proteção ambiental, tipificando crimes de poluição (inclusive sonora e atmosférica), exigindo licenciamento prévio para atividades poluidoras (art. 60), protegendo unidades de conservação (art. 40) e estabelecendo sanções administrativas – todos aplicáveis diretamente à operação e infraestrutura da UAM."
        )
      )
    ))
  }

  # ========================================================================
  # 15. LEI 12.187/2009 - POLÍTICA NACIONAL SOBRE MUDANÇA DO CLIMA
  # ========================================================================
  if (str_detect(nome_limpo, "l12187|12187|pnmc|mudança.*clima")) {
    return(list(
      nome_completo = "Lei 12.187/2009 - Política Nacional sobre Mudança do Clima (PNMC)",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2007-2010/2009/lei/l12187.htm",
      resumo = c(
        "Instituição da Política Nacional sobre Mudança do Clima e seus instrumentos legais voltados ao meio ambiente.",
        "Previsão de medidas de mitigação e de adaptação coordenadas entre as esferas de governo e a sociedade civil.",
        "Alinhamento das políticas públicas e dos programas governamentais aos objetivos climáticos definidos nacionalmente.",
        "Exigência de planos setoriais voltados para a redução de carbono nos modais de transporte urbano e de passageiros.",
        "Submissão de novas infraestruturas de mobilidade, como a UAM, às metas gradativas e verificáveis de redução de emissões."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 2, 3, 1, 5),
        justificativas = c(
          "Estabelece diretrizes obrigatórias para o planejamento governamental (Art. 4º) e exige o alinhamento de todas as políticas públicas aos objetivos climáticos (Art. 11). Isso cria um mandato político para que futuras regulamentações da UAM incorporem metas de mitigação, demonstrando forte influência do governo federal sobre o setor.",
          "O impacto econômico é indireto. A lei não trata de viabilidade financeira, modelos de negócio ou incentivos fiscais para a UAM. No entanto, ao determinar planos setoriais para redução de emissões no transporte (Art. 11), pode vir a influenciar os custos operacionais futuros e direcionar investimentos para tecnologias mais limpas.",
          "Aborda a necessidade de coordenar medidas com a sociedade civil e focar em grupos suscetíveis aos impactos climáticos (Art. 4º, inciso V). Isso se relaciona indiretamente com a aceitação pública da UAM e com a necessidade de equidade, ao exigir que os planos de adaptação considerem todos os agentes sociais afetados.",
          "O texto legal não faz qualquer menção a tecnologias específicas, infraestrutura de suporte (como vertiportos ou redes de comunicação), inovação ou parâmetros técnicos para operações aéreas. A influência sobre o fator tecnológico é nula.",
          "A lei é a pedra angular da política ambiental climática no Brasil. Ela impacta diretamente a UAM ao definir a necessidade de planos setoriais de mitigação e adaptação para o transporte urbano (Art. 11), submetendo a futura operação de aeronaves a metas progressivas e verificáveis de redução de emissões (pegada de carbono) e exigindo conformidade com o marco legal ambiental."
        )
      )
    ))
  }

  # ========================================================================
  # 16. DECRETO 6.780/2009 - POLÍTICA NACIONAL DE AVIAÇÃO CIVIL (PNAC)
  # ========================================================================
  if (str_detect(nome_limpo, "d6780|6780|pnac")) {
    return(list(
      nome_completo = "Decreto nº 6.780/2009 - Política Nacional de Aviação Civil (PNAC)",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2007-2010/2009/decreto/d6780.htm",
      resumo = c(
        "Estabelece diretrizes para o desenvolvimento da aviação civil no Brasil.",
        "Define objetivos voltados à segurança, eficiência e integração modal.",
        "Prevê coordenação entre entes federativos para controle de riscos operacionais.",
        "Aborda o uso do solo urbano no entorno de aeródromos.",
        "Inclui diretrizes para mitigação de ruídos e impactos ambientais.",
        "Estimula controle e compatibilização do planejamento urbano com zonas aeroportuárias.",
        "Orienta a ocupação econômica nas áreas próximas aos aeroportos.",
        "Apresenta diretrizes aplicáveis à implementação da mobilidade aérea urbana (UAM)."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 3, 3, 2, 5),
        justificativas = c(
          "O decreto institui a PNAC como instrumento orientador do setor, prevê articulação entre entes federativos e estabelece diretrizes de planejamento urbano e proteção de aeródromos, influenciando diretamente a formulação de políticas públicas para a aviação civil, inclusive para a UAM.",
          "Embora não aborde financiamento ou modelos de negócio, incentiva a instalação de atividades econômicas compatíveis no entorno aeroportuário e preconiza a integração multimodal, criando condições favoráveis ao desenvolvimento econômico indireto do setor.",
          "Trata da redução do adensamento populacional em áreas sujeitas a ruído e emissões, bem como da compatibilização do uso do solo, impactando a qualidade de vida urbana. Não aborda aceitação pública ou equidade de acesso de forma explícita.",
          "O documento menciona a preservação de auxílios à navegação aérea e o controle de zonas de proteção, mas não detalha tecnologias específicas de suporte à UAM (como U-space, 5G, vertiportos), limitando sua influência direta.",
          "Dedica seção específica à proteção ambiental, estabelecendo diretrizes para o tratamento equilibrado do ruído aeronáutico, redução de emissões e compatibilização entre operação aérea e planejamento urbano, impactando diretamente a sustentabilidade da UAM."
        )
      )
    ))
  }

  # ========================================================================
  # 17. DECRETO 99.274/1990 - REGULAMENTA PNMA
  # ========================================================================
  if (str_detect(nome_limpo, "d99274|99274")) {
    return(list(
      nome_completo = "Decreto nº 99.274/1990 - Regulamenta a Política Nacional do Meio Ambiente",
      url = "http://www.planalto.gov.br/ccivil_03/decreto/d99274.htm",
      resumo = c(
        "O documento regulamenta a Política Nacional do Meio Ambiente e o controle de atividades econômicas.",
        "O Conselho Nacional do Meio Ambiente é designado para definir os limites de emissões de aeronaves e veículos.",
        "O licenciamento é estruturado em fases, envolvendo as licenças Prévia, de Instalação e de Operação.",
        "A emissão da Licença Prévia depende da adequação aos planos municipais, estaduais e federais de uso do solo.",
        "A legislação ambiental orienta o planejamento territorial e as exigências operacionais para a infraestrutura da UAM."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 2, 1, 3, 5),
        justificativas = c(
          "Estabelece as bases da ação governamental na política ambiental, atribui ao poder público o monitoramento de atividades poluidoras e define competências do CONAMA. Exige coordenação federativa ao condicionar licenças ao cumprimento de normas de uso do solo nas três esferas, influenciando diretamente a regulação da UAM.",
          "Impacto econômico indireto: ao criar exigências de licenciamento e padrões de emissão, pode gerar custos de conformidade para operadores e fabricantes, mas o texto não menciona incentivos financeiros, fomento ou viabilidade de negócios.",
          "Não há referência a aceitação pública, equidade, inclusão ou percepção de risco. O foco restringe-se à proteção ambiental e ao controle de poluição, sem tratar de aspectos sociais da UAM.",
          "Define limites de emissão para aeronaves e condiciona o licenciamento de infraestrutura (vertiportos), o que impulsiona a adoção de tecnologias mais limpas e a adequação de projetos. Contudo, não detalha inovações ou parâmetros técnicos específicos para a UAM.",
          "É o núcleo do decreto: regulamenta a Política Nacional do Meio Ambiente, estabelece o licenciamento ambiental em fases e atribui ao CONAMA a fixação de padrões de emissão. A relação com a UAM é explícita na exigência de licenciamento para infraestrutura e no cumprimento de índices de poluição pelas aeronaves."
        )
      )
    ))
  }

  # ========================================================================
  # 18. LEI 7.661/1988 - PLANO NACIONAL DE GERENCIAMENTO COSTEIRO (PNGC)
  # ========================================================================
  if (str_detect(nome_limpo, "l7661|7661|pngc")) {
    return(list(
      nome_completo = "Lei nº 7.661/1988 - Plano Nacional de Gerenciamento Costeiro (PNGC)",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l7661.htm",
      resumo = c(
        "Institui o Plano Nacional de Gerenciamento Costeiro (PNGC)",
        "Define a Zona Costeira como área de interação ar-mar-terra",
        "Estabelece diretrizes para zoneamento e uso do território",
        "Regulamenta o licenciamento ambiental na zona costeira",
        "Articula políticas federais, estaduais e municipais"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 2, 2, 2, 5),
        justificativas = c(
          "Estabelece política nacional de gestão costeira com articulação federativa entre União, estados e municípios, criando estrutura de governança territorial relevante para implantação de infraestruturas UAM em zonas costeiras.",
          "Impacto indireto ao estabelecer restrições de uso do solo que podem afetar custos de implantação, mas sem tratar especificamente de incentivos ou modelos econômicos para UAM.",
          "Foca na preservação de bens culturais e naturais com benefícios sociais indiretos, mas não aborda especificamente inclusão, equidade ou aceitação social da UAM.",
          "Estabelece diretrizes gerais para sistema viário e urbanização, mas não aborda tecnologias avançadas ou infraestruturas específicas para UAM.",
          "Impacto direto e abrangente ao instituir regime especial de proteção ambiental para zona costeira, com licenciamento obrigatório e zoneamento ecológico que condiciona totalmente a implantação de infraestruturas UAM."
        )
      )
    ))
  }

  # ========================================================================
  # 19. LEI 12.651/2012 - CÓDIGO FLORESTAL
  # ========================================================================
  if (str_detect(nome_limpo, "l12651|12651|código.*florestal")) {
    return(list(
      nome_completo = "Lei N° 12.651/2012 - Código Florestal",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2011-2014/2012/lei/l12651.htm",
      resumo = c(
        "Objetivo da Lei: Estabelece normas sobre proteção e uso da vegetação nativa.",
        "Definições: Define conceitos como Área de Preservação Permanente (APP) e área urbana consolidada.",
        "Tipos de APP: Lista as áreas consideradas APPs, como faixas marginais de rios, entorno de lagos, nascentes e encostas.",
        "Áreas Verdes Urbanas: Apresenta instrumentos municipais para a criação de áreas verdes.",
        "Implicações para UAM: As restrições em APPs e as regras de intervenção podem condicionar a localização de infraestruturas, como vertiportos."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 2, 1, 5),
        justificativas = c(
          "Impacto moderado ao estabelecer política nacional de proteção vegetal com competências municipais para criação de áreas verdes urbanas, criando estrutura de governança ambiental que condiciona políticas de uso do solo para UAM.",
          "Impacto pontual ao criar restrições de uso do solo que podem aumentar custos de implantação de infraestruturas de UAM em áreas protegidas, sem mencionar incentivos econômicos ou mecanismos de compensação específicos.",
          "Impacto marginal ao visar preservação de paisagem e biodiversidade que pode contribuir para qualidade de vida urbana, mas sem foco específico em inclusão social, equidade ou aceitação pública de infraestruturas de transporte.",
          "Ausência de referência a requisitos tecnológicos, sistemas de comunicação, navegação ou qualquer aspecto técnico relacionado à infraestrutura ou operações de transporte aéreo urbano.",
          "Impacto direto e abrangente ao estabelecer proteção legal para vegetação nativa, APPs em zonas urbanas e rurais, com restrições específicas para intervenção em áreas protegidas que condicionam diretamente a localização de vertiportos e rotas de UAM."
        )
      )
    ))
  }

  # ========================================================================
  # 20. LEI 12.725/2012 - CONTROLE DA FAUNA NAS IMEDIAÇÕES DE AERÓDROMOS
  # ========================================================================
  if (str_detect(nome_limpo, "l12725|12725|fauna.*aeródromos")) {
    return(list(
      nome_completo = "Lei nº 12.725/2012 - Controle da fauna nas imediações de aeródromos",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2011-2014/2012/lei/l12725.htm",
      resumo = c(
        "Esta lei estabelece a Área de Segurança Aeroportuária (ASA) com um raio de 20 km ao redor de aeródromos, onde se aplicam restrições de uso e ocupação do solo.",
        "As autoridades municipais devem incorporar essas restrições no planejamento territorial e no licenciamento ambiental.",
        "O documento define atividades atrativas de fauna e estabelece sanções para infrações.",
        "Suas disposições se aplicam a aeródromos, incluindo infraestruturas de UAM, como vertiportos."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 3, 2, 4),
        justificativas = c(
          "Estabelece articulação federativa entre autoridades de aviação civil, municipais e ambientais, criando estrutura de governança territorial obrigatória para aeródromos que se aplica diretamente a vertiportos UAM.",
          "Implica custos adicionais para controle de fauna e restrições de uso do solo que impactam a viabilidade econômica de vertiportos, mas sem tratar de incentivos ou financiamento específico.",
          "Foca na segurança operacional que beneficia a população vizinha, com impacto moderado na aceitação social, mas não aborda especificamente equidade ou inclusão no acesso à UAM.",
          "Estabelece requisitos gerais para manejo ambiental de aeródromos, mas não aborda tecnologias avançadas de comunicação, navegação ou infraestrutura específica para UAM.",
          "Impacto relevante ao exigir licenciamento ambiental específico, planos de manejo da fauna e restrições a atividades atrativas de fauna, condicionando a implantação de vertiportos a critérios ambientais."
        )
      )
    ))
  }

  # ========================================================================
  # 21. LEI 6.902/1981 - CRIAÇÃO DE ESTAÇÕES ECOLÓGICAS E ÁREAS DE PROTEÇÃO AMBIENTAL
  # ========================================================================
  if (str_detect(nome_limpo, "l6902|6902|estações.*ecológicas")) {
    return(list(
      nome_completo = "Lei nº 6.902/1981 - Criação de Estações Ecológicas e Áreas de Proteção Ambiental",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l6902.htm",
      resumo = c(
        "Define Estações Ecológicas como áreas representativas de ecossistemas brasileiros destinadas à pesquisa e preservação ambiental.",
        "Autoriza União, Estados e Municípios a criarem Estações Ecológicas, com limites e órgãos administrativos definidos.",
        "Determina que as Estações Ecológicas possibilitem estudos comparativos entre áreas naturais e modificadas.",
        "Permite ao Poder Executivo declarar áreas como de interesse para proteção ambiental, visando à conservação ecológica e ao bem-estar humano.",
        "Estabelece restrições em Áreas de Proteção Ambiental, proibindo atividades que causem poluição, erosão, assoreamento ou ameaça à fauna e flora.",
        "Implica na necessidade de compatibilizar projetos de UAM com zonas de preservação, assegurando conformidade com normas ambientais e de ordenamento territorial."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 2, 1, 5),
        justificativas = c(
          "Impacto moderado ao estabelecer competência tripartite (União, Estados, Municípios) para criação de unidades de conservação, criando estrutura de governança ambiental que condiciona políticas de ordenamento territorial relevantes para UAM.",
          "Impacto pontual ao criar restrições que podem aumentar custos de implantação de infraestruturas próximas a áreas protegidas, sem mencionar incentivos econômicos ou mecanismos de compensação para projetos de transporte sustentável.",
          "Impacto marginal ao visar bem-estar humano através da conservação ambiental, criando benefícios indiretos para qualidade de vida, mas sem foco específico em inclusão social ou aceitação pública de infraestruturas de transporte.",
          "Ausência completa de referência a requisitos tecnológicos, sistemas de comunicação, infraestrutura técnica ou qualquer aspecto tecnológico relacionado a operações de transporte ou mobilidade urbana.",
          "Impacto direto e abrangente ao criar instrumentos legais para proteção ambiental (Estações Ecológicas e APAs) com restrições específicas a atividades poluidoras e obras que alterem condições ecológicas, condicionando diretamente a localização de vertiportos e rotas de UAM."
        )
      )
    ))
  }

  # ========================================================================
  # 22. RESOLUÇÃO CONAMA 2/1990 - PROGRAMA SILÊNCIO
  # ========================================================================
  if (str_detect(nome_limpo, "res.*conama.*002|conama.*2|silêncio")) {
    return(list(
      nome_completo = "Resolução CONAMA nº 2/1990 - Programa SILÊNCIO",
      url = "https://conama.mma.gov.br/?option=com_sisconama&task=arquivo.download&id=145",
      resumo = c(
        "O Programa SILÊNCIO visa à educação e ao controle da poluição sonora em nível nacional.",
        "O texto preconiza a manutenção do conforto ambiental e a mitigação dos impactos sonoros nos centros urbanos.",
        "A resolução orienta o desenvolvimento de veículos que operem com menor emissão de ruído.",
        "A gestão e a implementação das ações de controle são delegadas aos órgãos estaduais e municipais.",
        "A legislação permite aos municípios e estados a fixação de limites de emissão sonora mais restritivos do que os definidos nacionalmente."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 2, 5, 3, 5),
        justificativas = c(
          "Estabelece a coordenação nacional pelo IBAMA e a cooperação entre esferas federais, estaduais e municipais para o controle de ruídos. Define competências claras para a implementação de programas descentralizados.",
          "Incentiva a fabricação e o uso de máquinas e equipamentos com menor intensidade de ruído na indústria e veículos. Prevê apoio técnico e logístico, mas sem detalhar mecanismos de financiamento específicos para UAM.",
          "Foca diretamente na saúde, bem-estar público e qualidade de vida da população. Propõe a introdução do tema em currículos escolares e campanhas educativas para conscientização sobre ruídos.",
          "Promove o desenvolvimento de dispositivos e motores mais silenciosos. Prevê a capacitação técnica de pessoal para o controle da poluição sonora, embora não mencione tecnologias CNS/ATM ou redes 5G/6G.",
          "O documento trata especificamente do controle da poluição sonora como um direito ao conforto ambiental. Estabelece diretrizes para a manutenção da qualidade ambiental e mitigação de danos à saúde."
        )
      )
    ))
  }

  # ========================================================================
  # 23. RESOLUÇÃO ANEEL 1.000/2021
  # ========================================================================
  if (str_detect(nome_limpo, "aneel.*1000|1000|aneel.*distribução")) {
    return(list(
      nome_completo = "Resolução Normativa ANEEL nº 1.000/2021 - Regras de Prestação do Serviço Público de Distribuição de Energia Elétrica",
      url = "https://www2.aneel.gov.br/cedoc/ren20211000.pdf",
      resumo = c(
        "Define regras gerais para prestação do serviço de distribuição de energia elétrica.",
        "Estabelece direitos e deveres de consumidores, concessionárias e demais agentes.",
        "Regula a instalação de estações de recarga (Art. 550), exigindo comunicação prévia à distribuidora.",
        "Determina critérios para custos de conexão e adequação da rede (Art. 551).",
        "Exige uso de protocolos abertos em estações públicas ou comerciais (Art. 552).",
        "Impõe conformidade com normas técnicas da distribuidora e órgãos competentes (Art. 553).",
        "Permite exploração comercial da recarga com preços negociados (Art. 554).",
        "Restringe a injeção de energia na rede e participação no SCEE (Art. 555).",
        "Garante ressarcimento por danos elétricos conforme regras gerais (Art. 556).",
        "Autoriza distribuidoras a operar estações, sem inclusão dos ativos na base tarifária (Art. 557–560).",
        "Estabelece requisitos técnicos gerais como proteção e aterramento (Art. 29 e 30).",
        "Regula o processo de aumento de carga e conexão (Art. 63 e 67).",
        "Aplica-se à infraestrutura de recarga relevante para sistemas de mobilidade elétrica, incluindo UAM."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 5, 2, 5, 4),
        justificativas = c(
          "Norma emitida pela agência reguladora ANEEL demonstra ação estatal proativa ao criar um arcabouço regulatório específico para a infraestrutura de recarga de veículos elétricos (Capítulo V). Estabelece políticas e diretrizes que fundamentam o desenvolvimento do ecossistema da UAM, conferindo segurança e previsibilidade.",
          "Impacto direto e estruturante na viabilidade financeira da UAM. A norma permite explicitamente a exploração comercial dos serviços de recarga com preços negociados (Art. 554), viabilizando modelos de negócio para operadores de vertiportos. Define que custos de adequação da rede seguem critérios gerais (Art. 551), estabelecendo previsibilidade para investimentos.",
          "Influência pontual e indireta ao regulamentar infraestrutura de recarga, criando bases para existência do serviço de mobilidade elétrica, um pré-requisito para que a sociedade possa usufruir de seus benefícios no futuro.",
          "Máxima influência ao definir parâmetros críticos para infraestrutura terrestre e de energia da UAM. Exigência de protocolos abertos (Art. 552) garante interoperabilidade entre operadores. Conformidade com normas técnicas (Arts. 29, 553) estabelece padrões para integração segura dos sistemas.",
          "Boa influência ao fornecer base regulatória para eletrificação da mobilidade. Viabiliza substituição de modais baseados em combustíveis fósseis por alternativas elétricas, alinhando-se com descarbonização."
        )
      )
    ))
  }

  # ========================================================================
  # 24. RESOLUÇÃO ANEEL 1.059/2023
  # ========================================================================
  if (str_detect(nome_limpo, "aneel.*1\\.?059|resolu.*aneel.*1\\.?059|\\b1059\\b|\\b1\\.059\\b")) {
    return(list(
      nome_completo = "Resolução Normativa Aneel nº 1.059/2023 - Regras de Microgeração e Minigeração Distribuída",
      url = "https://www.aneel.gov.br/",
      resumo = c(
        "Definição de critérios para autoconsumo remoto, geração compartilhada e empreendimentos com múltiplas unidades consumidoras.",
        "Exigência de contiguidade física para propriedades que compõem empreendimentos de múltiplas unidades.",
        "Regulamentação de centrais fotovoltaicas flutuantes e sistemas de tração elétrica para transporte público.",
        "Obrigatoriedade de estudos técnicos em casos de inversão de fluxo de potência na rede de distribuição.",
        "Padronização de requisitos de proteção e medição georreferenciada para ativos de geração."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 4, 2, 5, 4),
        justificativas = c(
          "Resolução da ANEEL estabelece políticas e diretrizes para integração da geração distribuída, demonstrando ação estatal na criação de arcabouço regulatório que fundamenta ecossistema UAM.",
          "Viabiliza modelos de negócio ao regulamentar autoconsumo remoto e geração compartilhada. Permite que infraestrutura de recarga em vertiportos seja suprida por energia renovável de outras unidades, otimizando custos.",
          "Influência pontual ao não abordar diretamente fatores sociais críticos como aceitação pública, ruído, equidade ou percepção de segurança da UAM.",
          "Máxima influência ao definir infraestrutura terrestre e de energia necessária para operação da UAM. Estabelece requisitos técnicos para tração elétrica, medidores autônomos e identificação georreferenciada.",
          "Boa influência na dimensão ambiental ao promover uso de fontes renováveis, contribuindo para descarbonização da matriz energética que alimentará aeronaves elétricas."
        )
      )
    ))
  }

  # ========================================================================
  # 25. RESOLUÇÃO ANAC 736/2024 - OPERADORES DE AERÓDROMO
  # ========================================================================
  if (str_detect(nome_limpo, "resolução.*736|res.*736|anac.*736")) {
    return(list(
      nome_completo = "Resolução ANAC nº 736/2024 - Operadores de Aeródromo",
      url = "https://www.anac.gov.br/",
      resumo = c(
        "Definição do operador de aeródromo como o responsável legal perante a ANAC.",
        "Exigência de homologação (uso público) ou registro (uso privativo) para abertura ao tráfego aéreo.",
        "Obrigatoriedade de cadastro atualizado de todas as infraestruturas e auxílios à navegação aérea.",
        "Possibilidade de exclusão do cadastro em caso de conflito com normas municipais, estaduais ou federais.",
        "Estabelecimento de sanções administrativas e multas para o descumprimento das normas de atualização cadastral."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 1, 1, 2, 2),
        justificativas = c(
          "Estabelece marco regulatório para constituição de operadores de aeródromo, definindo responsabilidades perante ANAC, conformidade com normas do Comando da Aeronáutica e legislações municipais/estaduais/federais, evidenciando atuação governamental com coordenação federativa.",
          "O texto não aborda aspectos de viabilidade financeira, custos operacionais, incentivos fiscais, financiamento ou impactos econômicos da UAM. Não há menção a modelos de negócio ou desenvolvimento regional.",
          "Não há referência a aceitação pública, ruído, percepção de risco, acessibilidade ou inclusão social. Foca em aspectos técnicos e administrativos.",
          "Exige cadastro de instalações e equipamentos de auxílio à navegação, indiretamente requerendo infraestrutura tecnológica dos aeródromos. Sem detalhamento de parâmetros técnicos ou inovações.",
          "Previsão de exclusão do cadastro em conflito com legislações ambientais municipais/estaduais, sugerindo conformidade com requisitos ambientais locais, mas sem detalhamento de impactos ecológicos ou específicos."
        )
      )
    ))
  }
  
  # ========================================================================
  # 26. LEI 9.427/1996 - INSTITUI A ANEEL
  # ========================================================================
  if (str_detect(nome_limpo, "l9427|9427")) {
    return(list(
      nome_completo = "Lei 9.427/1996 - Institui a ANEEL",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l9427cons.htm",
      resumo = c(
        "Criação da Agência Nacional de Energia Elétrica (ANEEL) na qualidade de autarquia sob regime especial.",
        "Determinação de competências para a fiscalização da produção, transmissão, distribuição e comercialização de energia elétrica.",
        "Regulamentação do regime econômico e financeiro voltado às concessões do serviço público de energia elétrica.",
        "Inexistência de dispositivos legais aplicáveis à infraestrutura ou ao planejamento da Mobilidade Aérea Urbana (UAM)."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(2, 3, 1, 1, 1),
        justificativas = c(
          "Cria a ANEEL como autarquia reguladora, demonstrando capacidade estatal de estabelecer marcos setoriais e agências especializadas, mas não contém qualquer disposição sobre UAM, aviação civil ou planejamento urbano.",
          "Regula concessões e o regime econômico-financeiro do setor de energia elétrica, que é fundamental para a infraestrutura de recarga de eVTOLs. No entanto, não aborda modelos de negócio, custos operacionais, financiamento ou viabilidade específica da UAM, configurando impacto indireto e não determinante.",
          "O texto não menciona aspectos sociais como aceitação pública, ruído, equidade ou percepção de risco, limitando-se à regulação técnica e econômica do setor elétrico.",
          "Ausência de referências a tecnologias de suporte para UAM (CNS/ATM, vertiportos, gêmeos digitais) ou inovações no setor aéreo; a lei concentra-se exclusivamente na produção e distribuição de energia elétrica.",
          "Inexistência de dispositivos sobre impactos ecológicos, licenciamento ambiental, poluição sonora ou conformidade com legislação verde aplicável à UAM; a norma não trata de questões ambientais."
        )
      )
    ))
  }

  # ========================================================================
  # 27. LEI 9.074/1995 - CONCESSÕES E PERMISSÕES DE SERVIÇOS PÚBLICOS
  # ========================================================================
  if (str_detect(nome_limpo, "l9074|9074")) {
    return(list(
      nome_completo = "Lei 9.074/1995 - Concessões e permissões de serviços públicos",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l9074cons.htm",
      resumo = c(
        "Norma que institui o regime de concessões e permissões para serviços públicos de competência da União.",
        "Especifica a aplicação das regras a infraestruturas como vias rodoviárias federais, instalações de barragens, terminais alfandegados e operações postais.",
        "Apresenta regulação estruturada para a prestação de serviços no setor de energia elétrica.",
        "Omite disposições relacionadas ao planejamento do espaço aéreo ou ao desenvolvimento da mobilidade aérea urbana."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(2, 1, 1, 1, 1),
        justificativas = c(
          "A lei estabelece o regime de concessões para serviços públicos de competência da União (art. 1º), o que representa um envolvimento estatal na gestão de infraestrutura. No entanto, o texto não menciona a aviação civil, a UAM ou qualquer diretriz para agências reguladoras do setor aéreo, limitando-se a setores como energia elétrica e rodovias.",
          "O documento não aborda viabilidade financeira, modelos de negócio, investimentos, custos operacionais ou geração de empregos relacionados à UAM. Suas disposições econômicas concentram-se na outorga de concessões para setores convencionais, sem qualquer relação com a mobilidade aérea urbana.",
          "Ausência de referências a impactos sociais, aceitação pública, equidade, acessibilidade ou percepção de risco. A lei trata exclusivamente de procedimentos administrativos para delegação de serviços públicos, sem considerar aspectos sociais ou comunitários.",
          "O texto não menciona tecnologias de suporte, infraestrutura de comunicações, sistemas de navegação aérea, vertiportos ou qualquer inovação tecnológica relacionada à UAM. Sua abordagem é restrita a setores tradicionais de infraestrutura.",
          "Inexistência de dispositivos sobre impactos ecológicos, licenciamento ambiental, poluição sonora, emissões ou conformidade com legislação verde. A lei não estabelece requisitos ambientais aplicáveis à implantação ou operação de sistemas de mobilidade aérea urbana."
        )
      )
    ))
  }

  # ========================================================================
  # 28. RBAC 139 - CERTIFICAÇÃO OPERACIONAL DE AEROPORTOS
  # ========================================================================
  if (str_detect(nome_limpo, "rbac.*139|rbac139")) {
    return(list(
      nome_completo = "RBAC 139 - Certificação Operacional de Aeroportos",
      url = "https://www.anac.gov.br/assuntos/legislacao/legislacao-1/rbha-e-rbac/rbac/rbac-139",
      resumo = c(
        "Estabelece os critérios de Certificação Operacional de Aeroportos civis com operações internacionais.",
        "Isenta a aplicação de suas diretrizes a infraestruturas classificadas como heliportos e helipontos.",
        "Requer a compatibilização do Plano Básico de Zona de Proteção de Aeródromo (PBZPA) com as especificações operativas da instalação.",
        "Determina que o operador aprove o PBZPA junto ao Comando da Aeronáutica, regulando o uso do solo nas adjacências.",
        "Apresenta interface restrita com a Mobilidade Aérea Urbana (UAM), fundamentada na demarcação das zonas de proteção aeroportuária."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(2, 1, 1, 2, 2),
        justificativas = c(
          "O regulamento envolve a ANAC e o Comando da Aeronáutica na aprovação do PBZPA, indicando ação governamental, mas seu escopo não abrange diretamente a UAM, limitando-se a aeroportos convencionais.",
          "Não há menção a aspectos econômicos como viabilidade financeira, custos operacionais, investimentos ou incentivos fiscais relacionados à UAM. O foco é administrativo e operacional para aeroportos certificados.",
          "O texto não aborda questões sociais como aceitação pública, equidade, inclusão ou percepção de risco da UAM. As disposições são técnicas e restritas ao ambiente aeroportuário convencional.",
          "Embora exija a compatibilização do PBZPA, o regulamento não menciona tecnologias de suporte à UAM (ex.: U-space, 5G, vertiportos). O impacto é indireto e limitado.",
          "A exigência de compatibilização do PBZPA com o uso do solo no entorno tem implicações ambientais indiretas, mas não há referência a gestão de ruído, pegada de carbono ou licenciamento ambiental específico para UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 29. LEI 6.766/1979 - PARCELAMENTO DO SOLO URBANO
  # ========================================================================
  if (str_detect(nome_limpo, "l6766|6766")) {
    return(list(
      nome_completo = "Lei 6.766/1979 - Parcelamento do Solo Urbano",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l6766.htm",
      resumo = c(
        "Regulamenta o parcelamento do solo urbano.",
        "Exige faixas não edificáveis em áreas ambientais e viárias."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 2, 2, 4),
        justificativas = c(
          "Estabelece o marco regulatório federal para parcelamento do solo urbano, delegando competências a estados e municípios, criando estrutura de governança territorial relevante para a localização de infraestruturas UAM em zonas costeiras.",
          "Define requisitos para alocação de áreas públicas e equipamentos urbanos que impactam custos de implantação de vertiportos, mas não aborda especificamente incentivos ou modelos de negócio para UAM.",
          "Estabelece normas gerais de parcelamento que beneficiam a coletividade, mas não trata especificamente de acessibilidade, inclusão ou impactos sociais diretos da UAM.",
          "Exige infraestrutura básica urbana (sistemas de circulação, energia), mas não aborda tecnologias avançadas ou infraestruturas específicas para UAM.",
          "Proíbe parcelamento em áreas com limitações ambientais e exige faixas não edificáveis em áreas de preservação, com impacto relevante na conformidade ambiental da implantação de infraestruturas UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 27. LEI 10.636/2002 - RECURSOS ORIGINÁRIOS CIDE
  # ========================================================================
  if (str_detect(nome_limpo, "l10636|10636")) {
    return(list(
      nome_completo = "Lei 10.636/2002 - Recursos originários CIDE",
      url = "https://www.planalto.gov.br/ccivil_03/leis/2002/l10636.htm",
      resumo = c(
        "Objetivo: Destinar recursos da CIDE sobre combustíveis ao financiamento da infraestrutura de transportes e criar o FNIT (Art. 1º).",
        "Aplicação dos Recursos: Investimentos voltados à eficiência, segurança, conforto, qualidade de vida e redução de custos logísticos (Art. 6º).",
        "Fundo de Financiamento: O FNIT, vinculado ao Ministério dos Transportes, apoia programas de investimento multimodal (Art. 10 e 11).",
        "Gestão: A administração da infraestrutura deve ser descentralizada, podendo envolver entes públicos e privados (Art. 12).",
        "Relação com UAM: A lei se relaciona com a UAM ao instituir um fundo (FNIT) de aplicação multimodal para infraestrutura de transportes. Essa característica abre a possibilidade teórica de financiamento para infraestruturas de suporte à UAM, como vertiportos e sistemas de controle de tráfego aéreo urbano. A previsão de descentralização da gestão (Art. 12) também cria um ambiente favorável para que entes públicos ou privados desenvolvam projetos inovadores no setor de transportes, incluindo a mobilidade aérea."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 5, 3, 2, 3),
        justificativas = c(
          "Cria instrumento de política pública federal (FNIT) com gestão descentralizada e possibilidade de parcerias público-privadas, estabelecendo estrutura de governança relevante para financiamento de infraestruturas de transporte.",
          "Impacto direto e abrangente ao instituir fundo específico (FNIT) para financiamento multimodal de infraestrutura de transportes, criando mecanismo concreto de financiamento público para possíveis projetos UAM.",
          "Estabelece objetivos de melhoria da qualidade de vida e segurança dos usuários, com impacto moderado nos benefícios sociais, mas sem tratar especificamente de inclusão ou equidade no acesso à UAM.",
          "Foca em eficiência energética e redução de consumo de combustíveis, mas não aborda especificamente tecnologias avançadas ou requisitos técnicos para infraestrutura UAM.",
          "Prioriza redução de consumo de combustíveis e impactos negativos nos centros urbanos, com impacto moderado na sustentabilidade ambiental, mas sem tratar especificamente de pegada de carbono ou licenciamento ambiental."
        )
      )
    ))
  }
  
  # ========================================================================
  # 28. PROJETO DE LEI 743/2025
  # ========================================================================
  if (str_detect(nome_limpo, "pl743|743|pl.*743")) {
    return(list(
      nome_completo = "Projeto de Lei 743/2025",
      url = "https://www25.senado.leg.br/web/atividade/materias/-/materia/167437",
      resumo = c(
        "Altera quatro marcos legais: Código Brasileiro de Aeronáutica, Diretrizes da Política Urbana, Política Nacional de Mobilidade Urbana e lei da CIDE",
        "Objetivo: estabelecer base legal para regulamentação de aeronaves eVTOL na mobilidade urbana",
        "Propõe ajustes no planejamento territorial para infraestrutura de vertiportos",
        "Busca integrar eVTOLs como componente do sistema de transporte urbano",
        "Abre possibilidade de uso de recursos da CIDE para financiamento"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 4, 3, 4, 4),
        justificativas = c(
          "Impacto direto e abrangente ao propor marco legal específico para UAM, alterando quatro leis federais e criando base para políticas públicas setoriais, demonstrando forte envolvimento estatal e coordenação federativa para fomento do ecossistema.",
          "Impacto relevante ao prever incentivos fiscais através da alteração da lei da CIDE, criando condições para financiamento e investimentos no setor, além de fomentar inovação tecnológica e econômica com potencial para geração de empregos qualificados.",
          "Impacto moderado ao focar na integração multimodal e redução de congestionamentos, mas sem menção específica a equidade, acessibilidade ou mecanismos de inclusão social que evitem que a UAM se torne serviço de elite.",
          "Impacto relevante ao estabelecer base legal para regulamentação de eVTOLs e infraestrutura de vertiportos, criando enquadramento para desenvolvimento de sistemas CNS/ATM e integração com planejamento territorial urbano tridimensional.",
          "Impacto relevante ao mencionar explicitamente redução de emissões de poluentes e posicionar eVTOLs como componente de mobilidade urbana sustentável, embora sem detalhamento sobre gestão de poluição sonora ou conformidade com marco ambiental."
        )
      )
    ))
  }
  
  # ========================================================================
  # 29. LEI 9.472/1997 - LEI GERAL DE TELECOMUNICAÇÕES
  # ========================================================================
  if (str_detect(nome_limpo, "l9472|9472")) {
    return(list(
      nome_completo = "Lei 9.472/1997 - Lei Geral de Telecomunicações",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l9472.htm",
      resumo = c(
        "Estabelece a organização dos serviços de telecomunicações no Brasil e cria a ANATEL como órgão regulador.",
        "Define competências da União, direitos e deveres dos usuários e princípios de regulação econômica e técnica.",
        "Introduz normas sobre espectro de radiofrequências, infraestrutura e financiamento setorial.",
        "Fornece base legal para a integração entre redes de comunicação e políticas públicas de conectividade.",
        "Apresenta relevância para a UAM por disciplinar comunicações e infraestrutura tecnológica aplicáveis ao espaço aéreo urbano."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 3, 3, 5, 1),
        justificativas = c(
          "Cria a ANATEL como agência reguladora autônoma e estabelece a estrutura de governança estatal para o setor de telecomunicações, com impacto direto e abrangente na regulação das comunicações essenciais para UAM.",
          "Estabelece mecanismos de financiamento setorial (FISTEL) e regulação econômica que impactam custos de infraestrutura, mas não aborda especificamente incentivos ou modelos de negócio para UAM.",
          "Define princípios de acesso universal e defesa do consumidor, com impacto moderado na inclusão digital, mas sem tratar especificamente de equidade ou aceitação social da UAM.",
          "Impacto direto e abrangente ao disciplinar o espectro de radiofrequências, infraestrutura de comunicação e interoperabilidade de redes, elementos críticos para os sistemas CNS/ATM da UAM.",
          "Ausência de referência a requisitos ou impactos ambientais específicos no texto analisado, com influência mínima no fator ambiental da UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 30. LEI 13.116/2015 - COMPARTILHAMENTO DA INFRAESTRUTURA DE TELECOMUNICAÇÕES
  # ========================================================================
  if (str_detect(nome_limpo, "l13116|13116")) {
    return(list(
      nome_completo = "Lei 13.116/2015 - Compartilhamento da infraestrutura de telecomunicações",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2015/lei/l13116.htm",
      resumo = c(
        "Fornece as restrições para instalação de infraestrutura de telecomunicações em zonas de proteção de aeródromos e helipontos;",
        "Estabelece que a avaliação das estações transmissoras de radiocomunicação deve ser efetuada por entidade competente"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(2, 2, 1, 4, 1),
        justificativas = c(
          "Impacto pontual ao estabelecer diretrizes regulatórias para infraestrutura de telecomunicações com referência ao Comando da Aeronáutica, indicando coordenação interinstitucional limitada, mas sem políticas de fomento específicas para UAM.",
          "Impacto marginal ao criar procedimento simplificado de licenciamento que pode reduzir custos e prazos para infraestrutura de apoio, mas sem menção a incentivos fiscais ou modelos de negócio específicos para UAM.",
          "Ausência de referência a impactos sociais, aceitação pública, equidade ou inclusão, focando exclusivamente em aspectos técnicos de infraestrutura sem considerações sobre benefícios ou impactos sociais diretos.",
          "Impacto relevante ao estabelecer normas para infraestrutura de telecomunicações essenciais para sistemas CNS/ATM da UAM, incluindo avaliação de estações transmissoras e restrições em zonas de proteção de aeródromos/helipontos que afetam diretamente o planejamento técnico.",
          "Ausência completa de referência a impactos ecológicos, gestão de recursos naturais, pegada de carbono ou qualquer requisito ambiental relacionado à infraestrutura de telecomunicações."
        )
      )
    ))
  }
  
  # ========================================================================
  # 31. ATO ANATEL 915/2024
  # ========================================================================
  if (str_detect(nome_limpo, "artatel.*915|915|ato.*915")) {
    return(list(
      nome_completo = "Ato ANATEL 915/2024 - Faixas de frequências associadas ao Serviço Limitado Privado",
      url = "https://informacoes.anatel.gov.br/legislacao/atos-de-requisitos-tecnicos-de-gestao-do-espectro/2024/1920-ato-915",
      resumo = c(
        "Finalidade: Define regras técnicas para o uso de faixas de radiofrequência pelo Serviço Limitado Privado (SLP), substituindo normas antigas e garantindo uso eficiente do espectro.",
        "Coordenação: Exige que os operadores façam coordenação prévia com outros sistemas da mesma área para evitar interferências.",
        "Flexibilidade: Permite exceções técnicas, desde que aprovadas pela ANATEL e sem causar interferência prejudicial.",
        "Faixa de 4.950–4.990 MHz: Autoriza o aumento temporário de potência em câmeras instaladas em aeronaves durante emergências, para transmitir vídeo em tempo real ao solo.",
        "Relação com UAM: A disposição para operações aéreas e a estruturação técnica de faixas como 4.950-4.990 MHz e 27,5-27,9 GHz criam um marco regulatório fundamental para viabilizar futuras operações de comunicação seguras e confiáveis no contexto da Mobilidade Aérea Urbana."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 2, 5, 1),
        justificativas = c(
          "Estabelece diretrizes regulatórias para uso do espectro através da ANATEL, indicando envolvimento estatal no setor, mas com foco técnico-operacional limitado.",
          "Impacto indireto ao criar marco regulatório para comunicações, sem menção a incentivos fiscais, modelos de negócio ou impactos macroeconômicos para UAM.",
          "Benefícios tangenciais em emergências através de transmissão de vídeo de aeronaves, sem foco em inclusão, equidade ou aceitação social da UAM.",
          "Define parâmetros técnicos específicos para comunicações aeronave-solo e autoriza aumento de potência para câmeras em aeronaves, elementos essenciais para infraestrutura de comunicação da UAM.",
          "Ausência de referência a requisitos ou impactos ambientais no texto analisado."
        )
      )
    ))
  }
  
  # ========================================================================
  # 32. LEI 6.938/1981 - POLÍTICA NACIONAL DO MEIO AMBIENTE
  # ========================================================================
  if (str_detect(nome_limpo, "l6938|6938")) {
    return(list(
      nome_completo = "Lei 6.938/1981 - Política Nacional do Meio Ambiente",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l6938.htm",
      resumo = c(
        "Instrumentos da PNMA: Lista ferramentas como o zoneamento ambiental, a avaliação de impactos ambientais (AIA) e o licenciamento de atividades.",
        "Licenciamento Ambiental: Exige licenciamento prévio para construção e operação de atividades potencialmente poluidoras ou que causem degradação ambiental.",
        "Implicações para UAM: A infraestrutura (ex: vertiportos) e operações de UAM estão sujeitas ao licenciamento e devem ser planejadas conforme os instrumentos de zoneamento e avaliação de impacto."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 3, 2, 5),
        justificativas = c(
          "Impacto relevante ao estabelecer política nacional ambiental com ação governamental obrigatória para manutenção do equilíbrio ecológico, criando estrutura de governança ambiental que condiciona políticas setoriais incluindo transporte e desenvolvimento urbano.",
          "Impacto moderado ao condicionar desenvolvimento econômico à preservação ambiental através do licenciamento obrigatório, gerando custos de compliance para empreendimentos de UAM, mas sem mencionar incentivos fiscais ou financiamento específico.",
          "Impacto moderado ao visar proteção da dignidade humana e qualidade ambiental propícia à vida, criando base para aceitação social de empreendimentos através do controle de impactos, mas sem foco específico em equidade ou inclusão social direta.",
          "Impacto pontual ao exigir avaliação de impactos ambientais que pode incluir aspectos tecnológicos de poluição sonora e eficiência energética, mas sem especificar requisitos técnicos ou padrões tecnológicos para infraestruturas de UAM.",
          "Impacto direto e abrangente ao estabelecer marco legal ambiental completo com licenciamento obrigatório, zoneamento ambiental, avaliação de impactos e controle de atividades poluidoras, aplicável diretamente à infraestrutura e operações de UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 33. LEI 7.661/1988 - PLANO NACIONAL DE GERENCIAMENTO COSTEIRO
  # ========================================================================
  if (str_detect(nome_limpo, "l7661|7661")) {
    return(list(
      nome_completo = "Lei 7.661/1988 - Plano Nacional de Gerenciamento Costeiro",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l7661.htm",
      resumo = c(
        "Institui o Plano Nacional de Gerenciamento Costeiro (PNGC)",
        "Define a Zona Costeira como área de interação ar-mar-terra",
        "Estabelece diretrizes para zoneamento e uso do território",
        "Regulamenta o licenciamento ambiental na zona costeira",
        "Articula políticas federais, estaduais e municipais"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 2, 2, 2, 5),
        justificativas = c(
          "Estabelece política nacional de gestão costeira com articulação federativa entre União, estados e municípios, criando estrutura de governança territorial relevante para implantação de infraestruturas UAM em zonas costeiras.",
          "Impacto indireto ao estabelecer restrições de uso do solo que podem afetar custos de implantação, mas sem tratar especificamente de incentivos ou modelos econômicos para UAM.",
          "Foca na preservação de bens culturais e naturais com benefícios sociais indiretos, mas não aborda especificamente inclusão, equidade ou impactos sociais diretos da UAM.",
          "Estabelece diretrizes gerais para sistema viário e urbanização, mas não aborda tecnologias avançadas específicas para UAM ou requisitos técnicos para vertiportos.",
          "Impacto direto e abrangente ao instituir regime especial de proteção ambiental para zona costeira, com licenciamento obrigatório e zoneamento ecológico que condiciona totalmente a implantação de infraestruturas UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 34. LEI 12.651/2012 - CÓDIGO FLORESTAL
  # ========================================================================
  if (str_detect(nome_limpo, "l12651|12651")) {
    return(list(
      nome_completo = "Lei 12.651/2012 - Código Florestal",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2011-2014/2012/lei/l12651.htm",
      resumo = c(
        "Objetivo da Lei: Estabelece normas sobre proteção e uso da vegetação nativa.",
        "Definições: Define conceitos como Área de Preservação Permanente (APP) e área urbana consolidada.",
        "Tipos de APP: Lista as áreas consideradas APPs, como faixas marginais de rios, entorno de lagos, nascentes e encostas.",
        "Áreas Verdes Urbanas: Apresenta instrumentos municipais para a criação de áreas verdes.",
        "Implicações para UAM: As restrições em APPs e as regras de intervenção podem condicionar a localização de infraestruturas, como vertiportos."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 2, 1, 5),
        justificativas = c(
          "Impacto moderado ao estabelecer política nacional de proteção vegetal com competências municipais para criação de áreas verdes urbanas, criando estrutura de governança ambiental que condiciona políticas de uso do solo para UAM.",
          "Impacto pontual ao criar restrições de uso do solo que podem aumentar custos de implantação de infraestruturas de UAM em áreas protegidas, sem mencionar incentivos econômicos ou mecanismos de compensação específicos.",
          "Impacto marginal ao visar preservação de paisagem e biodiversidade que pode contribuir para qualidade de vida urbana, mas sem foco específico em inclusão social, equidade ou aceitação pública de infraestruturas de transporte.",
          "Ausência de referência a requisitos tecnológicos, sistemas de comunicação, navegação ou qualquer aspecto técnico relacionado à infraestrutura ou operações de transporte aéreo urbano.",
          "Impacto direto e abrangente ao estabelecer proteção legal para vegetação nativa, APPs em zonas urbanas e rurais, com restrições específicas para intervenção em áreas protegidas que condicionam diretamente a localização de vertiportos e rotas de UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 35. LEI 12.725/2012 - CONTROLE DA FAUNA
  # ========================================================================
  if (str_detect(nome_limpo, "l12725|12725")) {
    return(list(
      nome_completo = "Lei 12.725/2012 - Controle da fauna nas imediações de aeródromos",
      url = "https://www.planalto.gov.br/ccivil_03/_ato2011-2014/2012/lei/l12725.htm",
      resumo = c(
        "Esta lei estabelece a Área de Segurança Aeroportuária (ASA) com um raio de 20 km ao redor de aeródromos, onde se aplicam restrições de uso e ocupação do solo. As autoridades municipais devem incorporar essas restrições no planejamento territorial e no licenciamento ambiental. O documento define atividades atrativas de fauna e estabelece sanções para infrações. Suas disposições se aplicam a aeródromos, incluindo infraestruturas de UAM, como vertiportos."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 3, 2, 4),
        justificativas = c(
          "Estabelece articulação federativa entre autoridades de aviação civil, municipais e ambientais, criando estrutura de governança territorial obrigatória para aeródromos que se aplica diretamente a vertiportos UAM.",
          "Implica custos adicionais para controle de fauna e restrições de uso do solo que impactam a viabilidade econômica de vertiportos, mas sem tratar de incentivos ou financiamento específico.",
          "Foca na segurança operacional que beneficia a população vizinha, com impacto moderado na aceitação social, mas não aborda especificamente equidade ou inclusão no acesso à UAM.",
          "Estabelece requisitos gerais para manejo ambiental de aeródromos, mas não aborda tecnologias avançadas de comunicação, navegação ou infraestrutura específica para UAM.",
          "Impacto relevante ao exigir licenciamento ambiental específico, planos de manejo da fauna e restrições a atividades atrativas de fauna, condicionando a implantação de vertiportos a critérios ambientais."
        )
      )
    ))
  }
  
  # ========================================================================
  # 36. LEI 6.902/1981 - ESTAÇÕES ECOLÓGICAS E APAs
  # ========================================================================
  if (str_detect(nome_limpo, "l6902|6902")) {
    return(list(
      nome_completo = "Lei 6.902/1981 - Criação de Estações Ecológicas e Áreas de Proteção Ambiental",
      url = "https://www.planalto.gov.br/ccivil_03/leis/l6902.htm",
      resumo = c(
        "Define Estações Ecológicas como áreas representativas de ecossistemas brasileiros destinadas à pesquisa e preservação ambiental.",
        "Autoriza União, Estados e Municípios a criarem Estações Ecológicas, com limites e órgãos administrativos definidos.",
        "Determina que as Estações Ecológicas possibilitem estudos comparativos entre áreas naturais e modificadas.",
        "Permite ao Poder Executivo declarar áreas como de interesse para proteção ambiental, visando à conservação ecológica e ao bem-estar humano.",
        "Estabelece restrições em Áreas de Proteção Ambiental, proibindo atividades que causem poluição, erosão, assoreamento ou ameaça à fauna e flora.",
        "Implica na necessidade de compatibilizar projetos de UAM com zonas de preservação, assegurando conformidade com normas ambientais e de ordenamento territorial."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 2, 1, 5),
        justificativas = c(
          "Impacto moderado ao estabelecer competência tripartite (União, Estados, Municípios) para criação de unidades de conservação, criando estrutura de governança ambiental que condiciona políticas de ordenamento territorial relevantes para UAM.",
          "Impacto pontual ao criar restrições que podem aumentar custos de implantação de infraestruturas próximas a áreas protegidas, sem mencionar incentivos econômicos ou mecanismos de compensação para projetos de transporte sustentável.",
          "Impacto marginal ao visar bem-estar humano através da conservação ambiental, criando benefícios indiretos para qualidade de vida, mas sem foco específico em inclusão social ou aceitação pública de infraestruturas de transporte.",
          "Ausência completa de referência a requisitos tecnológicos, sistemas de comunicação, infraestrutura técnica ou qualquer aspecto tecnológico relacionado a operações de transporte ou mobilidade urbana.",
          "Impacto direto e abrangente ao criar instrumentos legais para proteção ambiental (Estações Ecológicas e APAs) com restrições específicas a atividades poluidoras e obras que alterem condições ecológicas, condicionando diretamente a localização de vertiportos e rotas de UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 37. LEI 15.190/2025 - LEI GERAL DO LICENCIAMENTO AMBIENTAL
  # ========================================================================
  if (str_detect(nome_limpo, "l15190|15190")) {
    return(list(
      nome_completo = "Lei 15.190/2025 - Lei Geral do Licenciamento Ambiental",
      url = "https://www2.camara.leg.br/legin/fed/lei/2025/lei-15190-8-agosto-2025-797833-publicacaooriginal-176089-pl.html",
      resumo = c(
        "Estabelece normas gerais para licenciamento ambiental de atividades utilizadoras de recursos ambientais",
        "Aplica-se aos órgãos e entidades do Sisnama (União, Estados, DF e Municípios)",
        "Sujeita à licença prévia atividades de construção, instalação, ampliação e operação",
        "Estabelece licença urbanística e ambiental integrada para municípios",
        "Define ordem prioritária para gerenciamento de impactos: prevenção, mitigação e compensação",
        "Mantém independência do licenciamento em relação a certidões de uso do solo",
        "Determina integração de dados de licenciamento no Sinima",
        "Estabelece aplicação a infraestruturas de Mobilidade Aérea Urbana (UAM)",
        "Requer planejamento territorial integrado para projetos de UAM",
        "Define uso de informações georreferenciadas no sistema ambiental"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 4, 3, 3, 5),
        justificativas = c(
          "Estabelece a estrutura federativa completa do licenciamento ambiental com articulação entre União, estados e municípios, criando sistema nacional de governança ambiental com impacto direto e abrangente na implantação de infraestruturas UAM.",
          "Impacto relevante ao definir requisitos obrigatórios que afetam custos e prazos de implantação de vertiportos, estabelecendo condicionantes econômicas significativas para a viabilidade financeira dos projetos UAM.",
          "Estabelece mecanismos de prevenção e mitigação de impactos que beneficiam comunidades vizinhas, com impacto moderado na aceitação social, mas sem tratar especificamente de equidade ou inclusão no acesso à UAM.",
          "Exige uso de informações georreferenciadas e integração de sistemas, com impacto moderado na infraestrutura tecnológica, mas não aborda especificamente tecnologias avançadas de comunicação ou navegação para UAM.",
          "Impacto direto e abrangente ao instituir regime nacional de licenciamento ambiental obrigatório para infraestruturas UAM, com hierarquia de mitigação de impactos e integração com planejamento territorial urbano."
        )
      )
    ))
  }
  
  # ========================================================================
  # 38. RESOLUÇÃO CONAMA 1/1986
  # ========================================================================
  if (str_detect(nome_limpo, "resconama001|conama.*001|conama.*1986")) {
    return(list(
      nome_completo = "Resolução CONAMA 1/1986",
      url = "https://conama.mma.gov.br/?option=com_sisconama&task=arquivo.download&id=745",
      resumo = c(
        "Estabelece critérios para avaliação de impacto ambiental",
        "Define atividades sujeitas a EIA/RIMA, incluindo aeroportos",
        "Estabelece diretrizes para análise de alternativas de localização",
        "Requer diagnóstico ambiental da área de influência",
        "Define conteúdo mínimo do RIMA"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 4, 2, 5),
        justificativas = c(
          "Impacto relevante ao estabelecer diretrizes nacionais para avaliação ambiental através do CONAMA, criando estrutura de governança ambiental com competências estaduais e federais que condicionam políticas setoriais incluindo transporte aéreo.",
          "Impacto moderado ao criar obrigação de EIA/RIMA que gera custos significativos de compliance para infraestruturas aeroportuárias incluindo vertiportos, influenciando a viabilidade econômica de projetos de UAM através de exigências processuais.",
          "Impacto relevante ao exigir análise de impactos na saúde pública e condições socioeconômicas, incluindo aspectos culturais e uso do solo, criando instrumento para avaliação de aceitação social e mitigação de efeitos negativos sobre comunidades.",
          "Impacto pontual ao mencionar análise de alternativas tecnológicas no EIA, criando base para avaliação comparativa de soluções técnicas, mas sem especificar requisitos tecnológicos ou padrões para sistemas de UAM.",
          "Impacto direto e abrangente ao estabelecer critérios obrigatórios para EIA/RIMA de aeroportos (incluindo vertiportos), com análise detalhada de impactos físicos, biológicos e ecológicos, criando marco regulatório ambiental completo para infraestruturas de UAM."
        )
      )
    ))
  }
  
  # ========================================================================
  # 39. RESOLUÇÃO CONAMA 237/1997
  # ========================================================================
  if (str_detect(nome_limpo, "resconama237|conama.*237")) {
    return(list(
      nome_completo = "Resolução CONAMA 237/1997",
      url = "https://conama.mma.gov.br/?option=com_sisconama&task=arquivo.download&id=237",
      resumo = c(
        "Estabelece procedimentos para licenciamento ambiental de atividades potencialmente poluidoras",
        "Define competências dos órgãos ambientais federais, estaduais e municipais",
        "Especifica três tipos de licenças: Prévia, Instalação e Operação",
        "Inclui infraestrutura de transporte no Anexo 1 de atividades sujeitas a licenciamento",
        "Exige compatibilidade com legislação municipal de uso do solo"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 2, 2, 5),
        justificativas = c(
          "Estabelece estrutura de governança ambiental com competências distribuídas entre órgãos federais, estaduais e municipais, criando mecanismo de coordenação federativa relevante para licenciamento de infraestruturas UAM.",
          "Impacto moderado ao estabelecer requisitos obrigatórios de licenciamento que afetam custos e prazos de implantação de vertiportos, mas sem tratar especificamente de incentivos ou modelos econômicos.",
          "Benefícios indiretos através da prevenção de impactos ambientais que afetam comunidades, mas sem abordar especificamente aceitação social, equidade ou inclusão no acesso à UAM.",
          "Estabelece requisitos gerais para estudos ambientais que podem incluir aspectos tecnológicos, mas não aborda especificamente tecnologias avançadas de comunicação ou infraestrutura para UAM.",
          "Impacto direto e abrangente ao instituir regime obrigatório de licenciamento ambiental para aeroportos e infraestruturas de transporte, aplicável a vertiportos UAM, com exigência de estudos ambientais específicos."
        )
      )
    ))
  }
  
  # ========================================================================
  # 40. RBAC 155 - HELIPONTOS
  # ========================================================================
  if (str_detect(nome_limpo, "rbac.*155|rbac155")) {
    return(list(
      nome_completo = "RBAC 155 - Helipontos",
      url = "https://www.anac.gov.br/assuntos/legislacao/legislacao-1/rbha-e-rbac/rbac/rbce-155",
      resumo = c(
        "Estabelece requisitos de segurança para projeto, construção e operação de helipontos",
        "Aplica-se a helipontos civis públicos e parcialmente a privados elevados",
        "Define heliponto como área para pouso, decolagem e movimentação de helicópteros",
        "Especifica características físicas incluindo FATO, TLOF e áreas de segurança",
        "Estabelece dimensões baseadas na maior dimensão do helicóptero (D)",
        "Prescreve auxílios visuais obrigatórios como biruta e sinalização horizontal",
        "Define requisitos para iluminação em operações noturnas",
        "Fornece base técnica para infraestrutura de Mobilidade Aérea Urbana (UAM)",
        "Especifica requisitos para helipontos elevados em ambiente urbano",
        "Estabelece sistemas de referência WGS-84 e MSL para coordenadas"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 3, 4, 5, 2),
        justificativas = c(
          "Impacto moderado ao estabelecer regulamento técnico através da ANAC, demonstrando atuação estatal na regulação de infraestrutura aérea, mas sem políticas de fomento ou incentivos específicos para UAM.",
          "Impacto moderado ao definir padrões técnicos que influenciam custos de implantação e operação de infraestruturas, criando parâmetros para investimentos em helipontos/vertiportos, mas sem mencionar incentivos fiscais ou modelos de financiamento.",
          "Impacto relevante ao estabelecer requisitos de segurança física (grades, áreas de proteção) que contribuem para aceitação pública e gestão de riscos em ambientes urbanos, criando base técnica para licença social de operações.",
          "Impacto direto e abrangente ao especificar parâmetros técnicos detalhados para infraestrutura terrestre (dimensões FATO/TLOF, sistemas de referência WGS-84/MSL, iluminação, sinalização), convertendo requisitos operacionais em critérios vinculantes para uso do solo urbano.",
          "Impacto pontual ao mencionar aspectos de segurança que podem ter implicações ambientais indiretas, mas sem referência específica a impactos ecológicos, poluição sonora, pegada de carbono ou requisitos ambientais para operações."
        )
      )
    ))
  }
  
  # ========================================================================
  # 41. RBAC 161 - PLANOS DE ZONEAMENTO DE RUÍDO
  # ========================================================================
  if (str_detect(nome_limpo, "rbac.*161|rbac161")) {
    return(list(
      nome_completo = "RBAC 161 - Planos de Zoneamento de Ruído de Aeródromos",
      url = "https://pergamum.anac.gov.br/pergamum/vinculos/RBAC161EMD00.pdf",
      resumo = c(
        "O RBAC Nº 161 institui o Plano de Zoneamento de Ruído (PZR) para aeródromos civis públicos.",
        "O regulamento visa mapear o impacto do ruído aeronáutico e estabelecer critérios de compatibilidade para o uso do solo no entorno.",
        "Detalha os usos compatíveis e incompatíveis com base em níveis de ruído.",
        "Estipula as obrigações do operador do aeródromo, incluindo a interação com municípios e a criação de uma Comissão de Gerenciamento de Ruído (CGRA)."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 5, 5, 4),
        justificativas = c(
          "Estabelece estrutura de governança com articulação obrigatória entre operadores de aeródromos, municípios e ANAC, criando comissões de gestão de ruído (CGRA) com impacto relevante na coordenação federativa para UAM.",
          "Implica custos adicionais para elaboração de PZR e medidas de mitigação que impactam a viabilidade econômica de vertiportos, mas sem tratar especificamente de incentivos ou financiamento.",
          "Impacto direto e abrangente na aceitação social da UAM ao estabelecer critérios obrigatórios de compatibilidade de uso do solo, gestão de ruído e proteção de comunidades do entorno, elementos críticos para a licença social para operar.",
          "Define metodologias técnicas para modelagem acústica e monitoramento de ruído, com impacto direto na infraestrutura tecnológica, mas não aborda especificamente comunicações ou navegação avançada para UAM.",
          "Impacto relevante ao instituir regime obrigatório de zoneamento de ruído aeronáutico com critérios ambientais específicos para aeródromos, aplicável a vertiportos UAM e integrado ao planejamento territorial urbano."
        )
      )
    ))
  }
  
  # ========================================================================
  # 42. CEF RBAC 161 - COMPÊNDIO DE ELEMENTOS DE FISCALIZAÇÃO
  # ========================================================================
  if (str_detect(nome_limpo, "cef.*rbac.*161|cef_rbac_161")) {
    return(list(
      nome_completo = "CEF RBAC 161 - Compêndio de Elementos de Fiscalização do RBAC 161",
      url = "https://www.anac.gov.br/assuntos/legislacao/legislacao-1/boletim-de-pessoal/2021/11/anexo-i-cef-rbac-no-161",
      resumo = c(
        "Estabelece regras para elaboração e divulgação dos Planos de Zoneamento de Ruído (PZR) e do Plano Básico de Zoneamento de Ruído (PBZR).",
        "Relaciona-se à UAM ao fornecer parâmetros técnicos e mecanismos de gestão de ruído aplicáveis à operação de vertiportos e corredores aéreos urbanos."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 4, 5, 4),
        justificativas = c(
          "Impacto moderado ao estabelecer procedimentos de fiscalização padronizados pela ANAC, demonstrando atuação regulatória estatal na gestão de impactos sonoros, mas sem políticas de fomento ou incentivos específicos.",
          "Impacto pontual ao criar obrigações de monitoramento e relatórios que geram custos operacionais para operadores de infraestruturas aéreas, mas sem mencionar incentivos econômicos ou mecanismos de financiamento para mitigação de ruído.",
          "Impacto relevante ao estabelecer mecanismos de gestão de ruído (PZR, PBZR) e transparência (Relatório Anual, reclamações) que são fundamentais para aceitação pública, mitigação de impactos percebidos e construção da licença social para operações de UAM.",
          "Impacto direto ao definir parâmetros técnicos para zoneamento acústico (curvas de 75/65 dB, coordenadas geográficas) que exigem capacitação técnica para implementação, mas sem especificar tecnologias de monitoramento ou sistemas avançados.",
          "Impacto relevante ao focar especificamente na gestão da poluição sonora através de planos de zoneamento de ruído, criando instrumento regulatório direto para controle de impactos ambientais sonoros de operações aéreas urbanas."
        )
      )
    ))
  }
  
  # ========================================================================
  # 43. RBAC 135 - OPERAÇÕES COM HELICÓPTEROS
  # ========================================================================
  if (str_detect(nome_limpo, "rbac.*135|rbac135")) {
    return(list(
      nome_completo = "RBAC 135 - Operações de serviço de transporte aéreo com helicópteros",
      url = "https://www.anac.gov.br/assuntos/legislacao/legislacao-1/boletim-de-pessoal/2022/bps-v-17-no-35-29-08-a-02-09-2022/rbac-135/visualizar_ato_normativo",
      resumo = c(
        "Estabelece regras para operações de transporte aéreo com helicópteros",
        "Define requisitos operacionais de aeronavegabilidade",
        "Inclui disposições sobre gestão de segurança operacional"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 3, 2, 3, 2),
        justificativas = c(
          "Estabelece regulação técnica pela ANAC para operações de helicópteros, indicando envolvimento estatal no setor, mas com foco operacional limitado à aviação tradicional.",
          "Define requisitos operacionais que impactam custos de operação e gestão de segurança, com influência moderada na viabilidade econômica de serviços UAM baseados em helicópteros.",
          "Estabelece requisitos de segurança operacional que beneficiam passageiros, mas sem abordar especificamente aceitação pública, ruído ou impactos sociais da UAM em comunidades urbanas.",
          "Define requisitos técnicos para equipamentos e procedimentos de voo com impacto moderado na infraestrutura operacional, mas não aborda tecnologias avançadas específicas para eVTOL ou UAM.",
          "Foca principalmente em aspectos operacionais de segurança, com impacto ambiental indireto através de procedimentos de voo, mas sem tratar especificamente de emissões, ruído ou licenciamento ambiental."
        )
      )
    ))
  }
  
  # ========================================================================
  # 44. ICA 53-8 - SERVIÇOS DE INFORMAÇÃO AERONÁUTICA
  # ========================================================================
  if (str_detect(nome_limpo, "ica.*53.*8|ica_53_8|ica.*538")) {
    return(list(
      nome_completo = "ICA 53-8 - Serviços de Informação Aeronáutica",
      url = "https://publicacoes.decea.mil.br/publicacao/ica-53-8",
      resumo = c(
        "Estabelece requisitos para Serviços de Informação Aeronáutica",
        "Define estrutura funcional e áreas de atuação do SIA",
        "Especifica conteúdo mínimo de dados aeronáuticos",
        "Regulamenta produtos de informação aeronáutica digital",
        "Estabelece requisitos para coleta de dados de terreno e obstáculos",
        "Fornece base técnica para operações de Mobilidade Aérea Urbana"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 2, 5, 1),
        justificativas = c(
          "Impacto moderado ao estabelecer estrutura de serviços de informação aeronáutica com harmonização internacional (OACI), demonstrando coordenação estatal na gestão de dados de navegação aérea, mas sem políticas de fomento específicas para UAM.",
          "Impacto pontual ao criar estrutura de coleta e gestão de dados que gera custos operacionais para o sistema aeronáutico, mas sem mencionar incentivos econômicos, financiamento ou impactos na viabilidade de negócios de UAM.",
          "Impacto marginal ao garantir qualidade de informações para segurança de voo, criando benefícios indiretos para confiança pública, mas sem foco específico em inclusão social, equidade ou aceitação pública de operações urbanas.",
          "Impacto direto e abrangente ao estabelecer requisitos detalhados para dados digitais de terreno e obstáculos (Produto e-TOD), sistemas de informação aeronáutica, metadados e integridade de dados essenciais para navegação CNS/ATM de aeronaves UAM em ambiente urbano complexo.",
          "Ausência de referência a impactos ecológicos, gestão de recursos naturais, pegada de carbono ou qualquer requisito ambiental relacionado a operações aéreas ou infraestruturas."
        )
      )
    ))
  }
  
  # ========================================================================
  # 45. ICA 11-408 - RESTRIÇÕES AOS OBJETOS PROJETADOS
  # ========================================================================
  if (str_detect(nome_limpo, "ica.*11.*408|ica_11_408")) {
    return(list(
      nome_completo = "ICA 11-408 - Restrições aos objetos projetados",
      url = "https://ipdsa.org.br/dados/link/434/arquivo/ICA%2011-408%20-%20Restri____es%20aos%20objetos%20projetados%20no%20espa__o%20a__reo.pdf",
      resumo = c(
        "Estabelece restrições a objetos projetados no espaço aéreo baseadas em Planos de Zona de Proteção",
        "Considera espaço aéreo como recurso limitado a ser administrado",
        "Define competências de administrações municipais/distritais e órgãos do DECEA",
        "Estabelece autos de embargo para propriedades vizinhas a aeródromos",
        "Requer compatibilização do ordenamento territorial com restrições aeronáuticas",
        "Define atribuições conjuntas para autoridades federais, estaduais e municipais",
        "Estabelece base regulatória para operações de Mobilidade Aérea Urbana (UAM)",
        "Disciplina uso do solo no entorno de infraestruturas aéreas",
        "Influencia planejamento urbano através de restrições aeronáuticas"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 4, 3, 5, 2),
        justificativas = c(
          "Estabelece estrutura federativa completa com atribuições conjuntas para autoridades federais, estaduais e municipais, criando sistema de governança territorial obrigatório para proteção do espaço aéreo com impacto direto e abrangente na UAM.",
          "Impacto relevante ao impor restrições de uso do solo que afetam custos de implantação de vertiportos e valor de propriedades, estabelecendo condicionantes econômicas significativas para o desenvolvimento da UAM.",
          "Estabelece mecanismos de proteção de comunidades do entorno através de restrições a objetos projetados, com impacto moderado na segurança e aceitação social, mas sem tratar especificamente de inclusão ou equidade.",
          "Define critérios técnicos para planos de proteção que influenciam o desenvolvimento de infraestruturas, com impacto direto no planejamento tecnológico, mas não aborda especificamente comunicações ou navegação avançada.",
          "Foca principalmente em segurança operacional através de restrições a objetos projetados, com impacto ambiental indireto através do controle do uso do solo, mas sem tratar especificamente de aspectos ecológicos ou licenciamento ambiental."
        )
      )
    ))
  }
  
  # ========================================================================
  # 46. ICA 63-19 - CRITÉRIOS DE ANÁLISE TÉCNICA DA ÁREA DE AERÓDROMOS
  # ========================================================================
  if (str_detect(nome_limpo, "ica.*63.*19|ica_63_19")) {
    return(list(
      nome_completo = "ICA 63-19 - Critérios de Análise Técnica da Área de Aeródromos",
      url = "https://publicacoes.decea.mil.br/publicacao/ica-63-19",
      resumo = c(
        "Define efeito adverso e critérios para estudos aeronáuticos",
        "Aplica-se a órgãos do DECEA, operadores de aeródromo e interessados",
        "Estabelece definições técnicas para aeródromos, helipontos e obstáculos",
        "Especifica condições para caracterização de efeito adverso",
        "Estabelece princípio da sombra para análise de obstáculos",
        "Define procedimentos para estudos aeronáuticos e medidas mitigadoras",
        "Fornece base regulatória para infraestruturas de UAM (vertiportos)",
        "Estabelece critérios para integração de operações aéreas em ambiente urbano",
        "Define instrumentos de planejamento para compatibilidade com espaço aéreo existente"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 3, 5, 2),
        justificativas = c(
          "Estabelece estrutura regulatória do DECEA com competências técnicas para análise de aeródromos e helipontos, criando mecanismos de governança aeronáutica relevantes para a implantação de vertiportos UAM.",
          "Define critérios técnicos que impactam custos de implantação através de estudos aeronáuticos obrigatórios e medidas mitigadoras, com influência moderada na viabilidade econômica de infraestruturas UAM.",
          "Estabelece critérios de proteção para comunidades do entorno através da análise de efeitos adversos, com impacto moderado na segurança e aceitação social, mas sem tratar especificamente de inclusão ou equidade.",
          "Impacto direto e abrangente ao definir critérios técnicos detalhados para superfícies de proteção, princípio da sombra e estudos aeronáuticos, estabelecendo parâmetros técnicos fundamentais para o projeto de vertiportos UAM.",
          "Foca principalmente em segurança operacional através do controle de obstáculos, com impacto ambiental indireto através do ordenamento territorial, mas sem tratar especificamente de aspectos ecológicos ou licenciamento ambiental."
        )
      )
    ))
  }
  
  # ========================================================================
  # 47. ICA 11-3 - PROCESSOS DA ÁREA DE AERÓDROMOS
  # ========================================================================
  if (str_detect(nome_limpo, "ica.*11.*3|ica_11_3")) {
    return(list(
      nome_completo = "ICA 11-3 - Processos da Área de Aeródromos",
      url = "https://publicacoes.decea.mil.br/publicacao/ICA-11-3",
      resumo = c(
        "Define os processos do COMAER para análise de PDIR, cadastro e alteração de aeródromos junto à ANAC, exploração de aeródromos civis públicos e avaliação de OPEA.",
        "Apresenta conceitos fundamentais como aeródromo, heliponto, heliporto e PZP, que disciplinam o uso do solo no entorno de infraestruturas aeronáuticas para garantir a segurança operacional.",
        "Prevê a interação obrigatória com administrações municipais, que devem emitir declaração de ciência e incorporar as restrições dos PZP em seus PDDU.",
        "No caso dos OPEA, permite recurso por interesse público, mediante declaração formal do Poder Municipal ou Estadual, analisada pelo COMAER com base em medidas mitigadoras.",
        "Conforme a Resolução nº 153/2010 da ANAC, o PDIR é obrigatório apenas para aeródromos que operem aeronaves com mais de 19 passageiros ou carga paga superior a 3.400 kg — ficando helipontos e vertiportos urbanos dispensados, embora sujeitos às demais exigências da ICA 11-3.",
        "Relaciona-se diretamente à UAM ao estabelecer critérios técnicos e urbanísticos para aeródromos e helipontos, fornecendo uma base regulatória para a implantação segura de vertiportos e outras infraestruturas aéreas nas cidades brasileiras."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 3, 4, 2),
        justificativas = c(
          "Impacto relevante ao estabelecer coordenação federativa obrigatória entre COMAER, ANAC e municípios através de PZP e declarações de interesse público, criando estrutura de governança multinível essencial para integração de UAM no planejamento urbano.",
          "Impacto moderado ao isentar helipontos/vertiportos do PDIR obrigatório (Resolução 153/2010), reduzindo custos de implantação para infraestruturas de UAM, mas sem mencionar incentivos fiscais ou mecanismos de financiamento específicos.",
          "Impacto moderado ao prever mecanismos de participação municipal e interesse público que podem contribuir para aceitação social, mas sem foco específico em equidade, acessibilidade ou inclusão social de serviços de UAM.",
          "Impacto relevante ao estabelecer procedimentos técnicos para análise de OPEA e PZP que convertem requisitos de segurança operacional em critérios vinculantes para uso do solo urbano, essenciais para integração segura de vertiportos no ambiente construído.",
          "Impacto pontual ao mencionar restrições de uso do solo que podem ter implicações ambientais indiretas, mas sem referência específica a impactos ecológicos, poluição sonora ou requisitos ambientais para operações aéreas urbanas."
        )
      )
    ))
  }
  
  # ========================================================================
  # 48. ICA 100-12 - REGRAS DO AR
  # ========================================================================
  if (str_detect(nome_limpo, "ica.*100.*12|ica_100_12")) {
    return(list(
      nome_completo = "ICA 100-12 - Regras do Ar",
      url = "https://publicacoes.decea.mil.br/publicacao/ICA-100-12",
      resumo = c(
        "Estabelece regras para operação de aeronaves em espaço aéreo brasileiro",
        "Define requisitos para voos visuais (VFR) e por instrumentos (IFR)",
        "Inclui disposições sobre aeronaves VTOL",
        "Estabelece limites operacionais em áreas urbanas"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 4, 5, 1),
        justificativas = c(
          "Impacto moderado ao estabelecer regras operacionais obrigatórias através do DECEA com harmonização internacional (OACI), demonstrando coordenação estatal na gestão do espaço aéreo, mas sem políticas de fomento específicas para UAM.",
          "Impacto pontual ao definir restrições operacionais que podem influenciar custos de operação de aeronaves UAM, mas sem mencionar incentivos econômicos, financiamento ou impactos na viabilidade de modelos de negócio.",
          "Impacto relevante ao estabelecer requisitos de segurança (alturas mínimas sobre áreas povoadas) que são fundamentais para aceitação pública, gestão de riscos e construção da licença social para operações de UAM em ambiente urbano denso.",
          "Impacto direto ao definir categorias operacionais específicas (VFR especial, VTOL) e requisitos técnicos para operação em CTR/ATZ que são essenciais para integração de sistemas CNS/ATM e navegação de aeronaves UAM no espaço aéreo urbano controlado.",
          "Ausência de referência a impactos ecológicos, gestão de poluição sonora, eficiência energética ou qualquer requisito ambiental relacionado a operações aéreas urbanas."
        )
      )
    ))
  }
  
  # ========================================================================
  # 49. ICA 100-36 - DELIMITAÇÃO DE EAC E FRZ
  # ========================================================================
  if (str_detect(nome_limpo, "ica.*100.*36|ica_100_36")) {
    return(list(
      nome_completo = "ICA 100-36 - Processo de Solicitação para o Uso Especial do Espaço Aéreo",
      url = "https://publicacoes.decea.mil.br/publicacao/ICA-100-36",
      resumo = c(
        "Estabelece definições de EAC e FRZ.",
        "Determina publicização através de produtos AIS (AIP para permanentes, NOTAM para temporários)"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(5, 4, 3, 4, 2),
        justificativas = c(
          "Estabelece o sistema nacional de controle do espaço aéreo através do DECEA, criando estrutura de governança estatal completa com poder para delimitar áreas restritas (EAC/FRZ) que impactam diretamente e abrangentemente a UAM.",
          "Impacto relevante ao definir restrições espaciais que condicionam o desenvolvimento de corredores aéreos e localização de vertiportos, estabelecendo limitações econômicas significativas para a viabilidade operacional da UAM.",
          "Estabelece mecanismos de proteção de áreas sensíveis através de FRZ, com impacto moderado na segurança e aceitação social, mas sem tratar especificamente de inclusão, equidade ou impactos comunitários da UAM.",
          "Define parâmetros técnicos precisos para delimitação tridimensional do espaço aéreo (coordenadas WGS-84, limites verticais) e sistemas de informação aeronáutica (AIS), com impacto relevante na infraestrutura tecnológica da UAM.",
          "Foca principalmente em segurança operacional e controle do espaço aéreo, com impacto ambiental indireto através do ordenamento territorial, mas sem tratar especificamente de aspectos ecológicos ou licenciamento ambiental."
        )
      )
    ))
  }
  
  # ========================================================================
  # 50. ICA 100-31 - REQUISITOS DOS SERVIÇOS DE TRÁFEGO AÉREO
  # ========================================================================
  if (str_detect(nome_limpo, "ica.*100.*31|ica_100_31")) {
    return(list(
      nome_completo = "ICA 100-31 - Requisitos dos Serviços de Tráfego Aéreo",
      url = "https://publicacoes.decea.mil.br/publicacao/ICA-100-31",
      resumo = c(
        "Estabelece requisitos para os Serviços de Tráfego Aéreo",
        "Define espaços aéreos, requisitos de comunicação, vigilância, coordenação e informações"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 3, 5, 2),
        justificativas = c(
          "Estabelece a estrutura estatal completa do SISCEAB com competências do DECEA para gestão do espaço aéreo, criando sistema de governança aeronáutica relevante para a integração da UAM no sistema nacional.",
          "Define requisitos operacionais que impactam custos de implementação de serviços de tráfego aéreo para UAM, com influência moderada na viabilidade econômica através de exigências de infraestrutura e coordenação.",
          "Estabelece objetivos de segurança operacional que beneficiam a sociedade, com impacto moderado na aceitação social através da prevenção de colisões, mas sem tratar especificamente de inclusão ou equidade.",
          "Impacto direto e abrangente ao definir requisitos técnicos para comunicação, vigilância, navegação e sistemas ATS, estabelecendo a infraestrutura CNS/ATM essencial para operações seguras da UAM.",
          "Foca principalmente em aspectos operacionais de segurança do tráfego aéreo, com impacto ambiental indireto através do planejamento de rotas, mas sem tratar especificamente de emissões, ruído ou licenciamento ambiental."
        )
      )
    ))
  }
  
  # ========================================================================
  # 51. ICA 100-4 - REGRAS E PROCEDIMENTOS ESPECIAIS PARA HELICÓPTEROS
  # ========================================================================
  if (str_detect(nome_limpo, "ica.*100.*4|ica_100_4")) {
    return(list(
      nome_completo = "ICA 100-4 - Regras e Procedimentos Especiais de Tráfego Aéreo para Helicópteros",
      url = "https://publicacoes.decea.mil.br/publicacao/ICA-100-4",
      resumo = c(
        "Estabelece regras e procedimentos para operação de helicópteros no espaço aéreo brasileiro",
        "Define termos técnicos para infraestrutura de operação de helicópteros",
        "Especifica condições para pouso e decolagem em diferentes tipos de áreas",
        "Estabelece regras de voo visual e por instrumentos para helicópteros",
        "Define procedimentos de tráfego aéreo em aeródromos com e sem torre de controle",
        "Regulamenta operações em plataformas marítimas",
        "Fornece fraseologia padronizada para comunicações"
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 3, 4, 3, 2),
        justificativas = c(
          "Estabelece estrutura regulatória do DECEA para operações de helicópteros com autorizações específicas para operações urbanas, criando mecanismos de governança aeronáutica relevantes para a UAM.",
          "Define procedimentos operacionais que impactam custos de operação em ambiente urbano, com influência moderada na viabilidade econômica através de exigências de autorização e coordenação com ATS.",
          "Estabelece regras de altura mínima sobre áreas povoadas (500 pés) e procedimentos de segurança que impactam diretamente a aceitação social, mitigando riscos para comunidades urbanas.",
          "Define procedimentos operacionais específicos para helicópteros que podem ser aplicados a eVTOLs, com impacto moderado na infraestrutura tecnológica, mas sem abordar comunicações avançadas ou navegação específica para UAM.",
          "Foca principalmente em segurança operacional e procedimentos de tráfego aéreo, com impacto ambiental indireto através do planejamento de rotas, mas sem tratar especificamente de emissões, ruído ou licenciamento ambiental."
        )
      )
    ))
  }
  
  # ========================================================================
  # 52. IS 161 - PROJETO DE MONITORAMENTO DE RUÍDO
  # ========================================================================
  if (str_detect(nome_limpo, "is\\s*161|is161")) {
    return(list(
      nome_completo = "IS 161 - Projeto de Monitoramento de Ruído",
      url = "https://www.anac.gov.br/",
      resumo = c(
        "Estabelece metodologia e critérios técnicos para monitoramento de ruído aeronáutico conforme o RBAC 161.",
        "Define o PMR como sistema estruturado de coleta, tratamento e análise de dados de ruído.",
        "Exige elaboração de curvas de ruído (DNL) e identificação de população e equipamentos sensíveis afetados.",
        "Determina critérios técnicos para posicionamento de pontos de medição e registro de eventos sonoros.",
        "Requer integração de dados operacionais, medições acústicas e reclamações da comunidade (CGRA).",
        "Estabelece requisitos para equipamentos, calibração e processamento dos dados.",
        "Prevê elaboração de relatórios periódicos com análise comparativa e indicação de medidas mitigadoras.",
        "Define regras de vigência, atualização e divulgação pública das informações.",
        "Aplica-se ao contexto da UAM, apoiando o planejamento de operações em áreas urbanas."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 2, 4, 3, 5),
        justificativas = c(
          "Estabelece diretrizes regulatórias da ANAC para monitoramento de ruído, indicando ação governamental no controle de impactos ambientais da aviação. Embora não crie políticas de fomento à UAM, fornece base normativa aplicável ao planejamento de infraestruturas urbanas.",
          "Impacto indireto, pois define obrigações para operadores de aeródromos, mas não aborda custos operacionais, modelos de negócio ou incentivos econômicos para UAM.",
          "Enfatiza a interação com a comunidade por meio do registro de reclamações, identificação de áreas residenciais e equipamentos sensíveis, e divulgação pública dos dados, contribuindo para a aceitação social e licença social para operar.",
          "Define parâmetros técnicos para sistemas de monitoramento de ruído, incluindo equipamentos certificados, integração com dados de radar e processamento em métrica DNL, que podem ser adaptados para avaliar operações de eVTOL em áreas urbanas.",
          "Foco central na gestão de ruído aeronáutico, com metodologia detalhada para medição, análise de impacto e elaboração de relatórios, sendo diretamente aplicável à avaliação ambiental de vertiportos e rotas UAM."
        )
      )
    ))
  }

  # ========================================================================
  # 53. ICA (MCA 100-20) - PROCEDIMENTOS OPERACIONAIS ADS-C NO ATS
  # ========================================================================
  if (str_detect(nome_limpo, "mca\\s*100[-_ ]?20|ica.*mca.*100[-_ ]?20")) {
    return(list(
      nome_completo = "ICA (MCA 100-20) - Procedimentos Operacionais para o Uso de Vigilância Dependente Automática-Contrato (ADS-C) no ATS",
      url = "https://publicacoes.decea.mil.br/",
      resumo = c(
        "Estabelece procedimentos técnicos para a aplicação do sistema de Vigilância Dependente Automática-Contrato (ADS-C) no controle de tráfego aéreo brasileiro.",
        "Complementa as diretrizes operacionais já dispostas em normativas vigentes, como as ICA 100-37 e 100-31.",
        "Descreve a arquitetura de redes de dados utilizadas na aviação, mencionando infraestruturas como ACARS e ATN.",
        "Padroniza o estabelecimento de contratos de transmissão, divididos nas categorias periódica, de demanda e de evento.",
        "Determina protocolos operacionais para a gestão da separação de aeronaves em rota e para o tratamento de emergências pelos controladores de voo.",
        "Delimita os procedimentos técnicos que cabem à tripulação de voo, incluindo o início e o encerramento das comunicações de enlace de dados.",
        "Não possui escopo ou aplicabilidade direta para questões de infraestrutura urbana ou operações de Mobilidade Aérea Urbana (UAM)."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(3, 1, 1, 2, 1),
        justificativas = c(
          "O documento é um ato normativo expedido pelo Comando da Aeronáutica, indicando envolvimento governamental e regulatório no setor de aviação. No entanto, seu escopo é restrito a procedimentos técnicos de ADS-C, sem abordar políticas mais amplas de Mobilidade Aérea Urbana (UAM), como incentivos fiscais ou coordenação federativa.",
          "Não há menção a aspectos econômicos, como viabilidade financeira, custos operacionais, financiamento ou geração de empregos. O foco é puramente técnico-operacional, sem evidências de impacto econômico direto ou indireto para a UAM.",
          "Ausência de discussão sobre aceitação pública, equidade, acesso ou percepção de risco. O texto é estritamente técnico, sem considerações sociais ou de inclusão, não contribuindo para a licença social necessária à UAM.",
          "Descreve tecnologias de suporte como ADS-C, ACARS e ATN, que são relevantes para a infraestrutura de comunicação aeronáutica. Porém, não aborda tecnologias específicas para UAM, como redes 5G/6G, vertiportos ou gêmeos digitais, tendo apenas influência indireta e pontual.",
          "Não há referência a impactos ambientais, pegada de carbono, poluição sonora ou conformidade com legislação verde. O documento ignora completamente questões ecológicas, sem evidências de influência no fator ambiental."
        )
      )
    ))
  }

  # ========================================================================
  # 54. RBAC 91 EMD 05 - REQUISITOS GERAIS DE OPERAÇÃO
  # ========================================================================
  if (str_detect(nome_limpo, "rbac\\s*91|rbac.*91.*emd.*05")) {
    return(list(
      nome_completo = "RBAC nº 91 - Requisitos gerais de operação para aeronaves civis",
      url = "https://www.anac.gov.br/assuntos/legislacao/legislacao-1/rbha-e-rbac/rbac",
      resumo = c(
        "Definição de normativas aplicáveis às operações de aeronaves civis no Brasil.",
        "Exigência de cadastramento para aeródromos e seguimento das altitudes de segurança do DECEA.",
        "Condicionamento de voos sobre áreas densamente povoadas para categorias específicas de aeronaves.",
        "Fixação de parâmetros de distância física para operações de helicópteros em locais não homologados.",
        "Estabelecimento de limites para a emissão de ruídos aeronáuticos em zonas habitadas.",
        "Influência direta no ordenamento territorial urbano para alocação de infraestrutura da UAM."
      ),
      pestel = list(
        fatores = c("Político", "Econômico", "Social", "Tecnológico", "Ambiental"),
        pontuacoes = c(4, 2, 3, 4, 4),
        justificativas = c(
          "O documento, emitido pela ANAC, estabelece diretrizes regulatórias obrigatórias para operações aéreas civis, incluindo cadastramento de aeródromos, cumprimento de altitudes definidas pelo DECEA e necessidade de autorizações específicas. Esses elementos demonstram forte influência estatal e regulatória sobre o ecossistema UAM, embora não aborde políticas de fomento ou coordenação federativa.",
          "O texto não menciona aspectos econômicos como custos operacionais, modelos de negócio, financiamento ou geração de empregos. Apenas indiretamente, ao criar um marco regulatório, pode influenciar a viabilidade financeira, mas sem qualquer evidência direta de impacto econômico.",
          "Há preocupação explícita com áreas densamente povoadas (seção 91.313), distâncias mínimas de vias públicas e pessoas (91.329) e limites de ruído em zonas habitadas (91.817). Essas disposições visam proteger a população e mitigar incômodos, refletindo influência social moderada, embora não tratem de equidade ou acesso ao serviço.",
          "O regulamento define parâmetros técnicos essenciais: níveis mínimos de voo (91.119), requisitos de manutenção e segurança, distâncias operacionais (91.329) e limites de ruído (91.817). Essas especificações condicionam o desenvolvimento de aeronaves, sistemas de navegação e infraestrutura de solo (vertiportos), influenciando diretamente a viabilidade tecnológica da UAM.",
          "A Subparte I é dedicada a requisitos operacionais de ruído, estabelecendo que operações não podem gerar ruídos além do funcionamento padrão em áreas habitadas sem autorização prévia (91.817). Isso evidencia gestão do impacto ambiental sonoro, alinhada à necessidade de conformidade com legislação local, ainda que não aborde outros aspectos como pegada de carbono."
        )
      )
    ))
  }

  # Retornar NULL para documentos não mapeados
  return(NULL)
}

# ============================================================================
# FUNÇÕES AUXILIARES (MANTIDAS IGUAIS)
# ============================================================================

extrair_texto_pdf <- function(caminho_pdf) {
  texto <- tryCatch({
    pdf_text(caminho_pdf)
  }, error = function(e) {
    message("✗ Erro ao ler PDF: ", e$message)
    return("")
  })
  
  if (length(texto) == 0) return("")
  texto <- paste(texto, collapse = " ")
  texto <- tolower(texto)
  return(texto)
}

tokenizar_texto <- function(texto) {
  palavras <- unlist(str_split(texto, "\\s+"))
  palavras <- str_replace_all(palavras, "[^a-záàâãéèêíïóôõöúçñ]", "")
  palavras <- palavras[nchar(palavras) > 2]
  palavras <- palavras[!palavras %in% stopwords_pt]
  return(palavras)
}

calcular_tscore <- function(palavras, top_n = 30) {
  if (length(palavras) < 2) return(data.frame())
  
  bigramas <- paste(palavras[-length(palavras)], palavras[-1])
  freq_bigramas <- table(bigramas)
  freq_palavras <- table(palavras)
  
  df_bigramas <- data.frame(
    bigrama = names(freq_bigramas),
    freq = as.integer(freq_bigramas),
    stringsAsFactors = FALSE
  )
  
  df_bigramas$palavra1 <- sapply(strsplit(df_bigramas$bigrama, " "), `[`, 1)
  df_bigramas$palavra2 <- sapply(strsplit(df_bigramas$bigrama, " "), `[`, 2)
  
  df_bigramas$palavra1_freq <- freq_palavras[df_bigramas$palavra1]
  df_bigramas$palavra2_freq <- freq_palavras[df_bigramas$palavra2]
  
  df_bigramas$tscore <- (df_bigramas$freq - (df_bigramas$palavra1_freq * df_bigramas$palavra2_freq) / length(palavras)) / 
                        sqrt(df_bigramas$freq)
  
  df_bigramas <- df_bigramas %>%
    arrange(desc(freq), desc(tscore)) %>%
    head(top_n) %>%
    select(bigrama, freq, tscore, palavra1_freq, palavra2_freq)
  
  df_bigramas$tscore <- round(df_bigramas$tscore, 2)
  
  return(df_bigramas)
}

extrair_palavras_chave <- function(palavras, n_keywords = 10) {
  if (length(palavras) == 0) return(data.frame())
  
  freq_palavras <- table(palavras)
  df_palavras <- data.frame(
    palavra = names(freq_palavras),
    frequencia = as.integer(freq_palavras),
    stringsAsFactors = FALSE
  )
  
  df_palavras$tamanho <- nchar(df_palavras$palavra)
  df_palavras <- df_palavras[df_palavras$tamanho >= 3, ]
  
  if (nrow(df_palavras) == 0) return(data.frame())
  
  max_freq <- max(df_palavras$frequencia)
  df_palavras$freq_norm <- df_palavras$frequencia / max_freq
  
  df_palavras$peso_tamanho <- ifelse(
    df_palavras$tamanho >= 8,
    1.0,
    ifelse(df_palavras$tamanho > 12, 0.8, 0.6)
  )
  
  df_palavras$relevancia <- df_palavras$freq_norm * 
                            df_palavras$peso_tamanho * 
                            log(df_palavras$frequencia + 1)
  
  df_keywords <- df_palavras %>%
    arrange(desc(relevancia)) %>%
    head(n_keywords) %>%
    select(palavra, frequencia, relevancia)
  
  df_keywords$relevancia <- round(df_keywords$relevancia, 3)
  
  return(df_keywords)
}

calcular_estatisticas <- function(texto, palavras) {
  total_palavras <- length(palavras)
  palavras_unicas <- length(unique(palavras))
  
  freq_palavras <- table(palavras)
  top_50 <- head(sort(freq_palavras, decreasing = TRUE), 50)
  
  sentencas <- str_split(texto, "[.!?]+")[[1]]
  num_sentencas <- length(sentencas)
  
  termos_uam <- c("mobilidade", "aérea", "urbana", "evtol", "aeronave",
                  "vertiporto", "heliponto", " uam ", "tráfego aéreo", 
                  "decolagem", "pouso", " voo ", "aviação")
  
  freq_uam <- sapply(termos_uam, function(termo) {
    str_count(texto, regex(termo, ignore_case = TRUE))
  })
  
  bigramas <- paste(palavras[-length(palavras)], palavras[-1])
  freq_bigramas <- table(bigramas)
  top_bigramas <- head(sort(freq_bigramas, decreasing = TRUE), 20)
  
  tscore_result <- calcular_tscore(palavras)
  keywords_result <- extrair_palavras_chave(palavras, n_keywords = 10)
  
  return(list(
    total_palavras = total_palavras,
    palavras_unicas = palavras_unicas,
    num_sentencas = num_sentencas,
    top_50_palavras = as.list(top_50),
    frequencia_termos_uam = as.list(freq_uam),
    top_20_bigramas = as.list(top_bigramas),
    palavras_chave = if(nrow(keywords_result) > 0) {
      lapply(1:nrow(keywords_result), function(i) {
        list(
          palavra = keywords_result$palavra[i],
          frequencia = keywords_result$frequencia[i],
          relevancia = keywords_result$relevancia[i]
        )
      })
    } else {
      list()
    },
    tscore_bigramas = if(nrow(tscore_result) > 0) {
      lapply(1:nrow(tscore_result), function(i) {
        list(
          bigrama = tscore_result$bigrama[i],
          freq = tscore_result$freq[i],
          tscore = tscore_result$tscore[i],
          palavra1_freq = tscore_result$palavra1_freq[i],
          palavra2_freq = tscore_result$palavra2_freq[i]
        )
      })
    } else {
      list()
    }
  ))
}

processar_documento <- function(caminho_pdf) {
  message("\n", strrep("=", 70))
  message("Processando: ", basename(caminho_pdf))
  message(strrep("=", 70))
  
  nome_arquivo <- basename(caminho_pdf)
  nome_doc <- sub("\\.pdf$", "", nome_arquivo, ignore.case = TRUE)
  
  nome_doc_limpo <- iconv(nome_doc, from = "UTF-8", to = "ASCII//TRANSLIT")
  if (is.na(nome_doc_limpo)) {
    nome_doc_limpo <- gsub("[^[:alnum:]_-]", "", nome_doc)
  }
  
  message("→ Nome do documento: ", nome_doc)
  message("→ Nome do arquivo JSON: ", nome_doc_limpo)
  
  dados_doc <- obter_dados_documento(nome_doc)
  
  if (is.null(dados_doc)) {
    message("✗ Documento não mapeado na base de dados")
    return(FALSE)
  }
  
  message("→ Extraindo texto do PDF...")
  texto <- extrair_texto_pdf(caminho_pdf)
  
  if (nchar(texto) == 0) {
    message("✗ Erro: Texto vazio")
    return(FALSE)
  }
  
  message("→ Tokenizando texto...")
  palavras <- tokenizar_texto(texto)
  
  message("→ Calculando estatísticas...")
  estatisticas <- calcular_estatisticas(texto, palavras)
  
  json_data <- list(
    nome = dados_doc$nome_completo,
    url = dados_doc$url,
    disponivel = TRUE,
    data_processamento = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    resumo = dados_doc$resumo,
    pestel = dados_doc$pestel,
    estatisticas = estatisticas
  )
  
  caminho_json <- file.path(pasta_json, paste0(nome_doc_limpo, ".json"))
  write_json(json_data, caminho_json, pretty = TRUE, auto_unbox = TRUE)
  
  message("✓ JSON salvo: ", caminho_json)
  message("✓ Total de palavras: ", estatisticas$total_palavras)
  message("✓ Palavras únicas: ", estatisticas$palavras_unicas)
  
  return(TRUE)
}

processar_todos_documentos <- function() {
  message("\n", strrep("=", 70))
  message("GERADOR DE JSONs - DOCUMENTOS LEGISLATIVOS UAM")
  message("VERSÃO FINAL COMPLETA - 35 DOCUMENTOS")
  message("TEXTO EXATAMENTE IGUAL AO LATEX")
  message(strrep("=", 70), "\n")
  
  pdfs <- list.files(pasta_documentos, pattern = "\\.pdf$", 
                     full.names = TRUE, recursive = TRUE)
  
  if (length(pdfs) == 0) {
    message("✗ Nenhum PDF encontrado na pasta '", pasta_documentos, "'")
    return()
  }
  
  message("✓ Encontrados ", length(pdfs), " documento(s)\n")
  
  sucessos <- 0
  falhas <- 0
  
  for (i in seq_along(pdfs)) {
    message("\n[", i, "/", length(pdfs), "] ", basename(pdfs[i]))
    
    if (processar_documento(pdfs[i])) {
      sucessos <- sucessos + 1
    } else {
      falhas <- falhas + 1
    }
  }
  
  message("\n", strrep("=", 70))
  message("PROCESSAMENTO CONCLUÍDO")
  message(strrep("=", 70))
  message("✓ Sucessos: ", sucessos)
  message("✗ Falhas: ", falhas)
  message("\n📁 JSONs salvos em: ", normalizePath(pasta_json))
  message(strrep("=", 70), "\n")
}

# ============================================================================
# EXECUTAR
# ============================================================================

processar_todos_documentos()