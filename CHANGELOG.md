## CHANGE LOG

### Version 0.0.6 (July 18, 2024)
-------------------------------------------

**What's new**
* **[Android Platform]**
  * Supports Signed Call Android SDK [v0.0.5.7](https://repo1.maven.org/maven2/com/clevertap/android/clevertap-signedcall-sdk/0.0.5.7/) which is compatible with CleverTap Android SDK [v6.2.1](https://github.com/CleverTap/clevertap-android-sdk/blob/master/docs/CTCORECHANGELOG.md#version-620-april-3-2024).
  * Enables back button functionality across call screens (incoming, outgoing, and ongoing) to allow users to navigate to other parts of the application while staying on a call.
  * **Call Delivery Confirmation**:
    * SDK displays the call delivery confirmation at the initiator by changing the *Calling...* state to the *Ringing...* state when the phone starts ringing at the receiver's end.
  * **New Public API**:
    * `CleverTapSignedCallFlutter.shared.getBackToCall()` : Allows to navigate the user to the active call.
    * `CleverTapSignedCallFlutter.shared.getCallState()` : Allows to retrieve the current call state.
  * **Support new parameters in the `initProperties` object which gets passed to the `CleverTapSignedCallFlutter.shared.init()` method**:
    * `notificationPermissionRequired` : A `Boolean` property to make notification permission as optional during the Signed Call initialization on Android 13 and onwards.
    * `swipeOffBehaviourInForegroundService` : An enum constant of `SCSwipeOffBehaviour` type to define the swipe off behavior for an active call within the foreground service managed by host application. Please ensure to check the SDK documentation for detailed information on usage of initProperties listed above.
  * **Support new call events in the CleverTapSignedCallFlutter.shared.callEventListener handler**:
    * `CallEvent.ringing`: Allows to determine that the call starts ringing on the receiver's device. This event is reported when the SDK successfully establishes communication with the receiver and the phone rings.
    * `CallEvent.cancelledDueToRingTimeout`: Allows to handle the SDK-initiated cancellations due to ring-timeout. This event is reported when the SDK fails to establish communication with the receiver, often due to an offline device or a device with low bandwidth.
    * `CallEvent.declinedDueToMicrophonePermissionBlocked`: Allows to determine the SDK-initiated decline cases when the microphone permission is blocked at the receiver's end.
    * `CallEvent.failedDueToInternalError`: Allows to determine the call failure cases. Possible reasons could include low internet connectivity, low RAM available on device, SDK fails to set up the voice channel within the time limit, etc. Considering the nature of the failure, in most cases, retrying the calls will succeed.
    *  The `CallEvent.declinedDueToBusyOnVoIP` and `CallEvent.declinedDueToBusyOnPSTN`, to differentiate calls declined due to another Signed Call(VoIP) or declined due to a PSTN call respectively.
  * **Support new parameters in the payload object received in the CleverTapSignedCallFlutter.shared.callEventListener handler**:
    * `callDetails.callId` :  It's a call-specific unique identifier.
    * `callDetails.channel` : It provides the name of the signaling channel which was used during the Signed Call. It could be either *Socket* or *FCM*.

**Bug Fixes**
* **[Android Platform]**
  * Resolves an intermittent issue where the dialing tone at the initiator's side of the call plays on the loudspeaker instead of the internal speaker.
  * Resolves NPE crash occurring when calls are simultaneously initiated to each other, which disrupts the order of signals exchanged between participants.

**Enhancements**
* **[Android Platform]**
  * Added safeguard handling to prevent duplication in the system events which SDK records and external callback reporting.

**Behaviour Changes**
* **[Android Platform]**
  * Adds heads up behaviour to the call-notifications to prompt the user every time the call-screen goes invisible, triggered by either a back button press or putting the app in the background. The heads up notifications allow users to return to the call interface by tapping on the notification.
  * Improved Bluetooth audio experience during calls. Dial tone of an outgoing call will now play through the connected Bluetooth headset instead of the internal speaker. Note: The SDK requires the runtime [BLUETOOTH_CONNECT](https://developer.android.com/reference/android/Manifest.permission#BLUETOOTH_CONNECT) permission for Android 12 and onwards to enable the Bluetooth management during calls.

### Version 0.0.5 (May 16, 2024 )
-------------------------------------------

**Added**
* **[iOS Platform]**
  * Supports [Signed Call iOS SDK v0.0.7](https://github.com/CleverTap/clevertap-signedcall-ios-sdk/blob/main/CHANGELOG.md#version-007-march-15-2024) which is compatible with [CleverTap iOS SDK v6.1.0](https://github.com/CleverTap/clevertap-ios-sdk/blob/master/CHANGELOG.md#version-610-february-22-2024) and higher.
  * Supports [Socket.io v16.1.0](https://github.com/socketio/socket.io-client-swift/releases/tag/v16.1.0) and [Starscream v4.0.8](https://github.com/daltoniam/Starscream/releases/tag/4.0.8) dependency.
  * Adds privacy manifest.
  * Expose socket usage logging for debugging purpose.
  
**Bug Fixes**
* **[iOS Platform]**
  * Handles runtime exception caused by an incompatible deployment target assigned to the Starscream framework by the host application. The Signed Call iOS dependency uses the Starscream framework as a transitive dependency. The issue is now handled within the SDK.

### Version 0.0.4 (January 22, 2024 )
-------------------------------------------

**What's new**

* **[Android Platform]**
  * Supports [Signed Call Android SDK v0.0.5](https://repo1.maven.org/maven2/com/clevertap/android/clevertap-signedcall-sdk/0.0.5) which is compatible with [CleverTap Android SDK v5.2.2](https://github.com/CleverTap/clevertap-android-sdk/blob/master/docs/CTCORECHANGELOG.md#version-522-december-22-2023).
  * Introduces new properties `initiatorImage` and `receiverImage` in the `MissedCallActionClickResult` instance provided through the `CleverTapSignedCallFlutter.shared.missedCallActionClickListener.listen(MissedCallActionClickResult)` event-stream.
  * Adds new public API registerVoIPCallStatusListener(SCVoIPCallStatusListener callStatusListener) to observe the changes in the call state, providing updates to both the initiator and receiver of the call.
  * Adds new callback APIs to handle events when the app is terminated or killed, as listed below:
    * Use `CleverTapSignedCallFlutter.shared.onBackgroundCallEvent(handler)` to handle VoIP call events when the app is in a killed state. 
    * Use `CleverTapSignedCallFlutter.shared.onBackgroundMissedCallActionClicked(handler)` to manage missed call action click events when the app is in a killed state.
      Please refer to the integration documentation for more details on handling callback events in a killed state.

* **[iOS Platform]**
  * Supports [Signed Call iOS SDK v0.0.6](https://github.com/CleverTap/clevertap-signedcall-ios-sdk/blob/main/CHANGELOG.md#version-006-january-19-2024) which is compatible with [CleverTap iOS SDK v5.2.2](https://github.com/CleverTap/clevertap-ios-sdk/blob/master/CHANGELOG.md#version-522-november-21-2023).
  
**Breaking Changes**

* **[Android and iOS Platform]**
  * The `CleverTapSignedCallFlutter.shared.callEventListener` event stream will now provide an instance of the `CallEventResult` class instead of the `CallEvent` class. Please refer to the integration documentation for details on usage.
  
* **[iOS Platform]**
  * iOS deployment target version is bumped to iOS 12.

**Behaviour Changes**

* **[Android Platform]**
  * Handles UX issues during network loss or switch by invalidating the socket reconnection and establishing an active connection to process the call related actions.
  * Modifies the SDK's behavior when the **Notifications Settings** are disabled for the application. Previously, if the app's notifications were disabled, the device rang on incoming calls without displaying the call screen in the background and killed states. In this version, the SDK now declines incoming calls when the notifications are disabled. If the notification settings are later enabled, the SDK resumes processing calls instead of automatically declining them.

* **[Android and iOS Platform]**
  * The `CleverTapSignedCallFlutter.shared.callEventListener` will now provide updates in the call state to both the initiator and receiver of the call. Previously, it was exposed only to the initiator of the call.
  
**Bug Fixes**

* **[Android Platform]**
  * Fixes multiple outgoing call requests initiated simultaneously through multiple calls of `CleverTapSignedCallFlutter.shared.call(..)`. The SDK now processes only one call at a time while rejecting other requests with a failure exception.
  * Addresses an **IllegalStateException** which occurs while prompting the user with the poor/bad network conditions on the call-screen.

* **[Android and iOS Platform]**
   * Addresses an infinite **Connecting** state issue on the call screen which was triggered by using CUIDs longer than 15 characters. In this version, the SDK extends support to CUIDs ranging from 5 to 50 characters.       

### Version 0.0.3 (September 11, 2023)
-------------------------------------------

**What's new**

* **[Android Platform]**
  * Supports [Signed Call Android SDK v0.0.4](https://repo1.maven.org/maven2/com/clevertap/android/clevertap-signedcall-sdk/0.0.4) which is compatible with [CleverTap Android SDK v5.2.0](https://github.com/CleverTap/clevertap-android-sdk/blob/master/docs/CTCORECHANGELOG.md#version-520-august-10-2023).
  
* **[iOS Platform]**
  * Supports [Signed Call iOS SDK v0.0.5](https://github.com/CleverTap/clevertap-signedcall-ios-sdk/blob/main/CHANGELOG.md#version-005-aug-23-2023) which is compatible with [CleverTap iOS SDK v5.2.0](https://github.com/CleverTap/clevertap-ios-sdk/blob/master/CHANGELOG.md#version-520-august-16-2023).

* **[Android and iOS Platform]**
  * Adds support for hiding the **Powered by Signed Call** label from VoIP call screens. For more information, refer to [Override Dashboard Branding for Call Screen In Android](https://developer.clevertap.com/docs/signed-call-android-sdk#override-the-dashboard-branding-for-call-screen) and [Override Dashboard Branding for Call Screen In iOS](https://developer.clevertap.com/docs/signed-call-ios-sdk#override-the-dashboard-branding-for-call-screen).

**Changes**

* **[Android Platform]**
  * The **index.html** file used inside the SDK has been renamed to a unique name to prevent conflicts with the same file name that may exist in the application.
  * Adjust the Microphone permission prompt limit to align with the [permissible threshold](https://developer.android.com/about/versions/11/privacy/permissions#dialog-visibility) which is shown when the receiver attends the call. Previously, if the Microphone permission was denied even once, SDK would continue to block all incoming calls at the receiver's end. 

    ***Note***: Starting from Android 11, users have the option to deny the prompt twice before the permission is blocked by system, whereas in earlier versions, users could deny the prompt until selecting the "don't ask again" checkbox.
    
* **[Android and iOS Platform]**
  * Captures a missed call system event when a call initiator manually cancels the call, reported under the `SCEnd` system event.

**Fixes**

* **[Android Platform]**
  * Improved Bluetooth handling for a better user experience:
    * Voice now goes through Bluetooth when Bluetooth connectivity is established during an ongoing call.
    * Voice now goes through the internal speaker when Bluetooth connectivity is disabled from the call screen button.
  * Resolved duplicate reporting of `SCIncoming` system events caused by receiving duplicate pushes for the same call, one from the socket and one from FCM.

### Version 0.0.2 (February 21, 2022)
-------------------------------------------

* Supports Signed Call Android SDK v0.0.2 and Signed Call iOS SDK v0.0.2.
* Adds Push Primer support for the [Android 13 notification runtime permission](https://developer.android.com/develop/ui/views/notifications/notification-permission).
* Adds new public API `disconnectSignallingSocket()` in order to close the Signalling socket connection.
* Fixes VoIP call screen distortion in iOS.

### Version 0.0.1 (December 20, 2022)
-------------------------------------------

* Initial Release.
* Supports Signed Call Android SDK v0.0.1 and Signed Call iOS SDK v0.0.1.
