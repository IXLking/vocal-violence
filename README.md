# Vocal Violence

## Overview
Vocal Violence is a **3D multiplayer voice-powered party fighting game** with a highly stylized chibi art direction inspired by retro arcade games and social party games.

## Core Features

### 🎤 Voice-Controlled Combat
- Real-time speech-to-text conversion
- Dynamic attack generation based on player phrases
- Voice intensity/volume affects attack power
- Creativity rewarded - new attacks stronger than repetition

### 🎮 Gameplay
- **Matchmaking System**: Real players + AI "Ghost Players" for seamless filling
- **3D Arena**: Sound-reactive environments with layered verticality
- **Chibi Aesthetics**: Exaggerated proportions, bright colors, expressive animations
- **Fast-Paced Combat**: Chaotic 4-player battles

### 🏆 Progression
- **Trophy Pass System**: Earn trophies to unlock cosmetics
- **Customization**: Hats, shirts, pants, shoes, accessories, voice effects, emotes
- **Shop**: Interactive cosmetic shop with rarity tiers
- **Leaderboards**: Global and friend rankings

### 🎨 Visual Style
- 3D chibi characters with pixel-art inspiration
- Sound-reactive decorations and environments
- Glow outlines, particle effects, screen shake
- Multiple themed arenas (Concert Hall, Arcade Rooftop, Neon Dojo, etc.)

### 🔊 Audio & Microphone
- Advanced microphone calibration
- Noise suppression and echo cancellation
- Sensitivity adjustment for competitive balance
- Accessibility options for quieter players

## Project Structure

```
vocal-violence/
├── scripts/
│   ├── globals/
│   │   └── game_manager.gd          # Player data, progression, cosmetics
│   ├── systems/
│   │   ├── voice_system.gd          # Microphone input & speech processing
│   │   ├── attack_generator.gd      # Dynamic 3D attack creation
│   │   ├── matchmaking_system.gd    # Real + ghost player matching
│   │   └── character_system.gd      # Character customization
│   └── scenes/
│       ├── main_menu.gd
│       ├── matchmaking_lobby.gd
│       ├── arena.gd
│       ├── character_customization.gd
│       └── settings_menu.gd
├── scenes/
│   ├── main_menu.tscn
│   ├── matchmaking_lobby.tscn
│   ├── arena.tscn
│   ├── character_customization.tscn
│   └── settings_menu.tscn
├── audio/
│   └── master_audio.tres
├── assets/
│   ├── models/              # 3D models and animations (TBD)
│   ├── textures/            # Textures and materials (TBD)
│   └── particles/           # Particle effects (TBD)
└── project.godot
```

## Getting Started

1. **Open the project** in Godot 4.1+
2. **Run the main scene** (`res://scenes/main_menu.tscn`)
3. **Test the menu flow** and prototype interactions
4. **Integrate speech-to-text API** (Google Cloud, Azure, etc.)
5. **Create 3D models and animations** for characters
6. **Build arena environments** with sound-reactive elements
7. **Connect multiplayer backend** for real player matchmaking

## Next Steps

- [ ] Integrate real speech-to-text API
- [ ] Create 3D chibi character models
- [ ] Design arena environments
- [ ] Implement particle effects system
- [ ] Build UI animations and polish
- [ ] Add multiplayer networking
- [ ] Create cosmetic database
- [ ] Build Trophy Pass progression
- [ ] Implement leaderboards
- [ ] Add sound effects and music
- [ ] Mobile phone microphone input optimization
- [ ] Cross-platform testing

## Architecture

### Core Systems

1. **GameManager** - Global singleton for player data, progression, cosmetics
2. **VoiceSystem** - Microphone input, audio analysis, speech recognition hooks
3. **AttackGenerator** - Converts voice phrases to 3D attacks with visual effects
4. **MatchmakingSystem** - Real player + ghost player matchmaking
5. **CharacterSystem** - Chibi character building and cosmetic application

### Scene Flow
- Main Menu → Matchmaking Lobby → Arena → Results
- Menus: Customize, Settings, Shop, Leaderboards (future)

## Technologies

- **Game Engine**: Godot 4.1+
- **Language**: GDScript
- **Rendering**: OpenGL (Mobile Renderer)
- **Audio**: Godot Audio Engine
- **Speech-to-Text**: Google Cloud Speech-to-Text / Azure Speech Services (TBD)
- **Backend**: Multiplayer framework (TBD)

## Development Roadmap

See [DEVELOPMENT_ROADMAP.md](DEVELOPMENT_ROADMAP.md) for detailed phases and tasks.

## License

TBD
