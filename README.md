# Bayanihan Res-Q: Scavenge & Dash

> "The faster you dash, the more you save!"

## 🎥 Video Overview

Watch the project overview here: [Bayanihan Res-Q Video Overview](https://youtu.be/M1R4Uc-STFo)

## 🎮 Game Summary

* **Genre:** Fast-Paced Action Puzzler / Vertical Scavenger-Runner
* **Target Audience:** General (Ages 7+)
* **Platform:** Mobile (Portrait, Single-Handed Control)
* **Developer:** BSEMC 1A - WVSU/CICT

**Bayanihan Res-Q** is a student-built mobile game project developed by college students. The goal is to create an action game that’s **fun to play** while also teaching **young players** the basics of disaster preparedness, smart relief distribution, and the spirit of **bayanihan**.

In Bayanihan Res-Q, you are a "Hero on the Road"—part of a specialized emergency response unit. Disaster has struck the region, leaving countless communities in urgent need of aid. But this is no standard delivery mission. The roads are chaotic, and you enter the crisis empty-handed. In flooded areas, your rescue truck can switch into a rescue boat so you can continue the mission across water-heavy zones.

## 🧠 Learning Objectives (Kid-Friendly)

By playing (and repeating runs), young players should gradually learn to:

* **Recognize common disasters in the Philippines:** typhoons, floods, earthquakes, and volcanic eruptions.
* **Prioritize essentials:** choose the right combination of rice, water, and medicine under pressure.
* **Understand “right aid, right time”:** wrong items waste space and slow down real relief operations.
* **Stay calm and make fast decisions:** accuracy matters as much as speed.

## 👧🧒 Target Players & Accessibility

* **Controls:** portrait, single-handed lane switching.
* **Readability:** icons-first UI; minimal reading required during gameplay.
* **Comfort options (recommended):** reduced screen shake, adjustable SFX/music, high-contrast UI mode.

## The Challenge

Your truck is racing at high speed into the disaster zone! As you dash along the winding, 3-lane road, essential relief goods (Rice, Water, Meds) will appear as "pickups" on the road lanes, having been strategically airdropped by logistics teams. When flood segments appear, the vehicle can switch from truck mode to boat mode to keep moving through deep water. You must manually lane-switch rapidly, weaving left and right to active-collect the exact combo of resources needed by the flashing Barangay demand icons at the top of your screen.

## Look Out!

But the road is dangerous. The SAME lanes that hold resources are also full of treacherous Hazards (Flooded Potholes) and Hard Blocks (Collapsed Roads, Debris).

* 🟢 **Resources:** Successfully collect these to build the perfect "Res-Q Pack."
* 🟡 **Hazards:** Hitting water or mud gives you a temporary speed penalty.
* 🔴 **Hard Blocks:** Hitting a fallen tree will reduce your truck’s Durability. Hit 3, and your mission fails (Truck Breakdown)!

## ⚡ Power-Ups & Fuel

Airdrop teams don't only deliver relief goods — they also scatter special items to keep your truck in the fight!

* 🟢 **Shield Power-Up:** Absorbs the next Hard Block hit completely, saving a point of Durability. Appears as a green diamond on the road.
* 🟠 **Speed Boost Power-Up:** Instantly increases your truck's speed for a burst of momentum. Appears as an orange diamond.
* 🟣 **Fuel Canister:** Your truck runs on a finite fuel tank that drains continuously as you race. Pick up purple fuel canisters scattered on the road to keep the engine going — running out of fuel ends your mission immediately!

> **Tip:** Fuel canisters and power-ups are rarer than resources, so plan lane-switches carefully. Always prioritize fuel when the gauge turns red!

## 🔁 Core Gameplay Loop (30 Seconds)

1. **Dash forward** on a 3-lane road.
2. **Collect resources** (Rice/Water/Meds) by switching lanes at the right time.
3. **Avoid hazards and blocks** to preserve speed and durability.
4. **Manage cargo** (capacity changes per level) and dump wrong items if needed.
5. **Match a Barangay’s demand** exactly to complete a delivery and score higher.
6. **Survive longer** as difficulty and disaster events increase the challenge.


## Scavenge Smartly

Your truck’s **cargo capacity changes per level**, so you’ll need to adapt your strategy each run. You can miss crucial items, and you can mistakenly pick up unwanted items. Picking up the wrong resource takes up valuable space! Use the single-button "Dump Cargo" mechanic to jettison unwanted cargo—this saves your inventory, but costs valuable time. You must reach the Barangay with the exact match of demand to fulfill the Quest and score maximum points.

Bayanihan Res-Q isn't just a game of speed; it's a game of split-second accuracy and reflex under pressure!

## 🎨 Design Goals & Community Impact

1. **Accessible Education:** By focusing on reflex and matching, we made a complex topic (disaster response) friendly and engaging for kids, teaching the importance of community support (Bayanihan) in a crisis.
2. **Data with Dignity:** We moved away from cold, numbers-only data, visualizing the human need through personalized "SMS Alerts" from residents.
3. **Real-World Lessons:**
	* **The Right Aid:** The game strictly penalizes "Wrong Item" collection to teach students that unsolicited/wrong donations can clog up relief efforts in real life.
	* **Efficiency under Pressure:** The core loop teaches split-second decision-making: "Do I risk the flood to get that rare medicine, or stay safe?"

## 🌪️ Random Disaster Events (Philippines)

To keep each run unpredictable (and grounded in real local risks), the game includes **random events** inspired by disasters common in the Philippines. Events should be **short**, **clearly telegraphed**, and **fair** (players should understand what changed and why they got hit).

Examples (tune during playtests):

* **Typhoon**
	- Visuals: stronger rain/wind, darker sky, occasional lightning.
	- Gameplay: reduced visibility, more debris patterns, slightly increased hazard frequency.
	- Audio: wind layers + rain intensity ramp.
* **Flooding**
	- Visuals: more water pooling and muddy sections.
	- Gameplay: more slow zones and “flooded pothole” hazards; deeper water segments trigger a truck-to-boat switch so players can traverse flooded areas; safe lanes still exist (avoid unavoidable damage).
	- Audio: water splashes and muffled ambience.
* **Earthquake / Aftershocks**
	- Visuals: brief camera shake (optionally reduced), dust puffs, new cracks/debris.
	- Gameplay: short aftershock moments that reshuffle obstacle patterns (telegraphed with rumble + dust).
	- Audio: rumble + impact cues.
* **Volcanic Eruption / Ashfall**
	- Visuals: ash particles, hazy air, darker palette.
	- Gameplay: periodic ash clouds that reduce visibility; falling debris as hard blocks.
	- Audio: distant rumbles + falling grit.
* **Other local hazards (optional)**
	- Landslides, storm surge, road collapses, etc., as long as they remain readable and balanced.

## 🛠️ Student Group Roles (Game Development)

Building this game is a class-wide collaboration. Students are organized into the following roles:

- **Group 1: Rescue Vehicle / Rescue Boat Design**
	- Design the main rescue vehicle(s) and rescue boat as usable game-ready assets (silhouette, proportions, readable at phone size).
	- Create the visual states needed for gameplay feedback (idle, movement, impact, shielded, low durability, etc.).
	- Define how the vehicle communicates gameplay info through visuals (pickup “magnet” area hint, durability cues, speed boost FX attachment points).
	- Deliverables: sprite sheets / textures (or 2D/3D assets), animation list, color palette, and export-ready files for Godot.

- **Group 2: Earthquake Environment**
	- Build the earthquake-themed environment look (cracked roads, rubble, fallen posts, dust, broken signage) that fits the Philippines setting.
	- Design earthquake event variations that affect difficulty (lane debris patterns, aftershock screen shake, temporary visibility dust).
	- Specify hazard/block visuals so players can read them instantly at high speed (clear shapes, strong contrast, consistent hitboxes).
	- Deliverables: tile/prop set, background/parallax layers, earthquake event art/VFX list, and example “pattern” sketches for spawners.

- **Group 3: Flood/Typhoon Environment**
	- Create flood and typhoon visuals: rain intensity, wind-driven debris, rising water, puddles/mud, and stormy sky layers.
	- Define how flood hazards behave in-game (slow zones, slippery sections, waterlogged potholes) and how they are telegraphed.
	- Propose typhoon random-event effects (reduced visibility, stronger hazard frequency, gust FX, lightning flashes) while staying fair.
	- Deliverables: water/mud tiles, rain/wind VFX assets, parallax backgrounds, and a short “event rules” sheet for developers.

- **Group 4: Volcanic Eruption Environment**
	- Design a volcanic eruption environment set: ashfall, darkened skies, lava glow accents, falling rocks, and evacuation signage.
	- Plan eruption event phases (calm → ashfall → heavier debris) that progressively change hazards and atmosphere during a run.
	- Create readable hazard art for eruption-specific obstacles (hot debris, ash clouds, blocked roads), consistent with gameplay hit rules.
	- Deliverables: volcanic tiles/props, ash/debris VFX list, background layers, and eruption phase reference frames.

- **Group 5: Sound Design**
	- Create the game’s audio identity: UI clicks, pickup sounds, hazard hits, block crashes, shield/speed/fuel sounds, and ambience.
	- Build event-based audio layers for random disasters (rain/wind for typhoon, rumble for earthquake, ashfall/debris for eruption).
	- Define mixing priorities so gameplay remains readable (alerts and critical feedback cut through ambience; avoid ear fatigue).
	- Deliverables: SFX set (normalized), ambience loops, simple audio-mix notes, and naming conventions for easy integration.

- **Group 6: Developers**
	- Implement gameplay systems in Godot 4: movement/lane switching, spawning/pattern logic, inventory, demand matching, scoring, and fail states.
	- Integrate environments and random events so they modify visuals/hazards/audio via reusable systems (signals, timers, difficulty scaling).
	- Maintain the project structure and build stability (scene organization, naming conventions, version control hygiene, merge conflict resolution).
	- Deliverables: working scenes/scripts, event system hooks, integration of assets from other groups, and playable builds for feedback.

- **Group 7: Game UI Design**
	- Design the portrait mobile UI: demand icons, cargo slots, durability, fuel, score, and the “SMS Alert / News Ticker” readability.
	- Create clear feedback for success/failure (matched delivery, wrong item, low fuel, durability warnings) with minimal screen clutter.
	- Provide UI states for random events (event banner, subtle warnings, accessibility-friendly colors/contrast).
	- Deliverables: UI layout mockups, UI asset pack (icons, frames, bars), and a style guide (type sizes, spacing, colors).

## ✅ Milestones (Suggested for Student Teams)

* **Milestone 1: Vertical Slice**
	- One playable run loop (movement → pickups → hazards → delivery match → fail state).
* **Milestone 2: One Event End-to-End**
	- Implement 1 random disaster event with visuals + gameplay effect + sound layer.
* **Milestone 3: UI + Feedback Pass**
	- Make sure kids can understand what happened (clear warnings, clear success/fail feedback).
* **Milestone 4: Audio Pass**
	- Add core SFX + one ambience layer per environment.
* **Milestone 5: Classroom Playtest Build**
	- A stable build for testing and iteration.

## 🧪 Playtesting With Kids (Quick Checklist)

* Can a new player explain the goal after **10 seconds**?
* Do they understand why collecting the **wrong item** is bad?
* Are hazards readable at speed (shape + color + consistent behavior)?
* Does it feel challenging but still **fun** (not punishing)?
* Are comfort options available (reduced shake, volume control)?

## 🤝 Student Dev Workflow (Suggested)

* **Single source of truth:** keep requirements in this README (update as decisions change).
* **Asset handoff:** each art/audio group provides export-ready files + a short “integration notes” sheet.
* **Naming conventions:** consistent names for events, hazards, and resources (e.g., `event_typhoon`, `hazard_flood_pothole`).
* **Integration cadence:** set a weekly merge day where Developers integrate new assets and produce a playable build.

## 🚀 Technical Implementation (Godot 4)

* **Resolution:** Optimized for Portrait (1080x1920, 9:16 aspect ratio) for single-hand mobile play.
* **Physics:** Uses Area2D extensively for both collecting and crashing, ensuring lightweight physics calculation.
* **Communication:** Groups work independently by emitting and listening to standardized Signals (signal `resource_collected(type)`), preventing dependency conflicts during code merges.