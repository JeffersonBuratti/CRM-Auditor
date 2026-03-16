---
description: Regras globais do projeto Plataforma de Auditoria Médica
---

# Regras Globais do Projeto

## Estrutura e Modularidade
- Código sempre modular: arquivos orquestradores (index) atuam como ponto de entrada e importam arquivos menores
- Cada página e serviço deve ter seu próprio diretório dedicado
- Nenhum arquivo deve ultrapassar 200 linhas — quebrar em submódulos quando necessário
- Imports sempre no topo do arquivo, nunca no meio do código

## Idioma
- Nomes de variáveis, funções, tabelas e colunas em **pt-BR**
- Comentários em **pt-BR**
- Nomes de arquivos e diretórios em **pt-BR** (camelCase para arquivos, PascalCase para componentes React)

## Backend
- Node.js + Express + TypeScript
- Prisma ORM para acesso ao banco (PostgreSQL)
- Toda operação com side-effect (escrita, atualização, deleção) deve usar **Redis distributed lock** para prevenir condition racing
- Todo evento relevante no sistema deve gerar registro em `HistoricoEvento` (quem, quando, o que, detalhes)
- Validação de entrada com **Zod**
- Respostas da API sempre no formato padronizado: `{ sucesso: boolean, dados: T | null, erro: string | null, meta: object | null }`
- Cada módulo segue a estrutura: `index.ts` (router) → `controlador.ts` → `servico.ts` → `validacao.ts`
- Migrations são arquivos SQL manuais na pasta `prisma/migrations/`, aplicados via `npx prisma migrate deploy`
- Ao alterar o schema Prisma, sempre ler o schema completo e seus relacionamentos antes de modificar
- Ao gerar novos models, sempre criar um `migration.sql` na pasta adequada de migrações

## Frontend
- React 18 + Vite + React Router + TailwindCSS
- **Mobile-first**, responsivo para telas entre 720p e 1080p
- Suporte nativo a **tema claro e escuro**
- Componentes nativos sempre que possível, evitar dependências desnecessárias
- Compatível com Capacitor para PWA mobile (Android + iOS)
- Acessibilidade: aria-labels, suporte a narrador, contraste adequado
- White-label: logos, cores e imagens configuráveis via contexto de tema

## Docker
- Cada serviço com seu próprio `docker-compose.yml` separado
- Rede compartilhada: `auditoria-network` (external)
- Storage local com volumes Docker mapeados para persistência e fácil backup/migração
- Isso vale para PostgreSQL, Redis e uploads de arquivos

## Autenticação
- JWT com access token + refresh token
- Middleware de roles para controle de acesso por perfil
- Roles: SUPER_ADMIN, OWNER, ENFERMEIRO_AUDITOR, MEDICO_AUDITOR, OPERADORA, PRESTADOR, BENEFICIARIO

## Notificações
- Adapter pattern genérico para canais de notificação (email inicialmente)
- Owner configura quais tipos de eventos geram notificações

## Uploads
- Abordagem híbrida: upload de PDF/JPG + formulário de metadados estruturados
- Armazenamento em volume Docker local
