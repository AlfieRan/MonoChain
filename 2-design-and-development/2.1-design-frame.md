# 2.1 Design Frame

## Systems Diagram

![My design frame](<../.gitbook/assets/Design Frame (1).jpg>)

The diagram above shows the major sectors of this project that I will be creating through out development. The diagram is split into three major sections that then have their own sub-sections to help simplify each part.&#x20;

The main sections are the following:

1. The Protocol - This is a summary for how the computers on the network will interact, construct data and validate it in order to create what will be known as the MonoChain.
2. The Web-portal - This is the website that will allow users to interact with the MonoChain through a few basic functions which are shown in the diagram.
3. The Node Software - This is what people who want to contribute to the MonoChain through the validating of transactions and data in order to "mine" coins on the network will use on their computers/servers.

Throughout the development stage I will initially focus mainly on the Node Software and the Protocol, and then once they are up to the point at which the network somewhat works I will also start developing the webportal as when the network doesn't work the portal doesn't have much of a use. I have also decided to break down the diagram into those specific subsections in order to roughly align with the[ Success Criteria](../1-analysis/1.5-success-criteria.md).

## Usability Features

Usability is an essential aspect to my project as I want it to be usable and understandable to both developers who have a prior understanding of blockchain technology and non-developers who have never used it before.





\===== end of me =====







### Effective

Users can achieve the goal with completeness and accuracy. To do this, I will make it easy for the players to realise that they need to reach a goal in order to complete a level. I will make this goal clear to see so there is no confusion over where the players need to go.

#### Aims

* Create a clear goal to reach to determine the end of a level
* Create a clear goal for any multiplayer modes

### Efficiency

The speed and accuracy to which a user can complete the goal. To do this, I will create a menu system which is easy to navigate through in order for to find what you are looking for. The information which is more important can be found with less clicks.

#### Aims

* Create a menu system that is quick and easy to navigate through
* Create a controls system that isn't too complicated but allows the player to do multiple actions

### Engaging

The solution is engaging for the user to use. To do this, I will create 5 levels and an online multiplayer mode to keep the players engaged and allow them to have fun while playing the game. Using vector style art will also make the game nicer to look at than blocks, so will draw more people in, keeping them engaged.

#### Aims

* Create a series of levels to work through
* Create a multiplayer mode to play
* Incorporate a style of game art the suits the game

### Error Tolerant

The solution should have as few errors as possible and if one does occur, it should be able to correct itself. To do this, I will write my code to manage as many different game scenarios as possible so that it will not crash when someone is playing it.

#### Aims

* The game doesn't crash
* The game does not contain any bugs that damage the user experience

### Easy To Learn

The solution should be easy to use and not be over complicated. To do this, I will create simple controls for the game. I will make sure that no more controls are added than are needed in order to keep them as simple as possible for the players.

#### Aims

* Create a list of controls for the game
* Create an in-level guide that helps players learn how to play the game

## Pseudocode for the Game

### Pseudocode for game

This is the basic layout of the object to store the details of the game. This will be what is rendered as it will inherit all important code for the scenes.

```
object Game
    type: Phaser
    parent: id of HTML element
    width: width
    height: height
    physics: set up for physics
    scenes: add all menus, levels and other scenes
end object

render Game to HTML web page
```

### Pseudocode for a level

This shows the basic layout of code for a Phaser scene. It shows where each task will be executed.

```
class Level extends Phaser Scene

    procedure preload
        load all sprites and music
    end procedure
    
    procedure create
        start music
        draw background
        create players
        create platforms
        create puzzle elements
        create enemies
        create obstacles
        create finishing position
        create key bindings
    end procedure
    
    procedure update
        handle key presses
        move player
        move interactable objects
        update animations
        check if player at exit
    end procedure
    
end class
```
