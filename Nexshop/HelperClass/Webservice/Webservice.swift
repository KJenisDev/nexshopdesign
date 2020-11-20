
import Foundation
import Alamofire


enum Webservice {
    
    static let baseUrl = "https://zestbrains.techboundary.xyz/public/"
    //static let baseUrl = "https://staging.thecellula.com/"
    static let apiVersion = "api/v1/"
//    static let apiVersion = "api/"
    
    
    //MARK:- LogIn
    enum LoginModule: RequestExecuter {
          
          case login, signup, check_username, resend_otp
          
          var method: HTTPMethod {
              switch self {
              case .login, .signup, .check_username, .resend_otp:
                  return .post
            }
          }
          
          var apiName: String {
              switch self {
              case .login:
                  return "app/login"
              case .signup:
                return "app/signup"
                case .check_username:
                return "app/check_username"
              case .resend_otp:
                return "app/resend_otp"
            }
            
            
          }
      }
    
    //MARK:- Wellness
    enum WellnessProfile: RequestExecuter {
        
        case getMyHealthProfile, updateHealthProfile, addFamilyDoctor, getFamilyList(Int), addFamilyMemberDetail, removeFamilyMember, getDoctorList, getPrescriptionList, addPrescription, removePrescription, addFamilyWhatsAppReminder, removeFamilyReminder, addEditFamilyReminder, getSleepTracker, addSleepReminder, addManualSleep, getWaterDetails, addWaterDetail, addWaterReminder, getBpDetails(Int), addBpDetails, getBpAnalytics, addBpTarget, getDiseae, getAllergy
        
        var method: HTTPMethod {
            switch self {
            case  .getMyHealthProfile, .getFamilyList, .getSleepTracker, .getBpDetails:
                return .get
            case .updateHealthProfile, .addFamilyDoctor, .addFamilyMemberDetail, .getPrescriptionList, .removePrescription, .addPrescription, .addFamilyWhatsAppReminder, .removeFamilyReminder, .addEditFamilyReminder, .addSleepReminder, .getWaterDetails, .addWaterReminder, .getDoctorList, .addBpDetails, .removeFamilyMember, .getBpAnalytics, .addBpTarget, .getDiseae, .getAllergy, .addManualSleep, .addWaterDetail:
                return .post
            }
        }
        
        var apiName: String {
            switch self {
            case .getMyHealthProfile:
                return  "app/get_my_health_profile"
            case .updateHealthProfile:
                return "app/update_my_health_profile"
            case .addFamilyDoctor:
                return "app/add_family_doctor"
            case .getFamilyList(let offset):
                return "app/get_all_family_list?limit=10&offset=\(offset)"
            case .addFamilyMemberDetail:
                return "app/add_edit_family_details"
            case .removeFamilyMember:
                return "app/remove_family_details"
            case .getDoctorList:
                return "app/get_doctor_list"
            case .getPrescriptionList:
                return "app/get_prescription_list"
            case .removePrescription:
                return "app/remove_prescription"
            case .addPrescription:
                return "app/add_prescription"
            case .addFamilyWhatsAppReminder:
                return "app/add_family_whatsapp_reminder"
            case .removeFamilyReminder:
                return "app/remove_family_reminder"
            case .addEditFamilyReminder:
                return "app/add_edit_family_reminder"
            case .getSleepTracker:
                return "app/get_sleep_tracker"
            case .addSleepReminder:
                return "app/add_sleep_reminder"
            case .getWaterDetails:
                return "app/get_water_details"
            case .addWaterReminder:
                return "app/add_water_reminder"
            case .getBpDetails(let offset):
                return "app/get_bp_details?limit=10&offset=\(offset)"
            case .addBpDetails:
                return "app/add_bp_details"
            case .getBpAnalytics:
                return "app/get_bp_analytics"
            case .addBpTarget:
                return "app/add_bp_target"
            case .getAllergy:
                return "app/get_allergy"
            case .getDiseae:
                return "app/get_disease"
            case .addManualSleep:
                return "app/add_sleep_data"
            case .addWaterDetail:
                return "app/add_water_details"
            }
        }
    }
    
       
    enum WellnessTracking: RequestExecuter {
        
        case getWeekMarathon, resetUserMarathonData, completeUserMarathon, getMealTrackingData, searchMeal, addMultipleMealData, getSpecificMealDetail, addMealReminder, moveAnotherMean, removeMeal, duplicateMeal, updateMealDetails, getAverageAnalytics, getRunningRecords, addRunningRecord, LikeDislikePost, getRunningAnalytics
        
        var method: HTTPMethod {
            switch self {
            case .getWeekMarathon, .resetUserMarathonData, .completeUserMarathon, .getMealTrackingData, .searchMeal, .addMultipleMealData,.addMealReminder, .getSpecificMealDetail, .moveAnotherMean, .removeMeal, .duplicateMeal,  .updateMealDetails, .getAverageAnalytics, .getRunningRecords, .LikeDislikePost, .addRunningRecord:
                return .post
            case .getRunningAnalytics:
                return .get
            }
        }
        
        var apiName: String {
            switch self {
            case .getWeekMarathon:
                return "app/get_week_marathon"
            case .resetUserMarathonData:
                return "app/reset_user_marathon"
            case .completeUserMarathon:
                return "app/complete_user_marathon"
            case .getMealTrackingData:
                return "app/get_meal_tracking_details"
            case .searchMeal:
                return "app/search_meal"
            case .addMultipleMealData:
                return "app/add_multiple_meal"
            case .getSpecificMealDetail:
                return "app/get_specific_meal_details"
            case .addMealReminder:
                return "app/add_meal_reminder"
            case .moveAnotherMean:
                return "app/add_move_meal"
            case .removeMeal:
                return "app/remove_meal"
            case .duplicateMeal:
                return "app/duplicate_meal"
            case .updateMealDetails:
                return "app/update_meal_details"
            case .getAverageAnalytics:
                return "app/get_average_analytics"
            case .getRunningRecords:
                return "app/get_running_record"
            case .addRunningRecord:
                return "app/add_running_record"
            case .LikeDislikePost:
                return "app/add_likes"
            case .getRunningAnalytics:
                return "app/get_running_analytics"
                          
            }
        }
    }
    
    enum WellnessFitness: RequestExecuter {
        
        case getWorkoutCategory, getWorkoutPlanDetail, createWorkoutPlanlist, getWorkoutLog, getCategoryWiseExercise, resetWorkoutExercise, removeMyWorkout, addExerciseComplete, addManualWorkoutExercise, getWorkoutPlanTrackingDetails, addWorkoutLog, removeInnerExercise, completeInnerExercise, completeOuterExercise
        
        var method: HTTPMethod {
            switch self {
            case .getWorkoutCategory, .getWorkoutLog, .createWorkoutPlanlist, .getCategoryWiseExercise, .resetWorkoutExercise, .removeMyWorkout, .addExerciseComplete, .addManualWorkoutExercise, .getWorkoutPlanTrackingDetails, .addWorkoutLog, .removeInnerExercise, .completeInnerExercise, .completeOuterExercise:
                return .post
            case .getWorkoutPlanDetail:
                return .get
            }
        }
        
        var apiName: String {
            switch self {
            case .getWorkoutCategory:
                return "app/get_workout_categories"
            case .getWorkoutPlanDetail:
                return "app/get_my_workout_plan_details"
            case .createWorkoutPlanlist:
                return "app/create_workout_plansheet"
            case.getWorkoutLog:
                return "app/get_my_workout_log"
            case .getCategoryWiseExercise:
                return "app/workout_plan_list"
            case .resetWorkoutExercise:
                return "app/reset_workout_exercise"
            case .removeMyWorkout:
                return "app/remove_workout_plansheet"
            case .addExerciseComplete:
                return "app/add_exercise_completed"
            case .addManualWorkoutExercise:
                return "app/add_manual_workout"
            case .getWorkoutPlanTrackingDetails:
                return "app/get_workout_plan_tracking_details"
            case .addWorkoutLog:
                return "app/add_workout_log"
            case .removeInnerExercise:
                return "app/remove_inner_exercise"
            case .completeInnerExercise:
                return "app/inner_exercise_completed"
            case .completeOuterExercise:
                return "app/outer_exercise_completed"
            }
        }
    }
    
    enum WellnessNutrition: RequestExecuter {
        
        case getRecipeHomepage, getSearchRecipes, getRecipeDetail, addLikeDislike, getAllReview, addAsHelpfull, addRecipeReview, getRecipeStepByStep
        
        var method: HTTPMethod {
            switch self {
            case .getRecipeHomepage:
                return .get
            case .getSearchRecipes, .getRecipeDetail, .addLikeDislike, .getAllReview, .addAsHelpfull, .addRecipeReview, .getRecipeStepByStep:
                return .post
            }
        }
        
        var apiName: String {
            switch self {
            case .getRecipeHomepage:
                return "app/get_recipe_homepage"
            case .getSearchRecipes:
                return "app/get_search_recipes"
            case .getRecipeDetail:
                return "app/get_recipe_details"
            case .addLikeDislike:
                return "app/add_likes"
            case .getAllReview:
                return "app/get_all_reviews"
            case .addAsHelpfull:
                return "app/add_help_counts"
            case .addRecipeReview:
                return "app/add_reviews"
            case .getRecipeStepByStep:
                return "app/get_recipe_step_by_step"
                
            }
        }
    }
    
    enum WellnessChallenges: RequestExecuter {
        
        case getChallenges, getChallengesDetail(Int), acceptChallenge(Int), getParticipateList, getChallengesDayDetail
        
        var method: HTTPMethod {
            switch self {
            case .getChallenges, .getParticipateList, .getChallengesDayDetail:
                return .post
            case .getChallengesDetail, .acceptChallenge:
                return .get
            }
        }
        
        var apiName: String {
            switch self {
            case .getChallenges:
                return "app/get_challenges"
            case .getChallengesDetail(let challengeId):
                return "app/get_challenge_detail/\(challengeId)"
            case .acceptChallenge(let challengeId):
                return "app/user_join_challenge/\(challengeId)"
            case .getParticipateList:
                return "app/get_participate_challenges"
            case .getChallengesDayDetail:
                return "app/challenge_day_details"
            }
        }
    }
    
    //MARK:- Services
    enum ServiceModule: RequestExecuter {
        
        case getHobieLanding, getServiceLanding, getServices, getServiceDetail, addBookingService, addToWhishlist, removeWhishlist, getCustomPackage, chatInbox
        
        var method: HTTPMethod {
            switch self {
            case .getHobieLanding, .getServiceLanding, .getServices, .getServiceDetail, .addBookingService, .addToWhishlist, .removeWhishlist, .getCustomPackage, .chatInbox:
                return .post
            }
        }
        
        var apiName: String {
            switch self {
            case .getHobieLanding:
                return "app/get_hobbies_landing_data"
            case .getServiceLanding:
                return "app/get_service_landing_data"
            case .getServices:
                return "app/get_services"
            case .getServiceDetail:
                return "app/get_service_details"
            case .addBookingService:
                return "app/add_booking_service"
            case .addToWhishlist:
                return "app/add_wishlist"
            case .removeWhishlist:
                return "app/remove_from_wishlist"
            case .getCustomPackage:
                return "app/get_custom_package"
            case .chatInbox:
                return "app/chat/room_listing"
            }
        }
    }
    
    
    
        //MARK:- Spiritual

    enum SpiritualInstitute: RequestExecuter {
        
        case getInstitutes,getInstituteDetail(Int),getCountryName,getCenterList,getCenterDetail(Int),getProjectList,getProjectDetail(Int),getVideoList,getVideoDetail(Int),getReadList,getReadDetail(Int),getEventList,getEventDetail(Int),getCourseList,getCourseDetail(Int),getEventTicket(Int),AddAttendees,EventBooking,ConfirmBooking,CourseCheckout,CourseRegistration,ConfirmRegistration,RequestDonation,ConfirmDonation
        
        //var apiName: String
        
        var method: HTTPMethod {
            switch self {
            case .getInstitutes:
                return .post
            case .getInstituteDetail:
                return .get
            case .getCountryName:
                return .post
            case .getCenterList:
                return .post
            case .getCenterDetail:
                return .get
            case .getProjectList:
                return .post
            case .getProjectDetail:
                return .get
            case .getVideoList:
                return .post
            case .getVideoDetail:
                return .get
            case .getReadList:
                return .post
            case .getReadDetail:
                return .get
            case .getEventList:
                return .post
            case .getEventDetail:
                return .get
            case .getCourseList:
                return .post
            case .getEventTicket:
                return .get
            case .getCourseDetail:
                return .get
            case .AddAttendees:
                return .post
            case .EventBooking:
            return .post
            case .ConfirmBooking:
            return .post
            case .CourseCheckout:
            return .post
            case .CourseRegistration:
            return .post
            case .ConfirmRegistration:
            return .post
            case .RequestDonation:
                return .post
            case .ConfirmDonation:
                return .post
            }
            
        }
        
        var apiName : String {
            switch self {
            case .getInstitutes:
                return "app/get_institutes"
            case .getInstituteDetail(let Id):
                return "app/get_institute/\(Id)"
            case .getCountryName:
                return "app/get_institute_center_countries"
            case .getCenterList:
                return "app/get_institute_centers"
            case .getCenterDetail(let Id):
                return "app/get_institute_center_detail/\(Id)"
            case .getProjectList:
                return "app/get_institute_projects"
            case .getProjectDetail(let Id):
                return "app/get_institute_project_detail/\(Id)"
            case .getVideoList:
                return "app/get_videos"
            case .getVideoDetail(let Id):
                return "app/get_video_detail/\(Id)"
            case .getReadList:
                return "app/get_articles"
            case .getReadDetail(let Id):
                return "app/get_article_detail/\(Id)"
            case .getEventList:
                return "app/get_events"
            case .getEventDetail(let Id):
                return "app/get_event_detail/\(Id)"
            case .getCourseList:
                return "app/get_courses"
            case .getCourseDetail(let Id):
                return "app/get_course_detail/\(Id)"
            case .getEventTicket(let Id):
                return "app/get_event_tickets/\(Id)"
            case .AddAttendees:
                return "app/add_attendees"
            case .EventBooking:
                return "app/book_event"
            case .ConfirmBooking:
                return "app/confirm_booking"
            case .CourseCheckout:
                return "app/get_course_checkout_detail"
            case .CourseRegistration:
                return "app/register_course"
            case .ConfirmRegistration:
            return "app/confirm_registraion"
            case .RequestDonation:
            return "app/donation_request"
            case .ConfirmDonation:
            return "app/confirm_donation"
            }
            
        }
    }
    
    enum InsituteProgram:RequestExecuter {
        case getProgramsList,getProgramsDetail(Int),joinUserProgram(Int),getProgramDayDetail,programCompleteDay(Int), challengeCompleteDay(Int)
        
        var method: HTTPMethod {
            switch self {
                case .getProgramsList:
                    return .post
                case .getProgramsDetail:
                    return .get
                case .joinUserProgram:
                    return .get
                case .getProgramDayDetail:
                    return .post
            case .programCompleteDay, .challengeCompleteDay:
                    return .get
            }
        }
        
        var apiName : String {
            switch self {
                case .getProgramsList:
                    return "app/get_programs"
                case .getProgramsDetail(let Id):
                    return "app/get_program_detail/\(Id)"
                case .joinUserProgram(let Id):
                    return "app/user_join_program/\(Id)"
                case .getProgramDayDetail:
                    return "app/program_day_details"
                case .programCompleteDay(let Id):
                    return "app/program_day_complete/\(Id)"
                case .challengeCompleteDay(let Id):
                return "app/challenge_day_complete/\(Id)"
            }
        }

    }
    
    enum Dashboard:RequestExecuter {
        case getHealthMeter, getHealthMeterCatList, updateHealthCategory, getHistoryHealthMeter, searchCategories, spentTime, getProfileData, membershipList, getMembershipDetail(Int), getPointsHistory, getHomePageData, getAllTopOffers, getAllProducts, getAllPeople, getALlServices, getQuickMenuCategory, UpdateQuickMenuCatList, getAllTickets, changePassword, checkEmail, updateEmail, resendOtp, verifyMobileAndOtp, getAllNotification, clearAllNotification, addNewTicket, getGoal, setGoal, globalSearch, claimMembership
        
        var method: HTTPMethod {
            switch self {
            case .getHealthMeter, .getHealthMeterCatList, .getProfileData, .membershipList, .getMembershipDetail, .getPointsHistory, .getHomePageData, .getQuickMenuCategory, .getGoal, .clearAllNotification:
                    return .get
            case .updateHealthCategory, .getHistoryHealthMeter, .searchCategories, .spentTime, .getAllTopOffers, .getAllProducts, .getAllPeople, .getALlServices, .UpdateQuickMenuCatList, .getAllTickets, .changePassword, .checkEmail, .updateEmail, .resendOtp, .verifyMobileAndOtp, .getAllNotification, .addNewTicket, .setGoal, .globalSearch, .claimMembership:
                    return .post
            }
        }
        
        var apiName : String {
            switch self {
                case .getHealthMeter:
                    return "app/getHealthMeter"
            case .getHealthMeterCatList:
                return "app/get_healthmeter_category_list"
                case .updateHealthCategory:
                    return "app/updateHealthCategory"
            case .getHistoryHealthMeter:
                return "app/gethistorydetails"
            case .searchCategories:
                return "app/search_category"
            case .spentTime:
                return "app/spent-time"
            case .getProfileData:
                return "app/get_profile"
            case .membershipList:
                return "app/getMembership"
            case .getMembershipDetail(let Id):
                return "app/getMembership/\(Id)"
            case .getPointsHistory:
                return "app/getuserPointsHistory"
            case .getHomePageData:
                return "app/getFrontHomePage"
            case .getAllTopOffers:
                return "app/getAllTopOffers"
            case .getAllProducts:
                return "app/getProducts"
            case .getAllPeople:
                return "app/getAllPeople"
            case .getALlServices:
                return "app/getAllServices"
            case .getQuickMenuCategory:
                return "app/get_quickpanel_category_list"
            case .UpdateQuickMenuCatList:
                return "app/updateQuickPanelCategory"
            case .getAllTickets:
                return "app/all_ticket_list"
            case .changePassword:
                return "app/change_password"
            case .checkEmail:
                return "app/check_email"
            case .updateEmail:
                return "app/update_email"
            case .resendOtp:
                return "app/resend_mobile_otp"
            case .verifyMobileAndOtp:
                return "app/verifymobile_otp_update"
            case .getAllNotification:
                return "app/general/get_notification_list"
            case .addNewTicket:
                return "app/add_ticket"
            case .getGoal:
                return "app/my_goal_list"
            case .setGoal:
                return "app/add_my_goal"
            case .globalSearch:
                return "app/global_search"
            case .clearAllNotification:
                return "app/general/clear_notification_list"
            case .claimMembership:
                return "app/claimNow"
                
            }
        }

    }
    //MARK:- Social
    enum Social : RequestExecuter {

        case getExploreCategoryList(limit:Int,Offset:Int),getSkillList(limit:Int,Offset:Int),SocialProfileSetup,getSocialData,getExplorePostList(limit:Int,Offset:Int),getMyPostList(limit:Int,Offset:Int),LikeDislikePost,getCommentList(limit:Int,offset:Int,post_id:Int),AddComment,RemoveComment,PostReport,Block,getFriendPostList(limit:Int,Offset:Int),getPostDetail(Int),SearchPost,CreatePost,getUserProfileList(Int),FollowPost,FollowingList,FollowersList,BlockList,DeletePost(Int),EditPost,RoomListing,FriendListing,RoomHistory,SendMessage,FindMeetList,LikeDislikeProfile,SearchFriend

        

         //WebURL.get_my_post_list + "?limit=1000000&offset=0"
        var method : HTTPMethod {
            switch self {
            case .getExploreCategoryList:
                return .get
            case .getSkillList:
                return .get
            case .SocialProfileSetup:
                return .post
            case .getSocialData:
            return .get
            case .getExplorePostList:
            return .get
            case .getMyPostList:
            return .get
            case .LikeDislikePost:
            return .post
            case .getCommentList:
                return .get
            case .AddComment:
                return .post
            case .RemoveComment:
                return .post
            case .PostReport:
                return .post
            case .Block:
                return .post
            case .getFriendPostList:
                return .get
            case .getPostDetail:
                return .get
            case .SearchPost:
                return .post
            case .CreatePost:
                return .post
            case .getUserProfileList:
                return .get
            case .FollowPost:
                return .post
            case .FollowingList:
                return .post
            case .FollowersList:
                return .post
            case .BlockList:
                return .post
            case .DeletePost:
                return .get
            case .RoomListing:
                return .post
            case .FriendListing:
                return .post
            case .RoomHistory:
                return .post
            case .SendMessage:
                return .post
            case .FindMeetList:
                return .post
            case .LikeDislikeProfile:
                return .post
            case .SearchFriend:
                return .post
            case .EditPost:
                return .post
                
            }
        }
        var apiName : String {
            switch self {
                case .getExploreCategoryList(let limit,let Offset):
                    return "app/get_explore_category_list?limit=\(limit)&offset=\(Offset)"
                case .getSkillList(let limit,let Offset):
                    return "app/get_skill_list?limit=\(limit)&offset=\(Offset)"
                case .SocialProfileSetup:
                    return "app/social_profile_setup"
            case .getSocialData:
                    return "app/get_social_profile_data"
            case .getExplorePostList(let limit,let Offset):
                    return "app/get_explore_post_list?limit=\(limit)&offset=\(Offset)"
            case .getMyPostList(let limit,let Offset):
            return "app/get_my_post_list?limit=\(limit)&offset=\(Offset)"
            case .LikeDislikePost:
                    return "app/social_add_likes"
            case .getCommentList(let limit,let Offset, let post_id):
                return "app/get_comment_list?post_id=\(post_id)&limit=\(limit)&offset=\(Offset)"
            case .AddComment:
                return "app/add_comment"
            case.RemoveComment:
                return "app/remove_comment"

            case.PostReport:
                return "app/social_post_report"
            case .Block:
                return "app/social_master_block"
            case .getFriendPostList(let limit,let Offset):
                return "app/get_friends_post_list?limit=\(limit)&offset=\(Offset)"
            case .getPostDetail(let Id):
                return "app/get_post_detail?post_id=\(Id)"
            case .SearchPost:
                return "app/social_search_post"
            case .CreatePost:
                return "app/create_post"
            case .EditPost:
                return "app/edit_post"
            case .getUserProfileList(let Id):
            return "app/social_get_user_data/\(Id)"
            case .FollowPost:
            return "app/follow"
            case .FollowingList:
            return "app/get_following_list"
            case .FollowersList:
            return "app/get_followers_list"
            case .BlockList:
            return "app/social_block_list"
            case .DeletePost(let Id):
            return "app/social_delete_post/\(Id)"
            case .RoomListing:
                return "app/chat/room_listing"
            case .FriendListing:
                return "app/social/get_friends_list"
            case .RoomHistory:
                return "app/chat/room_history"
            case .SendMessage:
                return "app/chat/send_messages"
            case .FindMeetList:
                return "app/social_find_and_meet"
            case .LikeDislikeProfile:
                return "app/social_tinder"
            case .SearchFriend:
                return "app/social_search_users"
            
             
            }
        }
    }
    
    enum OrderDetail: RequestExecuter {
        
        case getCourseDetail,OrderBookEventDetails
        
        var method: HTTPMethod {
            switch self {
            case .getCourseDetail,.OrderBookEventDetails:
                return .post
           
            }
        }
        
        var apiName: String {
            switch self {
            case .getCourseDetail:
                return "app/get_courses_registration"
            case .OrderBookEventDetails:
            return "app/get_booked_events"
           
            }
        }
    }
}












