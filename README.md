# svstudio-scripts
 
Scripts for Synthesizer V Studio Pro.

## Microtonal

There were no SynthV scripts I could find that allowed for microtonal composition. So I whipped these up with zero prior knowledge of Lua or Javascript. Don't expect me to do magic here.

I recommend binding these to shortcuts to make the process significantly faster.

By default, the EDO note scripts use 31-EDO. You can change the EDO in the script to whatever you prefer.

Existing Pitch Deviation points will be kept and adjusted by the cent difference.

The Pitch Deviation is not smoothed out and has sudden jumps. If the Pitch Deviation is too large, this can be noticeable.

These scripts cannot tell if you use Note Detuning, so avoid using those if you plan on using these scripts.

### Microtonal - Nearest EDO Note

This script adjusts the Pitch Deviation based the nearest note of EDO.

By default, the EDO is tuned on A, with A4 being tuned in the Voice settings.

This is intended to be used first, before the other scripts. This will do nothing if any of these scripts have already been run. If you need to run this script again, you can delete either of the points at the end.

### Microtonal - Next EDO Note

This script raises the Pitch Deviation by one EDO step.

### Microtonal - Previous EDO Note

This script lowers the Pitch Deviation by one EDO step.

### Microtonal - Next SynthV Note

This script raises the SynthV Note, and lowers the Pitch Deviation by an equal amount.

### Microtonal - Previous SynthV Note

This script lowers the SynthV Note, and raises the Pitch Deviation by an equal amount.

### Microtonal - Add Cent Difference

This script raises the Pitch Deviation by any specified cent difference.
