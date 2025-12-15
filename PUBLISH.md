# Como publicar manualmente no Visual Studio Marketplace

Este documento descreve os passos rápidos para enviar manualmente o arquivo `.vsix` ao Visual Studio Marketplace (útil se você preferir gerenciar a publicação manualmente).

Pré-requisitos
- Você deve ser owner do publisher `askal` no Marketplace: https://marketplace.visualstudio.com/manage/publishers/askal
- Tenha o arquivo `.vsix` pronto (ele está em `releases/askal-deploy-1.0.0.vsix` neste repositório).
- Recomenda-se ter uma conta do Azure DevOps e um PAT (se for usar upload via CLI), mas para upload manual via UI isso não é obrigatório.

Passo-a-passo (via interface web)
1. Acesse: https://marketplace.visualstudio.com/manage/publishers/askal
2. Clique em "New Extension" → "New Visual Studio Marketplace extension" (ou botão equivalente)
3. Em "Package type" escolha **VSIX** e selecione o arquivo `releases/askal-deploy-1.0.0.vsix` (arraste e solte ou selecione arquivo)
4. Preencha as informações requeridas (nome, descrição, versão, ícone, screenshots). A descrição pode ser copiada de `RELEASE_NOTES_v1.0.0.md`.
5. Configure visibilidade (Public/Private) e preço (se aplicável).
6. Revise e clique em **Publish**.

Dicas e pontos de atenção
- Verifique o campo `publisher` dentro de `extension/package.json` (deve ser `askal`) antes de publicar.
- Se a extensão já existir no publisher com o mesmo `name`/`publisher`/`version`, o Marketplace irá atualizar a versão.
- Em caso de erro, verifique os logs e mensagens retornadas pela interface — normalmente indicam problemas no `package.json` (metadados inválidos) ou assinatura do VSIX.

Upload via CLI (opcional)
- Instale `vsce` e publique usando um PAT com escopos adequados:
```bash
npm i -g vsce
vsce publish --pat <SEU_PAT>
```

Se quiser, eu posso criar o draft do Release no GitHub com o `.vsix` anexado (posso fazer se você me der permissão via `gh auth login` aí ou me fornecer token). Caso prefira fazer pela UI, tudo já está pronto — o arquivo VSIX está em `releases/askal-deploy-1.0.0.vsix`.
