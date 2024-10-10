package com.university.finder.data.model

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class Representative(
    val image: String,
    val repname: String
) : Parcelable