# Security Policy

## Supported Versions

Apenas a versão mais recente é oficialmente suportada com atualizações de segurança.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

---

## Reporting a Vulnerability

### ⚠️ NÃO crie Issues públicas para vulnerabilidades de segurança!

Se você descobrir uma vulnerabilidade de segurança, por favor:

1. **Envie um email para:** [seu-email@exemplo.com]
2. **Inclua:**
   - Descrição detalhada da vulnerabilidade
   - Passos para reproduzir
   - Impacto potencial
   - Sugestões de correção (se tiver)

### O que esperar

- **Resposta inicial:** Dentro de 48 horas
- **Confirmação:** Dentro de 1 semana
- **Correção:** Dependendo da severidade (crítico: 24-72h, alto: 1-2 semanas)
- **Divulgação:** Apenas após correção e release

---

## Considerações de Segurança

### ⚠️ Riscos Conhecidos

Este projeto lida com:
- **Execução de comandos do sistema** - Scripts podem executar comandos arbitrários
- **Privilégios administrativos** - Alguns scripts requerem admin
- **Acesso ao sistema de arquivos** - Manipulação de symlinks e arquivos

### 🛡️ Melhores Práticas

#### Para Usuários
1. **Sempre revise scripts antes de executar**
   - Abra arquivos .bat/.ps1 em um editor de texto
   - Verifique comandos suspeitos
   - Confirme caminhos de arquivos

2. **Execute apenas como admin quando necessário**
   - Symlinks: SIM
   - Visualização de logs: NÃO
   - Kill processes: NÃO

3. **Valide caminhos de configuração**
   - Não use caminhos de rede não confiáveis
   - Evite compartilhamentos SMB públicos
   - Proteja diretórios com permissões adequadas

4. **Backup antes de usar**
   - Faça backup de Profiles e MpMissions
   - Preserve configs importantes
   - Teste em ambiente não-produção primeiro

#### Para Desenvolvedores
1. **Validação de entrada**
   ```batch
   if not exist "%Path%" (
       echo ERRO: Caminho invalido
       exit /b 1
   )
   ```

2. **Escape de variáveis**
   ```batch
   set "SafePath=%Path%"
   # Sempre use aspas em caminhos
   ```

3. **Verificação de privilégios**
   ```batch
   net session >nul 2>&1
   if %errorlevel% neq 0 (
       echo Requer admin!
       exit /b 1
   )
   ```

4. **Sanitização de comandos**
   - Nunca concatene input do usuário em comandos
   - Use variáveis em vez de eval/invoke
   - Valide extensões de arquivo

---

## Vetores de Ataque Potenciais

### Path Traversal
**Risco:** Manipulação de caminhos para acessar arquivos fora do escopo
**Mitigação:**
```batch
REM Validar que caminho está dentro do esperado
if not "%Path:~0,8%"=="D:\Dayz\" (
    echo Path invalido!
    exit /b 1
)
```

### Command Injection
**Risco:** Injeção de comandos via variáveis não sanitizadas
**Mitigação:**
- Usar aspas em todas as variáveis
- Evitar `%input%` diretamente em comandos
- Validar formato esperado

### Privilege Escalation
**Risco:** Scripts com admin executando código malicioso
**Mitigação:**
- Minimizar uso de admin
- Validar origem de arquivos executados
- Logar todas operações privilegiadas

### Symlink Attacks
**Risco:** Symlinks apontando para locais maliciosos
**Mitigação:**
```batch
REM Verificar target antes de criar symlink
if not exist "%Target%" (
    echo Target nao existe!
    exit /b 1
)

REM Verificar que target é diretório legítimo
if not exist "%Target%\*.pbo" (
    echo Target nao parece ser pasta de mod!
    exit /b 1
)
```

---

## Auditoria de Código

### Checklist de Segurança
- [ ] Validação de todos os inputs
- [ ] Escape correto de variáveis
- [ ] Verificação de privilégios mínimos
- [ ] Sem hardcoded credentials
- [ ] Paths relativos evitados
- [ ] Error handling adequado
- [ ] Logs não expõem informações sensíveis

### Ferramentas Recomendadas
- **ShellCheck** - Análise estática de shell scripts
- **PSScriptAnalyzer** - Linter para PowerShell
- **Manual Review** - Sempre essencial!

---

## Responsabilidade do Usuário

⚠️ **IMPORTANTE:**
- Você é responsável por revisar código antes de executar
- Scripts de terceiros podem ser maliciosos
- Sempre faça backup antes de usar scripts desconhecidos
- Mantenha antivírus atualizado
- Use em ambiente controlado primeiro

---

## Atualizações de Segurança

Patches de segurança serão:
1. Desenvolvidos em privado
2. Testados extensivamente
3. Released com nota de security advisory
4. Documentados no CHANGELOG.md

---

## Contato

**Email de Segurança:** [security@exemplo.com]

Por favor, use criptografia PGP se possível:
```
[Sua chave PGP pública aqui]
```

---

**Última atualização:** 15 de Dezembro de 2025
