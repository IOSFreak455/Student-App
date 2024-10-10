package com.university.finder.data.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class AppointmentRequestModel(
    val appointmentDate: String,
    val appointmentSlot: String,
    val location: String,
    val repName: String,
    val studentName: String,
    val universityName: String
) : Parcelable