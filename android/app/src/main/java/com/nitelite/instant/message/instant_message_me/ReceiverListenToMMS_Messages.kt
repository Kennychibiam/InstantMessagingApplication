package com.nitelite.instant.message.instant_message_me

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class ReceiverListenToMMS_Messages : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        Log.d("OUTGOING MESSAGE","kotlin receive sms")

        print("kotlin receive mms")
        // This method is called when the BroadcastReceiver is receiving an Intent broadcast.
        TODO("ReceiverListenToMMS_Messages.onReceive() is not implemented")
    }
}