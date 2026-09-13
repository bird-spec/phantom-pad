# phantom pad

this is the pcb for my phantom macropad. it's a little keyboard that doubles as a controller for my drone. twelve mechanical keys in a 3x4 matrix plus two rotary encoders, all running off a seeed xiao

the whole point is one board that's both a keyboard and a flight controller. rotate the encoders for throttle and yaw, and the four keys around each one act like a d-pad for direction. slide the top section off and it's just a normal macropad again

it's a two layer board. i wired the switches in a matrix so twelve keys only need seven pins instead of twelve, which left enough pins free for the two encoders. every switch has a diode so pressing three keys at once doesn't register a fourth one that isn't pressed

this was my first pcb ever. i learned kicad from nothing to make it. the hardest part was the routing, and figuring out that a matrix needs the rows and columns to actually reach the microcontroller, which sounds obvious but isn't when you're staring at a wall of green lines

made with the seeed xiao, cherry mx footprints, and alps ec11 encoders. firmware runs on qmk

<img width="1917" height="1015" alt="Screenshot 2026-08-29 190821" src="https://github.com/user-attachments/assets/b0bf280d-cda5-41aa-8e87-9c59bce1b63d" />

 
