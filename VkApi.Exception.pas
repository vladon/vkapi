unit VkApi.Exception;

interface

uses
  System.SysUtils;

type
  EVkException = class(Exception)

  end;

  EVkUnknownError = class(EVkException);
  EVkApplicationDisabled = class(EVkException);
  EVkUnknownMethodPassed = class(EVkException);
  EVkIncorrectSignature = class(EVkException);
  EVkUserAuthorizationFailed = class(EVkException);
  EVkTooManyRequests = class(EVkException);
  EVkPermissionDenied = class(EVkException);
  EVkInvalidRequest = class(EVkException);
  EVkFloodControl = class(EVkException);
  EVkInternalServerError = class(EVkException);
  EVkTestMode = class(EVkException);
  EVkCaptchaNeeded = class(EVkException);
  EVkAccessDenied = class(EVkException);
  EVkHTTPAuthorizationFailed = class(EVkException);
  EVkValidationRequired = class(EVkException);
  EVkPermissionDeniedForNonStandalone = class(EVkException);
  EVkPermissionAllowedOnlyForStandaloneAndOpenAPI = class(EVkException);
  EVkMethodWasDisabled = class(EVkException);
  EVkParameterMissingOrInvalid = class(EVkException);
  EVkInvalidApplicationAPIId = class(EVkException);
  EVkInvalidUserId = class(EVkException);
  EVkInvalidTimestamp = class(EVkException);
  EVkAccessToAlbumDenied = class(EVkException);
  EVkAccessToAudioDenied = class(EVkException);
  EVkAccessToGroupDenied = class(EVkException);
  EVkThisAlbumIsFull = class(EVkException);
  EVkVotesProcessingPermissionDenied = class(EVkException);
  EVkOperationsWithGivenObjectsPermissionDenied = class(EVkException);
  EVkSomeAdsErrorOccured = class(EVkException);

implementation

end.
