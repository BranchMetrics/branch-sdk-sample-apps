package com.example.branchandroidtestsampleapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.TextView
import io.branch.referral.Branch
import io.branch.referral.BranchError
import org.json.JSONObject

class ReadDeepLinkActivity : AppCompatActivity() {

    val TAG = ReadDeepLinkActivity::class.simpleName

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_read_deep_link)
    }

    override fun onStart() {
        super.onStart()

        // ---------- Get Latest Session Params ----------
        val sessionParams = Branch.getInstance().latestReferringParams
        val sessionParamsTextConcat = sessionParams.toString()
        val readableSessionParams = sessionParamsTextConcat.replace(",", ",\n")
        val sessionParamViewModifier = findViewById<TextView>(R.id.sessionParamsText)

        // ---------- Get Parameters Sent on App Install ----------
        val installParams = Branch.getInstance().firstReferringParams
        val installParamsTextConcat = installParams.toString()
        val readableInstallParams = installParamsTextConcat.replace(",", ",\n")
        val installParamViewModifier = findViewById<TextView>(R.id.installParamsText)

        // ---------- Show Session and Install Parameters ----------
        sessionParamViewModifier.text = readableSessionParams
        Log.i(TAG, sessionParamsTextConcat)
        installParamViewModifier.text = readableInstallParams
        Log.i(TAG, installParamsTextConcat)

        // Home button to return to MainActivity

        val homeButton = findViewById<Button>(R.id.homeButton)
        homeButton.setOnClickListener {
            val homeIntent = Intent(this, MainActivity::class.java)
            startActivity(homeIntent)
        }
    }
}