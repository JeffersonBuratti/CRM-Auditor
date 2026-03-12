# Plataforma de Auditoria Médica — Plano Arquitetural

Plano completo para construção de uma plataforma white-label de gestão de auditorias médicas em conformidade com a ANS, com frontend React + Vite, backend Node.js + Prisma + Redis, PostgreSQL, tudo dockerizado com volumes locais.

---

## 1. Decisões Técnicas Consolidadas


| Aspecto            | Decisão                                                                                                  |
| ------------------ | --------------------------------------------------------------------------------------------------------- |
| **Frontend**       | React 18 + Vite + React Router + TailwindCSS + Capacitor-ready                                            |
| **Backend**        | Node.js + Express + Prisma ORM + Redis (Bull/BullMQ para filas)                                           |
| **Banco**          | PostgreSQL 16                                                                                             |
| **Cache/Locks**    | Redis 7 (condition racing prevention via distributed locks)                                               |
| **Auth**           | JWT (access + refresh token)                                                                              |
| **Storage**        | Volume Docker local (uploads, contratos, laudos)                                                          |
| **Email**          | Adapter pattern genérico (SMTP/SES/SendGrid plug-and-play)                                               |
| **Guias**          | Híbrido: upload PDF/JPG + formulário de metadados estruturados. TISS XML como feature futura ou não kk |
| **Idioma código** | pt-BR (variáveis, tabelas, comentários)                                                                 |
| **Repos**          | Separados — cada pasta com seu`package.json`                                                             |
| **Docker**         | docker-compose separado por serviço (front, back, db, redis)                                             |
| **White-label**    | Tema customizável (logos, cores, imagens) via configuração por ambiente                                |

---

## 2. Perfis de Acesso (Roles)


| Role                 | Descrição                                                                                                                                                                                      |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `SUPER_ADMIN`        | Dev/suporte técnico da plataforma. Acesso total, manutenção, config global                                                                                                                    |
| `OWNER`              | Dono da empresa de auditoria. Gerencia operadoras, auditores, fluxos, relatórios. Orquestra o fluxo: recebe guias da operadora, libera para triagem e dá a palavra final após parecer médico |
| `ENFERMEIRO_AUDITOR` | Realiza triagem técnico-administrativa: confere documentação, códigos TUSS, elegibilidade, duplicidades, compatibilidade CID/procedimento                                                    |
| `MEDICO_AUDITOR`     | Realiza análise clínica: necessidade médica, pertinência, proporcionalidade. Emite parecer                                                                                                   |
| `OPERADORA`          | Cliente do Owner. Envia guias, recebe pareceres finais, corrige pendências quando solicitado                                                                                                    |
| `PRESTADOR`          | Hospital/clínica/laboratório onde o procedimento ocorre. Login próprio para consultar guias emitidas para ele, acompanhar status, responder solicitações de documentação complementar |
| `BENEFICIARIO`       | Paciente envolvido. Acesso restrito ao que lhe diz respeito + notificações                                                                                                                     |

---

## 3. Estrutura de Diretórios

### 3.1 Frontend (`/frontend`)

```
frontend/
├── docker-compose.yml
├── Dockerfile
├── package.json
├── vite.config.ts
├── tailwind.config.ts
├── capacitor.config.ts
├── index.html
├── public/
│   └── assets/              # logos, favicons (white-label)
└── src/
    ├── main.tsx
    ├── App.tsx
    ├── routes/
    │   └── index.tsx         # orquestrador de rotas
    ├── config/
    │   ├── tema.ts           # cores, fontes (white-label)
    │   ├── api.ts            # base URLs
    │   └── constantes.ts
    ├── contexts/
    │   ├── AuthContext.tsx
    │   ├── TemaContext.tsx
    │   └── NotificacaoContext.tsx
    ├── hooks/
    │   ├── useAuth.ts
    │   ├── useTema.ts
    │   └── useApi.ts
    ├── layouts/
    │   ├── LayoutPrincipal/
    │   │   ├── index.tsx
    │   │   ├── Sidebar.tsx
    │   │   ├── Header.tsx
    │   │   └── Footer.tsx
    │   └── LayoutPublico/
    │       └── index.tsx
    ├── paginas/
    │   ├── Login/
    │   │   ├── index.tsx
    │   │   └── FormLogin.tsx
    │   ├── Dashboard/
    │   │   ├── index.tsx
    │   │   ├── CardResumo.tsx
    │   │   └── GraficoSLA.tsx
    │   ├── Operadoras/
    │   │   ├── index.tsx
    │   │   ├── ListaOperadoras.tsx
    │   │   ├── FormOperadora.tsx
    │   │   └── DetalhesOperadora.tsx
    │   ├── Guias/
    │   │   ├── index.tsx
    │   │   ├── ListaGuias.tsx
    │   │   ├── FormGuia.tsx
    │   │   ├── DetalhesGuia.tsx
    │   │   └── LinhaDoTempo.tsx
    │   ├── Triagem/
    │   │   ├── index.tsx
    │   │   ├── ListaTriagens.tsx
    │   │   ├── FormTriagem.tsx
    │   │   └── DetalhesTriagem.tsx
    │   ├── Pareceres/
    │   │   ├── index.tsx
    │   │   ├── FormParecer.tsx
    │   │   └── ListaPareceres.tsx
    │   ├── Prestadores/
    │   │   ├── index.tsx
    │   │   ├── ListaPrestadores.tsx
    │   │   ├── FormPrestador.tsx
    │   │   └── DetalhesPrestador.tsx
    │   ├── Beneficiarios/
    │   │   ├── index.tsx
    │   │   ├── ListaBeneficiarios.tsx
    │   │   ├── FormBeneficiario.tsx
    │   │   └── HistoricoBeneficiario.tsx
    │   ├── Usuarios/
    │   │   ├── index.tsx
    │   │   └── FormUsuario.tsx
    │   ├── Relatorios/
    │   │   ├── index.tsx
    │   │   ├── RelatorioSLA.tsx
    │   │   ├── RelatorioBeneficiario.tsx
    │   │   └── RelatorioAuditor.tsx
    │   ├── Notificacoes/
    │   │   ├── index.tsx
    │   │   └── ConfigNotificacoes.tsx
    │   └── Configuracoes/
    │       ├── index.tsx
    │       └── WhiteLabel.tsx
    ├── componentes/
    │   ├── ui/               # botões, inputs, modais, cards, tabelas
    │   │   ├── Botao.tsx
    │   │   ├── Input.tsx
    │   │   ├── Modal.tsx
    │   │   ├── Tabela.tsx
    │   │   ├── Badge.tsx
    │   │   └── Upload.tsx
    │   ├── LinhaDoTempo.tsx
    │   ├── SeletorTema.tsx
    │   └── AcessibilidadeBar.tsx
    ├── servicos/
    │   ├── api.ts            # axios/fetch wrapper
    │   ├── authServico.ts
    │   ├── guiaServico.ts
    │   ├── triagemServico.ts
    │   ├── operadoraServico.ts
    │   ├── prestadorServico.ts
    │   └── notificacaoServico.ts
    ├── tipos/
    │   ├── usuario.ts
    │   ├── guia.ts
    │   ├── triagem.ts
    │   ├── parecer.ts
    │   ├── operadora.ts
    │   ├── prestador.ts
    │   └── beneficiario.ts
    ├── utils/
    │   ├── formatadores.ts
    │   ├── validadores.ts
    │   └── acessibilidade.ts
    └── estilos/
        └── global.css
```

### 3.2 Backend (`/backend`)

```
backend/
├── docker-compose.yml
├── Dockerfile
├── package.json
├── tsconfig.json
├── .env.example
└── src/
    ├── index.ts              # entrada, orquestrador principal
    ├── servidor.ts           # config express
    ├── config/
    │   ├── ambiente.ts       # env vars
    │   ├── redis.ts
    │   ├── prisma.ts
    │   └── upload.ts         # multer config, caminhos de storage
    ├── middlewares/
    │   ├── autenticacao.ts   # JWT verify
    │   ├── autorizacao.ts    # role-based access
    │   ├── validacao.ts      # zod/joi schemas
    │   ├── rateLimiter.ts
    │   └── tratamentoErros.ts
    ├── modulos/
    │   ├── auth/
    │   │   ├── index.ts      # orquestrador (router)
    │   │   ├── authControlador.ts
    │   │   ├── authServico.ts
    │   │   ├── authValidacao.ts
    │   │   └── authTipos.ts
    │   ├── usuarios/
    │   │   ├── index.ts
    │   │   ├── usuarioControlador.ts
    │   │   ├── usuarioServico.ts
    │   │   └── usuarioValidacao.ts
    │   ├── operadoras/
    │   │   ├── index.ts
    │   │   ├── operadoraControlador.ts
    │   │   ├── operadoraServico.ts
    │   │   └── operadoraValidacao.ts
    │   ├── beneficiarios/
    │   │   ├── index.ts
    │   │   ├── beneficiarioControlador.ts
    │   │   ├── beneficiarioServico.ts
    │   │   └── beneficiarioValidacao.ts
    │   ├── guias/
    │   │   ├── index.ts
    │   │   ├── guiaControlador.ts
    │   │   ├── guiaServico.ts
    │   │   ├── guiaValidacao.ts
    │   │   └── guiaTipos.ts
    │   ├── triagem/
    │   │   ├── index.ts
    │   │   ├── triagemControlador.ts
    │   │   ├── triagemServico.ts
    │   │   └── triagemValidacao.ts
    │   ├── pareceres/
    │   │   ├── index.ts
    │   │   ├── parecerControlador.ts
    │   │   ├── parecerServico.ts
    │   │   └── parecerValidacao.ts
    │   ├── prestadores/
    │   │   ├── index.ts
    │   │   ├── prestadorControlador.ts
    │   │   ├── prestadorServico.ts
    │   │   └── prestadorValidacao.ts
    │   ├── notificacoes/
    │   │   ├── index.ts
    │   │   ├── notificacaoControlador.ts
    │   │   ├── notificacaoServico.ts
    │   │   ├── adaptadores/
    │   │   │   ├── emailAdapter.ts
    │   │   │   └── whatsappAdapter.ts  # stub futuro
    │   │   └── templates/
    │   │       └── guiaAtualizada.ts
    │   ├── historico/
    │   │   ├── index.ts
    │   │   ├── historicoServico.ts
    │   │   └── historicoMiddleware.ts  # auto-log de eventos
    │   ├── sla/
    │   │   ├── index.ts
    │   │   ├── slaServico.ts
    │   │   └── slaConfig.ts           # prazos por categoria ANS/RN
    │   ├── relatorios/
    │   │   ├── index.ts
    │   │   ├── relatorioControlador.ts
    │   │   └── relatorioServico.ts
    │   ├── uploads/
    │   │   ├── index.ts
    │   │   ├── uploadControlador.ts
    │   │   └── uploadServico.ts
    │   └── whiteLabel/
    │       ├── index.ts
    │       ├── whiteLabelControlador.ts
    │       └── whiteLabelServico.ts
    ├── utils/
    │   ├── respostaApi.ts    # response formatter padronizado
    │   ├── paginacao.ts
    │   ├── redisLock.ts      # distributed lock para condition racing
    │   └── geradorToken.ts
    └── tipos/
        ├── express.d.ts
        └── global.ts
├── prisma/
│   ├── schema.prisma
│   └── migrations/
│       └── ... (migrations SQL manuais)
├── seeds/
│   ├── index.ts              # orquestrador de seeds
│   ├── usuarios.ts
│   ├── operadoras.ts
│   └── slaConfigs.ts
```

### 3.3 Database (`/database`)

```
database/
├── docker-compose.yml        # PostgreSQL
├── docker-compose.redis.yml  # Redis
├── volumes/                  # persistência local (gitignored)
│   ├── postgres/
│   └── redis/
└── scripts/
    ├── backup.sh
    └── restore.sh
```

---

## 4. Modelo de Dados (Prisma — visão resumida)

### Entidades principais

- **Usuario** — id, nome, email, senhaHash, cpf, telefone, role (enum), ativo, criadoEm, atualizadoEm
- **Operadora** — id, razaoSocial, cnpj, contato, ativo, criadoEm
- **OperadoraDocumento** — id, operadoraId, tipo, caminhoArquivo, criadoEm
- **Prestador** — id, razaoSocial, cnpj, cnes, tipo (HOSPITAL, CLINICA, LABORATORIO, CONSULTORIO), endereco, contato, ativo, criadoEm
- **Beneficiario** — id, nome, cpf, carteirinha, operadoraId, dataNascimento, contato
- **Guia** — id, operadoraId, beneficiarioId, prestadorId, tipo (enum), status (enum), prioridade, codigoProcedimento, descricao, valorSolicitado, enfermeiroId, medicoId, criadoEm, prazoSLA, atualizadoEm
- **GuiaAnexo** — id, guiaId, tipo, caminhoArquivo, criadoEm
- **GuiaMetadados** — id, guiaId, codigoTUSS, cid, tipoInternacao, etc.
- **Triagem** — id, guiaId, enfermeiroId, resultado (APROVADA, REPROVADA, PENDENCIA), observacoes, criadoEm
- **Parecer** — id, guiaId, medicoId, resultado (enum), justificativa, criadoEm
- **HistoricoEvento** — id, entidade, entidadeId, acao, usuarioId, detalhes (JSON), criadoEm
- **Notificacao** — id, usuarioId, tipo, canal, conteudo, enviadoEm, lidoEm
- **ConfigNotificacao** — id, ownerId, tipoEvento, ativo
- **SlaConfig** — id, categoriaProcedimento, prazoHoras, rnReferencia
- **WhiteLabelConfig** — id, logoUrl, corPrimaria, corSecundaria, nomeExibicao

### Enums principais

```
Role: SUPER_ADMIN | OWNER | ENFERMEIRO_AUDITOR | MEDICO_AUDITOR | OPERADORA | PRESTADOR | BENEFICIARIO

StatusGuia: RASCUNHO | ENVIADA | EM_ANALISE | TRIAGEM_TECNICA | PENDENCIA_TECNICA
           | AGUARDANDO_PARECER | PARECER_EMITIDO | FINALIZADA | REABERTA | REENVIADA

ResultadoTriagem: APROVADA | REPROVADA | PENDENCIA
ResultadoParecer: AUTORIZADO | NEGADO | AUTORIZADO_PARCIAL | SOLICITAR_INFO

TipoGuia: CONSULTA | EXAME | INTERNACAO | PROCEDIMENTO | TERAPIA
TipoPrestador: HOSPITAL | CLINICA | LABORATORIO | CONSULTORIO
CanalNotificacao: EMAIL | WHATSAPP | SISTEMA
```

---

## 5. Fluxo Principal da Guia

```
OPERADORA envia guia (status: ENVIADA)
  → OWNER recebe, avalia e encaminha para triagem (status: EM_ANALISE)
    → ENFERMEIRO_AUDITOR recebe (status: TRIAGEM_TECNICA)
      → Aprova → segue para MEDICO_AUDITOR (status: AGUARDANDO_PARECER)
      → Reprova/pendência → devolve para OPERADORA (status: PENDENCIA_TECNICA)
        → OPERADORA corrige e reenvia (status: REENVIADA → volta pra EM_ANALISE)
    → MEDICO_AUDITOR emite parecer (status: PARECER_EMITIDO)
      → OWNER avalia resultado final, classifica (status: FINALIZADA)
      → OWNER discorda → reabrir ou solicitar novo parecer (status: REABERTA)
```

### Participação de cada role no fluxo


| Role                   | Momento de atuação                                                                         |
| ---------------------- | -------------------------------------------------------------------------------------------- |
| **OPERADORA**          | Envia guia, corrige pendências técnicas quando devolvida                                   |
| **OWNER**              | Início: recebe e libera pra triagem. Final: avalia parecer e classifica. Exceções: reabre |
| **ENFERMEIRO_AUDITOR** | Triagem técnico-administrativa (documentação, códigos, elegibilidade)                    |
| **MEDICO_AUDITOR**     | Análise clínica e emissão de parecer                                                      |

O meio do fluxo (enfermeiro → médico) flui diretamente, sem passar pelo Owner.

Cada transição gera:

- Registro em `HistoricoEvento` (quem, quando, o que, detalhes)
- Verificação de SLA (prazo conforme categoria/RN)
- Notificação aos envolvidos (conforme `ConfigNotificacao` do Owner)

---

## 6. Docker — Composição


| Serviço   | Arquivo                             | Porta | Volume               |
| ---------- | ----------------------------------- | ----- | -------------------- |
| PostgreSQL | `database/docker-compose.yml`       | 5432  | `./volumes/postgres` |
| Redis      | `database/docker-compose.redis.yml` | 6379  | `./volumes/redis`    |
| Backend    | `backend/docker-compose.yml`        | 3001  | `./volumes/uploads`  |
| Frontend   | `frontend/docker-compose.yml`       | 3000  | —                   |

Rede Docker compartilhada: `auditoria-network` (external, criada via script ou no primeiro compose).

---

## 7. Funcionalidades por Fase

### Fase 1 — Fundação (scaffolding + auth + CRUD base)

1. Estrutura de diretórios completa (front, back, db)
2. Docker-compose de todos os serviços
3. Schema Prisma + migration inicial
4. Auth (JWT + refresh token + middleware de roles)
5. CRUD Usuários (OWNER + ENFERMEIRO_AUDITOR + MEDICO_AUDITOR)
6. CRUD Operadoras (com upload de documentos)
7. CRUD Prestadores (cadastro + login próprio + consulta de guias emitidas para ele + acompanhamento de status)
8. CRUD Beneficiários (simples e dinâmico)
9. Layout principal + tema claro/escuro + white-label base
10. Tela de login

### Fase 2 — Fluxo Core

11. CRUD Guias (formulário + upload de anexos + metadados)
12. Máquina de estados da guia (transições + validações conforme fluxo definido)
13. Triagem técnica (tela do enfermeiro auditor)
14. Pareceres médicos (tela do médico auditor)
15. Histórico/Linha do tempo automática
16. SLA engine (prazos por categoria, alertas)
17. Dashboard com indicadores

### Fase 3 — Comunicação + Relatórios

18. Sistema de notificações (adapter email)
19. Config de notificações por Owner
20. Relatórios (SLA, beneficiário, auditor por enfermeiro e médico)
21. Exports (PDF de pareceres, triagens, relatórios)

### Fase 4 — Mobile + Acessibilidade

22. Capacitor setup (Android + iOS)
23. Acessibilidade (aria-labels, narrador, contraste)
24. Libras (integração com VLibras ou similar)

### Fase 5 — Expansão

25. WhatsApp adapter
26. TISS XML import (se demandado)
27. Assinatura digital de pareceres

---
