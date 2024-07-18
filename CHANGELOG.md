## CHANGE LOG

### Version 0.0.6 (July 18, 2024)
-------------------------------------------

**What's new**
* **[Android Platform]**
  * **Call Delivery Confirmation**:
    * SDK displays the call delivery confirmation at the initiator by changing the *Calling...* state to the *Ringing...* state when the phone starts ringing at the receiver's end.
  * **New Callback events support in the `callStatus(SCCallStatusDetails callDetails)` callback**:
    * `VoIPCallStatus.CALL_RINGING`: Allows to determine that the call starts ringing on the receiver's device. This event is reported when the SDK successfully establishes communication with the receiver and the phone rings.
    * `VoIPCallStatus.CALLEE_MICROPHONE_PERMISSION_BLOCKED`: Allows to determine the SDK-initiated decline cases when the microphone permission is blocked at the receiver's end.
    * `VoIPCallStatus.CALL_FAILED_DUE_TO_INTERNAL_ERROR`: Allows to determine the call failure cases. Possible reasons could include low internet connectivity, low RAM available on device, SDK fails to set up the voice channel within the time limit, etc. Considering the nature of the failure, in most cases, retrying the calls will succeed.
  * Exposes `channel` object in the `callStatus(SCCallStatusDetails callDetails)` callback. Use this to identify which signaling channel was used during the Signed Call. It could be either **Socket** or **FCM**.

**Bug Fixes**
* **[Android Platform]**
  * Fixed an issue where the receiver accepted the call, but the call did not transition to the ongoing call state.

#### Enhancements
* **[Android Platform]**
  * Added safeguard handling to prevent duplication in the system events which SDK records and external callback reporting.

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
