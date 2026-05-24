# Ghost Recon Breakpoint — ReShade Preset Pack

A ready-to-use ReShade 6.7.3 setup for **Tom Clancy's Ghost Recon Breakpoint** with **14 hand-picked presets** and a curated shader library already installed. Drag, drop, launch.

---

## TL; DR

1. Download [GhostRecon.Breakpoint.Reshades-v2.zip](https://github.com/mindattic/GhostRecon.Breakpoint.Reshades/releases/download/v2/GhostRecon.Breakpoint.Reshades-v2.zip)
2. Extract to directory containing `GRB.exe` 
3. Run `ReShade_Setup_6.7.3.exe`
4. Select `GRB.exe`
5. Run `GRB.exe`
6. Press `Home` to open Reshade UI

---

## What's inside

| Path                    | What it is                                                       |
| ----------------------- | ---------------------------------------------------------------- |
| `dxgi.dll`              | ReShade 6.7.3 runtime (the injector itself)                      |
| `ReShade.ini`           | ReShade config, pre-pointed at the `Presets\` folder             |
| `Presets/`              | 14 preset `.ini` files — show up in the in-game dropdown         |
| `reshade-shaders/`      | The full shader/texture library every preset needs               |
| `Presets/ReShade_Setup_6.7.3.exe` | Official ReShade installer (fallback)                  |

### Included presets

Each preset is named after the visual change it applies. Pick the look you want; the name tells you what's active.

| Preset | What it does |
| --- | --- |
| `Vanilla (No Effects).ini` | Empty Techniques line — game renders untouched. Use this to compare against vanilla. |
| `Natural - LUT + Ambient Light + Soft Grain.ini` | Subtle natural color grade via LUT, soft film grain, vignette, ambient-light boost. |
| `Ultimate - Punchy Contrast + Vibrance + Clarity.ini` | All-purpose: bumped contrast, vibrance, Technicolor punch, clarity sharpening. |
| `Photoreal Balanced (Dual Bloom + Dual LUT).ini` | TheWhiteOne preset. Dual bloom + dual LUT + GSFX tonemap. Neutral photoreal. |
| `Photoreal Colorful (Technicolor Boost).ini` | Balanced + Technicolor2 for saturated greens/blues. |
| `Photoreal Grim & Dark.ini` | Balanced tuned darker — moody, low-key. |
| `Photoreal Lush Greens (Selective Color).ini` | Balanced + PD80 Selective Color pushing jungle greens. |
| `Nommad - Cinetools LUT + MXAO + Bloom.ini` | Cinematic LUT + Marty's MXAO + PD80 bloom. |
| `Cinematic Realism (AO + Reflections + Motion Blur).ini` | Heavy stack: MXAO, qUINT SSR, HDRMotionBlur, FilmicPass. |
| `Perception - Heavy DoF + Multi-Bloom Cinematic.ini` | 16 active effects including CinematicDOF and multi-pass bloom. |
| `Stylized 2.0 - Filmic + Fisheye + Sharpen.ini` | FilmicPass + horizontal fisheye distortion + Glamayre sharpen. |
| `New Dawn - Filmic DPX + Depth Cues.ini` | Filmic tonemap, DPX film negative, depth-based contrast (RTGI optional). |
| `Wildlands - Lightroom Color Grade Only.ini` | Single effect: qUINT Lightroom for minimal color grading. |
| `nedaK - DPX Cinema + Tilt-Shift + Vibrance.ini` | Film-camera DPX look with tilt-shift focus simulation. |

---

## Installation (drag-and-drop, ~30 seconds)

1. **Find your Ghost Recon Breakpoint install folder.** This is the folder containing `GRB.exe`. Most common locations:
   - Steam: `...\Steam\steamapps\common\Ghost Recon Breakpoint\`
   - Ubisoft Connect: `...\Ubisoft\Ubisoft Game Launcher\games\Tom Clancy's Ghost Recon Breakpoint\`
2. **Download this repo as a ZIP** (green **Code** button → **Download ZIP**) and extract it.
3. **Copy everything from the extracted folder into your game folder.** When asked about merging folders, click **Yes / Replace**. You should now see `dxgi.dll`, `ReShade.ini`, `Presets\`, and `reshade-shaders\` next to `GRB.exe`.
4. **Launch the game.** Both `GRB.exe` (DX11) and `GRB_vulkan.exe` (D3D12 under the hood) work — `dxgi.dll` hooks DXGI for both.

### If drag-and-drop doesn't work

Some installs (especially Ubisoft Connect) overwrite or block `dxgi.dll`. In that case:

1. Delete the `dxgi.dll` you just dropped in.
2. Run `Presets/ReShade_Setup_6.7.3.exe`.
3. Click **Browse** → select `GRB.exe`.
4. Select **DirectX 10/11/12** as the rendering API.
5. When asked about shaders, **skip / cancel** the download — we already provide them.
6. Finish the installer, then re-copy `Presets\` and `reshade-shaders\` if they got removed.

---

## Using the presets in-game

1. Launch the game.
2. Wait for the title screen.
3. Press **Home** to open the ReShade overlay.
4. *First launch only:* ReShade compiles all shaders. Progress bar at the top — takes **1–2 minutes**. Don't alt-tab repeatedly. Future launches are instant (cached).
5. At the top of the overlay, click the **preset dropdown** to switch between the 14 presets.
6. Toggle individual effects on/off in the list below the dropdown.
7. Press **Home** again to close the overlay.

### Useful shortcuts

| Key      | Action                                            |
| -------- | ------------------------------------------------- |
| **Home** | Open / close the ReShade overlay                  |
| **PrtSc**| Save a screenshot to the game folder              |

In **Settings** tab → assign **Previous preset key** / **Next preset key** to cycle without opening the overlay.

---

## Notes

- **RTGI**: `New Dawn` references `qUINT_rtgi.fx`, which is Marty McFly's paid Patreon shader. ReShade silently skips it if missing; the rest of New Dawn still works. To enable RTGI, get it from [martymods.com](https://www.martysmods.com/) and drop the .fx into `reshade-shaders/Shaders/`.
- **FPS**: heavier presets (Cinematic Realism, Perception, Photoreal *) use MXAO, DoF, multi-pass bloom. If FPS drops, open the overlay and toggle off the most expensive effects. Lightest presets: `Vanilla`, `Wildlands - Lightroom Only`, `Ultimate`, `Natural`.
- **Uninstall**: delete `dxgi.dll`, `ReShade.ini`, `ReShade.log`, `Presets/`, `reshade-shaders/` from the game folder.

---

## Credits

### Preset authors

- **Natural LUT Preset** — Nexus Mods #1416
- **Nommad Reshade** by Nommad — Nexus Mods #414
- **UltimatePreset** — Nexus Mods #1798
- **TheWhiteOne Photorealistic Reshade** — Nexus Mods #716 (4 variants)
- **Apexass222**, **Auroan Wildlands**, **NEWDAWN**, **New 2.0**, **Perception**, **nedaK's GRB Preset** — community presets

### Shader libraries

- [ReShade](https://reshade.me) by crosire — BSD 3-Clause
- [crosire/reshade-shaders (legacy)](https://github.com/crosire/reshade-shaders/tree/legacy) — AmbientLight, Bloom, FilmicPass, MagicBloom, etc.
- [CeeJayDK/SweetFX](https://github.com/CeeJayDK/SweetFX) — CAS, FilmGrain, Levels, Vibrance, Vignette, Curves
- [prod80/prod80-ReShade-Repository](https://github.com/prod80/prod80-ReShade-Repository) — PD80_* color grading suite
- [martymcmodding/iMMERSE](https://github.com/martymcmodding/iMMERSE) & [/qUINT](https://github.com/martymcmodding/qUINT) — Pascal Gilcher's effects
- [BlueSkyDefender/AstrayFX](https://github.com/BlueSkyDefender/AstrayFX) & [/Depth3D](https://github.com/BlueSkyDefender/Depth3D) — Clarity, Smart_Sharp, SuperDepth3D
- [FransBouma/OtisFX](https://github.com/FransBouma/OtisFX) — CinematicDOF
- [luluco250/FXShaders](https://github.com/luluco250/FXShaders) — AdaptiveTonemapper, MagicHDR, NeoBloom, TiltShift
- [LordOfLunacy/Insane-Shaders](https://github.com/LordOfLunacy/Insane-Shaders) — Dehaze, ReVeil, Halftone
- [AlucardDH/dh-reshade-shaders](https://github.com/AlucardDH/dh-reshade-shaders) — DH_Ambient_Remove
- [AlexTuduran/FGFX](https://github.com/AlexTuduran/FGFX) — Perceptual irradiance
- [papadanku/CShade](https://github.com/papadanku/CShade) — CAS, FXAA, Letterbox
- [rj200/Glamarye_Fast_Effects_for_ReShade](https://github.com/rj200/Glamarye_Fast_Effects_for_ReShade) — Glamayre Fast Effects
- [mj-ehsan/NiceGuy-Shaders](https://github.com/mj-ehsan/NiceGuy-Shaders) — SlowSharp
- [Not-Smelly-Garbage/OldReshadeShaders](https://github.com/Not-Smelly-Garbage/OldReshadeShaders) — Archived classic shaders
- Plus additional community packs: Daodan, GShade-Shaders, Anagrama, Barbatos, METEOR, Lumenite, Zenteon, Warp-FX, CorgiFX, Pumbo, etc.

All shaders are bundled under their original licenses (mostly MIT, BSD, or "free for non-commercial use"). Credit goes to the authors above — none of this exists without their work.

---

## License

This repo is a personal-use convenience bundle. ReShade is BSD 3-Clause. Individual shaders carry their authors' own licenses — check each repo's LICENSE file for specifics.
