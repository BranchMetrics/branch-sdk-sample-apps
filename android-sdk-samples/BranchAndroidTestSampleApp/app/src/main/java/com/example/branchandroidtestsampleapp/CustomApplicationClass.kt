package com.example.branchandroidtestsampleapp

import android.app.Application
import android.content.res.Configuration
import io.branch.referral.Branch

class CustomApplicationClass : Application () {

    override fun onCreate() {

        super.onCreate()

        // Branch logging for debugging
        //Branch.enableLogging()

        // Branch object initialization
        Branch.getAutoInstance(this)
    }


    // Called by the system when the device configuration changes while your component is running.
    // Overriding this method is totally optional!
    override fun onConfigurationChanged ( newConfig : Configuration) {
        super.onConfigurationChanged(newConfig)
    }

    // This is called when the overall system is running low on memory,
    // and would like actively running processes to tighten their belts.
    // Overriding this method is totally optional!
    override fun onLowMemory() {
        super.onLowMemory()
    }

}