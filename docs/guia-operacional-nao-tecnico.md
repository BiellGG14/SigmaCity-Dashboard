# Guia operacional do projeto

Este guia foi preparado para apoiar a operação cotidiana do projeto por pessoas com diferentes níveis de familiaridade com desenvolvimento. A proposta é simples: explicar como o sistema está organizado, o que precisa estar instalado no computador, como iniciar o ambiente local, onde ficam os principais arquivos e como fazer ajustes com segurança.

Ele não substitui apoio técnico em mudanças profundas, mas já cobre muito bem o caminho para manutenção leve, revisão visual, ajustes de conteúdo, validações locais e diagnóstico inicial de problemas.

## Visão geral

O projeto é formado por duas camadas.

O **frontend** é a interface visual. É ele que mostra o Portal, a Biblioteca, o Produto I, o Produto II, a Equipe e as páginas de análise dos documentos. Tudo o que envolve texto visível, navegação, botões, ordem de seções, layout, cores e comportamento da interface está ligado ao frontend.

O **backend** é a camada que entrega os dados ao frontend. Ele foi construído em R com Plumber e é responsável por ler os arquivos JSON, organizar o conteúdo dos documentos, responder à API, entregar dados do Produto II, legislação e imagens como as nuvens de palavras.

Na prática, o fluxo é este: o navegador abre uma página do frontend, o frontend pede os dados ao backend e o backend devolve a resposta para a tela ser montada.

Essa distinção é importante porque quase toda investigação parte da mesma pergunta: o problema está na interface, na resposta da API ou no dado de origem?

## Como o projeto está organizado

Os arquivos mais importantes do frontend ficam em `frontend/src/app/` e `frontend/src/components/`.

O Portal está em `frontend/src/app/portal/`. A Biblioteca e as páginas dos documentos ficam em `frontend/src/app/documentos/`. O Produto I está em `frontend/src/app/produto-i/`. O Produto II está em `frontend/src/app/dashboard-pii/`. O menu superior fica em `frontend/src/components/Navbar.js`.

No backend, o centro da aplicação está em `backend/plumber.R`. O arquivo `backend/run_api.R` sobe a API localmente. A pasta `json/` guarda os dados processados dos documentos. A pasta `imagens/` guarda as imagens usadas pelo sistema. A pasta `documentos/` reúne materiais auxiliares e comparativos.

O frontend conversa com o backend através de `frontend/src/lib/api.js`. Localmente, o endereço padrão da API hoje é `http://127.0.0.1:8000`.

## Termos importantes

Alguns termos aparecem o tempo todo. Vale fixar o sentido deles desde o início.

**Frontend** é a interface visível no navegador.

**Backend** é a parte que responde com os dados.

**API** é o endereço usado para pedir dados ao backend.

**JSON** é o formato de muitos arquivos de dados usados pelo projeto.

**Rota** é um caminho de navegação ou de resposta. `/portal` é uma rota da interface. `/api/documentos` é uma rota da API.

**Build** é a validação de produção. Quando o projeto passa no build, significa que continua apto para gerar uma versão de produção.

**Dependência** é uma biblioteca externa que o projeto precisa para funcionar.

**Terminal** é a janela onde comandos são executados.

## O que precisa estar instalado no computador

Para rodar o projeto localmente com tranquilidade, o computador precisa ter um editor de código e algumas ferramentas básicas.

O editor mais recomendado aqui é o **Visual Studio Code**, porque facilita abrir a pasta do projeto, editar arquivos e usar o terminal integrado.

Também é importante ter um navegador moderno, como Chrome ou Edge.

Além disso, este projeto depende de:

- `Git`
- `Node.js`
- `npm`
- `R`

O Git ajuda a acompanhar alterações. O Node.js e o npm são usados pelo frontend. O R é usado pelo backend.

No Windows, a forma mais prática de instalar essas ferramentas costuma ser pelo `winget`:

```powershell
winget install Microsoft.VisualStudioCode
winget install Git.Git
winget install OpenJS.NodeJS
winget install RProject.R
```

Também é possível instalar manualmente usando os instaladores oficiais dessas ferramentas.

## Como verificar se o ambiente está pronto

Depois da instalação, abra um PowerShell e teste:

```powershell
node -v
npm -v
git --version
& 'C:\Program Files\R\R-4.5.3\bin\Rscript.exe' --version
```

Hoje, o ambiente validado neste projeto está funcionando com:

- Node `24.13.0`
- npm `11.6.2`
- Git `2.51.1`
- R `4.5.3`

Não é obrigatório ter exatamente essas versões, mas elas servem como referência.

Se `node` ou `npm` não forem reconhecidos, o frontend não vai subir. Se `Rscript` não funcionar, o backend não vai subir.

## Preparação inicial

Ao abrir o projeto pela primeira vez, o ideal é carregar a pasta raiz inteira no Visual Studio Code. Isso ajuda a navegar entre frontend, backend, dados e documentação sem perder o contexto.

Depois disso, a primeira preparação do frontend acontece dentro de `frontend/`:

```powershell
cd frontend
npm install
```

Esse comando baixa as dependências do frontend, como Next.js, React e Recharts.

No backend, o R precisa ter os pacotes principais instalados. Em um ambiente novo, rode:

```powershell
$env:R_LIBS_USER = Join-Path $env:USERPROFILE 'Documents\R\win-library\4.5'
& 'C:\Program Files\R\R-4.5.3\bin\Rscript.exe' -e "install.packages(c('plumber','jsonlite','readr'), repos='https://cloud.r-project.org')"
```

Esse passo costuma acontecer uma vez por máquina.

## Como iniciar o projeto com um único comando

Há uma forma simples de iniciar frontend e backend sem Docker.

Use o script:

```powershell
.\scripts\start-local.ps1
```

Esse comando abre duas janelas do PowerShell: uma para o backend e outra para o frontend. Ele foi pensado justamente para simplificar a rotina local.

Quando quiser encerrar os serviços iniciados por ele, use:

```powershell
.\scripts\stop-local.ps1
```

Esse segundo script encerra os processos que estiverem ouvindo nas portas `3000` e `8000`.

Se preferir iniciar manualmente, o caminho continua funcionando normalmente.

## Como iniciar manualmente

Se for necessário subir cada parte separadamente, abra dois terminais.

No terminal do frontend:

```powershell
cd frontend
npm run dev
```

No terminal do backend:

```powershell
cd backend
$env:R_LIBS_USER = Join-Path $env:USERPROFILE 'Documents\R\win-library\4.5'
& 'C:\Program Files\R\R-4.5.3\bin\Rscript.exe' run_api.R
```

O frontend normalmente responde em `http://localhost:3000` e hoje redireciona a entrada principal para `/portal`. O backend responde em `http://127.0.0.1:8000`.

## Como parar e reiniciar

Quando um serviço estiver rodando em um terminal, o jeito mais simples de parar é usar `Ctrl + C` naquela janela.

Se uma mudança envolver backend, leitura de JSON ou resposta da API, vale reiniciar o backend depois de salvar. Isso força a releitura dos dados atualizados.

No frontend, muitas mudanças aparecem automaticamente no navegador durante o desenvolvimento. Ainda assim, em ajustes mais delicados, pode ser útil reiniciar também o frontend e recarregar a página.

## Como verificar se tudo está funcionando

Uma sequência prática de validação é abrir:

- `http://localhost:3000/portal`
- `http://localhost:3000/documentos`
- um documento conhecido, como `http://localhost:3000/documentos/ALERTAn001_2023`

Também vale testar a saúde da API em:

```text
http://127.0.0.1:8000/api/health
```

Se a saúde da API estiver boa, mas a interface estiver errada, o problema tende a estar no frontend. Se a saúde já falhar, o foco passa a ser o backend ou o ambiente.

## Como saber onde mexer

Se a mudança for visual, editorial ou de navegação, o ponto de partida quase sempre é o frontend.

Se a mudança for em texto institucional, botões, nomes de abas, menu, organização da página ou aparência dos cards, normalmente o ajuste está em arquivos `.js` e `.css` do frontend.

Se a mudança envolver o conteúdo do documento, o link do arquivo original, um resumo, uma análise PESTEL, as fontes do Produto II ou qualquer resposta da API, o ponto de partida pode estar no backend ou nos arquivos `json/`.

Uma regra muito útil no dia a dia é esta:

- texto e estrutura visível: geralmente no `.js`
- aparência: geralmente no `.css`
- dado: geralmente no backend ou no JSON

## Ajustes frequentes no frontend

O menu superior é controlado em [Navbar.js](C:/Users/User/Documents/GitHub/SigmaCity-Dashboard/frontend/src/components/Navbar.js). Se for preciso trocar o nome de um item, mudar a ordem ou alterar o destino do link, esse é o arquivo principal.

O Portal é controlado em [page.js](C:/Users/User/Documents/GitHub/SigmaCity-Dashboard/frontend/src/app/portal/page.js). Título principal, subtítulo, textos dos produtos e botões do Portal ficam ali.

O Produto I é controlado em [page.js](C:/Users/User/Documents/GitHub/SigmaCity-Dashboard/frontend/src/app/produto-i/page.js). O contexto do projeto, a questão norteadora, o objetivo geral e a lista de documentos atualizados estão nesse arquivo.

O Produto II é controlado em [Produto2Dashboard.js](C:/Users/User/Documents/GitHub/SigmaCity-Dashboard/frontend/src/app/dashboard-pii/Produto2Dashboard.js). Cabeçalho, abas, cards, busca e exibição de questões passam por ele.

A Biblioteca fica em [page.js](C:/Users/User/Documents/GitHub/SigmaCity-Dashboard/frontend/src/app/documentos/page.js).

Quando a alteração for puramente visual, o melhor caminho costuma ser o arquivo `page.module.css` da própria página.

## Como lidar com documentos

Quando o problema aparece em um documento específico, a melhor investigação começa pelo dado de origem.

Os arquivos dos documentos ficam em `json/`. Um exemplo importante é `json/ALERTAn001_2023.json`. Esse tipo de arquivo costuma guardar nome, URL original, resumo, estatísticas, dados PESTEL e outros campos usados na análise.

Se o texto já estiver errado no JSON, a interface não vai corrigir isso sozinha.

Se o JSON estiver correto, o próximo passo é testar a API do documento, por exemplo:

```text
http://127.0.0.1:8000/api/documentos/detalhe?id=ALERTAn001_2023
```

Se a API responder errado, o problema está no backend. Se a API responder certo e a tela estiver errada, o problema está no frontend.

## Como atuar no backend com segurança

No backend, a atuação mais segura em operação cotidiana costuma ser esta: confirmar se a API sobe, testar se as rotas respondem e comparar a resposta da API com o JSON de origem.

Entrar em [plumber.R](C:/Users/User/Documents/GitHub/SigmaCity-Dashboard/backend/plumber.R) para alterar lógica de negócio ou estrutura de resposta já é uma intervenção mais sensível. Isso pode ser feito, mas pede mais cuidado e validação depois.

Em compensação, tarefas como abrir `api/health`, testar `api/documentos`, testar `api/documentos/detalhe` e testar `api/produto2` fazem parte de uma rotina muito saudável de diagnóstico.

## Problemas frequentes

Quando uma página abre sem conteúdo, o frontend pode estar funcionando, mas a API pode não estar respondendo como esperado.

Quando a nuvem de palavras não aparece, a imagem pode estar ausente, o nome da imagem pode ter vindo errado ou o backend pode não ter encontrado o arquivo certo.

Quando um botão existe, mas não leva a lugar nenhum, o link ou a rota podem estar incorretos.

Quando há acentuação estranha, o ideal é comparar o JSON, a resposta da API e a tela renderizada no navegador antes de concluir onde está o problema.

Outro cenário comum é esquecer de rodar `npm install` no frontend ou esquecer de instalar os pacotes do R no backend. Isso costuma travar o projeto logo no início.

## Como validar uma alteração

Depois de editar algo no frontend, abra a página no navegador e confirme visualmente se a mudança ficou como esperado.

Em seguida, rode:

```powershell
cd frontend
npm run lint
npm run build
```

O `lint` aponta problemas comuns de código. O `build` confirma que o projeto continua apto para produção.

Se a alteração envolver backend, vale testar manualmente a rota correspondente da API. Se era um documento, abra o documento e também teste a API do documento. Se era o Produto II, teste `api/produto2`.

## Até onde seguir sozinho

É perfeitamente razoável seguir sozinho em ajustes como troca de textos, renomeação de botões, reorganização do menu, pequenos ajustes visuais, revisão de páginas, teste de links, preparação do ambiente local e comparação entre JSON, API e tela.

Já mudanças como criação de lógica nova, alterações mais profundas no backend, reprocessamento de documentos, reestruturação da API ou funcionalidades novas de maior impacto pedem mais apoio técnico.

Essa distinção não é um limite artificial. Ela existe para proteger o projeto e tornar a manutenção mais segura.

## Como pedir ajuda de forma útil

Um pedido de ajuda funciona melhor quando explica:

- em que página a alteração foi feita;
- qual arquivo foi alterado;
- o que era esperado;
- o que aconteceu de fato;
- se houve mensagem de erro no terminal.

Um bom exemplo seria: “Ajustei o texto da página do Produto I em [page.js](C:/Users/User/Documents/GitHub/SigmaCity-Dashboard/frontend/src/app/produto-i/page.js). No navegador parece certo, mas o `npm run build` falhou. Segue a mensagem do terminal.”

## O que evitar

Não é recomendável apagar muitos arquivos de uma vez, mexer em vários pontos ao mesmo tempo, renomear pastas inteiras sem revisar impactos ou alterar o backend sem testar a API depois.

Também não vale a pena pular a etapa de validação. Mesmo uma mudança aparentemente pequena pode gerar efeito colateral em outra página.

O ritmo mais seguro para este projeto continua sendo incremental: uma mudança por vez, uma validação por vez e um registro simples do que foi alterado.
