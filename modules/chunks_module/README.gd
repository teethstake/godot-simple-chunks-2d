extends "This is how i take my notes, sorry if it makes you upset"


There are exaple levels in "res://modules/chunks_module/example/levels/". you can delete the whole
"res://modules/chunks_module/example" directory, it's not' needed for the module to function. But it
will break the SpawnerTileMap, since its all hardcoaded


Chunk:
	"General info":
		- coordinates (0, 0) should be in the top left of the chunk, to avoid weird behavours,
		while using ChunkManagerBase.find_chunk_key().
		- it should be a sole child of ChunkFrame
		- chunks' CollisionShape2D shouldn't overlap
		- CollisionShape2Ds shape has to be RectangleShape2D and it needs to cover the whole Chunk
		- reload_chunk() can cause bugs. I didn't' have time to make it safe yet.
	"Types":
		ChunkBase:
			- don't use
			- it's just a base class
		Chunk:
			- use
			- for every chunk you make, create a new inherited scene
			- it\'s a good idea to make an inhereted scene, that will have all components shared
			between your chunks (like tilemaps and such) and be a base for your chunks and just
			further inheret it, when making actual chunks. Call it MyChunk / BaseRoom or sth
			- make every chunk a scene (like in "Save Branch as Scene")
			- you have to specify the path to its .tscn file in the export variable
		HeavyChunk:
			- used for prototyping (it takes way more space, than a regular Chunk, because it saves
			all the data from the nodes it contains)
			- can be used for procedural generation or sth, idk
			- you can also make your own Base for it and call it MyHeavyChunk or sth otherwise don't'
			- put it into the ChunkFrame and put all the things, you would normally
			put inside a Chunk as it's (HeavyChunk's) children. Also you have to create your own
			CollisionShape2D for each one (with a RectangleShape2D shape)
			- BUG: spawner_tilemap_blacklist doesn't work because of the messy way its children are stored'
			- only saves the first level of its children


ChunkFrame:
	- used for some Chunk neighbour configuration
	- you can specify custom Chunk neighbours, that wont be remapped
	- put only the Chunk as its child
	- every chunk can have up to 4 neighbours, for each side (left, right, top, bottom), but those
	labels dont matter for anything, but the ChunkNeighbourMapper (i could've' made it an Array of
	arbitrary len, and i might do it in the future)


ChunkManager:
	"General info"
		- manages loading and unloading chunks
	"Types":
		ChunkManagerBase:
			- don't use
			- it's just a base class
		ChunkManager:
			- compiles ChunkFrame and Chunk data into a dictionary on _ready
			- copies it all into your clipboard as a string
		ChunkManagerLite:
			- you have to paste chunks as a string into its export variable
			- saves static memory, bc it has no children and just loads chunks from precompiled data


	ChunkNeighbourMapper:
		- maps Chunks' neighbours' to 4 general directions, but:
			- chunks have to be touching sides (there can't be' any space between their CollisionShape2Ds)
			- if a chunk has more than 1 possible neighbour at one side, specify those neighbours manually
			- gets destroyed, when called by the ChunkManager


ChunkLoader:
	- it loads the chunks
	- you can make its CollisionShape2D bigger, and it will load more of them (not the best
	implementation of rendering more than 5 chunks at a time, but you can do that)
	- in the future I'm' going to implement reloading chunks functionality
	- reload_chunks() can cause bugs, while going between chunks or when there is more than 1 ChunkLoader
	active


SpawnerTileMap:
	- most of it is explained in "res://modules/chunks_module/spawner_tilemap/SpawnerTileMap.gd"
	- if you want a thing spawned by it not to respown, upon reloading of the chunk add it to the 
	group "stm_dont_respawn"


I think other stuff is either obvious or in one of the example elvels, and there would be no point
explaining it by text. If there's anything unclear,' dm me on reddit (u/teethstake)

This whole thing is under the MIT licence, but if you were to use it in your project, pls credit me
and also dm me or send me an email about it (teethstake@gmail.com), I would love to see your games.
