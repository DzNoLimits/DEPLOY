#Requires -Version 5.1
<#
.SYNOPSIS
    Script de automacao completo para testes do mod Askal (DayZ)
.DESCRIPTION
    Build -> Kill -> Clean -> Start Server -> Monitor -> Start Client
.PARAMETER Action
    Ação a executar: Full (padrão), Build, Kill, Clean, Server, Monitor, Client, GetLogs
.EXAMPLE
    .\AUTORUN.ps1                  # Executa fluxo completo
    .\AUTORUN.ps1 -Action GetLogs  # Abre logs no VS Code
    .\AUTORUN.ps1 -Action Server   # Apenas inicia o servidor
    .\AUTORUN.ps1 -Action Client   # Apenas inicia o cliente
    .\AUTORUN.ps1 -Action Kill     # Apenas mata processos
#>
param(
    [ValidateSet('Full', 'Build', 'Kill', 'Clean', 'Server', 'Monitor', 'Client', 'GetLogs')]
    [string]$Action = 'Full'
)

# Configurações
$Config = @{
    ServerProfilesPath = "D:\Dayz\Server\Profiles"
    ServerCrashLogPath = "C:\Program Files (x86)\Steam\steamapps\common\DayZServer\Profiles"
    ClientProfilesPath = "C:\Program Files (x86)\Steam\steamapps\common\DayZ\Profiles"
    ServerExe = "C:\Program Files (x86)\Steam\steamapps\common\DayZServer\DayZServer_x64.exe"
    ClientExe = "C:\Program Files (x86)\Steam\steamapps\common\DayZ\DayZ_BE.exe"
    PboProject = "C:\Program Files (x86)\Mikero\DePboTools\bin\PboProject.exe"
    ModSource = "P:\askal"
    ModDeploy = "D:\Dayz\Mods\Askal_MOD"
    MonitorTimeout = 15
}

# Função: Kill DayZ Processes
function Stop-DayZProcesses {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "KILL - Encerrando processos DayZ" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    $processes = @('DayZServer_x64', 'DayZ_x64')
    foreach ($proc in $processes) {
        $running = Get-Process -Name $proc -ErrorAction SilentlyContinue
        if ($running) {
            Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
            Write-Host "  [OK] $proc encerrado" -ForegroundColor Green
        } else {
            Write-Host "  [INFO] $proc não estava rodando" -ForegroundColor Gray
        }
    }
    Start-Sleep -Seconds 2
}

# Notifications removed: keep console/log output only

# Função: Clean Logs
function Clear-DayZLogs {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "CLEAN - Limpando logs" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    $paths = @($Config.ServerProfilesPath, $Config.ServerCrashLogPath, $Config.ClientProfilesPath)
    $extensions = @('*.log', '*.rpt', '*.mdmp', '*.adm')
    
    # Deleta logs
    Write-Host "  Deletando logs..." -ForegroundColor Gray
    foreach ($path in $paths) {
        if (Test-Path $path) {
            foreach ($ext in $extensions) {
                Get-ChildItem -Path $path -Filter $ext -Recurse -ErrorAction SilentlyContinue | 
                    Remove-Item -Force -ErrorAction SilentlyContinue
            }
        }
    }
    
    Write-Host "  [OK] Todos os logs limpos" -ForegroundColor Green
}

# Função: Build PBO
function Build-PBO {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "BUILD - Compilando mod" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    $lockFile = Join-Path $PSScriptRoot 'build.lock'

    if (Test-Path $lockFile) {
        Write-Host "  [INFO] Build já está em execução (lockfile encontrado). Saindo." -ForegroundColor Yellow
        return $true
    }

    if (-not (Test-Path $Config.PboProject)) {
        Write-Host "  [ERRO] PboProject.exe não encontrado" -ForegroundColor Red
        return $false
    }
    
    if (-not (Test-Path $Config.ModSource)) {
        Write-Host "  [ERRO] Pasta do mod não encontrada" -ForegroundColor Red
        return $false
    }
    
    # Limpa PBOs antigos
    $addonsPath = Join-Path $Config.ModDeploy "addons"
    if (Test-Path $addonsPath) {
        Remove-Item "$addonsPath\*.pbo*" -Force -ErrorAction SilentlyContinue
    }
    
    # Compila
    $args = "+P +E=dayz +X=*.h,*.hpp,*.png,*.cpp,*.txt,thumbs.db,*.dep,*.bak,*.log +M=`"$($Config.ModDeploy)`" `"$($Config.ModSource)`""

    try {
        New-Item -Path $lockFile -ItemType File -Force | Out-Null
        Write-Host "  [INFO] Build iniciado" -ForegroundColor Cyan

        $process = Start-Process -FilePath $Config.PboProject -ArgumentList $args -Wait -PassThru -NoNewWindow

        if ($process.ExitCode -eq 0) {
            Write-Host "`n  [OK] Build completado com sucesso" -ForegroundColor Green
            Write-Host "  [INFO] Build completed successfully" -ForegroundColor Green
            return $true
        } else {
            Write-Host "`n  [ERRO] Build falhou (Exit Code: $($process.ExitCode))" -ForegroundColor Red
            Write-Host "  [ERROR] Build failed (Exit Code: $($process.ExitCode))" -ForegroundColor Red
            return $false
        }
    } finally {
        if (Test-Path $lockFile) { Remove-Item $lockFile -Force -ErrorAction SilentlyContinue }
    }
}

# Função: Start Server
function Start-DayZServer {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "SERVER - Iniciando servidor" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    $serverPath = "C:\Program Files (x86)\Steam\steamapps\common\DayZServer"
    
    $arguments = '-config=AskalServer.cfg ip=127.0.0.1 -port=2302 -cpuCount=4 "-profiles=Profiles" -name="Dayz Server" "-mod=@CF;@Community-Online-Tools;@JD''s Animated Weapons;@Mounts & Sights;@Askal_MOD;" -limitFPS=100 -freezecheck'
    
    Start-Process -FilePath $Config.ServerExe -ArgumentList $arguments -WorkingDirectory $serverPath
    
    Write-Host "  [OK] Servidor iniciado" -ForegroundColor Green
}

# Função: Monitor Logs
function Watch-ServerLogs {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "MONITOR - Aguardando script.log..." -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    # Aguarda criação do script.log
    $scriptLog = $null
    $maxWait = 30
    $waited = 0
    
    while ($waited -lt $maxWait) {
        $scriptLog = Get-ChildItem -Path $Config.ServerProfilesPath -Filter "script_*.log" -ErrorAction SilentlyContinue | 
                     Sort-Object LastWriteTime -Descending | 
                     Select-Object -First 1
        
        if ($scriptLog) {
            Write-Host "  [OK] Log encontrado: $($scriptLog.Name)" -ForegroundColor Green
            break
        }
        
        Start-Sleep -Seconds 1
        $waited++
    }
    
    if (-not $scriptLog) {
        Write-Host "  [ERRO] script.log não foi criado em $maxWait segundos" -ForegroundColor Red
        return $false
    }
    
    # Monitora por erros
    Write-Host "`n  Monitorando por erros (timeout: $($Config.MonitorTimeout)s)..." -ForegroundColor Yellow
    
    $lastSize = 0
    $noChangeCount = 0
    $maxNoChange = $Config.MonitorTimeout
    
    while ($noChangeCount -lt $maxNoChange) {
        Start-Sleep -Seconds 1
        
        # Verifica crash
        $crashLog = Get-ChildItem -Path $Config.ServerCrashLogPath -Filter "crash_*.log" -ErrorAction SilentlyContinue |
                    Sort-Object LastWriteTime -Descending |
                    Select-Object -First 1
        
        if ($crashLog) {
            Write-Host "`n========================================" -ForegroundColor Red
            Write-Host "CRASH DETECTADO!" -ForegroundColor Red
            Write-Host "========================================`n" -ForegroundColor Red
            Write-Host "Abrindo log: $($crashLog.FullName)" -ForegroundColor Yellow
            
            # Abre o log de crash no VS Code
            code $crashLog.FullName
            
            # Mata o servidor
            Write-Host "`nEncerrando servidor..." -ForegroundColor Yellow
            Stop-Process -Name "DayZServer_x64" -Force -ErrorAction SilentlyContinue
            
            return $false
        }
        
        # Verifica erros no script.log
        $scriptLog.Refresh()
        $currentSize = $scriptLog.Length
        
        if ($currentSize -gt $lastSize) {
            $content = Get-Content $scriptLog.FullName -Tail 50 -ErrorAction SilentlyContinue
            $errorLines = $content | Where-Object { $_ -match '\(E\)' }
            
            if ($errorLines) {
                Write-Host "`n========================================" -ForegroundColor Red
                Write-Host "ERRO DETECTADO NO SCRIPT!" -ForegroundColor Red
                Write-Host "========================================`n" -ForegroundColor Red
                $errorLines | ForEach-Object { Write-Host $_ -ForegroundColor Red }
                Write-Host "`nLog: $($scriptLog.FullName)" -ForegroundColor Yellow
                return $false
            }
            
            $lastSize = $currentSize
            $noChangeCount = 0
        } else {
            $noChangeCount++
        }
    }
    
    Write-Host "`n  [OK] Servidor estável - sem erros detectados" -ForegroundColor Green
    return $true
}

# Função: Start Client
function Start-DayZClient {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "CLIENT - Iniciando cliente" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    $clientPath = "C:\Program Files (x86)\Steam\steamapps\common\DayZ"
    
    $arguments = '-connect=127.0.0.1:2302 "-mod=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop\@CF;C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop\@Community-Online-Tools;C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop\@JD''s Animated Weapons;C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop\@Mounts & Sights;D:\Dayz\Mods\Askal_MOD"'
    
    Start-Process -FilePath $Config.ClientExe -ArgumentList $arguments -WorkingDirectory $clientPath
    
    Write-Host "  [OK] Cliente iniciado" -ForegroundColor Green
}

# Função: Get Logs
function Get-DayZLogs {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "GET-LOGS - Abrindo logs" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    $ServerLogsPath = "D:\Dayz\Server\Profiles"
    $ClientLogsPath = "$env:LOCALAPPDATA\DayZ"
    
    $logsOpened = 0
    
    # Abre logs do servidor
    Write-Host "[SERVIDOR] Abrindo logs de $ServerLogsPath" -ForegroundColor Yellow
    $serverLogs = Get-ChildItem -Path $ServerLogsPath -Filter "script_*.log" -ErrorAction SilentlyContinue |
                  Sort-Object LastWriteTime -Descending |
                  Select-Object -First 1
    
    if ($serverLogs) {
        foreach ($log in $serverLogs) {
            Write-Host "  → $($log.Name)" -ForegroundColor Green
            & code $log.FullName
            $logsOpened++
        }
    } else {
        Write-Host "  ⚠ Nenhum log encontrado" -ForegroundColor Yellow
    }
    
    # Abre logs do cliente
    Write-Host "`n[CLIENTE] Abrindo logs de $ClientLogsPath" -ForegroundColor Yellow
    $clientLogs = Get-ChildItem -Path $ClientLogsPath -Filter "script_*.log" -ErrorAction SilentlyContinue |
                  Sort-Object LastWriteTime -Descending |
                  Select-Object -First 1
    
    if ($clientLogs) {
        foreach ($log in $clientLogs) {
            Write-Host "  → $($log.Name)" -ForegroundColor Green
            & code $log.FullName
            $logsOpened++
        }
    } else {
        Write-Host "  ⚠ Nenhum log encontrado" -ForegroundColor Yellow
        
        # Tenta alternativa
        Write-Host "  Tentando em $env:APPDATA\DayZ..." -ForegroundColor Gray
        $clientLogs = Get-ChildItem -Path "$env:APPDATA\DayZ" -Filter "script_*.log" -ErrorAction SilentlyContinue |
                      Sort-Object LastWriteTime -Descending |
                      Select-Object -First 2
        
        if ($clientLogs) {
            foreach ($log in $clientLogs) {
                Write-Host "  → $($log.Name)" -ForegroundColor Green
                & code $log.FullName
                $logsOpened++
            }
        }
    }
    
    Write-Host "`n[OK] $logsOpened logs abertos no VS Code" -ForegroundColor Green
}

# MAIN EXECUTION
try {
    Write-Host "`n========================================" -ForegroundColor Magenta
    Write-Host "ASKAL DEPLOY - $Action" -ForegroundColor Magenta
    Write-Host "========================================`n" -ForegroundColor Magenta
    
    switch ($Action) {
        'GetLogs' {
            Get-DayZLogs
        }
        
        'Kill' {
            Stop-DayZProcesses
        }
        
        'Clean' {
            Clear-DayZLogs
        }
        
        'Build' {
            if (-not (Build-PBO)) {
                throw "Build falhou"
            }
        }
        
        'Server' {
            Start-DayZServer
        }
        
        'Monitor' {
            $serverOk = Watch-ServerLogs
            if (-not $serverOk) {
                throw "Monitor falhou - erro/crash detectado"
            }
        }
        
        'Client' {
            Start-DayZClient
        }
        
        'Full' {
            # 1. Kill
            Stop-DayZProcesses
            
            # 2. Clean
            Clear-DayZLogs
            
            # 3. Build
            if (-not (Build-PBO)) {
                throw "Build falhou"
            }
            
            # 4. Start Server
            Start-DayZServer
            Start-Sleep -Seconds 3
            
            # 5. Monitor
            $serverOk = Watch-ServerLogs
            
            # 6. Start Client (se servidor OK)
            if ($serverOk) {
                Start-DayZClient
                Write-Host "`n========================================" -ForegroundColor Green
                Write-Host "TESTE CONCLUIDO COM SUCESSO" -ForegroundColor Green
                Write-Host "========================================`n" -ForegroundColor Green
                exit 0
            } else {
                throw "Servidor com erro/crash"
            }
        }
    }
    
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "ACAO CONCLUIDA COM SUCESSO" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Green
    exit 0
    
} catch {
    Write-Host "`n[ERRO] $_" -ForegroundColor Red
    exit 1
} finally {
    # Aguarda 3 segundos antes de fechar o terminal
    Start-Sleep -Seconds 3
}
