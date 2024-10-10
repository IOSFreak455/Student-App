package com.university.finder.data.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class AppointmentModel(
    val appointmentdate: String,
    val appointmentslot: String,
    val createdatetime: String,
    val id: Int,
    val location: String,
    val repname: String,
    val studentname: String,
    val universityname: String
) : Parcelable