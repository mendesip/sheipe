# API Design

API REST do Sheipe. Base URL: `/api/v1/`.

## Decisões técnicas

| Concern | Solução |
|---|---|
| Autenticação | Rails 8 auth generator + Bearer token (opaque, DB-backed) |
| Autorização | `action_policy` |
| Paginação | `pagy` — offset para listas, keyset/cursor para feed |
| Serialização | `alba` |
| Rate limiting | `rack-attack` + `rate_limit` do Rails 8 |
| N+1 | `ar_lazy_preload` |
| Docs | `rswag` (OpenAPI gerado a partir dos RSpec request specs) |

## Autenticação

Bearer token no header: `Authorization: Bearer <token>`

| Método | Path | Descrição |
|---|---|---|
| `POST` | `/auth/register` | Cadastro de novo usuário |
| `POST` | `/auth/login` | Login — retorna `{ token, user }` |
| `DELETE` | `/auth/logout` | Logout — invalida a sessão atual |

## Usuários

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/me` | Perfil do usuário autenticado |
| `PATCH` | `/me` | Atualiza perfil (nome, avatar, etc.) |
| `DELETE` | `/me` | Remove conta |
| `GET` | `/users/:id` | Perfil público de outro usuário |

## Academias

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/gyms` | Lista/busca academias |
| `POST` | `/gyms` | Cadastra uma academia |
| `GET` | `/gyms/:id` | Detalhes da academia |
| `PATCH` | `/gyms/:id` | Atualiza academia (owner) |
| `DELETE` | `/gyms/:id` | Remove academia (owner) |
| `POST` | `/gyms/:id/memberships` | Entra na academia |
| `DELETE` | `/gyms/:id/memberships` | Sai da academia |

### Equipamentos

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/gyms/:id/equipment` | Lista equipamentos da academia |
| `POST` | `/gyms/:id/equipment` | Adiciona equipamento |
| `PATCH` | `/gyms/:id/equipment/:equipment_id` | Atualiza equipamento |
| `DELETE` | `/gyms/:id/equipment/:equipment_id` | Remove equipamento |

## Treinadores & Alunos

Vínculo iniciado pelo atleta (solicita treinador) ou pelo trainer (convida aluno).

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/trainers` | Busca treinadores disponíveis |
| `GET` | `/me/trainer` | Trainer atual do atleta autenticado |
| `POST` | `/me/trainer` | Solicita vínculo com um trainer |
| `DELETE` | `/me/trainer` | Encerra vínculo com trainer |
| `GET` | `/me/athletes` | Lista atletas do trainer autenticado |
| `POST` | `/me/athletes` | Convida um atleta |
| `PATCH` | `/me/athletes/:id` | Aceita/rejeita solicitação |
| `DELETE` | `/me/athletes/:id` | Remove atleta |

### Acesso do trainer aos dados do atleta

Todos os endpoints abaixo exigem vínculo ativo em `TrainerAthlete`.

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/athletes/:id/workouts` | Histórico de treinos do atleta |
| `PATCH` | `/athletes/:id/workouts/:workout_id/trainer_notes` | Adiciona/edita anotações do trainer |
| `GET` | `/athletes/:id/routine_plans` | Planos do atleta |
| `POST` | `/athletes/:id/routine_plans` | Atribui um plano ao atleta |
| `GET` | `/athletes/:id/body_metrics` | Métricas corporais do atleta |

## Exercícios

`GET /exercises` retorna exercícios do sistema (`is_system: true`) + criados pelo usuário autenticado.

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/exercises` | Lista exercícios (filtros: muscle_group, category, query) |
| `POST` | `/exercises` | Cria exercício customizado |
| `GET` | `/exercises/:id` | Detalhes do exercício |
| `PATCH` | `/exercises/:id` | Atualiza exercício (owner ou admin) |
| `DELETE` | `/exercises/:id` | Remove exercício (owner ou admin) |

## Rotinas

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/routines` | Lista rotinas do usuário autenticado |
| `POST` | `/routines` | Cria rotina |
| `GET` | `/routines/:id` | Detalhes da rotina (com exercises e sets) |
| `PATCH` | `/routines/:id` | Atualiza rotina |
| `DELETE` | `/routines/:id` | Remove rotina |

### Exercícios da rotina

| Método | Path | Descrição |
|---|---|---|
| `POST` | `/routines/:id/exercises` | Adiciona exercício à rotina |
| `PATCH` | `/routines/:id/exercises/:re_id` | Atualiza (posição, notas) |
| `DELETE` | `/routines/:id/exercises/:re_id` | Remove exercício da rotina |
| `POST` | `/routines/:id/exercises/:re_id/sets` | Adiciona série |
| `PATCH` | `/routines/:id/exercises/:re_id/sets/:set_id` | Atualiza série |
| `DELETE` | `/routines/:id/exercises/:re_id/sets/:set_id` | Remove série |

## Planos de Treino

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/routine_plans` | Lista planos do usuário autenticado |
| `POST` | `/routine_plans` | Cria plano |
| `GET` | `/routine_plans/:id` | Detalhes do plano (com days e rotinas) |
| `PATCH` | `/routine_plans/:id` | Atualiza plano |
| `DELETE` | `/routine_plans/:id` | Remove plano |
| `POST` | `/routine_plans/:id/days` | Adiciona dia ao plano |
| `PATCH` | `/routine_plans/:id/days/:day_id` | Atualiza dia (rotina, day_of_week, week_number) |
| `DELETE` | `/routine_plans/:id/days/:day_id` | Remove dia do plano |

## Treinos

`POST /workouts` aceita `routine_id` opcional para iniciar a partir de uma rotina — nesse caso os `WorkoutExercise` e `WorkoutSet` são pré-populados com os dados da rotina.

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/workouts` | Histórico de treinos do usuário (offset, filtros: date_range, routine_id) |
| `POST` | `/workouts` | Inicia treino (aceita `routine_id` opcional) |
| `GET` | `/workouts/:id` | Detalhes do treino |
| `PATCH` | `/workouts/:id` | Atualiza (notas, gym_id) |
| `DELETE` | `/workouts/:id` | Remove treino |
| `POST` | `/workouts/:id/finish` | Finaliza treino (registra `finished_at`) |

### Exercícios do treino

| Método | Path | Descrição |
|---|---|---|
| `POST` | `/workouts/:id/exercises` | Adiciona exercício ao treino |
| `PATCH` | `/workouts/:id/exercises/:we_id` | Atualiza (posição, notas) |
| `DELETE` | `/workouts/:id/exercises/:we_id` | Remove exercício |
| `POST` | `/workouts/:id/exercises/:we_id/sets` | Adiciona série |
| `PATCH` | `/workouts/:id/exercises/:we_id/sets/:set_id` | Atualiza série (peso, reps, rpe, completed) |
| `DELETE` | `/workouts/:id/exercises/:we_id/sets/:set_id` | Remove série |

## Métricas Corporais

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/me/body_metrics` | Histórico de métricas (offset, filtros: date_range) |
| `POST` | `/me/body_metrics` | Registra medição |
| `GET` | `/me/body_metrics/:id` | Detalhes da medição |
| `PATCH` | `/me/body_metrics/:id` | Atualiza medição |
| `DELETE` | `/me/body_metrics/:id` | Remove medição |

## Social

### Feed & Discovery

Ambos paginados com cursor (`pagy` keyset).

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/feed` | Posts de usuários seguidos (cursor) |
| `GET` | `/discover` | Posts ranqueados por engajamento (cursor) |

### Posts

`POST /workouts/:id/post` publica um treino existente como post.

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/users/:id/posts` | Posts públicos de um usuário |
| `POST` | `/workouts/:id/post` | Publica treino como post |
| `GET` | `/posts/:id` | Detalhes do post |
| `PATCH` | `/posts/:id` | Atualiza (caption, visibility) |
| `DELETE` | `/posts/:id` | Remove post |

### Curtidas & Comentários

| Método | Path | Descrição |
|---|---|---|
| `POST` | `/posts/:id/likes` | Curte post |
| `DELETE` | `/posts/:id/likes` | Remove curtida |
| `GET` | `/posts/:id/comments` | Lista comentários (offset) |
| `POST` | `/posts/:id/comments` | Comenta (aceita `parent_id` para respostas) |
| `PATCH` | `/posts/:id/comments/:comment_id` | Edita comentário (owner) |
| `DELETE` | `/posts/:id/comments/:comment_id` | Remove comentário |

### Follows

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/users/:id/followers` | Lista seguidores |
| `GET` | `/users/:id/following` | Lista quem o usuário segue |
| `POST` | `/users/:id/follow` | Seguir usuário |
| `DELETE` | `/users/:id/follow` | Deixar de seguir |

## Notificações

| Método | Path | Descrição |
|---|---|---|
| `GET` | `/notifications` | Lista notificações (offset, filtro: unread) |
| `PATCH` | `/notifications/:id/read` | Marca como lida |
| `POST` | `/notifications/read_all` | Marca todas como lidas |

## Convenções

### Paginação

Listas com offset retornam:
```json
{
  "data": [],
  "meta": {
    "current_page": 1,
    "total_pages": 10,
    "total_count": 98,
    "per_page": 10
  }
}
```

Feed e discover retornam cursor:
```json
{
  "data": [],
  "meta": {
    "next_cursor": "eyJpZCI6NDJ9",
    "has_more": true
  }
}
```

### Erros

```json
{
  "error": {
    "code": "validation_failed",
    "message": "Name can't be blank",
    "details": { "name": ["can't be blank"] }
  }
}
```

| Status | Uso |
|---|---|
| `401` | Token ausente ou inválido |
| `403` | Autenticado mas sem permissão |
| `404` | Recurso não encontrado |
| `422` | Falha de validação |
| `429` | Rate limit atingido |
