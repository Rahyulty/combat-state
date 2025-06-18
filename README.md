# **PlayerState Module**

## **Overview**

The `PlayerState` module provides a robust, flexible framework for managing player states in Roblox combat and action systems. It abstracts state management using a `Folder` of `BoolValue` instances and offers a clear API for querying, modifying, and monitoring player state. THIS IS SPECIFICALLY MADE FOR MY UPCOMING GAME WHICH IS WHY SOME FUNCTIONS ARE SPECIFIC 

This module enables:

* Direct table-like access to player states.
* Safe modification and querying of state values.
* Standardized composite checks for common player actions (e.g., attacking, dashing).
* Event-driven state change handling.

## **Intended Use**

`PlayerState` is designed for use in combat frameworks, movement systems, and similar contexts where player state must be tracked, updated, and queried efficiently.

---

## **API Reference**

### **Constructor**

---

#### `PlayerState.new(stateFolder: Folder) → PlayerState`

Creates a new `PlayerState` instance based on the contents of `stateFolder`. Each child of `stateFolder` is expected to be a `BoolValue` or similar instance representing a named state.

✅ Provides direct access:

```lua
local blocking = playerState["Blocking"]
playerState["Blocking"] = true
```

##### **Parameters**

* `stateFolder` — A `Folder` instance containing `BoolValue` children representing individual states.

##### **Returns**

* A `PlayerState` instance with metamethod support for direct access and assignment of states.

---

### **Methods**

---

#### `PlayerState:reset(stateFolder: Folder)`

Re-initializes the internal state mapping using a new `stateFolder`. Typically called when a player respawns or their state values are reset.

##### **Parameters**

* `stateFolder` — A `Folder` containing fresh `BoolValue` instances for states.

---

#### `PlayerState:GetObject(name: string) → BoolValue | nil`

Retrieves the underlying `BoolValue` instance for a given state name.

##### **Parameters**

* `name` — The name of the state to retrieve.

##### **Returns**

* The `BoolValue` associated with the name, or `nil` if not found.

---

#### `PlayerState:OnChanged(name: string, callback: (newValue: boolean) → ()) → RBXScriptConnection | nil`

Connects a callback function to the `.Changed` event of a specific state.

##### **Parameters**

* `name` — The name of the state to observe.
* `callback` — A function to invoke when the state’s `Value` changes.

##### **Returns**

* An `RBXScriptConnection` if successful; otherwise `nil` (with a warning logged).

---

#### `PlayerState:canAttack(character: Model) → boolean`

Checks whether the player is in a state that permits attacking.

---

#### `PlayerState:canDash(character: Model) → boolean`

Checks whether the player can perform a dash action.

---

#### `PlayerState:canBlock(character: Model) → boolean`

Checks whether the player can initiate blocking.

---

#### `PlayerState:canRun(character: Model) → boolean`

Checks whether the player can run.

---

#### `PlayerState:canHit(character: Model) → boolean`

Checks whether the player can be hit (i.e., not invulnerable or immune).

---

##### **Parameters (for all utility methods)**

* `character` — The `Model` representing the player's character. These methods check for specific child objects like `"Stun"` or `"TrueStun"` in conjunction with states.

##### **Returns**

* `true` if the action is allowed; otherwise `false`.

---

## **Metamethods**

---

#### `__index`

* Allows direct read access to state values (e.g., `state["Blocking"]` returns the current boolean value).
* Falls back to methods (e.g., `state:canAttack()`).

#### `__newindex`

* Allows direct assignment of state values (e.g., `state["Blocking"] = true`).
* Logs a warning if attempting to set an unknown state.

---

## **Example Usage**

```lua
local stateFolder = player:WaitForChild("States")
local playerState = PlayerState.new(stateFolder)

-- Set state
playerState["Blocking"] = true

-- Get state
if playerState["Blocking"] then
    print(player.Name .. " is blocking.")
end

-- Check composite condition
if playerState:canAttack(player.Character) then
    print(player.Name .. " can attack.")
end

-- Listen for state changes
playerState:OnChanged("Blocking", function(newVal)
    print("Blocking state changed to:", newVal)
end)

-- Reset on respawn
player.CharacterAdded:Connect(function(character)
    local newStateFolder = character:WaitForChild("States")
    playerState:reset(newStateFolder)
end)
```

---

## **Design Philosophy**

* **Safety:** Prevents silent errors when accessing or modifying unknown states.
* **Flexibility:** Works with any `BoolValue`-like objects as states.
* **Performance:** Reduces repetitive checks across combat and movement code by centralizing composite logic.
* **Extensibility:** Easily add custom composite checks or states as needed.

---

## **Warnings**

* The `stateFolder` must contain all expected `BoolValue` instances with correct names before initializing `PlayerState`.
* Any changes to state names must be reflected in utility methods (e.g., `canAttack`).
