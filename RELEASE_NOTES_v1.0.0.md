# Release v1.0.0 — Askal Dev. Tool

## Resumo
Lançamento inicial da extensão "Askal Dev. Tool" — um conjunto simples de ferramentas para automatizar o setup, deploy e testes do mod Askal para DayZ. A extensão inclui comandos para criar symlinks, iniciar/encerrar servidor e cliente, empacotar PBOs e visualizar/limpar logs.

## O que há de novo
- Primeira versão pública (`v1.0.0`) com:
  - Scripts .bat e .ps1 para gerenciamento do servidor/cliente DayZ
  - Empacotador PBO (`Build_PBO`) para desenvolvedores de mod
  - Criação automática de symlinks e gerenciamento de profiles/mpmissions
  - `Get-Logs` e `Clean-Logs` para diagnóstico rápido
  - Workflow de publicação (GitHub Actions) para publicar no Marketplace

## Instalação local (teste do VSIX)
Se quiser testar imediatamente, instale o arquivo `.vsix` localmente:

```bash
# no terminal
code --install-extension extension/askal-deploy-1.0.0.vsix
```

## Publicação no Marketplace (passos rápidos)
1. Certifique-se de que o segredo `VSCE_TOKEN` está configurado em `Settings → Secrets and variables → Actions` no repositório.
2. Crie a tag `v1.0.0` (já criada) e faça push (já feito). Isso dispara o workflow `publish-extension.yml`.
3. O workflow usará `VSCE_TOKEN` para publicar automaticamente se tudo estiver configurado corretamente.

## Backup (release no GitHub)
Se preferir publicar manualmente ou ter um backup, crie um release no GitHub e anexe o arquivo:
- `extension/askal-deploy-1.0.0.vsix`

### Criar release (interface web)
1. Vá em **Releases → Draft a new release** no repositório
2. Tag version: `v1.0.0` (já criada)
3. Title: `v1.0.0`
4. Cole estas notas na descrição
5. Upload do asset: selecione `extension/askal-deploy-1.0.0.vsix`
6. Publish release

### Criar release via API (opcional)
Se preferir usar a API/CLI e tiver um token com permissão, avise que eu passo o comando pronto.

## Observações
- Verifique se o `publisher` em `extension/package.json` está correto (`askal-dev-tool`).
- Se o publish falhar, verifique o log da Action em **Actions → publish → run** para mensagens de erro.
- Se precisar, eu posso criar o release draft por você (eu preciso do `gh` ou permissões/command-line do GitHub). Caso prefira que eu faça via UI, posso gerar a descrição pronta (já aqui) para colar.

---

Obrigado por criar o publisher — diga se quer que eu crie o release draft agora (eu não tenho `gh` instalado aqui) ou se você prefere colar esse texto no formulário da interface do GitHub.