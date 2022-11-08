package com.clevertap.signedcall_flutter_example;

import android.util.Log;

import androidx.annotation.NonNull;

import com.clevertap.android.sdk.pushnotification.fcm.CTFcmMessageHandler;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

public class MyFirebaseMessagingService extends FirebaseMessagingService {

    @Override
    public void onMessageReceived(@NonNull RemoteMessage message) {
        Log.d("SignedCallFlutter: ", "fcm notification received");

        //To handover the FCM push to the Core SDK for further processing
        new CTFcmMessageHandler().createNotification(getApplicationContext(), message);
    }

    @Override
    public void onNewToken(@NonNull String s) {
        super.onNewToken(s);
    }
}