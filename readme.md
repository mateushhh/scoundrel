# Scoundrel (Godot)

A digital implementation of the dungeon-crawling card game **Scoundrel**.

## Rules
Survive the dungeon by clearing the deck. You start with **20 Health**.

* **The Room:** 4 cards are dealt. You must play at least **3 cards** to advance to the next room.
* **Running:** You can skip a room (put cards back in the deck) once; you cannot skip two rooms in a row.

### Card Effects
* ♥ **Hearts (Potion):** Heals HP equal to rank (Max 20).
* ♦ **Diamonds (Weapon):** Equips a weapon. Reduces damage from Monsters.
* ♣ ♠ **Clubs & Spades (Monsters):** Deals damage equal to rank.
    * *Combat:* Damage = `Monster Rank` - `Weapon Rank`.
    * *Durability:* You cannot use a weapon on a monster if it is **stronger** than the last monster you killed with that same weapon.

## Source Code Architecture

The project is structured to separate generic card logic from specific game rules, making the assets reusable.

* **`card.gd`** and **`deck.gd`**: Universal scripts. They handle 2D sprites, card creation, shuffling, and basic mouse inputs. They contain **zero** rules specific to Scoundrel.
* **`game.gd`**: Contains the state machine, UI management, and gamerule logic.