unit VkApi.Exception;

interface

uses
  System.SysUtils;

type
  EVkException = class(Exception)

  end;

  // common
  // https://vk.com/dev/errors
  // 1
  EVkUnknownError = class(EVkException);
  // 2
  EVkApplicationIsDisabled = class(EVkException);
  // 3
  EVkUnknownMethodPassed = class(EVkException);
  // 4
  EVkIncorrectSignature = class(EVkException);
  // 5
  EVkUserAuthorizationFailed = class(EVkException);
  // 6
  EVkTooManyRequestsPerSecond = class(EVkException);
  // 7
  EVkPermissionToPerformThisActionDenied = class(EVkException);
  // 8
  EVkInvalidRequest = class(EVkException);
  // 9
  EVkFloodControl = class(EVkException);
  // 10
  EVkInternalServerError = class(EVkException);
  // 11
  EVkInTestModeApplicationShouldBeDisabledOrUserShouldBeAuthorized =
    class(EVkException);
  // 14
  EVkCaptchaNeeded = class(EVkException);
  // 15
  EVkAccessDenied = class(EVkException);
  // 16
  EVkHTTPAuthorizationFailed = class(EVkException);
  // 17
  EVkValidationRequired = class(EVkException);
  // 19
  EVkContentBlocked = class(EVkException);
  // 20
  EVkPermissionToPerformThisActionIsDeniedForNonStandalone =
    class(EVkException);
  // 21
  EVkPermissionToPerformThisActionIsAllowedOnlyForStandaloneAndOpenAPI =
    class(EVkException);
  // 23
  EVkThisMethodWasDisabled = class(EVkException);
  // 100
  EVkParameterMissingOrInvalid = class(EVkException);
  // 101
  EVkInvalidApplicationAPIId = class(EVkException);
  // 103
  EVkOutOfLimits = class(EVkException);
  // 113
  EVkInvalidUserId = class(EVkException);
  // 121
  EVkInvalidHash = class(EVkException);
  // 150
  EVkInvalidTimestamp = class(EVkException);
  // 200
  EVkAccessToAlbumDenied = class(EVkException);
  // 201
  EVkAccessToAudioDenied = class(EVkException);
  // 203
  EVkAccessToGroupDenied = class(EVkException);
  // 300
  EVkThisAlbumIsFull = class(EVkException);
  // 500
  EVkVotesProcessingPermissionDenied = class(EVkException);
  // 600
  EVkOperationsWithGivenObjectsPermissionDenied = class(EVkException);
  // 603
  EVkSomeAdsErrorOccured = class(EVkException);

  // auth
  // 1000
  EVkInvalidPhoneNumber = class(EVkException);
  // 1004
  EVkThisPhoneNumberIsUsedByAnotherUser = class(EVkException);
  // 1112
  EVkProcessingTryLater = class(EVkException);
  // 1110
  EVkIncorrectCode = class(EVkException);
  // 1111
  EVkIncorrectPassword = class(EVkException);
  // 1115
  EVkTooManyAuthAttempts = class(EVkException);

  // wall
  // 18
  EVkUserWasDeletedOrBanned = class(EVkException);
  // 210
  EVkAccessToWallPostDenied = class(EVkException);
  // 211
  EVkAccessToWallCommentDenied = class(EVkException);
  // 212
  EVkAccessToPostCommentsDenied = class(EVkException);
  // 213
  EVkAccessToStatusRepliesDenied = class(EVkException);
  // 214
  EVkAccessToAddingPostDenied = class(EVkException);
  // 219
  EVkAdvertisementPostWasRecentlyAdded = class(EVkException);

  // photos
  // 114
  EVkInvalidAlbumId = class(EVkException);
  // 118
  EVkInvalidServer = class(EVkException);
  // 122
  EVkInvalidPhotos = class(EVkException);
  // 129
  EVkInvalidPhoto = class(EVkException);
  // 302
  EVkAlbumsNumberLimitIsReached = class(EVkException);

  // friends
  // 171
  EVkInvalidListId = class(EVkException);
  // 173
  EVkMaximumNumberOfListsReached = class(EVkException);
  // 174
  EVkUserCannotAddHimselfAsFriend = class(EVkException);
  // 175
  EVkCannotAddThisUserToFriendsAsHePutYouOnBlacklist = class(EVkException);
  // 176
  EVkCannotAddThisUserToFriendsAsYouPutHimOnBlacklist = class(EVkException);

  // storage

  // audio
  // 123
  EVkInvalidAudio = class(EVkException);
  // 270
  EVkAudioFileWasRemovedByCopyrightHolder = class(EVkException);
  // 301
  EVkInvalidFilename = class(EVkException);
  // 302
  EVkInvalidFilesize = class(EVkException);

  // pages
  // 119
  EVkInvalidTitle = class(EVkException);
  // 140
  EVkPageNotFound = class(EVkException);
  // 141
  EVkAccessToPageDenied = class(EVkException);

  // groups
  // 260
  EVkAccessToGroupsListDeniedDueUserPrivacySettings = class(EVkException);
  // 125
  EVkInvalidGroupId = class(EVkException);
  // 104
  EVkNotFound = class(EVkException);
  // 700
  EVkCannotEditCreatorRole = class(EVkException);
  // 701
  EVkUserShouldBeInClub = class(EVkException);
  // 702
  EVkTooManyOfficersInClub = class(EVkException);

  // video
  // 204
  EVkVideoAccessDenied = class(EVkException);

  // notes
  // 180
  EVkNoteNotFound = class(EVkException);
  // 181
  EVkAccessToNoteDenied = class(EVkException);
  // 182
  EVkYouCannotCommentThisNote = class(EVkException);
  // 183
  EVkAccessToCommentDenied = class(EVkException);

  // places
  // 190
  EVkYouHaveSentSameCheckinInLast10Minutes = class(EVkException);
  // 191
  EVkAccessToCheckinsDenied = class(EVkException);

  // account
  // 148
  EVkAccessToUserMenuDenied = class(EVkException);

  // messages
  // 22
  EVkUploadError = class(EVkException);
  // 1160
  EVkOriginalPhotoWasChanges = class(EVkException);

  // newsfeed
  // 1170
  EVkTooManyFeedLists = class(EVkException);

  // polls
  // 250
  EVkAccessToPollDenied = class(EVkException);
  // 251
  EVkInvalidPollId = class(EVkException);
  // 252
  EVkInvalidAnswerId = class(EVkException);

  // docs
  // 105
  EVkCouldNotSaveFile = class(EVkException);
  // 1150
  EVkInvalidDocumentId = class(EVkException);
  // 1151
  EVkAccessToDocumentDeletingDenied = class(EVkException);

  // execute
  // 12
  EVkUnableToCompileCode = class(EVkException);
  // 13
  EVkRuntimeErrorOccuredDuringCodeInvocation = class(EVkException);


implementation

end.
