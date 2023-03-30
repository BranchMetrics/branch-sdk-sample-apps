package com.example.branchandroidtestsampleapp

import android.widget.ImageView
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class MainActivityViewModel : ViewModel() {

    val displayLightBadge: MutableLiveData<Boolean> by lazy {
        MutableLiveData<Boolean>(false)
    }
}