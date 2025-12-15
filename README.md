# DayZ Server & Client Management Scripts

Scripts em Batch para automatizar o gerenciamento de servidor e cliente DayZ, incluindo criação de symlinks, compilação de mods, limpeza de logs e inicialização de processos.

---

## 📋 Requisitos

- **Windows 10/11** com privilégios de administrador
- **DayZ** instalado via Steam
- **DayZ Server** instalado via Steam
- **PboProject** (Mikero Tools) - para compilação de mods
- **PowerShell 5.1+** - para scripts .ps1

---

## 📁 Estrutura de Arquivos

```
DEPLOY/
├── Scripts/
│   ├── Build_PBO.bat          # Compila o mod local usando PboProject
│   ├── Build_PBO.ps1           # Versão PowerShell
│   ├── Create_Symlinks.bat     # Cria links simbólicos para mods
│   └── Create_Symlinks.ps1     # Versão PowerShell
├── Clean-Logs.bat              # Limpa logs do servidor e cliente
├── Get-Logs.bat                # Visualiza logs mais recentes
├── Kill-DayZ.bat               # Encerra processos do DayZ
├── Start-Client.bat            # Inicia cliente com mods
├── Start-Server.bat            # Inicia servidor DayZ
└── Start_Server.bat            # (alternativa)
```

---

## 🚀 Scripts Disponíveis

### 🔗 Create_Symlinks.bat
**Propósito:** Cria links simbólicos para mods do Workshop, perfis e mpmissions.

**Requer:** Executar como **ADMINISTRADOR**

**Configuração:**
```batch
set "Workshop=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"
set "Server=C:\Program Files (x86)\Steam\steamapps\common\DayZServer"
set "Profiles=D:\Dayz\Server\Profiles"
set "Mpmissions=D:\Dayz\Server\MpMissions"
set "LocalMod=D:\Dayz\Mods\Askal_MOD"
```

**O que faz:**
- Cria symlinks para todos os mods do Workshop
- Cria symlink para Profiles
- Cria symlink para MpMissions
- Cria symlink para mod local (@Askal_MOD)

**Uso:**
1. Clique com botão direito → **Executar como administrador**
2. O script criará todos os symlinks automaticamente
3. Symlinks já existentes serão preservados

---

### 🏗️ Build_PBO.bat / Build_PBO.ps1
**Propósito:** Compila o mod local usando PboProject (Mikero Tools).

**Configuração:**
```batch
set PboProjectPath="C:\Program Files (x86)\Mikero\DePboTools\bin\PboProject.exe"
set ModRootPath="P:\askal"
set ModDeployRoot="D:\Dayz\Mods\Askal_MOD"
set KeyPath="D:\Dayz\Keys\AsKal.bikey"
```

**O que faz:**
- Valida caminhos e ferramentas
- Limpa PBOs antigos
- Compila o mod com exclusões configuradas
- Assina PBOs com bikey (se configurado)

**Uso:**
```batch
Build_PBO.bat
```

---

### 🎮 Start-Server.bat
**Propósito:** Inicia o servidor DayZ com configuração completa.

**Parâmetros:**
- `-config=AskalServer.cfg` - Arquivo de configuração do servidor
- `-port=2302` - Porta do servidor
- `-cpuCount=4` - Número de núcleos CPU
- `-profiles=Profiles` - Diretório de perfis
- `-mod=...` - Lista de mods a carregar
- `-limitFPS=100` - Limite de FPS
- `-freezecheck` - Detecção de travamentos

**Uso:**
```batch
Start-Server.bat
```

---

### 🕹️ Start-Client.bat / Start_Client.bat
**Propósito:** Inicia o cliente DayZ com mods e conexão automática ao servidor local.

**Configuração:**
- Conecta automaticamente em `127.0.0.1:2302`
- Carrega mods: CF, Community-Online-Tools, JD's Animated Weapons, Mounts & Sights, Askal_MOD

**Uso:**
```batch
Start-Client.bat
```

**Ordem recomendada:**
1. Execute `Start-Server.bat` primeiro
2. Aguarde servidor iniciar (~30-60s)
3. Execute `Start-Client.bat`
4. Cliente conectará automaticamente

---

### 🧹 Clean-Logs.bat
**Propósito:** Remove logs antigos do servidor e cliente.

**O que remove:**
- `*.log` - Arquivos de log
- `*.RPT` - Relatórios de crash
- `*.mdmp` - Dumps de memória

**Locais:**
- Servidor: `C:\Program Files (x86)\Steam\steamapps\common\DayZServer\Config\`
- Cliente: `C:\Users\Rocha\AppData\Local\DayZ\`

**Uso:**
```batch
Clean-Logs.bat
```

---

### 📄 Get-Logs.bat
**Propósito:** Visualiza os logs mais recentes do servidor e cliente.

**O que exibe:**
- Lista todos arquivos `.log` disponíveis
- Mostra conteúdo completo do log mais recente de cada tipo
- Ordenado por data (mais recente primeiro)

**Locais pesquisados:**
- Servidor: `D:\Dayz\Server\Profiles\`
- Cliente: `C:\Users\Rocha\AppData\Local\DayZ\`

**Uso:**
```batch
Get-Logs.bat
```

---

### ❌ Kill-DayZ.bat
**Propósito:** Encerra todos os processos DayZ em execução.

**O que faz:**
- Mata processo `DayZServer_x64.exe` (servidor)
- Mata processo `DayZ_x64.exe` (cliente)
- Força encerramento com `/F`

**Uso:**
```batch
Kill-DayZ.bat
```

---

## 🔧 Configuração Inicial

### 1. Ajustar Caminhos
Edite os scripts para corresponder à sua instalação:

**Create_Symlinks.bat:**
```batch
set "Workshop=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"
set "Server=C:\Program Files (x86)\Steam\steamapps\common\DayZServer"
set "Profiles=D:\Dayz\Server\Profiles"
set "Mpmissions=D:\Dayz\Server\MpMissions"
set "LocalMod=D:\Dayz\Mods\Askal_MOD"
```

**Build_PBO.bat:**
```batch
set ModRootPath="P:\askal"              # Sua pasta de desenvolvimento
set ModDeployRoot="D:\Dayz\Mods\Askal_MOD"  # Destino compilado
set KeyPath="D:\Dayz\Keys\AsKal.bikey"      # Sua chave .bikey
```

### 2. Criar Symlinks (Primeira Vez)
Execute `Create_Symlinks.bat` como **administrador** antes de iniciar o servidor pela primeira vez.

### 3. Compilar Mod Local (Se Aplicável)
Se você desenvolve mods, compile-os primeiro:
```batch
Scripts\Build_PBO.bat
```

---

## 🎯 Fluxo de Trabalho Típico

### Desenvolvimento de Mod
```batch
1. Editar código-fonte em P:\askal
2. Scripts\Build_PBO.bat          # Compila o mod
3. Start-Server.bat                # Inicia servidor
4. Start-Client.bat                # Conecta cliente
5. Testar no jogo
6. Kill-DayZ.bat                   # Encerra tudo
7. Get-Logs.bat                    # Verificar erros
```

### Jogo Normal
```batch
1. Start-Server.bat
2. Start-Client.bat
3. [Jogar]
4. Kill-DayZ.bat
```

### Limpeza/Manutenção
```batch
Clean-Logs.bat                     # Remove logs antigos
Get-Logs.bat                       # Visualiza logs atuais
```

---

## 🧰 Extensão VS Code — Botões rápidos

A extensão adiciona botões na barra de status para executar os scripts locais em um terminal integrado. Cada botão executa diretamente o script correspondente na raiz do repositório:

-- **Build PBO:** `AUTORUN.ps1 -Action Build` (PowerShell)
-- **Start Server:** `AUTORUN.ps1 -Action Server` (PowerShell)
-- **Start Client:** `AUTORUN.ps1 -Action Client` (PowerShell)
-- **Kill DayZ:** `AUTORUN.ps1 -Action Kill` (PowerShell)
-- **Auto Test:** `AUTORUN.ps1 -Action Full` (PowerShell)
-- **Get Logs:** `AUTORUN.ps1 -Action GetLogs` (PowerShell)

> Observação: os botões executam os scripts usando o terminal integrado do VS Code (criado com `cwd` na raiz do workspace). Garanta que os caminhos nas variáveis do script estejam configurados para o seu ambiente.

Após reinstalar a extensão, execute `Developer: Reload Window` no Command Palette para garantir que a versão mais recente esteja ativa.

Nota sobre builds em loop e execuções duplicadas:
- A extensão previne execuções concorrentes do mesmo comando (um botão em execução não pode ser iniciado novamente até terminar).
- O processo de build também cria um arquivo de lock (`build.lock`) na raiz do repositório enquanto estiver em execução; se outro build for acionado enquanto um estiver ativo, o script detectará o lock e não iniciará um novo build.
- Se um build ficar travado por alguma razão, remova manualmente o arquivo `build.lock` na raiz do repositório para liberar a execução.

Notificações e feedback visual:
- A extensão exibe notificações do VS Code quando uma ação é iniciada e quando termina (sucesso/falha). Consulte o painel `Output → Askal` para ver a saída completa das execuções de PowerShell.
- O `AUTORUN.ps1` tenta exibir notificações do sistema (Toast) quando possível. Para notificações nativas no Windows instale o módulo PowerShell `BurntToast` (opcional). Se não estiver disponível, o script usa um balão de notificação via Windows Forms como fallback.

## ⚠️ Troubleshooting

### Symlinks não funcionam
- **Causa:** Falta de privilégios administrativos
- **Solução:** Clique direito → "Executar como administrador"

### Servidor não inicia
- **Causa:** Porta 2302 já em uso
- **Solução:** Execute `Kill-DayZ.bat` ou reinicie o PC

### Mods não carregam
- **Causa:** Symlinks não criados ou caminhos incorretos
- **Solução:** Recrie symlinks com `Create_Symlinks.bat`

### Cliente não conecta
- **Causa:** Servidor ainda não terminou de iniciar
- **Solução:** Aguarde ~60s após iniciar servidor, depois inicie cliente

### Build_PBO falha
- **Causa:** PboProject não instalado ou caminho incorreto
- **Solução:** Instale Mikero Tools e ajuste `$PboProjectPath`

### Logs não aparecem
- **Causa:** Caminhos diferentes ou servidor/cliente não rodou ainda
- **Solução:** Ajuste caminhos em `Get-Logs.bat` conforme sua instalação

---

## 📝 Notas Importantes

- **Privilégios Admin:** Symlinks requerem privilégios de administrador no Windows
- **Porta Firewall:** Libere porta 2302 TCP/UDP no firewall
- **Mod Order:** A ordem dos mods em `-mod=` pode ser importante
- **Backups:** Faça backup de `Profiles` e `MpMissions` regularmente
- **Logs:** Logs crescem rápido - limpe periodicamente com `Clean-Logs.bat`

---

## Contribuições

Encontrou um bug ou tem uma sugestão? Abra uma issue.

---

<!-- Publicação removida: este repositório e os scripts são para uso local. -->


## 📄 Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.

---

## 🔗 Links Úteis

- [DayZ Wiki](https://community.bistudio.com/wiki/DayZ)
- [DayZ Server Setup Guide](https://community.bistudio.com/wiki/DayZ:Server_Configuration)
- [Mikero Tools](https://mikero.bytex.digital/Downloads)
- [DayZ Modding Discord](https://discord.gg/dayzmods)

---

**Feito com ❤️ para a comunidade DayZ**
