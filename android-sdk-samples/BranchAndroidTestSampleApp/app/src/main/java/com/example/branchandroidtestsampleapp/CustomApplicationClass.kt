package com.example.branchandroidtestsampleapp

import android.app.Application
import android.content.res.Configuration
import io.branch.referral.Branch

class CustomApplicationClass : Application () {
    override fun onCreate() {
        super.onCreate()
        // Branch logging for debugging
        Branch.enableLogging()

        // Branch object initialization
        Branch.getAutoInstance(this)
    }
}