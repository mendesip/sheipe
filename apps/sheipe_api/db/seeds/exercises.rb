# System exercises — created with `is_system: true`, no creator.
# Idempotent: looked up by [name, is_system: true] and updated in place.

SYSTEM_EXERCISES = [
  # ── Chest ──────────────────────────────────────────────
  { name: "Barbell Bench Press",    muscle_group: "chest",     category: "strength", description: "Compound chest press with a barbell." },
  { name: "Incline Dumbbell Press", muscle_group: "chest",     category: "strength", description: "Upper chest emphasis with dumbbells." },
  { name: "Push-Up",                muscle_group: "chest",     category: "strength", description: "Bodyweight horizontal press." },
  { name: "Cable Crossover",        muscle_group: "chest",     category: "strength", description: "Isolated chest fly using cables." },

  # ── Back ───────────────────────────────────────────────
  { name: "Deadlift",               muscle_group: "back",      category: "strength", description: "Posterior-chain compound lift." },
  { name: "Pull-Up",                muscle_group: "back",      category: "strength", description: "Bodyweight vertical pull." },
  { name: "Barbell Row",            muscle_group: "back",      category: "strength", description: "Bent-over horizontal row." },
  { name: "Lat Pulldown",           muscle_group: "back",      category: "strength", description: "Cable vertical pull." },

  # ── Shoulders ──────────────────────────────────────────
  { name: "Overhead Press",         muscle_group: "shoulders", category: "strength", description: "Standing barbell press overhead." },
  { name: "Lateral Raise",          muscle_group: "shoulders", category: "strength", description: "Side delt isolation with dumbbells." },
  { name: "Face Pull",              muscle_group: "shoulders", category: "strength", description: "Rear delt and upper back cable pull." },

  # ── Biceps ─────────────────────────────────────────────
  { name: "Barbell Curl",           muscle_group: "biceps",    category: "strength", description: "Standing curl with a barbell." },
  { name: "Hammer Curl",            muscle_group: "biceps",    category: "strength", description: "Neutral-grip dumbbell curl." },

  # ── Triceps ────────────────────────────────────────────
  { name: "Triceps Pushdown",       muscle_group: "triceps",   category: "strength", description: "Cable triceps extension." },
  { name: "Skullcrusher",           muscle_group: "triceps",   category: "strength", description: "Lying triceps extension with EZ bar." },
  { name: "Dip",                    muscle_group: "triceps",   category: "strength", description: "Bodyweight dip on parallel bars." },

  # ── Legs (quads/hamstrings) ────────────────────────────
  { name: "Back Squat",             muscle_group: "legs",      category: "strength", description: "Barbell back squat — quad-dominant." },
  { name: "Front Squat",            muscle_group: "legs",      category: "strength", description: "Barbell front squat — quad emphasis." },
  { name: "Romanian Deadlift",      muscle_group: "legs",      category: "strength", description: "Hamstring-dominant hip hinge." },
  { name: "Leg Press",              muscle_group: "legs",      category: "strength", description: "Machine compound leg press." },
  { name: "Leg Curl",               muscle_group: "legs",      category: "strength", description: "Hamstring isolation on machine." },
  { name: "Leg Extension",          muscle_group: "legs",      category: "strength", description: "Quad isolation on machine." },

  # ── Glutes ─────────────────────────────────────────────
  { name: "Hip Thrust",             muscle_group: "glutes",    category: "strength", description: "Barbell hip extension on bench." },
  { name: "Bulgarian Split Squat",  muscle_group: "glutes",    category: "strength", description: "Single-leg squat with rear foot elevated." },

  # ── Core ───────────────────────────────────────────────
  { name: "Plank",                  muscle_group: "core",      category: "strength", description: "Isometric anti-extension hold." },
  { name: "Hanging Leg Raise",      muscle_group: "core",      category: "strength", description: "Hanging knee/leg raise for abs." },
  { name: "Cable Crunch",           muscle_group: "core",      category: "strength", description: "Kneeling cable crunch." },

  # ── Full body / cardio / mobility ──────────────────────
  { name: "Burpee",                 muscle_group: "full_body", category: "cardio",   description: "Full body conditioning movement." },
  { name: "Treadmill Run",          muscle_group: "full_body", category: "cardio",   description: "Steady-state or interval running." },
  { name: "World's Greatest Stretch", muscle_group: "full_body", category: "mobility", description: "Multi-plane mobility flow." }
].freeze

SYSTEM_EXERCISES.each do |attrs|
  exercise = Exercise.find_or_initialize_by(name: attrs[:name], is_system: true)
  exercise.assign_attributes(attrs.merge(is_system: true, creator: nil))
  exercise.save!
end

puts "Seeded #{SYSTEM_EXERCISES.size} system exercises."
