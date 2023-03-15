package com.example.branchandroidtestsampleapp

import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import io.branch.referral.Branch
import io.branch.referral.util.BranchEvent

class ColorBlockPage : AppCompatActivity() {

    val TAG = ColorBlockPage::class.simpleName

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_color_block_page)
    }

    override fun onStart() {
        super.onStart()

        val sessionParams = Branch.getInstance().latestReferringParams
        val colorBlockImageView = findViewById<ImageView>(R.id.colorBlock)
        val yourColorBlockString = findViewById<TextView>(R.id.yourBlockColorString)

        // Check if session parameters contain the "blockColor" parameter. If it does, modify the block's color.

        if (sessionParams.has("blockColor")) {
            val blockColor = sessionParams["blockColor"]
            yourColorBlockString.text = getString(R.string.blockColorString, blockColor)

            if (sessionParams["blockColor"] == "Yellow" || sessionParams["blockColor"] == "yellow") {
                colorBlockImageView.setBackgroundColor(Color.YELLOW)
            }
            else if (sessionParams["blockColor"] == "Blue" || sessionParams["blockColor"] == "blue") {
                colorBlockImageView.setBackgroundColor(Color.BLUE)
            }
            else if (sessionParams["blockColor"] == "Red" || sessionParams["blockColor"] == "red") {
                colorBlockImageView.setBackgroundColor(Color.RED)
            }
            else if (sessionParams["blockColor"] == "White" || sessionParams["blockColor"] == "white") {
                colorBlockImageView.setBackgroundColor(Color.WHITE)
            }
            else if (sessionParams["blockColor"] == "Green" || sessionParams["blockColor"] == "green") {
                colorBlockImageView.setBackgroundColor(Color.GREEN)
            }
            else {
                Log.e(TAG, "ERROR: Unexpected 'blockColor' parameter detected... " +
                        "\nColor block defaults to 'White'... " +
                        "\nPlease use 'Blue', 'Yellow', 'Red', 'Green' or 'White' for your 'blockColor' parameter.")
            }
        } else {
            yourColorBlockString.text = "Your color block is: White"
        }

        // Home button to return to MainActivity

        val homeButton = findViewById<Button>(R.id.homeButton)
        homeButton.setOnClickListener {
            val homeIntent = Intent(this, MainActivity::class.java)
            homeIntent.putExtra("branch_force_new_session", true)
            startActivity(homeIntent)
        }

    }
}