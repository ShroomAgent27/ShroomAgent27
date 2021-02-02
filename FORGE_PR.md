The Logger class that NettyPacketEncoder uses is `org.apache.logging.log4j.core.Logger`.

The default method, `#error(Throwable)` is parsed as `#error(Object)` since there isn't a specified Throwable method for `#error` logging.

In org.apache.logging.log4j.spi.AbstractLogger

```
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

Supplying an Object message such that the call becomes `#error(Object, Throwable)` will correctly print the stack trace to applicable logs.

Supplying a `null` object prints the word `null` in console, so in this PR I provided a message (that can be changed to something else on request) in order to be a bit more helpful in what the erroring buffer was.

