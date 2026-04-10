library(plumber)
library(jsonlite)
library(readr)
library(tidyverse)

#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }
}

pasta_json <- "../json"

ler_todos_jsons <- function() {
  arquivos_json <- list.files(pasta_json, pattern = "\\.json$", full.names = TRUE)
  dados <- list()
  nomes <- c()
  mapeamento <- list()
  
  for (arquivo in arquivos_json) {
    tryCatch({
      json_data <- fromJSON(arquivo)
      nome_doc <- json_data$nome
      nome_arquivo_json <- tools::file_path_sans_ext(basename(arquivo))
      dados[[nome_doc]] <- json_data
      nomes <- c(nomes, nome_doc)
      mapeamento[[nome_doc]] <- nome_arquivo_json
    }, error = function(e) {
      # Ignorar
    })
  }
  return(list(dados = dados, nomes = nomes, mapeamento = mapeamento))
}

# Carregar dados logo na inicialização da API
sistema_dados <- ler_todos_jsons()

#* Responde se a API está viva
#* @get /
function() {
  list(status = "OK", message = "SigmaCity Plumber API")
}

#* Retorna a lista de nomes e mapeamentos
#* @get /api/documentos
function() {
  list(nomes = sistema_dados$nomes, mapeamento = sistema_dados$mapeamento)
}

#* Retorna os dados completos de um documento específico
#* @param nome_doc
#* @get /api/documentos/detalhe
function(nome_doc, res) {
  doc <- sistema_dados$dados[[nome_doc]]
  if (is.null(doc)) {
    res$status <- 404
    return(list(error = "Documento nao encontrado"))
  }
  
  # Inject mapping so frontend can load the right image
  doc$nome_imagem_base <- sistema_dados$mapeamento[[nome_doc]]
  
  return(doc)
}

#* Retorna Arquivo de Legislacao Identificacao
#* @get /api/legislacao/identificacao
function() {
  caminho <- "../documentos/Comparativo_Legislacao_AAM.xlsx - IDENTIFICAÇÃO.csv"
  if (file.exists(caminho)) {
    return(readr::read_csv(caminho, show_col_types = FALSE) |> as.data.frame())
  }
  return(list(error = "CSV nao encontrado"))
}

#* Retorna Arquivo de Legislacao Elegibilidade
#* @get /api/legislacao/elegibilidade
function() {
  caminho <- "../documentos/Comparativo_Legislacao_AAM.xlsx - ELEGIBILIDADE.csv"
  if (file.exists(caminho)) {
    return(readr::read_csv(caminho, show_col_types = FALSE) |> as.data.frame())
  }
  return(list(error = "CSV nao encontrado"))
}

#* Retorna Arquivo de Legislacao Inclusao
#* @get /api/legislacao/inclusao
function() {
  caminho <- "../documentos/Comparativo_Legislacao_AAM.xlsx - INCLUSÃO.csv"
  if (file.exists(caminho)) {
    return(readr::read_csv(caminho, show_col_types = FALSE) |> as.data.frame())
  }
  return(list(error = "CSV nao encontrado"))
}

#* Retorna a imagem da Nuvem de Palavras
#* @param nome_img
#* @get /api/imagens/:nome_img
function(nome_img, res) {
  path <- paste0("../imagens/nuvem de palavras/", nome_img)
  if (file.exists(path)) {
    return(plumber::include_file(path, res))
  }
  res$status <- 404
  return(list(error = "Imagem nao encontrada"))
}
