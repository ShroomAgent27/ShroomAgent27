# The Problem

Phantoms don't actually show the correct location of where they are. Applying [debug messages](https://github.com/Xalcon/TorchMaster/compare/mc/1.16...shroomdog27:debug) to DistanceLogics.Cubic shows that posX, poxY, and posZ are actually all zero when the entity type in question is a phantom.

Some output before this patch

```
[20:53:12] [Server thread/INFO] [ne.xa.to.Torchmaster/]: minX = 55.0, posX = 0.0, minX <= posX = false
[20:53:12] [Server thread/INFO] [ne.xa.to.Torchmaster/]: maxX = 184.0, posX = 0.0, maxX >= posX = true
[20:53:12] [Server thread/INFO] [ne.xa.to.Torchmaster/]: minY = 8.0, posY = 0.0, minY <= posY = false
[20:53:12] [Server thread/INFO] [ne.xa.to.Torchmaster/]: maxY = 137.0, posY = 0.0, maxY >= posY = true
[20:53:12] [Server thread/INFO] [ne.xa.to.Torchmaster/]: minZ = -325.0, posZ = 0.0, minZ <= posZ = true
[20:53:12] [Server thread/INFO] [ne.xa.to.Torchmaster/]: maxZ = -196.0, posZ = 0.0, maxZ >= posZ = false
```


# The Cause

As a result of my Forge PR, `net.minecraft.world.spawner.PhantomSpawner`,

the relevant method portions look like this (lines 59 to 63 shown.)

```java
PhantomEntity phantomentity = EntityType.PHANTOM.create(p_230253_1_);
if(net.minecraftforge.common.ForgeHooks.canEntitySpawn(phantomentity, p_230253_1_, blockpos1.getX(), blockpos1.getY(), blockpos1.getZ(), null, SpawnReason.NATURAL) == -1) return 0;
phantomentity.moveTo(blockpos1, 0.0F, 0.0F);
ilivingentitydata = phantomentity.finalizeSpawn(p_230253_1_, difficultyinstance, SpawnReason.NATURAL, ilivingentitydata, (CompoundNBT)null);
p_230253_1_.addFreshEntityWithPassengers(phantomentity);
```

First, the phantom is created.

Second, the ForgeHook to fire the `LivingSpawnEvent.CheckSpawn` event.

Third, the phantom is moved to the desired `blockpos1`.

`blockpos1` is set on line 51 of the PhantomSpawner class.

```java
BlockPos blockpos1 = blockpos.above(20 + random.nextInt(15)).east(-10 + random.nextInt(21)).south(-10 + random.nextInt(21));
```

Finally, the phantom's spawn is finalized.

Note that the event is fired before the phantom is moved to `blockpos`!

# The Solution

A proper long term solution would be to correct Forge in to moving the hook until after the phantom's position is properly set.

However, Forge probably isn't going to accept a PR that changes something that small. Thus, where this PR comes in.

Fetch the information given from the event and use THAT location instead of the entity's own (bad) location.

This corrects the behaviour of properly blocking phantoms, since the game is now checking where the phantoms are going to be, instead of where they currently are (which again, is 0, 0, 0).

Other entities are also still blocked, since their positions are also set properly in `net.minecraftforge.common.ForgeHooks.canEntitySpawn`.


Some output of the debug messages after this patch.
```
[20:59:16] [Server thread/DEBUG] [ne.xa.to.Torchmaster/]: minX = 55.0, posX = 113.0, minX <= posX = true
[20:59:16] [Server thread/DEBUG] [ne.xa.to.Torchmaster/]: maxX = 184.0, posX = 113.0, maxX >= posX = true
[20:59:16] [Server thread/DEBUG] [ne.xa.to.Torchmaster/]: minY = 8.0, posY = 99.0, minY <= posY = true
[20:59:16] [Server thread/DEBUG] [ne.xa.to.Torchmaster/]: maxY = 137.0, posY = 99.0, maxY >= posY = true
[20:59:16] [Server thread/DEBUG] [ne.xa.to.Torchmaster/]: minZ = -325.0, posZ = -259.0, minZ <= posZ = true
[20:59:16] [Server thread/DEBUG] [ne.xa.to.Torchmaster/]: maxZ = -196.0, posZ = -259.0, maxZ >= posZ = true
```

Using the BlockPos data from the event now correctly has phantoms (and other entities) be fixed.

Cats and Pillager Patrols are also fixed by this patch. (which were also PR'd by me. doh.)
