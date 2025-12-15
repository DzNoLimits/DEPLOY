# 🚀 Quickstart Guide - DayZ Server Scripts

Guia rápido para começar a usar os scripts em **5 minutos**!

---

## ⚡ Setup Rápido

### 1️⃣ Pré-requisitos (2 min)
Certifique-se que tem instalado:
- ✅ Windows 10/11
- ✅ DayZ (Steam)
- ✅ DayZ Server (Steam)
- ✅ Privilégios de Administrador

### 2️⃣ Clone/Download (30 seg)
```powershell
git clone https://github.com/yourusername/dayz-scripts.git
cd dayz-scripts
```

Ou baixe o [ZIP](https://github.com/yourusername/dayz-scripts/archive/main.zip) e extraia.

### 3️⃣ Configure Caminhos (1 min)
Edite `Create_Symlinks.bat` com seus caminhos:
```batch
set "Workshop=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"
set "Server=C:\Program Files (x86)\Steam\steamapps\common\DayZServer"
set "Profiles=D:\Dayz\Server\Profiles"
set "Mpmissions=D:\Dayz\Server\MpMissions"
set "LocalMod=D:\Dayz\Mods\Askal_MOD"
```

### 4️⃣ Crie Symlinks (30 seg)
**Clique direito** em `Create_Symlinks.bat` → **Executar como administrador**

Você verá:
```
========================================
Criando Symlinks para DayZ Server
========================================

[1/4] Criando symlinks para mods...
  Criado: @CF
  Criado: @Community-Online-Tools
  ...

[2/4] Criando symlink para Profiles...
  Criado: Profiles

[3/4] Criando symlink para MpMissions...
  Criado: MpMissions

[4/4] Criando symlink para mod local...
  Criado: @Askal_MOD

========================================
FINALIZADO!
========================================
```

### 5️⃣ Inicie o Servidor (10 seg)
Duplo clique em `Start-Server.bat`

Aguarde ~30-60 segundos até ver:
```
Server is ready
```

### 6️⃣ Conecte o Cliente (10 seg)
Duplo clique em `Start-Client.bat`

O cliente abrirá e conectará automaticamente!

---

## 🎮 Uso Básico

### Iniciar Tudo
```batch
1. Start-Server.bat       # Inicia servidor
2. Start-Client.bat       # Inicia cliente (auto-conecta)
```

### Parar Tudo
```batch
Kill-DayZ.bat            # Mata servidor + cliente
```

### Ver Logs
```batch
Get-Logs.bat             # Mostra logs mais recentes
```

### Limpar Logs
```batch
Clean-Logs.bat           # Remove logs antigos
```

---

## 🔧 Comandos Úteis

### Workflow Completo (Dev)
```batch
# 1. Limpar ambiente
Kill-DayZ.bat
Clean-Logs.bat

# 2. (Se modificou mod) Compilar
Scripts\Build_PBO.bat

# 3. Iniciar servidor
Start-Server.bat

# 4. Aguardar 60s, depois iniciar cliente
Start-Client.bat

# 5. Jogar/Testar

# 6. Verificar logs
Get-Logs.bat
```

### Apenas Jogar
```batch
Start-Server.bat    # Espere 60s
Start-Client.bat    # Jogue!
Kill-DayZ.bat       # Feche tudo
```

---

## ⚠️ Troubleshooting Rápido

### ❌ "ERRO: Execute como ADMINISTRADOR!"
**Solução:** Clique direito → "Executar como administrador"

### ❌ Cliente não conecta
**Solução:** 
1. Aguarde servidor completar inicialização (~60s)
2. Verifique se porta 2302 está livre: `netstat -an | findstr 2302`

### ❌ Mods não carregam
**Solução:**
1. Recrie symlinks: Execute `Create_Symlinks.bat` como admin
2. Verifique caminhos em `Start-Server.bat` e `Start-Client.bat`

### ❌ Servidor trava/fecha
**Solução:**
1. Execute `Get-Logs.bat` para ver erro
2. Verifique arquivo `.RPT` em `D:\Dayz\Server\Profiles`

---

## 📁 Estrutura de Arquivos

```
dayz-scripts/
│
├── 📜 Scripts principais
│   ├── Create_Symlinks.bat    ⭐ Criar links (ADMIN)
│   ├── Start-Server.bat       ⭐ Iniciar servidor
│   ├── Start-Client.bat       ⭐ Iniciar cliente
│   ├── Kill-DayZ.bat          🛑 Parar tudo
│   ├── Get-Logs.bat           📄 Ver logs
│   └── Clean-Logs.bat         🧹 Limpar logs
│
├── 📂 Scripts/
│   ├── Build_PBO.bat          🔨 Compilar mods
│   ├── Build_PBO.ps1
│   ├── Create_Symlinks.ps1
│   └── ...
│
└── 📚 Documentação
    ├── README.md              📖 Documentação completa
    ├── QUICKSTART.md          ⚡ Este guia
    ├── TODO.md                📋 Roadmap
    ├── CHANGELOG.md           📝 Histórico
    ├── CONTRIBUTING.md        🤝 Como contribuir
    └── LICENSE                ⚖️ Licença MIT
```

---

## 🎯 Próximos Passos

Agora que está funcionando:

1. **Customize** → Edite parâmetros em `Start-Server.bat`
2. **Adicione Mods** → Coloque em `!Workshop` e recrie symlinks
3. **Desenvolva** → Use `Build_PBO.bat` para compilar seus mods
4. **Contribua** → Veja [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 🆘 Ajuda

- 📖 **Documentação completa:** [README.md](README.md)
- 🐛 **Problemas:** [Abra uma issue](https://github.com/yourusername/dayz-scripts/issues)
- 💬 **Dúvidas:** [Discussions](https://github.com/yourusername/dayz-scripts/discussions)

---

**Divirta-se! 🎮**
