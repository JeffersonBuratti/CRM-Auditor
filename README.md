# Plataforma de Auditoria Médica

Sistema completo para gestão de auditoria médica com suporte a múltiplos perfis de acesso.

## Tecnologias

- **Frontend**: React 18, Vite, TailwindCSS, TypeScript
- **Backend**: Node.js, Express, Prisma ORM, TypeScript
- **Banco de Dados**: PostgreSQL 16
- **Cache/Lock**: Redis
- **Infraestrutura**: Docker, Docker Compose

## Estrutura do Projeto

```
CRM Auditor/
├── backend/           # API REST (Express + Prisma)
│   ├── prisma/        # Schema e migrations
│   └── src/           # Código fonte
├── frontend/          # SPA (React + Vite)
│   └── src/           # Código fonte
├── database/          # Docker configs (Postgres + Redis)
│   └── scripts/       # Backup e restore
└── scripts/           # Scripts de inicialização
```

## Perfis de Acesso

| Role | Descrição |
|------|-----------|
| SUPER_ADMIN | Acesso total ao sistema |
| OWNER | Administrador da operação |
| ENFERMEIRO_AUDITOR | Triagem técnica de guias |
| MEDICO_AUDITOR | Parecer médico de guias |
| OPERADORA | Gestão da operadora |
| PRESTADOR | Consulta de guias emitidas |
| BENEFICIARIO | Acompanhamento de guias |

## Início Rápido

### Pré-requisitos

- Node.js 20+
- Docker e Docker Compose

### Instalação

```bash
# Instalar dependências do backend
cd backend && npm install

# Instalar dependências do frontend
cd frontend && npm install

# Dar permissão aos scripts
chmod +x scripts/*.sh database/scripts/*.sh
```

### Subir com Docker

```bash
./scripts/iniciar.sh
```

### Desenvolvimento Local

```bash
# Terminal 1 - Backend
cd backend && npm run dev

# Terminal 2 - Frontend
cd frontend && npm run dev
```

### Parar Serviços

```bash
./scripts/parar.sh
```

## Portas

| Serviço | Porta |
|---------|-------|
| Frontend | 3000 |
| Backend | 3001 |
| PostgreSQL | 5432 |
| Redis | 6379 |

## Migrations

```bash
cd backend
npx prisma migrate deploy
```
