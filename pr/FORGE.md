# The Problem

Phantoms, Cats, and Pillagers from a Pillager Patrol do not set their positions until after `ForgeHooks.canEntitySpawn` is called.


# The Cause

Let's take a look at the phantom spawner.

As a result of my Forge PR, `net.minecraft.world.spawner.PhantomSpawner`,

the relevant method section look like this (lines 59 to 63 shown).

```java
PhantomEntity phantomentity = EntityType.PHANTOM.create(p_230253_1_);
if(net.minecraftforge.common.ForgeHooks.canEntitySpawn(phantomentity, p_230253_1_, blockpos1.getX(), blockpos1.getY(), blockpos1.getZ(), null, SpawnReason.NATURAL) == -1) return 0;
phantomentity.moveTo(blockpos1, 0.0F, 0.0F);
ilivingentitydata = phantomentity.finalizeSpawn(p_230253_1_, difficultyinstance, SpawnReason.NATURAL, ilivingentitydata, (CompoundNBT)null);
p_230253_1_.addFreshEntityWithPassengers(phantomentity);
```

First, the phantom is created. This sets the default location to `BlockPos.ZERO`.

This happens in `net.minecraft.entity.Entity` on line 205.

Second, the ForgeHook to fire the `LivingSpawnEvent.CheckSpawn` event.

Third, the phantom is moved to the desired `blockpos1`.

The relevant method section looks like this (lines 199 to 207 shown).


```java
public Entity(EntityType<?> p_i48580_1_, World p_i48580_2_) {
  super(Entity.class);
  this.type = p_i48580_1_;
  this.level = p_i48580_2_;
  this.dimensions = p_i48580_1_.getDimensions();
  this.position = Vector3d.ZERO;
  this.blockPosition = BlockPos.ZERO;
  this.packetCoordinates = Vector3d.ZERO;
  this.setPos(0.0D, 0.0D, 0.0D);
```

`BlockPos.ZERO` is just `new BlockPos(0, 0, 0)`. 


Finally, the phantom's spawn is finalized.

Note that the event is fired before the phantom is moved to `blockpos`!

I should have correctly made sure that the event was fired after the entity's position was moved to the correct location.

However I failed to do so because I didn't think it would cause that big of a deal at the time. However, mods only really check the Entity's location, which is set to `BlockPos.ZERO`.

This value is technically correct at the time, as the entity hasn't been moved yet, but extremely unhelpful, since it doesn't show where the entity is going to be.

# The Solution

The solution is to just make sure that the event is always fired after the entity is moved to its correct location.

This is exactly what this patch does.

I do understand that this is an extremely minor patch, but I wanted to open it anyway to make awarness of the issue that I introduced.
