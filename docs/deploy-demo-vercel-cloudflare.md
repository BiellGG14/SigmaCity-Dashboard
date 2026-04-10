# Demo deploy: Vercel + Plumber local via Cloudflare Tunnel

Este roteiro serve para uma apresentacao urgente, sem containerizar o backend R.

## Arquitetura

- Frontend Next.js: Vercel, apontando para a pasta `frontend`.
- Backend R/Plumber: sua maquina local em `http://127.0.0.1:8000`.
- Tunel HTTPS: Cloudflare Quick Tunnel expondo a porta `8000`.

## 1. Rodar a API Plumber local

No PowerShell, na raiz do projeto:

```powershell
$env:R_LIBS_USER = Join-Path $env:USERPROFILE 'Documents\R\win-library\4.5'
$env:CORS_ORIGIN = '*'
& 'C:\Program Files\R\R-4.5.3\bin\Rscript.exe' backend\run_api.R
```

Teste em outro terminal:

```powershell
Invoke-RestMethod http://127.0.0.1:8000/api/health
```

## 2. Instalar o Cloudflare Tunnel

Se `cloudflared` ainda nao estiver instalado:

```powershell
winget install --id Cloudflare.cloudflared
```

## 3. Abrir o tunel da API

Com a API Plumber rodando:

```powershell
cloudflared tunnel --url http://127.0.0.1:8000
```

Copie a URL gerada, por exemplo:

```text
https://alguma-coisa.trycloudflare.com
```

Importante: no Quick Tunnel essa URL muda quando o tunel e reiniciado. Para uma apresentacao, deixe o terminal aberto ate o fim.

## 4. Configurar a Vercel

No projeto da Vercel:

- Root Directory: `frontend`
- Build Command: `npm run build`
- Install Command: `npm install`

Environment Variables:

```text
NEXT_PUBLIC_API_URL=https://alguma-coisa.trycloudflare.com
API_INTERNAL_URL=https://alguma-coisa.trycloudflare.com
```

Depois de alterar as variaveis, faca redeploy.

## 5. Checagem antes de apresentar

Abra:

```text
https://alguma-coisa.trycloudflare.com/api/health
```

Depois confira no site da Vercel:

- `/`
- `/portal`
- `/documentos`
- `/legislacao`
- `/dashboard-pii`
- um detalhe de documento com nuvem de palavras

## Plano B: ngrok

Tambem funciona, mas eu deixaria como plano B. O ngrok tem plano gratuito, mas nao e open source e tem limites de trafego/requisicoes. O comando equivalente seria:

```powershell
ngrok http 8000
```

Depois use a URL HTTPS do ngrok nas mesmas variaveis da Vercel.
