package com.nitelite.instant.message.instant_message_me

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.util.Log.DEBUG

class ReceiverListenIncomingMessages : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        print("kotlin receive sms")
        Log.d("INCOMING MESSAGE","kotlin receive sms")
        // This method is called when the BroadcastReceiver is receiving an Intent broadcast.
        TODO("ReceiverListenIncomingMessages.onReceive() is not implemented")
    }
}