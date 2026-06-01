import re

# Read the file
file_path = r"g:\.shortcut-targets-by-id\1h_enSk1Ykjlyh98tR9W4BdFCmvRH96BD\02-UAM Cidades\20 - WebSite\projeto\Projeto_Sigma_cityPII\Horizontal (A3) - Guia (1).txt"

with open(file_path, 'r', encoding='utf-16 le', errors='ignore') as f:
    content = f.read()

# First pass: Add space before capital letters (likely word starts)
# Pattern: lowercase/digit followed by uppercase
content = re.sub(r'([a-z·ÈÌÛ˙„ıÁ])([A-Z])', r'\1 \2', content)

# Also handle digit to letter transitions
content = re.sub(r'([0-9])([A-Z])', r'\1 \2', content)

# Handle common Portuguese words/patterns - add space before common conjunctions and articles that got merged
patterns = [
    (r'([A-Z])Èo', r'\1 È o'),  # È o
    (r'([A-Z])a', r'\1 a'),     # a (articles)
    (r'([a-z])e([A-Z])', r'\1 e \2'),  # e (and)
]

for pattern, replacement in patterns:
    content = re.sub(pattern, replacement, content)

# Write back
with open(file_path, 'w', encoding='utf-16 le') as f:
    f.write(content)

print("File fixed with word spacing restored")
