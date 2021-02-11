# The Problem

Minecraft's `net.minecraft.network.NettyPacketEncoder` doesn't print stack traces when there's a problem encoding packets.

This is an example of the message you would get under the vanilla `NettyPacketEncoder`

```
2021-02-10 22:23:47 [Netty Server IO #4/ERROR] [minecraft/NettyPacketEncoder]: io.netty.handler.codec.EncoderException: String too big (was 4232519 bytes encoded, max 262144)
```

Not very informative is it? It's just the excecption class, and the exception message. No stacktrace whatsoever.

# The Cause


The Logger class that NettyPacketEncoder uses is `org.apache.logging.log4j.core.Logger`.

The default method, `#error(Throwable)` is parsed as `#error(Object)` since there isn't a specified Throwable method for `#error` logging. This causes the Logger to not print the stack trace, so the `Throwable` paramater is set to null in the `lofIfEnabled` method.

In `org.apache.logging.log4j.spi.AbstractLogger`,

```java
@Override
public void error(final Object message) {
    logIfEnabled(FQCN, Level.ERROR, null, message, null);
}

@Override
public void error(final Object message, final Throwable t) {
    logIfEnabled(FQCN, Level.ERROR, null, message, t);
}

@Override
public void logIfEnabled(final String fqcn, final Level level, final Marker marker, final Object message,
        final Throwable t) {
    if (isEnabled(level, marker, message, t)) {
        logMessage(fqcn, level, marker, message, t);
    }
}
```

# The Solution

Supplying an Object message such that the call becomes `#error(Object, Throwable)` will correctly print the stack trace to applicable logs.

Supplying a `null` object prints the word `null` in console, so in this PR I provided a message (that can be changed to something else on request) in order to be a bit more helpful in what the erroring buffer was.

Here is a similiar error message using my patch.


```
2021-02-10 22:01:24 [Netty Server IO #8/ERROR] [minecraft/NettyPacketEncoder]: Critical failure encoding packet: PooledUnsafeDirectByteBuf(ridx: 0, widx: 1, cap: 256)
io.netty.handler.codec.EncoderException: String too big (was 4419497 bytes encoded, max 262144)
        at net.minecraft.network.PacketBuffer.func_211400_a(PacketBuffer.java:363) ~[?:?] {re:classloading,pl:runtimedistcleaner:A}
        at net.minecraft.network.PacketBuffer.func_179256_a(PacketBuffer.java:180) ~[?:?] {re:classloading,pl:runtimedistcleaner:A}
        at net.minecraft.network.play.server.SChatPacket.func_148840_b(SourceFile:34) ~[?:?] {re:classloading}
        at net.minecraft.network.NettyPacketEncoder.encode(NettyPacketEncoder.java:38) ~[?:?] {re:classloading}
        at net.minecraft.network.NettyPacketEncoder.encode(NettyPacketEncoder.java:12) ~[?:?] {re:classloading}
        at io.netty.handler.codec.MessageToByteEncoder.write(MessageToByteEncoder.java:107) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannelHandlerContext.invokeWrite0(AbstractChannelHandlerContext.java:738) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannelHandlerContext.invokeWrite(AbstractChannelHandlerContext.java:730) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannelHandlerContext.write(AbstractChannelHandlerContext.java:816) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannelHandlerContext.write(AbstractChannelHandlerContext.java:723) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.handler.codec.MessageToMessageEncoder.write(MessageToMessageEncoder.java:111) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannelHandlerContext.invokeWrite0(AbstractChannelHandlerContext.java:738) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannelHandlerContext.invokeWriteAndFlush(AbstractChannelHandlerContext.java:801) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannelHandlerContext.write(AbstractChannelHandlerContext.java:814) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannelHandlerContext.writeAndFlush(AbstractChannelHandlerContext.java:794) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannelHandlerContext.writeAndFlush(AbstractChannelHandlerContext.java:831) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.DefaultChannelPipeline.writeAndFlush(DefaultChannelPipeline.java:1071) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.AbstractChannel.writeAndFlush(AbstractChannel.java:300) ~[server-1.16.5-20210115.111550-extra.jar:?] {}
        at net.minecraft.network.NetworkManager.lambda$dispatchPacket$5(NetworkManager.java:196) ~[?:?] {re:mixin,pl:runtimedistcleaner:A,re:classloading,pl:runtimedistcleaner:A}
        at io.netty.util.concurrent.AbstractEventExecutor.safeExecute(AbstractEventExecutor.java:163) [server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.util.concurrent.SingleThreadEventExecutor.runAllTasks(SingleThreadEventExecutor.java:404) [server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:465) [server-1.16.5-20210115.111550-extra.jar:?] {}
        at io.netty.util.concurrent.SingleThreadEventExecutor$5.run(SingleThreadEventExecutor.java:884) [server-1.16.5-20210115.111550-extra.jar:?] {}
        at java.lang.Thread.run(Thread.java:748) [?:1.8.0_261] {}
```

Much more informative, is it not?
