package com.example.branchandroidtestsampleapp

import android.widget.ImageView
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class MainActivityViewModel : ViewModel() {

    val currentBadge: MutableLiveData<Int> by lazy {
        MutableLiveData<Int>(R.drawable.branchbadgelightlarger)
    }
}