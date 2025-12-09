

Day 1 (11/30/2025):
- Installed Love2D and extenstions
- Set up github repo (this created default README.md and .attributes files)
- created a .vscode file with launch.json and settings.json files to run the code with "love ."
- created conf.lua file to configure game settings for title bar and game window size
- put test code in main.lua (allows you to press d to move a square to the side)


Day 2 (12/1/2025):
- No work


Day 3 (12/2/2025):
- Added nodes for map (still incomplete)


Day 4 (12/3/2025):
- Fixed node names
- Load node into main.lua
- Navigation through nodes via entering the node ID number via main.lua
- Set up an image (should work when i add image paths to all nodes), still needs pixelated
- Added inventory and item logic
- Made test clickable item
- Nodes are now navigated by clicking on the node name
- Inventory can be navigated by pressing keys 1-8 (I want to change this so that it is clickable)


Day 5 (12/4/2025):
- Added more images and another image folder
- Added Has_Item function
- Started Main menu screen
- Created separate player class and moved logic over from main
- Added health and damage logic


Day 6 (12/5/2025):
- Added event and interaction logic
- Health bar added to screen
- Gameover screen when you hit 0 health
- Organized files into structured folders
- Added background and font to main menu
- Added music


Day 7 (12/6/2025):
- Styled the GUI and HUD 
- Shelf wobble minigame added for node 1
- Added can images to sprites folder for gold and normal cans
- Broke up the explore file into smaller files
- Scaled down nodes (commented them out)
- Finished adding location images for scaled down node map


Day 8 (12/7/2025):
- Added last intersection image
- Added funtional jewelry story robbery with a chance to miss it and changing images.
- Added puting out the dumpster fire to get key and unlock front door
- Moved more code of out of explore.lua and put it into utils.lua and game_state.lua (dumpster fire and robbery made it too crowded)
- Moved item logic to items.lua and added more files to clean up the main logic and handle audio, initialization, and updated game_state to switch between states of the game
- Added chance to take damage on scary_highway and steep_hill
- Added arrows for navigation
- Fixed issue where additional health was taken when entering aisle_floor node
- Fixed issue where you could not access the living through the kitchen if the the front door was locked
- Added path to exit living room to the front porch
- Added win screen and button to go back to the main menu
- Added recycling bin interaction
- Added descriptions to nodes and displayed them
- volume slider

Day 9 (12/8/2025):
- Added sprite images for items and interactables
- Added sprite images in inv slots
- Finished node descriptions
- fixed bigs/issues and various backlog tasks

Day 10 (12/9/2025):
- Cleaned up code files and comments
- Changed gameover screen text
- moved loadfont function to utils.lua
- Event messages now display at correct times
