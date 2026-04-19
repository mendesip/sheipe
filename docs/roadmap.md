# Roadmap de Implementação — Sheipe

## Context

Sheipe está na fase de documentação de arquitetura (data model, API spec, screen map prontos). O próximo passo é implementar o projeto do zero, em ordem que minimize retrabalho e entregue valor incremental. Decisões que afetam o roadmap:

- **Solo developer** → cada fase entrega API + Flutter end-to-end (sem tracks paralelos)
- **Offline-first** → toda a camada de treino precisa funcionar sem internet (Isar + Repository pattern)
- **Cubit como ViewModel** → arquitetura MVVM com Bloc/Cubit; sem StatefulWidget para lógica de negócio

O roadmap está dividido em 8 fases. Cada fase é um incremento funcional e deployável.

---

## Stack de referência

| Camada | Tecnologia |
|---|---|
| API | Rails 8, `action_policy`, `pagy`, `alba`, `rack-attack`, `ar_lazy_preload`, `rswag` |
| Banco de dados | PostgreSQL (UUID nativo via `uuid-ossp`, escala horizontal) |
| Auth API | Rails 8 auth generator + Bearer token (opaque, DB-backed) |
| App state | Bloc/Cubit (nomeado como ViewModel) |
| Navegação | `go_router` |
| HTTP | `dio` + interceptors para Bearer token |
| Local DB | `drift` (offline-first, SQLite type-safe) |
| Segurança | `flutter_secure_storage` (token storage) |
| Gráficos | `fl_chart` |
| Push | Firebase Cloud Messaging (FCM) |

---

## Fase 0 — Scaffold & Fundação (setup)

**Objetivo:** monorepo funcional com padrões definidos antes de qualquer feature.

### API (`apps/sheipe_api`)
- [ ] `rails new sheipe_api --api --database=postgresql`
- [ ] Habilitar extensão `uuid-ossp` na migration inicial — todos os modelos usarão UUID como PK
- [ ] Adicionar gems: `rack-cors`, `pagy`, `alba`, `action_policy`, `ar_lazy_preload`, `rack-attack`, `rswag`
- [ ] `BaseController` com `rescue_from` centralizado e formato de erro padrão
- [ ] CORS configurado para desenvolvimento

### Flutter (`apps/sheipe_app`)
- [ ] `flutter create sheipe_app`
- [ ] Adicionar dependências: `flutter_bloc`, `go_router`, `dio`, `isar`, `flutter_secure_storage`, `get_it` (DI)
- [ ] Estrutura de pastas: `features/`, `core/` (network, storage, DI), `shared/` (widgets, theme)
- [ ] Design system: `AppTheme`, `AppColors`, `AppTextStyles`
- [ ] `AppRouter` (GoRouter) com rotas base e guards de autenticação
- [ ] `ApiClient` (Dio) com interceptor de Bearer token + refresh
- [ ] `AppDatabase` (Drift) — singleton com tabelas mapeando as entidades offline
- [ ] Padrão de Repository: `abstract Repository` → `LocalDataSource` (Drift) + `RemoteDataSource` (Dio)

---

## Fase 1 — Autenticação & Perfil

**Objetivo:** usuário se registra, faz login e gerencia perfil.

### API
- [ ] `rails generate authentication` → adaptar SessionsController para Bearer token
- [ ] `POST /api/v1/auth/register` — cria User + Session, retorna token
- [ ] `POST /api/v1/auth/login` — retorna token
- [ ] `DELETE /api/v1/auth/logout` — invalida Session
- [ ] `GET/PATCH /api/v1/me`
- [ ] `GET /api/v1/users/:id` (perfil público)

### Flutter
- [ ] `AuthCubit` + `AuthRepository`
- [ ] Telas: `SplashScreen`, `OnboardingScreen`, `LoginScreen`, `RegisterScreen` (2 steps: dados + role)
- [ ] Token persistido com `flutter_secure_storage`
- [ ] Redirect automático baseado em auth state no GoRouter
- [ ] `EditProfileScreen`

---

## Fase 2 — Core de Treino (MVP principal)

**Objetivo:** atleta consegue criar rotinas e logar treinos offline. É o núcleo do app.

### API
- [ ] `Exercise`: CRUD + listagem com filtros (`muscle_group`, `category`, `query`) + seed de exercícios do sistema
- [ ] `Routine` + `RoutineExercise` + `RoutineSet`: CRUD completo
- [ ] `Workout`: `POST /workouts` (com `routine_id` opcional pré-popula exercises/sets), `POST /workouts/:id/finish`
- [ ] `WorkoutExercise` + `WorkoutSet`: CRUD nested
- [ ] Autorização com `action_policy` em todos os recursos

### Flutter — Offline-first
- [ ] Drift tables: `ExercisesTable`, `RoutinesTable`, `WorkoutsTable`, `WorkoutExercisesTable`, `WorkoutSetsTable`
- [ ] Sync strategy: escreve no Drift primeiro → faz background sync com API → resolve conflitos por `updated_at`
- [ ] `ExerciseLibraryScreen` + `ExerciseDetailScreen` + `ExerciseFormScreen`
- [ ] `RoutinesListScreen` + `RoutineDetailScreen` + `RoutineFormScreen` + `ExercisePickerScreen`
- [ ] `StartWorkoutScreen` (escolher rotina ou livre)
- [ ] `ActiveWorkoutScreen` (modal fullscreen)
  - `ExerciseSetLoggerSheet` (peso, reps, rpe)
  - `RestTimerOverlay`
  - `AddExerciseSheet`
- [ ] `WorkoutSummaryScreen`
- [ ] `WorkoutHistoryScreen` + `WorkoutDetailScreen` (tab Treino)

---

## Fase 3 — Planos de Treino

**Objetivo:** atleta organiza rotinas em planos semanais com periodização.

### API
- [ ] `RoutinePlan` + `RoutinePlanDay`: CRUD completo
- [ ] `GET /routine_plans/:id` inclui days com rotinas aninhadas

### Flutter
- [ ] `RoutinePlansListScreen`
- [ ] `RoutinePlanDetailScreen` — grid semana × dia (week_number suportado)
- [ ] `RoutinePlanFormScreen` + `RoutinePickerSheet`

---

## Fase 4 — Trainer & Academias

**Objetivo:** trainers gerenciam atletas e atribuem planos; academias cadastram equipamentos.

### API
- [ ] `TrainerAthlete`: endpoints de vínculo bidirecional (solicitar, convidar, aceitar, rejeitar)
- [ ] Trainer scope: `GET/PATCH /athletes/:id/workouts`, `PATCH /athletes/:id/workouts/:id/trainer_notes`, `POST /athletes/:id/routine_plans`
- [ ] `Gym`: CRUD (owner role), memberships
- [ ] `Equipment`: CRUD dentro de Gym

### Flutter
- [ ] Tab **Atletas** (trainer): `AthletesListScreen`, `AthleteDetailScreen`
- [ ] `AthleteWorkoutHistoryScreen` + `AthleteWorkoutDetailScreen` + `TrainerNotesSheet`
- [ ] `AssignPlanScreen`
- [ ] `PendingRequestsScreen` (trainer aceita/rejeita)
- [ ] `TrainerSearchScreen` + `TrainerPublicProfileScreen` + `TrainerRequestSheet` (atleta)
- [ ] `GymSearchScreen` + `GymDetailScreen` + `GymFormScreen` (owner) + `GymEquipmentFormScreen`

---

## Fase 5 — Métricas Corporais

**Objetivo:** atleta e trainer acompanham evolução física ao longo do tempo.

### API
- [ ] `BodyMetric`: CRUD (`/me/body_metrics` e `/athletes/:id/body_metrics` para trainer)

### Flutter
- [ ] `BodyMetricsScreen` (lista + resumo)
- [ ] `BodyMetricFormScreen`
- [ ] `BodyMetricChartScreen` — gráficos de evolução por métrica (`fl_chart`)

---

## Fase 6 — Social

**Objetivo:** usuários compartilham treinos, seguem uns aos outros e interagem via feed.

### API
- [ ] `Follow`: endpoints follow/unfollow, followers, following
- [ ] `WorkoutPost`: publicar treino (`POST /workouts/:id/post`), CRUD, `PostMedia`
- [ ] `PostLike`, `PostComment` (com `parent_id` para respostas)
- [ ] `PostView` — registrado automaticamente no `show` do post
- [ ] `PostTag` — gerado automaticamente na publicação com base nos exercícios do treino
- [ ] `GET /feed` — cursor pagination (pagy keyset), posts de seguidos
- [ ] `GET /discover` — cursor pagination, ranqueado por score de engajamento
- [ ] `GET /users/:id/posts`

### Flutter
- [ ] `FeedScreen` + `DiscoverScreen` (tab Feed)
- [ ] `PostDetailScreen` + `CommentsScreen` (respostas aninhadas)
- [ ] `CreatePostScreen` — acessado via `WorkoutSummaryScreen`
- [ ] `UserProfileScreen` (outros usuários) + `FollowersScreen` + `FollowingScreen`
- [ ] Atualizar `ProfileScreen` (próprio) com tab Posts + contadores de seguidores

---

## Fase 7 — Notificações

**Objetivo:** usuários recebem alertas de eventos relevantes em tempo real.

### API
- [ ] `Notification`: model + CRUD (`GET`, `PATCH /:id/read`, `POST /read_all`)
- [ ] Background jobs (ActiveJob + Solid Queue) para os 10 tipos de eventos
- [ ] Integração FCM: envio de push via job após criação da Notification

### Flutter
- [ ] FCM setup (`firebase_messaging`) + permission request no onboarding
- [ ] Handler de push em foreground e background
- [ ] `NotificationsScreen` (ícone no AppBar)
- [ ] Deep link a partir do push → navega para o recurso `notifiable`

---

## Fase 8 — Qualidade & Produção

**Objetivo:** app estável, documentado e pronto para lançamento.

### API
- [ ] `rswag` — gerar OpenAPI spec a partir dos RSpec request specs
- [ ] `rack-attack` — brute-force e rate limiting de infra
- [ ] Rails 8 `rate_limit` macro — throttles de negócio (ex: 10 posts/hora)
- [ ] Error monitoring (Sentry ou similar)
- [ ] Seeds realistas para staging

### Flutter
- [ ] Testes de Cubit (unit) e de widgets críticos (active workout, set logger)
- [ ] Performance: lazy loading em listas longas, imagens com `cached_network_image`
- [ ] Acessibilidade: `Semantics`, contraste de cores
- [ ] Preparação para App Store / Play Store (ícones, splash, metadata)

---

## Sequência recomendada de execução

```
Fase 0 → Fase 1 → Fase 2 → Fase 3 → Fase 4 → Fase 5 → Fase 6 → Fase 7 → Fase 8
 setup    auth    treino   planos   trainer   métricas  social   notif.   prod
```

Cada fase entrega **API + Flutter** antes de avançar. O MVP funcional (app usável para treino) está completo ao fim da Fase 2.
