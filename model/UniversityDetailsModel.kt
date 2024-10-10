package com.university.finder.data.model

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class UniversityDetailsModel(
    val admissionIntake: String,
    val description: String,
    val id: Int,
    var images: String? = null,
    val location: String,
    val position: String,
    val repName: String,
    val universityName: String
) : Parcelable