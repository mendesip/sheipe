# Telas do App

Mapeamento de telas do Sheipe (Flutter). App único com navegação adaptada por role.

## Navegação principal

### Athlete (Bottom Tab Bar)
| Tab | Ícone | Descrição |
|---|---|---|
| Feed | home | Posts de quem segue + discover |
| Treino | fitness_center | Histórico e início de treino |
| Rotinas | list_alt | Rotinas e planos de treino |
| Perfil | person | Perfil, métricas, configurações |

### Trainer (Bottom Tab Bar)
| Tab | Ícone | Descrição |
|---|---|---|
| Atletas | group | Lista e gestão de atletas |
| Rotinas | list_alt | Templates de rotinas para atribuição |
| Perfil | person | Perfil e configurações |

> O treino ativo é uma rota modal que sobrepõe a tab bar — o usuário pode minimizá-la e retornar ao treino via banner persistente.

---

## Auth

```
SplashScreen
OnboardingScreen          ← slides de apresentação (3 telas)
  ├── LoginScreen
  │     └── ForgotPasswordScreen
  └── RegisterScreen
        ├── Step 1: dados básicos (nome, email, senha)
        └── Step 2: seleção de role (athlete | trainer)
```

---

## Feed

```
FeedScreen                ← posts de usuários seguidos (cursor)
  ├── [tab] DiscoverScreen  ← posts ranqueados por engajamento (cursor)
  └── PostDetailScreen
        └── CommentsScreen
              └── CommentsScreen (respostas a comentário)

CreatePostScreen          ← acessado via WorkoutSummaryScreen
```

---

## Treino (tab Athlete)

O treino ativo é modal — bloqueia a navegação principal mas pode ser minimizado.

```
WorkoutHistoryScreen      ← tela raiz da tab
  └── WorkoutDetailScreen
        └── [trainer] TrainerNotesSheet

[FAB] StartWorkoutScreen  ← selecionar rotina ou iniciar livre
  └── ActiveWorkoutScreen  ← modal fullscreen
        ├── ExerciseSetLoggerSheet  ← bottom sheet por série (peso, reps, rpe)
        ├── RestTimerOverlay        ← timer de descanso com overlay
        └── AddExerciseSheet        ← busca e adiciona exercício mid-workout
              └── ExercisePickerScreen
  └── WorkoutSummaryScreen  ← exibido ao finalizar
        └── CreatePostScreen  ← publicar treino (opcional)
```

---

## Rotinas (tab compartilhada Athlete e Trainer)

```
RoutinesListScreen
  ├── RoutineDetailScreen
  │     ├── RoutineFormScreen (editar)
  │     └── ExercisePickerScreen
  │           └── ExerciseDetailScreen
  └── RoutineFormScreen (criar)
        └── ExercisePickerScreen

RoutinePlansListScreen    ← acessado via RoutinesListScreen
  ├── RoutinePlanDetailScreen  ← visualização semanal (grid dia × semana)
  │     └── RoutinePlanFormScreen (editar)
  └── RoutinePlanFormScreen (criar)
        └── RoutinePickerSheet  ← selecionar rotinas para os dias
```

---

## Exercícios

Acessado via ExercisePickerScreen ou busca.

```
ExerciseLibraryScreen     ← filtros: muscle_group, category, texto
  ├── ExerciseDetailScreen
  │     └── ExerciseFormScreen (editar — só owner/admin)
  └── ExerciseFormScreen (criar exercício customizado)
```

---

## Perfil (tab)

```
ProfileScreen (próprio)
  ├── [tab] PostsGrid
  ├── [tab] BodyMetricsScreen
  │     ├── BodyMetricChartScreen  ← gráfico de evolução por métrica
  │     └── BodyMetricFormScreen   ← registrar nova medição
  ├── FollowersScreen
  ├── FollowingScreen
  ├── SettingsScreen
  │     ├── EditProfileScreen
  │     └── NotificationsSettingsScreen
  └── NotificationsScreen

UserProfileScreen (outros usuários)
  ├── [tab] PostsGrid
  ├── FollowersScreen
  └── FollowingScreen
```

---

## Atletas (tab Trainer)

```
AthletesListScreen
  └── AthleteDetailScreen        ← visão geral: treinos recentes, plano ativo, métricas
        ├── AthleteWorkoutHistoryScreen
        │     └── AthleteWorkoutDetailScreen
        │           └── TrainerNotesSheet  ← adicionar/editar trainer_notes
        ├── AthleteBodyMetricsScreen
        │     └── BodyMetricChartScreen
        └── AssignPlanScreen     ← atribuir RoutinePlan ao atleta
              └── RoutinePickerSheet
```

### Solicitação de vínculo (fluxo bidirecional)

```
TrainerSearchScreen        ← atleta busca trainer (via ProfileScreen)
  └── TrainerPublicProfileScreen
        └── TrainerRequestSheet  ← enviar solicitação

PendingRequestsScreen      ← trainer aceita/rejeita solicitações (via AthletesListScreen)
```

---

## Academias

Acessado via ProfileScreen ou busca.

```
GymSearchScreen
  └── GymDetailScreen
        ├── GymEquipmentListScreen
        └── [owner] GymFormScreen (editar)
              └── GymEquipmentFormScreen

GymFormScreen (cadastrar nova academia — role: owner)
```

---

## Notificações

```
NotificationsScreen        ← acessado via ícone no AppBar
  └── [navega para o recurso relacionado conforme notifiable_type]
```

---

## Resumo por role

| Tela | Athlete | Trainer |
|---|---|---|
| Feed & Discover | ✓ | ✓ |
| Treino ativo | ✓ | — |
| Histórico de treinos | ✓ (próprio) | ✓ (atletas) |
| Rotinas & Planos | ✓ | ✓ (templates) |
| Atribuir plano a atleta | — | ✓ |
| Métricas corporais | ✓ (próprio) | ✓ (atletas, leitura) |
| Gestão de academia | owner only | owner only |
| Perfil social | ✓ | ✓ |
