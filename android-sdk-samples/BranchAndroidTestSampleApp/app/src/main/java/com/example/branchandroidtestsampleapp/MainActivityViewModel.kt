package com.example.branchandroidtestsampleapp

import android.widget.ImageView
import androidx.lifecycle.ViewModel

class MainActivityViewModel : ViewModel() {

    var badgeMeter = 0

    fun meterChanger() {
        if (badgeMeter == 1) {
            badgeMeter--
        } else {
            badgeMeter++
        }
    }
}