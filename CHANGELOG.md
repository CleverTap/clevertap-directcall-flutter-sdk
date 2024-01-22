## CHANGE LOG

### Version 0.0.4 (January 22, 2024 )
-------------------------------------------

**What's new**

* **[Android Platform]**
  * Supports [Signed Call Android SDK v0.0.5](https://repo1.maven.org/maven2/com/clevertap/android/clevertap-signedcall-sdk/0.0.5) which is compatible with [CleverTap Android SDK v5.2.2](https://github.com/CleverTap/clevertap-android-sdk/blob/master/docs/CTCORECHANGELOG.md#version-522-december-22-2023).
  * Introduces new properties initiator_image and receiver_image in the MissedCallNotificationOpenResult object provided through the onMissedCallNotificationOpened(Context context, MissedCallNotificationOpenResult result) callback.
  * Adds new public API registerVoIPCallStatusListener(SCVoIPCallStatusListener callStatusListener) to observe the changes in the call state, providing updates to both the initiator and receiver of the call.
  
* **[iOS Platform]**
  * Supports [Signed Call iOS SDK v0.0.6](https://github.com/CleverTap/clevertap-signedcall-ios-sdk/blob/main/CHANGELOG.md#version-006-january-19-2024) which is compatible with [CleverTap iOS SDK v5.2.2](https://github.com/CleverTap/clevertap-ios-sdk/blob/master/CHANGELOG.md#version-522-november-21-2023).
  * Adds new NSNotification.Name `SCCallStatusDidUpdate` to observe the changes in the call state, providing updates to both the initiator and receiver of the call.
  
**Breaking Changes**

* **[Android Platform]**
  * The callStatus(VoIPCallStatus voIPCallStatus) callback method in the OutgoingCallResponse callback is no longer supported. Please use the new public API registerVoIPCallStatusListener(SCVoIPCallStatusListener callStatusListener).
    
* **[iOS Platform]**
  * The `MessageReceived` NSNotification observer is no longer supported. Please use the new NSNotification.Name `SCCallStatusDidUpdate`.
  
**Behaviour Changes**

* **[Android Platform]**
  * Handles UX issues during network loss or switch by invalidating the socket reconnection and establishing an active connection to process the call related actions.
  * Modifies the SDK's behavior when the Notifications Settings are disabled for the application. Previously, if the app's notifications were disabled, the device rang on incoming calls without displaying the call screen in the background and killed states. In this version, the SDK now declines incoming calls when the notifications are disabled. If the notification settings are later enabled, the SDK resumes processing calls instead of automatically declining them.
   
**Fixes**

* **[Android Platform]**
  * Fixes multiple outgoing call requests initiated simultaneously through multiple calls of SignedCallAPI.call(). The SDK now processes only one call at a time while rejecting other requests with a failure exception.
  * Addresses an IllegalStateException which occurs while prompting the user with the poor/bad network conditions on the call-screen.

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
