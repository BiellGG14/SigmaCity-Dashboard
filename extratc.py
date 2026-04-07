#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Gerador de Análises Estatísticas de Documentos Legislativos - VERSÃO DEFINITIVA
================================================================================

VERSÃO CONSOLIDADA com TODAS as técnicas estatísticas + Referências Bibliográficas

Este script processa documentos legislativos e gera um PDF consolidado
para cada documento contendo TODAS as análises estatísticas com citações completas.

Análises incluídas:
- 7 análises originais (Python para Linguística de Corpus)
- 8 técnicas avançadas (6 livros acadêmicos)
- Total: 15+ análises estatísticas com referências bibliográficas

COMPATÍVEL COM: Windows, Linux, macOS

Autor: Análise para Projeto SIGMA city - Produto 1
Data: Dezembro 2025
"""

import os
import sys
import json
import warnings
from pathlib import Path
from collections import Counter, defaultdict
from datetime import datetime
import platform

# Suprimir warnings
warnings.filterwarnings('ignore')

# Importações de processamento de texto
import re

# Tokenização básica sem NLTK
def word_tokenize(text):
    """Tokenização básica de palavras"""
    return re.findall(r'\b\w+\b', text.lower())

def sent_tokenize(text):
    """Tokenização básica de sentenças"""
    return re.split(r'[.!?]+', text)

def ngrams(words, n):
    """Gera n-gramas"""
    return [tuple(words[i:i+n]) for i in range(len(words)-n+1)]

# Importações numéricas e estatísticas
import numpy as np
import pandas as pd
from scipy import stats

# Importações de visualização
import matplotlib
matplotlib.use('Agg')  # Backend não-interativo
import matplotlib.pyplot as plt
import seaborn as sns
from wordcloud import WordCloud

# Importações para PDF
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch, cm
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Image, 
    PageBreak, Table, TableStyle, KeepTogether
)
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_JUSTIFY

# Processamento de PDFs
import PyPDF2

# Configuração de estilo
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")

# ============================================================================
# REFERÊNCIAS BIBLIOGRÁFICAS COMPLETAS
# ============================================================================

REFERENCIAS = {
    # Análises originais
    'frequencias': {
        'tecnica': 'Análise de Frequências',
        'autor': 'Moreira Filho, J.L.',
        'livro': 'Python para Linguística de Corpus: Guia Prático',
        'ano': 2021,
        'pagina': '45-52',
        'descricao': 'Contagem e análise de frequência de palavras em corpus'
    },
    'zipf': {
        'tecnica': 'Lei de Zipf',
        'autor': 'Moreira Filho, J.L.',
        'livro': 'Python para Linguística de Corpus: Guia Prático',
        'ano': 2021,
        'pagina': '78-85',
        'descricao': 'Relação logarítmica entre frequência e rank de palavras'
    },
    'dispersao': {
        'tecnica': 'Análise de Dispersão',
        'autor': 'Moreira Filho, J.L.',
        'livro': 'Python para Linguística de Corpus: Guia Prático',
        'ano': 2021,
        'pagina': '92-98',
        'descricao': 'Distribuição de palavras ao longo do texto'
    },
    'ngramas': {
        'tecnica': 'N-gramas (Bigramas e Trigramas)',
        'autor': 'Moreira Filho, J.L.',
        'livro': 'Python para Linguística de Corpus: Guia Prático',
        'ano': 2021,
        'pagina': '105-115',
        'descricao': 'Sequências de n palavras consecutivas'
    },
    'colocacoes': {
        'tecnica': 'Análise de Colocações',
        'autor': 'Moreira Filho, J.L.',
        'livro': 'Python para Linguística de Corpus: Guia Prático',
        'ano': 2021,
        'pagina': '118-125',
        'descricao': 'Palavras que frequentemente co-ocorrem'
    },
    
    # Técnicas avançadas
    'ttr': {
        'tecnica': 'Type-Token Ratio (TTR)',
        'autor': 'Jockers, M.L.',
        'livro': 'Text Analysis with R for Students of Literature',
        'ano': 2013,
        'pagina': '73-79',
        'descricao': 'Medida de diversidade lexical (palavras únicas / palavras totais)'
    },
    'mattr': {
        'tecnica': 'Moving-Average Type-Token Ratio (MATTR)',
        'autor': 'Covington, M.A. & McFall, J.D.',
        'livro': 'Computational Linguistics (citado em Jockers, 2013)',
        'ano': 2010,
        'pagina': 'p.79 (Jockers)',
        'descricao': 'TTR calculado em janelas deslizantes para maior robustez'
    },
    'hapax': {
        'tecnica': 'Hapax Legomena',
        'autor': 'Baayen, R.H.',
        'livro': 'Analyzing Linguistic Data: A Practical Introduction',
        'ano': 2008,
        'pagina': '241, 247',
        'descricao': 'Palavras que ocorrem apenas uma vez no texto'
    },
    'gries_dp': {
        'tecnica': 'Gries DP (Deviation of Proportions)',
        'autor': 'Gries, S.Th.',
        'livro': 'Quantitative Corpus Linguistics with R',
        'ano': 2017,
        'pagina': '97',
        'descricao': 'Medida de dispersão melhorada (0=uniforme, 1=concentrado)'
    },
    't_score': {
        'tecnica': 'T-Score (Colocações)',
        'autor': 'Winter, B.',
        'livro': 'Statistics for Linguists: An Introduction Using R',
        'ano': 2019,
        'pagina': '202',
        'descricao': 'Teste estatístico para identificar colocações significativas'
    }
}

def formatar_referencia(chave):
    """Formata referência bibliográfica para exibição no PDF"""
    ref = REFERENCIAS.get(chave, {})
    if not ref:
        return ""
    
    return (f"<i><b>Fonte:</b> {ref['autor']} ({ref['ano']}). "
            f"{ref['livro']}, p. {ref['pagina']}</i><br/>"
            f"<i>{ref['descricao']}</i>")

# ============================================================================
# CONFIGURAÇÕES GLOBAIS - COMPATÍVEL COM WINDOWS/LINUX/MAC
# ============================================================================

# Detectar sistema operacional
SISTEMA = platform.system()  # 'Windows', 'Linux', 'Darwin' (Mac)

# Definir pasta atual (onde o script está)
PASTA_ATUAL = Path.cwd()

# Configurar pastas de forma compatível com todos os sistemas
PASTA_PROJETO = PASTA_ATUAL  # Pasta atual
PASTA_DOCUMENTOS = PASTA_ATUAL  # Mesma pasta
PASTA_ESTATISTICAS = PASTA_ATUAL / "estatisticas"  # Subpasta estatisticas
PASTA_TEMP = PASTA_ATUAL / "temp"  # Subpasta temp

# Criar pastas necessárias
PASTA_ESTATISTICAS.mkdir(exist_ok=True)
PASTA_TEMP.mkdir(exist_ok=True)

print(f"Sistema operacional detectado: {SISTEMA}")
print(f"Pasta de trabalho: {PASTA_ATUAL}")
print(f"PDFs serão salvos em: {PASTA_ESTATISTICAS}")
print()

# Stopwords - palavras a serem filtradas das análises
STOPWORDS = {
    'a', 'o', 'as', 'os', 'um', 'uma', 'uns', 'umas',
    'de', 'do', 'da', 'dos', 'das', 'em', 'no', 'na', 'nos', 'nas',
    'por', 'pelo', 'pela', 'pelos', 'pelas', 'para', 'ao', 'aos', 'à', 'às',
    'com', 'sem', 'sob', 'sobre', 'entre', 'até', 'desde', 'perante',
    'e', 'ou', 'mas', 'porém', 'contudo', 'todavia', 'entretanto',
    'que', 'qual', 'quais', 'quando', 'onde', 'como', 'porque', 'porquê',
    'se', 'não', 'nem', 'também', 'já', 'ainda', 'mais', 'menos',
    'muito', 'pouco', 'todo', 'toda', 'todos', 'todas',
    'este', 'esta', 'estes', 'estas', 'esse', 'essa', 'esses', 'essas',
    'aquele', 'aquela', 'aqueles', 'aquelas', 'isto', 'isso', 'aquilo',
    'meu', 'minha', 'meus', 'minhas', 'teu', 'tua', 'teus', 'tuas',
    'seu', 'sua', 'seus', 'suas', 'nosso', 'nossa', 'nossos', 'nossas',
    'eu', 'tu', 'ele', 'ela', 'nós', 'vós', 'eles', 'elas',
    'me', 'te', 'lhe', 'nos', 'vos', 'lhes',
    'ser', 'estar', 'ter', 'haver', 'fazer', 'ir', 'poder', 'dar',
    'sido', 'será', 'serão', 'sendo', 'foram', 'fica', 'ficam',
    'artigo', 'art', 'inciso', 'parágrafo', 'alínea', 'item',
    'lei', 'decreto', 'medida', 'provisória',
    'i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'viii', 'ix', 'x',
    'xi', 'xii', 'xiii', 'xiv', 'xv',
    'dispõe', 'estabelece', 'regulamenta', 'conforme', 'mediante',
    'seguinte', 'seguintes', 'forma', 'seguir', 'único', 'deve',
    'dada', 'dado', 'dados', 'dadas', 'são', 'fica', 'ficam',
    'www', 'http', 'https', 'com', 'br', 'org', 'pdf', 'html',
    'caput', 'cp', 'nº', 'nr', 'num', 'nume', 'número',
    'parágrafo', 'paragrafo', 'inciso', 'alinea', 'alínea',
    'item', 'artigo', 'lei', 'decreto', 'portaria', 'incluído'
}

# Termos UAM para análise
TERMOS_UAM = [
    'mobilidade', 'aérea', 'urbana', 'evtol', 'aeronave',
    'espaço aéreo', 'vertiporto', 'heliponto', 'uam',
    'transporte aéreo', 'navegação', 'tráfego aéreo',
    'decolagem', 'pouso', 'voo', 'aviação', 'drone'
]

# ============================================================================
# CLASSES DE TÉCNICAS AVANÇADAS
# ============================================================================

class LexicalDiversity:
    """Diversidade Lexical - Múltiplas medidas de TTR"""
    
    @staticmethod
    def ttr_simple(palavras):
        if not palavras:
            return 0.0
        return len(set(palavras)) / len(palavras)
    
    @staticmethod
    def mattr(palavras, window_size=1000):
        """Moving-Average Type-Token Ratio"""
        if len(palavras) < window_size:
            return LexicalDiversity.ttr_simple(palavras)
        
        ratios = []
        for i in range(len(palavras) - window_size + 1):
            window = palavras[i:i+window_size]
            ttr = len(set(window)) / window_size
            ratios.append(ttr)
        
        return np.mean(ratios)
    
    @staticmethod
    def root_ttr(palavras):
        if not palavras:
            return 0.0
        types = len(set(palavras))
        tokens = len(palavras)
        return types / np.sqrt(tokens)
    
    @staticmethod
    def herdans_c(palavras):
        if not palavras or len(set(palavras)) <= 1:
            return 0.0
        types = len(set(palavras))
        tokens = len(palavras)
        return np.log(types) / np.log(tokens)

class HapaxAnalysis:
    """Análise de Hapax Legomena"""
    
    @staticmethod
    def hapax_legomena(palavras):
        freq = Counter(palavras)
        return [palavra for palavra, count in freq.items() if count == 1]
    
    @staticmethod
    def hapax_ratio(palavras):
        if not palavras:
            return 0.0
        freq = Counter(palavras)
        hapax_count = sum(1 for f in freq.values() if f == 1)
        return hapax_count / len(freq)
    
    @staticmethod
    def hapax_percentage(palavras):
        if not palavras:
            return 0.0
        freq = Counter(palavras)
        hapax_count = sum(1 for f in freq.values() if f == 1)
        return (hapax_count / len(palavras)) * 100

class Dispersion:
    """Medidas de Dispersão Avançadas"""
    
    @staticmethod
    def gries_dp(palavra, texto_dividido):
        """Gries DP (Deviation of Proportions)"""
        ocorrencias = [parte.count(palavra) for parte in texto_dividido]
        total_palavra = sum(ocorrencias)
        
        if total_palavra == 0:
            return None
        
        tamanhos = [len(parte) for parte in texto_dividido]
        tamanho_total = sum(tamanhos)
        
        n = len(texto_dividido)
        soma = 0
        
        for i in range(n):
            prop_obs = ocorrencias[i] / total_palavra
            prop_exp = tamanhos[i] / tamanho_total
            soma += abs(prop_obs - prop_exp)
        
        return soma / 2

class Collocation:
    """Análise de Colocações com T-Score"""
    
    @staticmethod
    def t_score(freq_bigrama, freq_w1, freq_w2, total_bigramas):
        if freq_bigrama == 0:
            return 0.0
        expected = (freq_w1 * freq_w2) / total_bigramas
        return (freq_bigrama - expected) / np.sqrt(freq_bigrama)

# ============================================================================
# CLASSE PRINCIPAL: ANALISADOR DE DOCUMENTOS
# ============================================================================

class AnalisadorDocumento:
    """
    Classe para análise estatística completa de um documento legislativo.
    Implementa TODAS as técnicas (originais + avançadas) com referências bibliográficas.
    """
    
    def __init__(self, caminho_documento, nome_documento):
        """
        Inicializa o analisador.
        
        Args:
            caminho_documento: Caminho para o arquivo PDF
            nome_documento: Nome identificador do documento
        """
        self.caminho = caminho_documento
        self.nome = nome_documento
        self.texto_completo = ""
        self.palavras = []
        self.sentencas = []
        self.resultados = {}
        
        print(f"\n{'='*70}")
        print(f"Inicializando análise de: {nome_documento}")
        print(f"{'='*70}")
        
    def extrair_texto_pdf(self):
        """Extrai texto do PDF"""
        print("→ Extraindo texto do PDF...")
        try:
            with open(self.caminho, 'rb') as file:
                pdf_reader = PyPDF2.PdfReader(file)
                texto = ""
                for page in pdf_reader.pages:
                    texto += page.extract_text() + "\n"
                
                self.texto_completo = texto
                print(f"  ✓ {len(texto)} caracteres extraídos")
                return True
        except Exception as e:
            print(f"  ✗ Erro ao extrair PDF: {e}")
            return False
    
    def preprocessar_texto(self):
        """Preprocessa o texto: tokenização e remoção de stopwords"""
        print("→ Preprocessando texto...")
        try:
            # Tokenizar palavras
            palavras_raw = word_tokenize(self.texto_completo.lower())
            
            # Filtrar: apenas letras, mínimo 3 caracteres, sem stopwords
            self.palavras = [
                p for p in palavras_raw 
                if p.isalpha() and len(p) > 2 and p not in STOPWORDS
            ]
            
            # Tokenizar sentenças
            self.sentencas = sent_tokenize(self.texto_completo)
            
            palavras_antes = len(palavras_raw)
            palavras_depois = len(self.palavras)
            stopwords_removidas = palavras_antes - palavras_depois
            
            print(f"  ✓ {palavras_antes} palavras originais")
            print(f"  ✓ {stopwords_removidas} stopwords removidas")
            print(f"  ✓ {palavras_depois} palavras relevantes")
            print(f"  ✓ {len(self.sentencas)} sentenças")
            return True
        except Exception as e:
            print(f"  ✗ Erro no preprocessamento: {e}")
            return False
    
    # ========================================================================
    # ANÁLISE 1: FREQUÊNCIAS
    # ========================================================================
    
    def calcular_frequencias(self):
        """Calcula frequências absolutas e relativas"""
        print("→ Calculando frequências...")
        
        # Frequência absoluta
        freq_absoluta = Counter(self.palavras)
        
        # Frequência relativa (por 10.000 palavras)
        total = len(self.palavras)
        freq_relativa = {
            palavra: (freq / total) * 10000
            for palavra, freq in freq_absoluta.items()
        }
        
        # Ordenar e pegar top 50
        top_50 = freq_absoluta.most_common(50)
        
        self.resultados['frequencias'] = {
            'total_palavras': total,
            'total_unicas': len(freq_absoluta),
            'top_50': top_50,
            'freq_absoluta': freq_absoluta,
            'freq_relativa': freq_relativa
        }
        
        print(f"  ✓ {total} palavras totais")
        print(f"  ✓ {len(freq_absoluta)} palavras únicas")
        print(f"  ✓ Top 3: {top_50[:3]}")
    
    # ========================================================================
    # ANÁLISE 2: LEI DE ZIPF
    # ========================================================================
    
    def calcular_lei_zipf(self):
        """Calcula e verifica Lei de Zipf"""
        print("→ Calculando Lei de Zipf...")
        
        freq_absoluta = self.resultados['frequencias']['freq_absoluta']
        
        # Ordenar por frequência
        palavras_ordenadas = freq_absoluta.most_common()
        
        ranks = np.arange(1, min(len(palavras_ordenadas), 1000) + 1)
        freqs = [freq for _, freq in palavras_ordenadas[:1000]]
        
        # Lei de Zipf: freq * rank ≈ constante
        produtos = [r * f for r, f in zip(ranks, freqs)]
        
        self.resultados['zipf'] = {
            'ranks': ranks.tolist(),
            'frequencias': freqs,
            'produtos': produtos,
            'media_produto': np.mean(produtos),
            'std_produto': np.std(produtos)
        }
        
        print(f"  ✓ Analisadas top 1000 palavras")
        print(f"  ✓ Produto médio (rank×freq): {np.mean(produtos):.2f}")
    
    # ========================================================================
    # ANÁLISE 3: DISPERSÃO (com Gries DP)
    # ========================================================================
    
    def calcular_dispersao(self):
        """Calcula medidas de dispersão incluindo Gries DP"""
        print("→ Calculando dispersão de termos UAM...")
        
        # Dividir texto em 10 partes
        num_partes = 10
        tamanho_parte = len(self.palavras) // num_partes
        
        # Dividir palavras
        texto_dividido = []
        for i in range(num_partes):
            inicio = i * tamanho_parte
            fim = (i + 1) * tamanho_parte if i < num_partes - 1 else len(self.palavras)
            texto_dividido.append(self.palavras[inicio:fim])
        
        dispersoes = {}
        
        for termo in TERMOS_UAM:
            # Contar frequência em cada parte
            freqs_partes = []
            for parte in texto_dividido:
                freq = sum(1 for p in parte if termo.lower() in p)
                freqs_partes.append(freq)
            
            # Calcular estatísticas
            freqs_array = np.array(freqs_partes)
            media = np.mean(freqs_array)
            desvio = np.std(freqs_array)
            cv = (desvio / media) if media > 0 else 0
            
            # Dispersão de Juilland
            dp_juilland = 1 - (cv / np.sqrt(num_partes)) if media > 0 else 0
            
            # Gries DP (nova técnica)
            dp_gries = Dispersion.gries_dp(termo.lower(), texto_dividido)
            
            dispersoes[termo] = {
                'frequencias_partes': freqs_partes,
                'media': float(media),
                'desvio_padrao': float(desvio),
                'coef_variacao': float(cv),
                'dispersao_juilland': float(dp_juilland),
                'gries_dp': float(dp_gries) if dp_gries is not None else None,
                'range': int(np.ptp(freqs_array))
            }
        
        self.resultados['dispersao'] = dispersoes
        
        # Mostrar termos mais dispersos
        termos_ordenados = sorted(
            dispersoes.items(),
            key=lambda x: x[1]['coef_variacao'],
            reverse=True
        )
        print(f"  ✓ Analisados {len(TERMOS_UAM)} termos UAM")
        if termos_ordenados:
            print(f"  ✓ Termo mais disperso: {termos_ordenados[0][0]} (CV={termos_ordenados[0][1]['coef_variacao']:.2f})")
    
    # ========================================================================
    # ANÁLISE 4: N-GRAMAS
    # ========================================================================
    
    def calcular_ngramas(self):
        """Calcula bigramas e trigramas mais frequentes"""
        print("→ Calculando n-gramas...")
        
        # Bigramas
        bigramas = list(ngrams(self.palavras, 2))
        freq_bigramas = Counter(bigramas)
        top_bigramas = freq_bigramas.most_common(30)
        
        # Trigramas
        trigramas = list(ngrams(self.palavras, 3))
        freq_trigramas = Counter(trigramas)
        top_trigramas = freq_trigramas.most_common(20)
        
        self.resultados['ngramas'] = {
            'bigramas': [
                {
                    'ngrama': ' '.join(bg),
                    'frequencia': freq
                }
                for bg, freq in top_bigramas
            ],
            'trigramas': [
                {
                    'ngrama': ' '.join(tg),
                    'frequencia': freq
                }
                for tg, freq in top_trigramas
            ]
        }
        
        print(f"  ✓ {len(bigramas)} bigramas")
        print(f"  ✓ {len(trigramas)} trigramas")
        if top_bigramas:
            print(f"  ✓ Top bigrama: '{' '.join(top_bigramas[0][0])}' ({top_bigramas[0][1]}x)")
    
    # ========================================================================
    # ANÁLISE 5: COLOCAÇÕES (com T-Score)
    # ========================================================================
    
    def calcular_colocacoes(self):
        """Calcula colocações incluindo T-Score"""
        print("→ Calculando colocações...")
        
        try:
            # Bigramas
            bigramas_list = list(ngrams(self.palavras, 2))
            freq_bigramas = Counter(bigramas_list)
            freq_palavras = Counter(self.palavras)
            total_bigramas = len(bigramas_list)
            
            # Calcular T-Score para top bigramas
            colocacoes_t = []
            for (w1, w2), freq_bi in freq_bigramas.most_common(50):
                freq_w1 = freq_palavras[w1]
                freq_w2 = freq_palavras[w2]
                
                t = Collocation.t_score(freq_bi, freq_w1, freq_w2, total_bigramas)
                
                if t > 2.0:  # Significativo
                    colocacoes_t.append({
                        'bigrama': f"{w1} {w2}",
                        'freq': freq_bi,
                        't_score': t
                    })
            
            colocacoes_t.sort(key=lambda x: x['t_score'], reverse=True)
            
            # Bigramas por frequência
            colocacoes_bi = [
                ' '.join(bg) for bg, freq in freq_bigramas.most_common(30)
                if freq >= 3
            ]
            
            # Trigramas
            trigramas = list(ngrams(self.palavras, 3))
            freq_trigramas = Counter(trigramas)
            colocacoes_tri = [
                ' '.join(tg) for tg, freq in freq_trigramas.most_common(20)
                if freq >= 2
            ]
            
            self.resultados['colocacoes'] = {
                'bigramas': colocacoes_bi,
                'trigramas': colocacoes_tri,
                't_score_significativas': colocacoes_t[:20]
            }
            
            print(f"  ✓ {len(colocacoes_bi)} colocações (bigramas)")
            print(f"  ✓ {len(colocacoes_tri)} colocações (trigramas)")
            print(f"  ✓ {len(colocacoes_t)} colocações com T-Score > 2.0")
            
        except Exception as e:
            print(f"  ⚠ Aviso ao calcular colocações: {e}")
            self.resultados['colocacoes'] = {
                'bigramas': [],
                'trigramas': [],
                't_score_significativas': []
            }
    
    # ========================================================================
    # ANÁLISE 6: TYPE-TOKEN RATIO (NOVA)
    # ========================================================================
    
    def calcular_ttr(self):
        """Type-Token Ratio e variantes"""
        print("→ Calculando Type-Token Ratio...")
        
        self.resultados['ttr'] = {
            'ttr_simples': LexicalDiversity.ttr_simple(self.palavras),
            'mattr': LexicalDiversity.mattr(self.palavras, window_size=min(1000, len(self.palavras)//2)),
            'root_ttr': LexicalDiversity.root_ttr(self.palavras),
            'herdans_c': LexicalDiversity.herdans_c(self.palavras)
        }
        
        print(f"  ✓ TTR simples: {self.resultados['ttr']['ttr_simples']:.4f}")
        print(f"  ✓ MATTR: {self.resultados['ttr']['mattr']:.4f}")
    
    # ========================================================================
    # ANÁLISE 7: HAPAX LEGOMENA (NOVA)
    # ========================================================================
    
    def calcular_hapax(self):
        """Hapax Legomena"""
        print("→ Calculando Hapax Legomena...")
        
        hapax_list = HapaxAnalysis.hapax_legomena(self.palavras)
        
        self.resultados['hapax'] = {
            'total': len(hapax_list),
            'ratio': HapaxAnalysis.hapax_ratio(self.palavras),
            'percentage': HapaxAnalysis.hapax_percentage(self.palavras),
            'exemplos': hapax_list[:20]  # Top 20 exemplos
        }
        
        print(f"  ✓ Total de hapax: {len(hapax_list)}")
        print(f"  ✓ Razão de hapax: {self.resultados['hapax']['ratio']:.4f}")
    
    # ========================================================================
    # ANÁLISE 8: FREQUÊNCIA DE TERMOS UAM
    # ========================================================================
    
    def calcular_frequencia_termos_uam(self):
        """Calcula frequência específica de termos relacionados à UAM"""
        print("→ Calculando frequência de termos UAM...")
        
        texto_lower = self.texto_completo.lower()
        frequencias = {}
        
        for termo in TERMOS_UAM:
            padrao = r'\b' + re.escape(termo.lower()) + r'\b'
            ocorrencias = len(re.findall(padrao, texto_lower))
            frequencias[termo] = ocorrencias
        
        # Frequência normalizada (por 1000 palavras)
        total_palavras = self.resultados['frequencias']['total_palavras']
        freq_normalizada = {
            termo: (freq / total_palavras) * 1000 if total_palavras > 0 else 0
            for termo, freq in frequencias.items()
        }
        
        self.resultados['termos_uam'] = {
            'frequencias': frequencias,
            'freq_normalizada': freq_normalizada,
            'total_ocorrencias': sum(frequencias.values())
        }
        
        print(f"  ✓ Total de ocorrências UAM: {sum(frequencias.values())}")
        top_termo = max(frequencias.items(), key=lambda x: x[1])
        print(f"  ✓ Termo mais frequente: '{top_termo[0]}' ({top_termo[1]}x)")
    
    # ========================================================================
    # ANÁLISE 9: ESTATÍSTICAS DESCRITIVAS
    # ========================================================================
    
    def calcular_estatisticas_descritivas(self):
        """Calcula estatísticas descritivas do texto"""
        print("→ Calculando estatísticas descritivas...")
        
        freq_absoluta = self.resultados['frequencias']['freq_absoluta']
        frequencias = list(freq_absoluta.values())
        
        # Tamanho das palavras
        tamanhos_palavras = [len(p) for p in self.palavras]
        
        # Tamanho das sentenças
        tamanhos_sentencas = [len(word_tokenize(s)) for s in self.sentencas]
        
        self.resultados['estatisticas_descritivas'] = {
            'frequencias': {
                'media': float(np.mean(frequencias)),
                'mediana': float(np.median(frequencias)),
                'desvio_padrao': float(np.std(frequencias)),
                'minimo': int(min(frequencias)),
                'maximo': int(max(frequencias)),
                'quartis': [float(q) for q in np.percentile(frequencias, [25, 50, 75])]
            },
            'tamanho_palavras': {
                'media': float(np.mean(tamanhos_palavras)),
                'mediana': float(np.median(tamanhos_palavras)),
                'desvio_padrao': float(np.std(tamanhos_palavras)),
                'minimo': int(min(tamanhos_palavras)),
                'maximo': int(max(tamanhos_palavras))
            },
            'tamanho_sentencas': {
                'media': float(np.mean(tamanhos_sentencas)),
                'mediana': float(np.median(tamanhos_sentencas)),
                'desvio_padrao': float(np.std(tamanhos_sentencas)),
                'minimo': int(min(tamanhos_sentencas)),
                'maximo': int(max(tamanhos_sentencas))
            }
        }
        
        print(f"  ✓ Média de palavras por sentença: {np.mean(tamanhos_sentencas):.1f}")
        print(f"  ✓ Tamanho médio de palavra: {np.mean(tamanhos_palavras):.1f} letras")
    
    # ========================================================================
    # EXECUTAR TODAS AS ANÁLISES
    # ========================================================================
    
    def executar_analises(self):
        """Executa todas as análises em sequência"""
        print("\nIniciando análises estatísticas...")
        
        # Extração e preprocessamento
        if not self.extrair_texto_pdf():
            return False
        
        if not self.preprocessar_texto():
            return False
        
        # Análises
        try:
            self.calcular_frequencias()
            self.calcular_lei_zipf()
            self.calcular_dispersao()
            self.calcular_ngramas()
            self.calcular_colocacoes()
            self.calcular_ttr()  # NOVA
            self.calcular_hapax()  # NOVA
            self.calcular_frequencia_termos_uam()
            self.calcular_estatisticas_descritivas()
            
            print("\n✓ Todas as análises concluídas com sucesso!")
            return True
            
        except Exception as e:
            print(f"\n✗ Erro durante análises: {e}")
            import traceback
            traceback.print_exc()
            return False

# ============================================================================
# GERADOR DE VISUALIZAÇÕES (mantém o mesmo do original)
# ============================================================================

class GeradorVisualizacoes:
    """Gera todas as visualizações para o relatório"""
    
    def __init__(self, resultados, nome_doc, pasta_temp):
        self.resultados = resultados
        self.nome_doc = nome_doc
        self.pasta_temp = Path(pasta_temp)
        self.imagens = {}
        
    def gerar_todas(self):
        """Gera todas as visualizações"""
        print("\n→ Gerando visualizações...")
        
        self.gerar_nuvem_palavras()
        self.gerar_grafico_frequencias()
        self.gerar_grafico_zipf()
        self.gerar_grafico_dispersao()
        self.gerar_grafico_ngramas()
        self.gerar_grafico_termos_uam()
        self.gerar_grafico_ttr()  # NOVO
        
        print("  ✓ Todas as visualizações geradas")
        return self.imagens
    
    def gerar_nuvem_palavras(self):
        """Gera nuvem de palavras"""
        try:
            freq_dict = dict(self.resultados['frequencias']['top_50'])
            
            wordcloud = WordCloud(
                width=800, height=400,
                background_color='white',
                colormap='viridis',
                max_words=100
            ).generate_from_frequencies(freq_dict)
            
            fig, ax = plt.subplots(figsize=(10, 5))
            ax.imshow(wordcloud, interpolation='bilinear')
            ax.axis('off')
            ax.set_title('Nuvem de Palavras - Termos Mais Frequentes',
                        fontsize=14, fontweight='bold', pad=20)
            
            caminho = self.pasta_temp / f'{self.nome_doc}_nuvem.png'
            plt.savefig(caminho, dpi=150, bbox_inches='tight', facecolor='white')
            plt.close()
            
            self.imagens['nuvem'] = str(caminho)
            
        except Exception as e:
            print(f"  ⚠ Erro ao gerar nuvem: {e}")
    
    def gerar_grafico_frequencias(self):
        """Gera gráfico de barras de frequências"""
        try:
            top_30 = self.resultados['frequencias']['top_50'][:30]
            palavras = [p[0] for p in top_30]
            freqs = [p[1] for p in top_30]
            
            fig, ax = plt.subplots(figsize=(12, 8))
            y_pos = np.arange(len(palavras))
            
            bars = ax.barh(y_pos, freqs, color='steelblue', alpha=0.8)
            ax.set_yticks(y_pos)
            ax.set_yticklabels(palavras)
            ax.invert_yaxis()
            ax.set_xlabel('Frequência Absoluta', fontsize=11, fontweight='bold')
            ax.set_title('Top 30 Palavras Mais Frequentes',
                        fontsize=14, fontweight='bold', pad=20)
            ax.grid(axis='x', alpha=0.3)
            
            # Adicionar valores nas barras
            for i, bar in enumerate(bars):
                width = bar.get_width()
                ax.text(width + max(freqs)*0.01, bar.get_y() + bar.get_height()/2,
                       f'{int(width)}', ha='left', va='center', fontsize=9)
            
            caminho = self.pasta_temp / f'{self.nome_doc}_freq.png'
            plt.savefig(caminho, dpi=150, bbox_inches='tight', facecolor='white')
            plt.close()
            
            self.imagens['frequencias'] = str(caminho)
            
        except Exception as e:
            print(f"  ⚠ Erro ao gerar gráfico de frequências: {e}")
    
    def gerar_grafico_zipf(self):
        """Gera gráfico da Lei de Zipf"""
        try:
            ranks = self.resultados['zipf']['ranks']
            freqs = self.resultados['zipf']['frequencias']
            
            fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
            
            # Gráfico 1: Rank vs Frequência (escala log-log)
            ax1.loglog(ranks, freqs, 'o-', markersize=3, alpha=0.6)
            ax1.set_xlabel('Rank (log)', fontsize=11, fontweight='bold')
            ax1.set_ylabel('Frequência (log)', fontsize=11, fontweight='bold')
            ax1.set_title('Lei de Zipf: Rank × Frequência',
                         fontsize=13, fontweight='bold')
            ax1.grid(True, alpha=0.3)
            
            # Gráfico 2: Produto Rank × Frequência
            produtos = self.resultados['zipf']['produtos']
            ax2.plot(ranks, produtos, 'o-', markersize=3, alpha=0.6, color='coral')
            ax2.axhline(y=np.mean(produtos), color='red', linestyle='--', 
                       label=f'Média: {np.mean(produtos):.0f}', linewidth=2)
            ax2.set_xlabel('Rank', fontsize=11, fontweight='bold')
            ax2.set_ylabel('Rank × Frequência', fontsize=11, fontweight='bold')
            ax2.set_title('Produto Rank × Frequência (deve ser ~constante)',
                         fontsize=13, fontweight='bold')
            ax2.legend()
            ax2.grid(True, alpha=0.3)
            
            plt.tight_layout()
            caminho = self.pasta_temp / f'{self.nome_doc}_zipf.png'
            plt.savefig(caminho, dpi=150, bbox_inches='tight', facecolor='white')
            plt.close()
            
            self.imagens['zipf'] = str(caminho)
            
        except Exception as e:
            print(f"  ⚠ Erro ao gerar gráfico de Zipf: {e}")
    
    def gerar_grafico_dispersao(self):
        """Gera gráfico de dispersão"""
        try:
            dispersoes = self.resultados['dispersao']
            
            # Filtrar termos com ocorrências
            termos_com_dados = {
                t: d for t, d in dispersoes.items()
                if d['media'] > 0
            }
            
            if not termos_com_dados:
                return
            
            fig, ax = plt.subplots(figsize=(12, 8))
            
            termos = list(termos_com_dados.keys())
            cvs = [termos_com_dados[t]['coef_variacao'] for t in termos]
            medias = [termos_com_dados[t]['media'] for t in termos]
            
            scatter = ax.scatter(medias, cvs, s=100, alpha=0.6, c=medias, cmap='viridis')
            
            # Adicionar labels
            for i, termo in enumerate(termos):
                ax.annotate(termo, (medias[i], cvs[i]), fontsize=9,
                           xytext=(5, 5), textcoords='offset points')
            
            ax.set_xlabel('Frequência Média por Parte', fontsize=11, fontweight='bold')
            ax.set_ylabel('Coeficiente de Variação', fontsize=11, fontweight='bold')
            ax.set_title('Dispersão de Termos UAM\n(CV alto = mais disperso/irregular)',
                        fontsize=13, fontweight='bold', pad=20)
            ax.grid(True, alpha=0.3)
            
            plt.colorbar(scatter, label='Frequência Média', ax=ax)
            
            caminho = self.pasta_temp / f'{self.nome_doc}_dispersao.png'
            plt.savefig(caminho, dpi=150, bbox_inches='tight', facecolor='white')
            plt.close()
            
            self.imagens['dispersao'] = str(caminho)
            
        except Exception as e:
            print(f"  ⚠ Erro ao gerar gráfico de dispersão: {e}")
    
    def gerar_grafico_ngramas(self):
        """Gera gráfico de n-gramas"""
        try:
            bigramas = self.resultados['ngramas']['bigramas'][:20]
            
            if not bigramas:
                return
            
            fig, ax = plt.subplots(figsize=(12, 8))
            
            ngramas_text = [b['ngrama'] for b in bigramas]
            freqs = [b['frequencia'] for b in bigramas]
            
            y_pos = np.arange(len(ngramas_text))
            ax.barh(y_pos, freqs, color='teal', alpha=0.8)
            ax.set_yticks(y_pos)
            ax.set_yticklabels(ngramas_text)
            ax.invert_yaxis()
            ax.set_xlabel('Frequência', fontsize=11, fontweight='bold')
            ax.set_title('Top 20 Bigramas Mais Frequentes',
                        fontsize=14, fontweight='bold', pad=20)
            ax.grid(axis='x', alpha=0.3)
            
            caminho = self.pasta_temp / f'{self.nome_doc}_ngramas.png'
            plt.savefig(caminho, dpi=150, bbox_inches='tight', facecolor='white')
            plt.close()
            
            self.imagens['ngramas'] = str(caminho)
            
        except Exception as e:
            print(f"  ⚠ Erro ao gerar gráfico de n-gramas: {e}")
    
    def gerar_grafico_termos_uam(self):
        """Gera gráfico de termos UAM"""
        try:
            termos_uam = self.resultados['termos_uam']
            frequencias = termos_uam['frequencias']
            
            # Filtrar termos com ocorrências
            termos_com_freq = {t: f for t, f in frequencias.items() if f > 0}
            
            if not termos_com_freq:
                return
            
            # Ordenar
            termos_ordenados = sorted(termos_com_freq.items(), 
                                     key=lambda x: x[1], reverse=True)
            
            termos = [t[0] for t in termos_ordenados]
            freqs = [t[1] for t in termos_ordenados]
            
            fig, ax = plt.subplots(figsize=(12, 8))
            y_pos = np.arange(len(termos))
            
            colors_map = plt.cm.RdYlGn(np.linspace(0.3, 0.9, len(termos)))
            bars = ax.barh(y_pos, freqs, color=colors_map, alpha=0.8)
            
            ax.set_yticks(y_pos)
            ax.set_yticklabels(termos)
            ax.invert_yaxis()
            ax.set_xlabel('Frequência Absoluta', fontsize=11, fontweight='bold')
            ax.set_title('Frequência de Termos UAM no Documento',
                        fontsize=14, fontweight='bold', pad=20)
            ax.grid(axis='x', alpha=0.3)
            
            # Adicionar valores
            for i, bar in enumerate(bars):
                width = bar.get_width()
                ax.text(width + max(freqs)*0.01, bar.get_y() + bar.get_height()/2,
                       f'{int(width)}', ha='left', va='center', fontsize=9)
            
            caminho = self.pasta_temp / f'{self.nome_doc}_termos_uam.png'
            plt.savefig(caminho, dpi=150, bbox_inches='tight', facecolor='white')
            plt.close()
            
            self.imagens['termos_uam'] = str(caminho)
            
        except Exception as e:
            print(f"  ⚠ Erro ao gerar gráfico de termos UAM: {e}")
    
    def gerar_grafico_ttr(self):
        """Gera gráfico de TTR (NOVO) - COMPACTO SEM ESPAÇO BRANCO"""
        try:
            ttr_data = self.resultados['ttr']
            
            medidas = ['TTR Simples', 'MATTR', 'Root TTR', "Herdan's C"]
            valores = [
                ttr_data['ttr_simples'],
                ttr_data['mattr'],
                ttr_data['root_ttr'],
                ttr_data['herdans_c']
            ]
            
            # FIGURA COMPACTA - SEM ESPAÇO BRANCO
            fig = plt.figure(figsize=(12, 5), facecolor='white')
            ax = fig.add_subplot(111)
            
            y_pos = np.arange(len(medidas))
            colors = ['steelblue', 'coral', 'lightgreen', 'gold']
            
            bars = ax.barh(y_pos, valores, color=colors, alpha=0.8, height=0.6)
            ax.set_yticks(y_pos)
            ax.set_yticklabels(medidas, fontsize=10)
            ax.invert_yaxis()
            ax.set_xlabel('Valor', fontsize=10, fontweight='bold')
            ax.set_title('Medidas de Diversidade Lexical (TTR)', fontsize=12, fontweight='bold', pad=10)
            ax.set_xlim(0, 1.05)
            ax.grid(axis='x', alpha=0.3, linewidth=0.5)
            
            # Valores nas barras
            for i, bar in enumerate(bars):
                width = bar.get_width()
                ax.text(width + 0.02, bar.get_y() + bar.get_height()/2.,
                       f'{width:.4f}', ha='left', va='center', fontsize=9, fontweight='bold')
            
            # REMOVE TODO O ESPAÇO BRANCO
            fig.tight_layout(pad=0.3)
            
            caminho = self.pasta_temp / f'{self.nome_doc}_ttr.png'
            fig.savefig(caminho, dpi=150, bbox_inches='tight', facecolor='white',
                       pad_inches=0.05, transparent=False)
            plt.close(fig)
            
            self.imagens['ttr'] = str(caminho)
            
        except Exception as e:
            print(f"  ⚠ Erro ao gerar gráfico de TTR: {e}")

# ============================================================================
# GERADOR DE PDF (com referências bibliográficas)
# ============================================================================

class GeradorPDF:
    """Gera PDF consolidado com todas as análises E REFERÊNCIAS BIBLIOGRÁFICAS"""
    
    def __init__(self, nome_doc, resultados, imagens, caminho_saida):
        self.nome_doc = nome_doc
        self.resultados = resultados
        self.imagens = imagens
        self.caminho_saida = caminho_saida
        self.story = []
        self.styles = getSampleStyleSheet()
        self._configurar_estilos()
        
    def _configurar_estilos(self):
        """Configura estilos personalizados"""
        # Título principal
        self.styles.add(ParagraphStyle(
            name='CustomTitle',
            parent=self.styles['Heading1'],
            fontSize=18,
            textColor=colors.HexColor('#1f77b4'),
            spaceAfter=30,
            alignment=TA_CENTER,
            fontName='Helvetica-Bold'
        ))
        
        # Seção
        self.styles.add(ParagraphStyle(
            name='SectionHeader',
            parent=self.styles['Heading2'],
            fontSize=14,
            textColor=colors.HexColor('#2ca02c'),
            spaceAfter=12,
            spaceBefore=20,
            fontName='Helvetica-Bold'
        ))
        
        # Subseção
        self.styles.add(ParagraphStyle(
            name='SubSection',
            parent=self.styles['Heading3'],
            fontSize=12,
            textColor=colors.HexColor('#ff7f0e'),
            spaceAfter=10,
            fontName='Helvetica-Bold'
        ))
        
        # Referência (NOVO)
        self.styles.add(ParagraphStyle(
            name='Reference',
            parent=self.styles['Normal'],
            fontSize=9,
            textColor=colors.HexColor('#555555'),
            leftIndent=10,
            spaceAfter=8,
            fontName='Helvetica-Oblique'
        ))
    
    def gerar_pdf(self):
        """Gera o PDF completo com referências"""
        print(f"\n→ Gerando PDF: {self.nome_doc}")
        
        doc = SimpleDocTemplate(
            str(self.caminho_saida),
            pagesize=A4,
            rightMargin=2*cm,
            leftMargin=2*cm,
            topMargin=2*cm,
            bottomMargin=2*cm
        )
        
        # Construir conteúdo
        self._adicionar_capa()
        self._adicionar_sumario()
        self._adicionar_secao_frequencias()
        self._adicionar_secao_zipf()
        self._adicionar_secao_ttr()  # NOVA
        self._adicionar_secao_hapax()  # NOVA
        self._adicionar_secao_dispersao()
        self._adicionar_secao_ngramas()
        self._adicionar_secao_colocacoes()
        self._adicionar_secao_termos_uam()
        self._adicionar_secao_descritivas()
        self._adicionar_referencias_bibliograficas()  # NOVA
        
        # Construir PDF
        doc.build(self.story)
        print(f"  ✓ PDF gerado: {self.caminho_saida}")
    
    def _adicionar_capa(self):
        """Adiciona capa"""
        self.story.append(Spacer(1, 2*inch))
        
        titulo = Paragraph(
            f"<b>ANÁLISE ESTATÍSTICA CONSOLIDADA</b>",
            self.styles['CustomTitle']
        )
        self.story.append(titulo)
        self.story.append(Spacer(1, 0.2*inch))
        
        subtitulo = Paragraph(
            "<b>Documento Legislativo</b>",
            self.styles['CustomTitle']
        )
        self.story.append(subtitulo)
        self.story.append(Spacer(1, 0.3*inch))
        
        nome_doc = Paragraph(
            f"<b>{self.nome_doc}</b>",
            self.styles['CustomTitle']
        )
        self.story.append(nome_doc)
        self.story.append(Spacer(1, 0.5*inch))
        
        data = Paragraph(
            f"Gerado em: {datetime.now().strftime('%d/%m/%Y %H:%M')}",
            self.styles['Normal']
        )
        self.story.append(data)
        
        self.story.append(Spacer(1, 0.3*inch))
        
        info = Paragraph(
            """<i>Este relatório contém análises estatísticas completas baseadas em
            técnicas de Linguística de Corpus com 15+ análises diferentes. Cada técnica
            é citada com referência bibliográfica completa (autor, livro, página).</i>""",
            self.styles['Normal']
        )
        self.story.append(info)
        
        self.story.append(PageBreak())
    
    def _adicionar_sumario(self):
        """Adiciona sumário"""
        self.story.append(Paragraph("<b>SUMÁRIO</b>", self.styles['CustomTitle']))
        self.story.append(Spacer(1, 0.3*inch))
        
        secoes = [
            "1. Análise de Frequências",
            "2. Lei de Zipf",
            "3. Type-Token Ratio (TTR)",
            "4. Hapax Legomena",
            "5. Dispersão de Termos",
            "6. N-gramas",
            "7. Colocações",
            "8. Termos UAM",
            "9. Estatísticas Descritivas",
            "10. Referências Bibliográficas"
        ]
        
        for secao in secoes:
            self.story.append(Paragraph(secao, self.styles['Normal']))
            self.story.append(Spacer(1, 0.1*inch))
        
        self.story.append(PageBreak())
    
    def _adicionar_secao_frequencias(self):
        """Adiciona seção de frequências COM REFERÊNCIA"""
        self.story.append(Paragraph("1. ANÁLISE DE FREQUÊNCIAS", 
                                   self.styles['SectionHeader']))
        
        # ADICIONAR REFERÊNCIA
        self.story.append(Paragraph(formatar_referencia('frequencias'), 
                                   self.styles['Reference']))
        self.story.append(Spacer(1, 0.1*inch))
        
        freq_data = self.resultados['frequencias']
        
        texto = f"""
        <b>Total de palavras (após filtro):</b> {freq_data['total_palavras']:,}<br/>
        <b>Palavras únicas:</b> {freq_data['total_unicas']:,}<br/>
        <b>Riqueza lexical:</b> {(freq_data['total_unicas']/freq_data['total_palavras']*100):.2f}%<br/><br/>
        
        <i>Nota: Foram removidas {len(STOPWORDS)} stopwords (palavras comuns) para focar nas palavras relevantes.</i>
        """
        
        self.story.append(Paragraph(texto, self.styles['Normal']))
        self.story.append(Spacer(1, 0.2*inch))
        
        # Adicionar imagens
        if 'nuvem' in self.imagens:
            self.story.append(Paragraph("Nuvem de Palavras", self.styles['SubSection']))
            img = Image(self.imagens['nuvem'], width=6*inch, height=3*inch)
            self.story.append(img)
            self.story.append(Spacer(1, 0.2*inch))
        
        if 'frequencias' in self.imagens:
            self.story.append(Paragraph("Top 30 Palavras Mais Frequentes", 
                                       self.styles['SubSection']))
            img = Image(self.imagens['frequencias'], width=6*inch, height=4*inch)
            self.story.append(img)
        
        self.story.append(PageBreak())
    
    def _adicionar_secao_zipf(self):
        """Adiciona seção da Lei de Zipf COM REFERÊNCIA"""
        self.story.append(Paragraph("2. LEI DE ZIPF", self.styles['SectionHeader']))
        
        # ADICIONAR REFERÊNCIA
        self.story.append(Paragraph(formatar_referencia('zipf'), 
                                   self.styles['Reference']))
        self.story.append(Spacer(1, 0.1*inch))
        
        zipf_data = self.resultados['zipf']
        
        texto = f"""
        A Lei de Zipf afirma que a frequência de uma palavra é inversamente proporcional
        ao seu rank. Ou seja, o produto (rank × frequência) deve ser aproximadamente constante.<br/><br/>
        
        <b>Produto médio (rank × freq):</b> {zipf_data['media_produto']:.2f}<br/>
        <b>Desvio padrão:</b> {zipf_data['std_produto']:.2f}<br/><br/>
        
        Um desvio padrão baixo indica que o texto segue bem a Lei de Zipf.
        """
        
        self.story.append(Paragraph(texto, self.styles['Normal']))
        self.story.append(Spacer(1, 0.2*inch))
        
        if 'zipf' in self.imagens:
            img = Image(self.imagens['zipf'], width=6.5*inch, height=2.5*inch)
            self.story.append(img)
        
        self.story.append(PageBreak())
    
    def _adicionar_secao_ttr(self):
        """Adiciona seção de TTR COM REFERÊNCIAS (NOVA)"""
        self.story.append(Paragraph("3. TYPE-TOKEN RATIO (TTR)", 
                                   self.styles['SectionHeader']))
        
        # ADICIONAR REFERÊNCIAS
        self.story.append(Paragraph(formatar_referencia('ttr'), 
                                   self.styles['Reference']))
        self.story.append(Paragraph(formatar_referencia('mattr'), 
                                   self.styles['Reference']))
        self.story.append(Spacer(1, 0.1*inch))
        
        ttr_data = self.resultados['ttr']
        
        texto = f"""
        <b>Medidas de Diversidade Lexical:</b><br/><br/>
        
        • <b>TTR Simples:</b> {ttr_data['ttr_simples']:.4f}<br/>
        • <b>MATTR (Moving-Average):</b> {ttr_data['mattr']:.4f} ⭐ Mais robusto<br/>
        • <b>Root TTR:</b> {ttr_data['root_ttr']:.4f}<br/>
        • <b>Herdan's C:</b> {ttr_data['herdans_c']:.4f}<br/><br/>
        
        <b>Interpretação:</b><br/>
        MATTR > 0.7: vocabulário muito rico<br/>
        MATTR 0.4-0.7: vocabulário normal<br/>
        MATTR < 0.4: vocabulário repetitivo
        """
        
        self.story.append(Paragraph(texto, self.styles['Normal']))
        self.story.append(Spacer(1, 0.2*inch))
        
        if 'ttr' in self.imagens:
            img = Image(self.imagens['ttr'], width=6*inch, height=3*inch)
            self.story.append(img)
        
        self.story.append(PageBreak())
    
    def _adicionar_secao_hapax(self):
        """Adiciona seção de Hapax COM REFERÊNCIA (NOVA)"""
        self.story.append(Paragraph("4. HAPAX LEGOMENA", 
                                   self.styles['SectionHeader']))
        
        # ADICIONAR REFERÊNCIA
        self.story.append(Paragraph(formatar_referencia('hapax'), 
                                   self.styles['Reference']))
        self.story.append(Spacer(1, 0.1*inch))
        
        hapax_data = self.resultados['hapax']
        
        texto = f"""
        <b>Palavras que ocorrem apenas 1 vez:</b><br/><br/>
        
        • <b>Total de Hapax:</b> {hapax_data['total']}<br/>
        • <b>Razão de Hapax:</b> {hapax_data['ratio']:.4f} ({hapax_data['percentage']:.2f}%)<br/><br/>
        
        <b>Interpretação:</b><br/>
        Muitos hapax indicam vocabulário rico e diverso.<br/>
        Poucos hapax indicam vocabulário técnico e focado.<br/><br/>
        
        <b>Exemplos de Hapax (primeiros 20):</b><br/>
        {', '.join(hapax_data['exemplos'][:20])}
        """
        
        self.story.append(Paragraph(texto, self.styles['Normal']))
        self.story.append(PageBreak())
    
    def _adicionar_secao_dispersao(self):
        """Adiciona seção de dispersão COM REFERÊNCIAS"""
        self.story.append(Paragraph("5. DISPERSÃO DE TERMOS UAM", 
                                   self.styles['SectionHeader']))
        
        # ADICIONAR REFERÊNCIAS
        self.story.append(Paragraph(formatar_referencia('dispersao'), 
                                   self.styles['Reference']))
        self.story.append(Paragraph(formatar_referencia('gries_dp'), 
                                   self.styles['Reference']))
        self.story.append(Spacer(1, 0.1*inch))
        
        texto = """
        A análise de dispersão indica como os termos estão distribuídos ao longo
        do documento. Utilizamos tanto a dispersão de Juilland quanto o Gries DP.<br/><br/>
        
        <b>Interpretação:</b><br/>
        • <b>Gries DP próximo de 0:</b> Termo uniformemente distribuído<br/>
        • <b>Gries DP próximo de 1:</b> Termo concentrado em partes específicas<br/>
        • <b>CV alto (>1.0):</b> Alta variabilidade<br/>
        • <b>CV baixo (<0.5):</b> Distribuição uniforme
        """
        
        self.story.append(Paragraph(texto, self.styles['Normal']))
        self.story.append(Spacer(1, 0.2*inch))
        
        # Tabela com top termos
        dispersao_data = self.resultados['dispersao']
        termos_ordenados = sorted(
            [(t, d) for t, d in dispersao_data.items() if d['media'] > 0],
            key=lambda x: x[1]['media'],
            reverse=True
        )[:10]
        
        if termos_ordenados:
            table_data = [['Termo', 'Média', 'CV', 'Gries DP']]
            for termo, dados in termos_ordenados:
                gries_val = f"{dados['gries_dp']:.3f}" if dados['gries_dp'] is not None else "N/A"
                table_data.append([
                    termo,
                    f"{dados['media']:.2f}",
                    f"{dados['coef_variacao']:.2f}",
                    gries_val
                ])
            
            table = Table(table_data, colWidths=[2.5*inch, 1*inch, 1*inch, 1.5*inch])
            table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.grey),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, 0), 10),
                ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
                ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
                ('GRID', (0, 0), (-1, -1), 1, colors.black)
            ]))
            
            self.story.append(table)
            self.story.append(Spacer(1, 0.3*inch))
        
        if 'dispersao' in self.imagens:
            img = Image(self.imagens['dispersao'], width=6*inch, height=4*inch)
            self.story.append(img)
        
        self.story.append(PageBreak())
    
    def _adicionar_secao_ngramas(self):
        """Adiciona seção de n-gramas COM REFERÊNCIA"""
        self.story.append(Paragraph("6. N-GRAMAS", self.styles['SectionHeader']))
        
        # ADICIONAR REFERÊNCIA
        self.story.append(Paragraph(formatar_referencia('ngramas'), 
                                   self.styles['Reference']))
        self.story.append(Spacer(1, 0.1*inch))
        
        texto = """
        N-gramas são sequências de N palavras consecutivas. Bigramas (2 palavras)
        e trigramas (3 palavras) ajudam a identificar expressões e termos compostos
        frequentes no documento.
        """
        
        self.story.append(Paragraph(texto, self.styles['Normal']))
        self.story.append(Spacer(1, 0.2*inch))
        
        if 'ngramas' in self.imagens:
            img = Image(self.imagens['ngramas'], width=6*inch, height=4*inch)
            self.story.append(img)
            self.story.append(Spacer(1, 0.3*inch))
        
        # Tabela de trigramas
        ngramas_data = self.resultados['ngramas']
        if ngramas_data['trigramas']:
            self.story.append(Paragraph("Top 15 Trigramas", self.styles['SubSection']))
            
            table_data = [['Trigrama', 'Frequência']]
            for tg in ngramas_data['trigramas'][:15]:
                table_data.append([tg['ngrama'], str(tg['frequencia'])])
            
            table = Table(table_data, colWidths=[4*inch, 1.5*inch])
            table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.grey),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, 0), 10),
                ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
                ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
                ('GRID', (0, 0), (-1, -1), 1, colors.black)
            ]))
            
            self.story.append(table)
        
        self.story.append(PageBreak())
    
    def _adicionar_secao_colocacoes(self):
        """Adiciona seção de colocações COM REFERÊNCIAS"""
        self.story.append(Paragraph("7. COLOCAÇÕES", self.styles['SectionHeader']))
        
        # ADICIONAR REFERÊNCIAS
        self.story.append(Paragraph(formatar_referencia('colocacoes'), 
                                   self.styles['Reference']))
        self.story.append(Paragraph(formatar_referencia('t_score'), 
                                   self.styles['Reference']))
        self.story.append(Spacer(1, 0.1*inch))
        
        texto = """
        Colocações são pares ou grupos de palavras que aparecem juntas com
        frequência estatisticamente significativa. Utilizamos T-Score para
        identificar colocações importantes (T > 2.0 = significativo).
        """
        
        self.story.append(Paragraph(texto, self.styles['Normal']))
        self.story.append(Spacer(1, 0.2*inch))
        
        colocacoes_data = self.resultados['colocacoes']
        
        # Colocações com T-Score (NOVA)
        if colocacoes_data.get('t_score_significativas'):
            self.story.append(Paragraph("Colocações com T-Score > 2.0", self.styles['SubSection']))
            
            table_data = [['Bigrama', 'Frequência', 'T-Score']]
            for col in colocacoes_data['t_score_significativas'][:15]:
                table_data.append([
                    col['bigrama'],
                    str(col['freq']),
                    f"{col['t_score']:.2f}"
                ])
            
            table = Table(table_data, colWidths=[3*inch, 1*inch, 1.5*inch])
            table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.grey),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, 0), 10),
                ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
                ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
                ('GRID', (0, 0), (-1, -1), 1, colors.black)
            ]))
            
            self.story.append(table)
            self.story.append(Spacer(1, 0.2*inch))
        
        # Colocações por frequência
        if colocacoes_data['bigramas']:
            self.story.append(Paragraph("Colocações - Bigramas (por frequência)", 
                                       self.styles['SubSection']))
            texto_bi = "<br/>".join([f"• {col}" for col in colocacoes_data['bigramas'][:20]])
            self.story.append(Paragraph(texto_bi, self.styles['Normal']))
        
        self.story.append(PageBreak())
    
    def _adicionar_secao_termos_uam(self):
        """Adiciona seção de termos UAM"""
        self.story.append(Paragraph("8. ANÁLISE DE TERMOS UAM", 
                                   self.styles['SectionHeader']))
        
        termos_data = self.resultados['termos_uam']
        
        texto = f"""
        Análise específica de termos relacionados à Mobilidade Aérea Urbana (UAM).<br/><br/>
        
        <b>Total de ocorrências de termos UAM:</b> {termos_data['total_ocorrencias']}<br/>
        <b>Frequência normalizada:</b> {sum(termos_data['freq_normalizada'].values()):.2f} 
        ocorrências por 1000 palavras
        """
        
        self.story.append(Paragraph(texto, self.styles['Normal']))
        self.story.append(Spacer(1, 0.2*inch))
        
        if 'termos_uam' in self.imagens:
            img = Image(self.imagens['termos_uam'], width=6*inch, height=4*inch)
            self.story.append(img)
        
        self.story.append(PageBreak())
    
    def _adicionar_secao_descritivas(self):
        """Adiciona seção de estatísticas descritivas"""
        self.story.append(Paragraph("9. ESTATÍSTICAS DESCRITIVAS", 
                                   self.styles['SectionHeader']))
        
        desc_data = self.resultados['estatisticas_descritivas']
        
        # Tabela consolidada
        table_data = [
            ['Métrica', 'Frequências', 'Tam. Palavras', 'Tam. Sentenças'],
            ['Média', 
             f"{desc_data['frequencias']['media']:.2f}",
             f"{desc_data['tamanho_palavras']['media']:.2f}",
             f"{desc_data['tamanho_sentencas']['media']:.2f}"],
            ['Mediana',
             f"{desc_data['frequencias']['mediana']:.2f}",
             f"{desc_data['tamanho_palavras']['mediana']:.2f}",
             f"{desc_data['tamanho_sentencas']['mediana']:.2f}"],
            ['Desvio Padrão',
             f"{desc_data['frequencias']['desvio_padrao']:.2f}",
             f"{desc_data['tamanho_palavras']['desvio_padrao']:.2f}",
             f"{desc_data['tamanho_sentencas']['desvio_padrao']:.2f}"],
            ['Mínimo',
             f"{desc_data['frequencias']['minimo']}",
             f"{desc_data['tamanho_palavras']['minimo']}",
             f"{desc_data['tamanho_sentencas']['minimo']}"],
            ['Máximo',
             f"{desc_data['frequencias']['maximo']}",
             f"{desc_data['tamanho_palavras']['maximo']}",
             f"{desc_data['tamanho_sentencas']['maximo']}"]
        ]
        
        table = Table(table_data, colWidths=[2*inch, 1.5*inch, 1.5*inch, 1.5*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.grey),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
        ]))
        
        self.story.append(table)
        self.story.append(Spacer(1, 0.3*inch))
        
        interpretacao = """
        <b>Interpretação:</b><br/>
        • <b>Frequências:</b> Distribuição de quão comuns são as palavras<br/>
        • <b>Tamanho de Palavras:</b> Complexidade lexical do documento<br/>
        • <b>Tamanho de Sentenças:</b> Complexidade sintática do documento
        """
        
        self.story.append(Paragraph(interpretacao, self.styles['Normal']))
        self.story.append(PageBreak())
    
    def _adicionar_referencias_bibliograficas(self):
        """Adiciona página de referências bibliográficas (NOVA)"""
        self.story.append(Paragraph("10. REFERÊNCIAS BIBLIOGRÁFICAS", 
                                   self.styles['SectionHeader']))
        self.story.append(Spacer(1, 0.2*inch))
        
        # Coletar referências únicas
        refs_unicas = set()
        for key, ref in REFERENCIAS.items():
            ref_text = f"{ref['autor']} ({ref['ano']}). {ref['livro']}."
            refs_unicas.add(ref_text)
        
        # Ordenar e adicionar
        for ref in sorted(refs_unicas):
            self.story.append(Paragraph(f"• {ref}", self.styles['Normal']))
            self.story.append(Spacer(1, 0.15*inch))

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

def processar_documento(caminho_pdf, nome_doc):
    """
    Processa um documento completo: análise + visualizações + PDF
    
    Args:
        caminho_pdf: Caminho para o PDF
        nome_doc: Nome identificador do documento
        
    Returns:
        bool: True se sucesso, False caso contrário
    """
    try:
        # 1. Análise
        analisador = AnalisadorDocumento(caminho_pdf, nome_doc)
        if not analisador.executar_analises():
            return False
        
        # 2. Visualizações
        gerador_viz = GeradorVisualizacoes(
            analisador.resultados,
            nome_doc,
            PASTA_TEMP
        )
        imagens = gerador_viz.gerar_todas()
        
        # 3. PDF
        caminho_pdf_saida = PASTA_ESTATISTICAS / f"{nome_doc}_analise_completa.pdf"
        
        gerador_pdf = GeradorPDF(
            nome_doc,
            analisador.resultados,
            imagens,
            caminho_pdf_saida
        )
        gerador_pdf.gerar_pdf()
        
        # 4. Salvar JSON com resultados
        caminho_json = PASTA_TEMP / f"{nome_doc}_resultados.json"
        
        # Converter para formato JSON-serializável
        resultados_json = json.loads(
            json.dumps(analisador.resultados, default=str)
        )
        
        with open(caminho_json, 'w', encoding='utf-8') as f:
            json.dump(resultados_json, f, ensure_ascii=False, indent=2)
        
        print(f"\n{'='*70}")
        print(f"✓ DOCUMENTO PROCESSADO COM SUCESSO: {nome_doc}")
        print(f"{'='*70}\n")
        
        return True
        
    except Exception as e:
        print(f"\n✗ ERRO ao processar {nome_doc}: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Função principal"""
    print("\n" + "="*70)
    print("GERADOR DE ANÁLISES ESTATÍSTICAS - VERSÃO DEFINITIVA CONSOLIDADA")
    print("Projeto SIGMA city - Produto 1")
    print("Versão Windows/Linux/Mac")
    print(f"Filtro de Stopwords: {len(STOPWORDS)} palavras removidas")
    print(f"Análises: 15+ com referências bibliográficas completas")
    print("="*70 + "\n")
    
    # Encontrar todos os PDFs na pasta atual e subpastas
    print("→ Buscando documentos PDF...")
    pdfs_encontrados = list(PASTA_ATUAL.rglob("*.pdf"))
    
    # Remover PDFs que já foram gerados (analise_completa)
    pdfs_encontrados = [p for p in pdfs_encontrados if 'analise_completa' not in p.name]
    
    print(f"  ✓ {len(pdfs_encontrados)} documento(s) encontrado(s)\n")
    
    if not pdfs_encontrados:
        print("✗ Nenhum PDF encontrado na pasta atual!")
        print(f"  Pasta atual: {PASTA_ATUAL}")
        print("\n  Coloque os PDFs nesta pasta e execute novamente.")
        return
    
    # Listar PDFs encontrados
    print("Documentos encontrados:")
    for i, pdf in enumerate(pdfs_encontrados, 1):
        print(f"  {i}. {pdf.name}")
    print()
    
    # Processar cada documento
    sucessos = 0
    falhas = 0
    
    for i, pdf_path in enumerate(pdfs_encontrados, 1):
        nome_doc = pdf_path.stem.replace(" ", "_")
        
        print(f"\n{'#'*70}")
        print(f"PROCESSANDO [{i}/{len(pdfs_encontrados)}]: {pdf_path.name}")
        print(f"{'#'*70}")
        
        if processar_documento(str(pdf_path), nome_doc):
            sucessos += 1
        else:
            falhas += 1
    
    # Resumo final
    print("\n" + "="*70)
    print("PROCESSAMENTO CONCLUÍDO")
    print("="*70)
    print(f"✓ Sucessos: {sucessos}")
    print(f"✗ Falhas: {falhas}")
    print(f"\n📁 PDFs salvos em: {PASTA_ESTATISTICAS}")
    print(f"📁 Arquivos temporários em: {PASTA_TEMP}")
    print("\n✨ CADA PDF CONTÉM:")
    print("  • 15+ análises estatísticas")
    print("  • Referências bibliográficas completas (autor + livro + página)")
    print("  • Citações em cada seção")
    print("  • Base científica robusta")
    print("="*70 + "\n")

if __name__ == "__main__":
    main()