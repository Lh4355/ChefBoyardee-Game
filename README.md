# Chef Boyardee Simulator

A humorous adventure game built with LÖVE 2D where you play as a sentient can of Chef Boyardee ravioli navigating various locations, managing your can's health, and completing minigames to survive your journey.

## Installation

### Requirements
- [LÖVE 2D](https://love2d.org/) (version 11.0 or higher)

### Setup
1. Clone or download this repository
2. Navigate to the project directory
3. Run the game with: `love .`

For detailed installation instructions, see [Installation_Steps.md](Installation_Steps.md)

## How to Play

### Objective
Explore locations, manage your can's health, complete minigames, and reach the end of your adventure.

### Controls
- **Arrow Keys** - Move around
- **Mouse Click** - Interact with objects and NPCs

### Gameplay
- **Explore** - Visit different locations and discover NPCs and items
- **Manage Health** - Your can's condition affects gameplay; keep it in good shape
- **Complete Minigames** - Engage in click-based challenges to progress
- **Collect Items** - Find items that help you on your journey
- **Win Condition** - Navigate through all locations to win the game

## Features

- Full state management system (Menu, Explore, GameOver, Won states)
- Dynamic location-based exploration with interactive nodes
- Audio manager with music and sound effect support
- HUD system displaying player status and inventory
- Minigame framework (click-based fillers)
- Event and interaction system for NPCs
- Sprite-based rendering with location backgrounds

## Project Structure

```
src/
├── constants.lua          # Game constants and configuration
├── utils.lua              # Utility functions
├── data/                  # Game data and assets
│   ├── items.lua          # Item definitions
│   ├── map_nodes.lua      # Map node data
│   ├── nodes.lua          # Node configurations
│   ├── audio/             # Audio files
│   ├── fonts/             # Font files
│   └── images/            # Image assets
├── entities/              # Game object definitions
│   ├── item.lua           # Item entity
│   ├── node.lua           # Location node entity
│   └── player.lua         # Player character entity
├── minigames/             # Minigame implementations
│   └── click_filler.lua   # Click-based minigame
├── states/                # Game state modules
│   ├── menu.lua           # Main menu state
│   ├── explore.lua        # Exploration state
│   ├── gameover.lua       # Game over state
│   └── game_won.lua       # Victory state
└── system/                # Core game systems
    ├── audio_manager.lua  # Audio control and playback
    ├── events.lua         # Event system
    ├── game_state.lua     # State management
    ├── hud.lua            # Heads-up display
    ├── initialization.lua # Game initialization
    ├── input_manager.lua  # Input handling
    ├── interactions.lua   # NPC/object interactions
    ├── scene_renderer.lua # Rendering and UI
    └── volume_widget.lua  # Volume control UI
```

## Development

### Current Status
This project is in active development (Clean-Up branch). See [Backlog.md](Backlog.md) for planned features and improvements.

### Key Areas
- **Code Cleanup** - Removing redundancy and improving modularity
- **Feature Expansion** - Implementing map system, save functionality, and additional minigames
- **Content Addition** - Expanding locations, events, and NPCs

### Contributing
See [Change_Log.md](Change_Log.md) for recent updates and changes.

## License

This project is created for educational and entertainment purposes.
