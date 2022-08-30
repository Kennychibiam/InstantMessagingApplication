package com.nitelite.instant.message.instant_message_me

import android.app.Activity
import android.app.AlertDialog
import android.app.Instrumentation
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import android.view.View
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL_SMS_HANDLING="com.nitelite.handling.messages"
    private var methodChannel:MethodChannel?=null
    private var methodChannelResult:MethodChannel.Result?=null
    //private val METHOD_CHANNEL_RECIEVE_INCOMING_DATA="com.nitelite.incomingdata";
     var makeAppDefaultLaincher=null



    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
         setUpChannels(this,flutterEngine.dartExecutor.binaryMessenger)

    }

    fun setUpChannels(context: Context, messenger: BinaryMessenger){
       methodChannel=MethodChannel(messenger,METHOD_CHANNEL_SMS_HANDLING)
        methodChannel!!.setMethodCallHandler { call, result ->
            methodChannelResult=result

             if(call.method=="isAppDefaultSms"){
                if(isAppDefault()){
                    result.success(true)
                }else{
                    makeAppDefault()
//                    val builder = AlertDialog.Builder(this)
//                    builder.setTitle("Make this app the default SMS")
//                    builder.setMessage("For the best functionality make Instant Message Me your default messaging application")
////builder.setPositiveButton("OK", DialogInterface.OnClickListener(function = x))
//
//                    builder.setPositiveButton("Yes") { dialog, which ->
//                       makeAppDefault()
//                        result.success(true)
//                    }
//
//                    builder.setNegativeButton("No") { dialog, which ->
//                        result.success(false)
//                    }
//
//
//                    builder.show()

                }

            }
            else{
                result.notImplemented()
            }
        }
    }

    private fun tearDownChannels(){
      methodChannel!!.setMethodCallHandler(null)
    }
    override fun onDestroy() {
        tearDownChannels()
        super.onDestroy()

    }




    private fun isAppDefault():Boolean{
        val myPackageName = packageName
        return Telephony.Sms.getDefaultSmsPackage(this).equals(myPackageName)
    }
    private fun makeAppDefault(){

            // App is not default.
                 // Show the "not currently set as the default SMS app" interface
        val myPackageName = packageName

                    val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
                    intent.putExtra(
                        Telephony.Sms.Intents.EXTRA_PACKAGE_NAME,
                        myPackageName
                    )

                    startActivityForResult(intent,200)

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if(resultCode==Activity.RESULT_OK && requestCode==200){
            print(methodChannelResult)
            methodChannelResult?.success(true)
        }
        else{
            methodChannelResult?.success(false)
        }
    }
}
