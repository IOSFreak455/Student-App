package com.university.finder.data.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class TimeSlotModel(
    val slot: String
) : Parcelable