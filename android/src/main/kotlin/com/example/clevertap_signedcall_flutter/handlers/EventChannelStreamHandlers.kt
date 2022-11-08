package com.example.clevertap_signedcall_flutter.handlers

import io.flutter.plugin.common.EventChannel

/**
 * Following file contains all the handlers for stream setup and teardown requests.
 */
object CallEventStreamHandler : EventChannel.StreamHandler {
    internal var eventSink: EventChannel.EventSink? = null

    //Handles a request to set up an event stream.
    override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
    }

    //Gets called when the most recently created event stream is closed
    override fun onCancel(p0: Any?) {
        eventSink = null
    }
}

object MissedCallActionEventStreamHandler : EventChannel.StreamHandler {
    internal var eventSink: EventChannel.EventSink? = null

    //Handles a request to set up an event stream.
    override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
    }

    //Gets called when the most recently created event stream is closed
    override fun onCancel(p0: Any?) {
        eventSink = null
    }
}