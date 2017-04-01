# godot-SpaceDynamics
![logo](https://github.com/Toshiwoz/godot-SpaceDynamics/blob/master/icon.png)

I am creating a series of tools to help create star systems and other space dynamic objects within Godot Engine

For orbits representation I'll be using AU (149.597.870.700 meters) as measurement unit

Todos:

- [x] implement Navigation GUI
	- [x] Object Name
	- [ ] Object Type
	- [ ] Target position indicator
	- [ ] plot orbit path
	
- [ ] implement orbits algorythm
	- [ ] Spherical orbit
	- [ ] Elliptical orbit
	- [ ] Comet-like orbit
	- [ ] Calculate transfer manouver

- [x] implement camera behaviour
	- [x] Set predefined position when selecting Object
	- [ ] Orbit view (rotate camera around pointed object)
	- [ ] Cockpit View
	- [ ] Chase camera

- [ ] implement Celestial Bodies (planets, stars, meteorites, blackholes)
	- [ ] Celestial Body (general object that allow to easily integrate general behaviur
		- [x] Gravity
		- [ ] Collision Shape (implemented but not with the dynamic shape)
		- [ ] LOD (texture)
		- [ ] LOD (shape)
		- [ ] LOD (within atmosphere distance)
		- [ ] LOD (near ground, ground level)

- [ ] implement ship
	- [ ] Ship within phisics object
	- [ ] Pulse engines
	- [ ] Autopilot (after transfer manouver algorythm is implemented)
	- [ ] Ship Editor

Seeking Collaborators to implement what listed above, this can be used as base for different types of space games.