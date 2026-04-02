# Bayanihan Res-Q: Scavenge & Dash

> "The faster you dash, the more you save!"

## 🎮 Game Summary

* **Genre:** Fast-Paced Action Puzzler / Vertical Scavenger-Runner
* **Target Audience:** General (Ages 7+)
* **Platform:** Mobile (Portrait, Single-Handed Control)
* **Developer:** [Your Class Name/School] - Western Visayas Development Team

In Bayanihan Res-Q, you are a "Hero on the Road"—part of a specialized emergency response unit. Disaster has struck the lush Panay Region, leaving countless communities in urgent need of aid. But this is no standard delivery mission. The roads are chaotic, and you enter the crisis empty-handed.

## The Challenge

Your truck is racing at high speed into the disaster zone! As you dash along the winding, 3-lane road, essential relief goods (Rice, Water, Meds) will appear as "pickups" on the road lanes, having been strategically airdropped by logistics teams. You must manually lane-switch rapidly, weaving left and right to active-collect the exact combo of resources needed by the flashing Barangay demand icons at the top of your screen.

## Look Out!

But the road is dangerous. The SAME lanes that hold resources are also full of treacherous Hazards (Flooded Potholes) and Hard Blocks (Collapsed Roads, Debris).

* 🟢 **Resources:** Successfully collect these to build the perfect "Res-Q Pack."
* 🟡 **Hazards:** Hitting water or mud gives you a temporary speed penalty.
* 🔴 **Hard Blocks:** Hitting a fallen tree will reduce your truck’s Durability. Hit 3, and your mission fails (Truck Breakdown)!

## Scavenge Smartly

You have limited inventory slots in your truck bed. You can miss crucial items, and you can mistakenly pick up unwanted items. Picking up the wrong resource takes up a valuable slot! Use the single-button "Dump Cargo" mechanic to jettison unwanted cargo—this saves your inventory, but costs valuable time. You must reach the Barangay with the exact match of demand to fulfill the Quest and score maximum points.

Bayanihan Res-Q isn't just a game of speed; it's a game of split-second accuracy and reflex under pressure!

## 🎨 Design Goals & Community Impact

1. **Accessible Education:** By focusing on reflex and matching, we made a complex topic (disaster response) friendly and engaging for kids, teaching the importance of community support (Bayanihan) in a crisis.
2. **Data with Dignity:** We moved away from cold, numbers-only data, visualizing the human need through personalized "SMS Alerts" from residents.
3. **Real-World Lessons:**
    * **The Right Aid:** The game strictly penalizes "Wrong Item" collection to teach students that unsolicited/wrong donations can clog up relief efforts in real life.
    * **Efficiency under Pressure:** The core loop teaches split-second decision-making: "Do I risk the flood to get that rare medicine, or stay safe?"

## 🛠️ The "Department Model" Group Assignments

Building this game required the synchronized efforts of 30+ students working as functional departments. This is how the class was structured:

| Group | Department | Task | Primary Godot Node Focus |
| --- | --- | --- | --- |
| Logistics Tech | The Matchmaker (Engine) | Codes the "Demand Match" logic. Compares the Current Inventory (from UI) against the Barangay Demand (from Spawner) to calculate success or failure signals. | Singleton (Global), Signal |
| Map & Intel | The World (Level Design) | Uses Godot's TileMap and ParallaxScrolling to dynamically generate an infinite, stylized road system that flows downwards. They create the base layers (road, water, grass). | TileMap, ParallaxLayer |
| The "Events" Team | The Spawner (Storyteller) | Design and spawn logical "patterns" of road items: resources, hazards (water), and blocks (debris). They balance the "Rarity"—e.g., Medicine is rare, Rice is common. | Area2D (for triggers), RandomNumberGenerator |
| Inventory UI | The Dashboard (Interface) | Design the single-hand portrait control panel. Create the dynamic HBoxContainer for the 3 visual cargo slots, the Durability progress bar, and the "SMS News Ticker" at the bottom. | HBoxContainer, ProgressBar, Anchor |
| Fleet Group | The Magnet (Units) | Codes the 3-lane horizontal snapping movement logic. Programs the truck's "Pick-up Area." When the truck overlaps a resource, it adds the item to the inventory list and triggers collection animations. | Area2D (for collection), move_and_slide() or Tween (for lane movement) |

## 🚀 Technical Implementation (Godot 4)

* **Resolution:** Optimized for Portrait (1080x1920, 9:16 aspect ratio) for single-hand mobile play.
* **Physics:** Uses Area2D extensively for both collecting and crashing, ensuring lightweight physics calculation.
* **Communication:** Groups work independently by emitting and listening to standardized Signals (signal `resource_collected(type)`), preventing dependency conflicts during code merges.