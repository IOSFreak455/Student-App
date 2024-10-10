package com.university.finder.data.api

import com.google.gson.JsonObject
import com.google.gson.JsonPrimitive
import com.university.finder.data.model.AppointmentModel
import com.university.finder.data.model.AppointmentRequestModel
import com.university.finder.data.model.Representative
import com.university.finder.data.model.UniversityDetailsModel
import com.university.finder.data.model.UniversityResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST
import retrofit2.http.Query
import javax.inject.Singleton

@Singleton
interface NetworkService {

    @POST("authenticate")
    suspend fun authenticate()

    @POST("bookAppointment")
    suspend fun bookAppointment(@Body appointmentRequestModel: AppointmentRequestModel): Response<List<AppointmentModel>>

    @POST("getAllAppointments")
    suspend fun getAllAppointments(): Response<List<AppointmentModel>>

    @POST("getAllUniversities")
    suspend fun getAllUniversities(): Response<UniversityResponse>


    @POST("getUpcomingAppointments")
    suspend fun getUpcomingAppointments(): Response<List<AppointmentModel>>

    @POST("getUniversitiesByID")
    suspend fun getUniversitiesByID(@Query("id") id: Int): Response<List<UniversityDetailsModel>>

    @POST("getRepresentatives")
    suspend fun getRepresentatives(): Response<List<Representative>>
}