library(plumber)
library(jsonlite)
library(readr)

project_root <- normalizePath(
  if (file.exists(file.path("backend", "plumber.R"))) "." else "..",
  winslash = "/",
  mustWork = TRUE
)

json_dir <- file.path(project_root, "json")
documentos_dir <- file.path(project_root, "documentos")
imagens_dir <- file.path(project_root, "imagens", "nuvem de palavras")
dash_pii_path <- file.path(project_root, "dashPII.Rmd")

repair_text <- function(x) {
  if (!is.character(x)) {
    return(x)
  }

  needs_repair <- grepl("[ÃÂâ]", x)
  out <- x
  if (any(needs_repair, na.rm = TRUE)) {
    repaired <- suppressWarnings(iconv(x[needs_repair], from = "latin1", to = "UTF-8"))
    out[needs_repair] <- ifelse(is.na(repaired), x[needs_repair], repaired)
  }
  out
}

repair_object <- function(x) {
  if (is.data.frame(x)) {
    names(x) <- repair_text(names(x))
    x[] <- lapply(x, repair_object)
    return(x)
  }

  if (is.list(x)) {
    names(x) <- repair_text(names(x))
    return(lapply(x, repair_object))
  }

  repair_text(x)
}

read_csv_repaired <- function(path) {
  dados <- readr::read_csv(path, show_col_types = FALSE, locale = locale(encoding = "UTF-8"))
  as.data.frame(repair_object(dados))
}

read_all_json <- function() {
  arquivos_json <- list.files(json_dir, pattern = "\\.json$", full.names = TRUE)
  dados <- list()
  documentos <- list()

  for (arquivo in arquivos_json) {
    tryCatch({
      json_data <- repair_object(fromJSON(arquivo, simplifyVector = FALSE))
      id <- tools::file_path_sans_ext(basename(arquivo))
      nome <- json_data$nome %||% id
      json_data$id <- id
      json_data$nome_imagem_base <- id

      dados[[id]] <- json_data
      documentos[[length(documentos) + 1]] <- list(
        id = id,
        nome = nome,
        disponivel = isTRUE(json_data$disponivel)
      )
    }, error = function(e) {
      warning(sprintf("Falha ao carregar JSON %s: %s", arquivo, e$message))
    })
  }

  documentos <- documentos[order(vapply(documentos, function(doc) doc$nome, character(1)))]
  list(dados = dados, documentos = documentos)
}

extract_assignment_block <- function(lines, assignment_name) {
  start <- grep(paste0("^", assignment_name, "\\s*<-"), lines)[1]
  if (is.na(start)) {
    stop(sprintf("Bloco %s nao encontrado", assignment_name))
  }

  block <- character()
  depth <- 0
  started <- FALSE

  for (i in seq(start, length(lines))) {
    line <- lines[[i]]
    block <- c(block, line)
    depth <- depth + lengths(regmatches(line, gregexpr("\\(", line, perl = TRUE)))
    depth <- depth - lengths(regmatches(line, gregexpr("\\)", line, perl = TRUE)))
    started <- started || grepl("\\(", line)

    if (started && depth <= 0) {
      break
    }
  }

  paste(block, collapse = "\n")
}

load_produto2_data <- function() {
  if (!file.exists(dash_pii_path)) {
    stop("dashPII.Rmd nao encontrado")
  }

  lines <- readLines(dash_pii_path, encoding = "UTF-8", warn = FALSE)
  env <- new.env(parent = baseenv())

  eval(parse(text = extract_assignment_block(lines, "TEMAS")), envir = env)
  eval(parse(text = extract_assignment_block(lines, "PESTEL_COV")), envir = env)
  eval(parse(text = extract_assignment_block(lines, "FATORES")), envir = env)

  temas <- repair_object(env$TEMAS)
  pestel_cov <- env$PESTEL_COV
  fatores <- repair_object(env$FATORES)

  temas <- temas[order(vapply(temas, function(t) tolower(iconv(t$nome, to = "ASCII//TRANSLIT")), character(1)))]
  total_questoes <- sum(vapply(temas, function(t) length(t$questoes), integer(1)))

  list(
    temas = temas,
    fatores = fatores,
    pestel_cov = pestel_cov,
    fontes = c("Normativo", "Cientifico", "Internacional"),
    total_questoes = total_questoes
  )
}

find_cloud_image <- function(nome_img) {
  requested <- file.path(imagens_dir, nome_img)
  if (file.exists(requested)) {
    return(requested)
  }

  base <- sub("_nuvem\\.png$", "", nome_img)
  candidates <- c(
    paste0(base, "_nuvem.png"),
    paste0(gsub("_", "", base), "_nuvem.png"),
    paste0(gsub("[^[:alnum:]]", "", base), "_nuvem.png")
  )

  existing <- list.files(imagens_dir, pattern = "\\.png$", full.names = FALSE)
  normalized_existing <- gsub("[^[:alnum:]]", "", existing)
  normalized_candidates <- gsub("[^[:alnum:]]", "", candidates)
  match_index <- match(normalized_candidates, normalized_existing, nomatch = 0)
  match_index <- match_index[match_index > 0]

  if (length(match_index) > 0) {
    return(file.path(imagens_dir, existing[[match_index[[1]]]]))
  }

  requested
}

serve_png <- function(path, res) {
  readBin(path, what = "raw", n = file.info(path)$size)
}

`%||%` <- function(a, b) {
  if (is.null(a) || length(a) == 0) b else a
}

sistema_dados <- read_all_json()
produto2_cache <- NULL

#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", Sys.getenv("CORS_ORIGIN", "*"))
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS %||% "Content-Type")
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$status <- 200
    return(list())
  }
  plumber::forward()
}

#* Health check
#* @get /
function() {
  list(status = "OK", message = "SigmaCity Plumber API")
}

#* Health check under API namespace
#* @get /api/health
function() {
  list(status = "OK", document_count = length(sistema_dados$documentos))
}

#* Retorna a lista de documentos
#* @get /api/documentos
function() {
  list(documentos = sistema_dados$documentos)
}

#* Retorna os dados completos de um documento especifico
#* @param id
#* @param nome_doc
#* @get /api/documentos/detalhe
function(res, id = "", nome_doc = "") {
  doc_id <- if (nzchar(id)) id else NULL
  if (is.null(doc_id) && nzchar(nome_doc)) {
    found <- Filter(function(item) identical(item$nome, nome_doc), sistema_dados$documentos)
    if (length(found) > 0) {
      doc_id <- found[[1]]$id
    }
  }

  doc <- sistema_dados$dados[[doc_id]]
  if (is.null(doc)) {
    res$status <- 404
    return(list(error = "Documento nao encontrado"))
  }

  doc
}

#* Retorna Arquivo de Legislacao Identificacao
#* @get /api/legislacao/identificacao
function(res) {
  caminho <- file.path(documentos_dir, "Comparativo_Legislacao_AAM.xlsx - IDENTIFICAÇÃO.csv")
  if (file.exists(caminho)) {
    return(read_csv_repaired(caminho))
  }
  res$status <- 404
  list(error = "CSV nao encontrado")
}

#* Retorna Arquivo de Legislacao Elegibilidade
#* @get /api/legislacao/elegibilidade
function(res) {
  caminho <- file.path(documentos_dir, "Comparativo_Legislacao_AAM.xlsx - ELEGIBILIDADE.csv")
  if (file.exists(caminho)) {
    return(read_csv_repaired(caminho))
  }
  res$status <- 404
  list(error = "CSV nao encontrado")
}

#* Retorna Arquivo de Legislacao Inclusao
#* @get /api/legislacao/inclusao
function(res) {
  caminho <- file.path(documentos_dir, "Comparativo_Legislacao_AAM.xlsx - INCLUSÃO.csv")
  if (file.exists(caminho)) {
    return(read_csv_repaired(caminho))
  }
  res$status <- 404
  list(error = "CSV nao encontrado")
}

#* Retorna dados estruturados do Produto II
#* @get /api/produto2
function(res) {
  tryCatch({
    if (is.null(produto2_cache)) {
      produto2_cache <<- load_produto2_data()
    }
    produto2_cache
  }, error = function(e) {
    res$status <- 500
    list(error = e$message)
  })
}

#* Retorna a imagem da Nuvem de Palavras
#* @param nome_img
#* @serializer contentType list(type = "image/png")
#* @get /api/imagens
function(nome_img = "", res) {
  path <- find_cloud_image(nome_img)
  if (file.exists(path)) {
    return(serve_png(path, res))
  }
  res$status <- 404
  list(error = "Imagem nao encontrada")
}

#* Retorna a imagem da Nuvem de Palavras
#* @param nome_img
#* @serializer contentType list(type = "image/png")
#* @get /api/imagens/:nome_img
function(nome_img, res) {
  path <- find_cloud_image(nome_img)
  if (file.exists(path)) {
    return(serve_png(path, res))
  }
  res$status <- 404
  list(error = "Imagem nao encontrada")
}
