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
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_read_deep_link)
    }

    override fun onStart() {
        super.onStart()

        // ---------- Branch Session Listener ----------

        Branch.sessionBuilder(this).withCallback(object : Branch.BranchReferralInitListener {
            override fun onInitFinished(referringParams: JSONObject?, error: BranchError?) {
                if (error == null) {
                    Log.i("BRANCH SDK", referringParams.toString())

                    // ---------- Get Latest Session Params ----------
                    val sessionParams = Branch.getInstance().latestReferringParams
                    val sessionParamsTextConcat = sessionParams.toString()
                    val readableSessionParams = sessionParamsTextConcat.replace(",",",\n")
                    val sessionParamViewModifier = findViewById<TextView>(R.id.sessionParamsText)

                    // ---------- Get Parameters Sent on App Install ----------
                    val installParams = Branch.getInstance().firstReferringParams
                    val installParamsTextConcat = installParams.toString()
                    val readableInstallParams = installParamsTextConcat.replace(",", ",\n")
                    val installParamViewModifier = findViewById<TextView>(R.id.installParamsText)

                    // ---------- Show Session and Install Parameters ----------
                    fun readDeepLink() {
                        sessionParamViewModifier.text = readableSessionParams
                        Log.i("Session Params",sessionParamsTextConcat)
                        installParamViewModifier.text = readableInstallParams
                        Log.i("Install Params", installParamsTextConcat)
                    }

                    readDeepLink()
                } else {
                    Log.e("BRANCH SDK", error.message)
                }
            }
        }).withData(this.intent.data).init()


        // Home button to return to MainActivity

        val homeButton = findViewById<Button>(R.id.homeButton)
        homeButton.setOnClickListener {
            val homeIntent = Intent(this, MainActivity::class.java)
            homeIntent.putExtra("branch_force_new_session", true)
            startActivity(homeIntent)
        }
    }
}