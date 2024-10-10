package com.university.finder.data.model

data class UniversityResponse(
    val message: String,
    val status: String,
    val universities: List<University>
)