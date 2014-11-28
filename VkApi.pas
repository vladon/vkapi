unit VkApi;

interface

uses
  System.SysUtils, REST.Authenticator.OAuth, REST.Client, REST.Types,
  REST.Utils, System.Math, System.Types, System.StrUtils, System.JSON,
  System.Variants, SynCommons, VkApi.Photo, System.DateUtils, VkApi.Utils,
  VkApi.Authenticator, VkApi.Types, VkApi.Constants, VkApi.Exception;

{ helpers }
type
  TVkPhotosGetWallUploadServerResponse = record
    UploadUrl: string;
    AlbumId: Integer;
    UserId: Integer;
  end;

type
  TVkPostedPhotoInfo = record
    Server: Integer;
    Photo: string; // photo info
    Hash: string;
  end;

type
  TVkSaveWallPhotoParams = record
    UserId: Integer;
    GroupId: Integer;
    Photo: string;
    Server: Integer;
    Hash: string;
  end;

{ TVkApi class }

type
  TVkApi = class
    private
      FAppId: string;
      FSecretKey: string;
      FAccessToken: string;
      FVkAuthenticator: TVkAuthenticator;
      FRESTClient: TRESTClient;
      FRESTRequest: TRESTRequest;
      FRESTResponse: TRESTResponse;
      FAppPermissions: Integer;

      function GetScope: string;
      procedure SetScope(const Value: string);

      function GetDisplay: TVkDisplayType;
      procedure SetDisplay(const Value: TVkDisplayType);

      function GetApiVersion: TVkApiVersion;
      procedure SetApiVersion(const Value: TVkApiVersion);

      function GetAuthorizationRequestURI: string;

      procedure SetAccessToken(const Value: string);

      procedure PrepareRESTRequest;
    public
      property Scope: string read GetScope write SetScope;
      property Display: TVkDisplayType read GetDisplay write SetDisplay;
      property ApiVersion: TVkApiVersion read GetApiVersion write SetApiVersion;
      property AuthorizationRequestURI: string read GetAuthorizationRequestURI;
      property AccessToken: string read FAccessToken write SetAccessToken;

      constructor Create(const AAppId: string; const ASecretKey: string;
         const AAccessToken: string);
      destructor Destroy; override;

      // account methods
      function AccountGetAppPermissions(const AUserId: Integer = 0): Integer;

      // wall methods
      function WallPost(const AOwnerId: Integer; const AMessage: string):
        string;

      function WallPostPhoto(const AOwnerId: Integer; const AAttachments:
         string; const AMessage: string): string;

      // ***
      // photos methods

      // photos.getWallUploadServer
      function PhotosGetWallUploadServer(const GroupId: Integer):
        TVkPhotosGetWallUploadServerResponse;

      // photos.saveWallPhoto - https://vk.com/dev/photos.saveWallPhoto
      function PhotosSaveWallPhoto(const AParams: TVkSaveWallPhotoParams):
        TVkPhoto;

      // ***
      function UploadPhotoToWall(const AFilename: string): TVkPhoto;
  end;

implementation

{ TVkApi }

function TVkApi.AccountGetAppPermissions(const AUserId: Integer = 0): Integer;
begin
  FRESTRequest.Resource := 'account.getAppPermissions';
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Params.Clear;
  if AUserId <> 0 then
  begin
    FRESTRequest.Params.AddItem('user_id', IntToStr(AUserId), pkGETorPOST, [
       poDoNotEncode]);
  end;
  FRESTRequest.Params.AddItem('v', VkApiVersionToString(Self.ApiVersion),
     pkGETorPOST, [poDoNotEncode]);
  FRESTRequest.Execute;

  if not TryStrToInt((FRESTResponse.JSONValue as TJSONObject).GetValue(
     'response').ToString, Result) then
     Result := 0;

  if AUserId = 0 then
    FAppPermissions := Result;
end;

constructor TVkApi.Create(const AAppId: string; const ASecretKey: string;
   const AAccessToken: string);
begin
  inherited Create;

  FAppId := AAppId;
  FSecretKey := ASecretKey;
  FAccessToken := AAccessToken;

  FVkAuthenticator := TVkAuthenticator.Create(nil);
  FRESTClient := TRESTClient.Create(VKAPI_BASE_URL);
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);

  // Pre-init objects

  FVkAuthenticator.AccessTokenParamName := VKAPI_ACCESS_TOKEN_PARAM_NAME;
  FVkAuthenticator.ResponseType := VKAPI_RESPONSE_TYPE;
  FVkAuthenticator.TokenType := VKAPI_TOKEN_TYPE;
  FVkAuthenticator.AuthorizationEndpoint := VKAPI_AUTHORIZATION_ENDPOINT;
  FVkAuthenticator.RedirectionEndpoint := VKAPI_REDIRECTION_ENDPOINT;
  FVkAuthenticator.ClientID := FAppId;
  FVkAuthenticator.ClientSecret := FSecretKey;
  FVkAuthenticator.AccessToken := FAccessToken;

  FRESTClient.Accept := VKAPI_ACCEPT;
  FRESTClient.AllowCookies := True;
  FRESTClient.Authenticator := FVkAuthenticator;
  FRESTClient.FallbackCharsetEncoding := VKAPI_FALLBACK_CHARSET_ENCODING;
  FRESTClient.AutoCreateParams := True;
  FRESTClient.HandleRedirects := True;

  FRESTRequest.Accept := VKAPI_ACCEPT;
  FRESTRequest.AcceptCharset := VKAPI_ACCEPT_CHARSET;
  FRESTRequest.AutoCreateParams := True;
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.HandleRedirects := True;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.Timeout := VKAPI_TIMEOUT;

  Self.ApiVersion := VKAPI_DEFAULT_API_VERSION;
end;

destructor TVkApi.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;

  inherited Destroy;
end;

function TVkApi.GetApiVersion: TVkApiVersion;
begin
  Result := FVkAuthenticator.ApiVersion;
end;

function TVkApi.GetAuthorizationRequestURI: string;
begin
  if FVkAuthenticator <> nil then
    Result := FVkAuthenticator.AuthorizationRequestURI
  else
    Result := '';
end;

function TVkApi.GetDisplay: TVkDisplayType;
begin
  Result := FVkAuthenticator.Display;
end;

function TVkApi.GetScope: string;
begin
  if FVkAuthenticator <> nil then
    Result := FVkAuthenticator.Scope
  else
    Result := '';
end;

function TVkApi.PhotosGetWallUploadServer(
  const GroupId: Integer): TVkPhotosGetWallUploadServerResponse;
var
  v: Variant;
begin
  PrepareRESTRequest;

  FRESTRequest.Resource := 'photos.getWallUploadServer';
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Params.AddItem('group_id', IntToStr(GroupId), pkGETorPOST,
    [poDoNotEncode]);
  FRESTRequest.Execute;

  if FRESTResponse.StatusCode = 200 then
  begin
    v := _JsonFast(RawUTF8(FRESTResponse.Content));
    Result.UploadUrl := v.response.upload_url;
    Result.AlbumId := v.response.album_id;
    Result.UserId := v.response.user_id;
  end else begin

  end;
end;

function TVkApi.PhotosSaveWallPhoto(const AParams: TVkSaveWallPhotoParams):
  TVkPhoto;
var
  v: Variant;
begin
  PrepareRESTRequest;

  FRESTRequest.Resource := 'photos.saveWallPhoto';
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  if AParams.UserId > 0 then
    FRESTRequest.Params.AddItem('user_id', IntToStr(AParams.UserId), pkGETorPOST,
        [poDoNotEncode]);

  if AParams.GroupId > 0 then
    FRESTRequest.Params.AddItem('group_id', IntToStr(AParams.GroupId),
       pkGETorPOST, [poDoNotEncode]);

  FRESTRequest.Params.AddItem('photo', AParams.Photo, pkGETorPOST, [
     poDoNotEncode]);

  FRESTRequest.Params.AddItem('server', IntToStr(AParams.Server), pkGETorPOST, [poDoNotEncode]);

  FRESTRequest.Params.AddItem('hash', AParams.Hash, pkGETorPOST, [
     poDoNotEncode]);

  FRESTRequest.Execute;

  if FRESTResponse.StatusCode = 200 then
  begin
    v := _JsonFast(RawUTF8(FRESTResponse.Content));

    Result.Text := FRESTResponse.Content;

    try
      Result.Id := VarValue(v.response._(0).id, 0);
      Result.AlbumId := VarValue(v.response._(0).album_id, 0);
      Result.OwnerId := VarValue(v.response._(0).owner_id, 0);

      Result.UserId := VarValue(v.response._(0).user_id, 0);
      Result.Photo75 := VarValue(v.response._(0).photo_75, EmptyStr);
      Result.Photo130 := VarValue(v.response._(0).photo_130, EmptyStr);
      Result.Photo604 := VarValue(v.response._(0).photo_604, EmptyStr);
      Result.Photo807 := VarValue(v.response._(0).photo_807, EmptyStr);
      Result.Photo1280 := VarValue(v.response._(0).photo_1280, EmptyStr);
      Result.Photo2560 := VarValue(v.response._(0).photo_2560);
      Result.Width := VarValue(v.response._(0).width, 0);
      Result.Height := VarValue(v.response._(0).height, 0);
      Result.Text := VarValue(v.response._(0).text, EmptyStr);
      Result.Date := UnixToDateTime(VarValue(v.response._(0).date));
    except
      on E: Exception do
      begin
        Result.Text := Result.Text + #13#10 + E.ClassName + #13#10 + E.Message;
      end;
    end;
  end;
end;

procedure TVkApi.PrepareRESTRequest;
begin
  FRESTRequest.Params.Clear;
  FRESTRequest.Params.AddItem('v', VkApiVersionToString(Self.ApiVersion),
     pkGETorPOST, [poDoNotEncode]);
end;

procedure TVkApi.SetAccessToken(const Value: string);
begin
  FAccessToken := Value;
  if FVkAuthenticator <> nil then
    FVkAuthenticator.AccessToken := Value;
end;

procedure TVkApi.SetApiVersion(const Value: TVkApiVersion);
begin
  if (Value <> FVkAuthenticator.ApiVersion) then
    FVkAuthenticator.ApiVersion := Value;
end;

procedure TVkApi.SetDisplay(const Value: TVkDisplayType);
begin
  if (Value <> FVkAuthenticator.Display) then
    FVkAuthenticator.Display := Value;
end;

procedure TVkApi.SetScope(const Value: string);
begin
  if FVkAuthenticator <> nil then
    FVkAuthenticator.Scope := Value;
end;

function TVkApi.UploadPhotoToWall(const AFilename: string): TVkPhoto;
begin

end;

function TVkApi.WallPost(const AOwnerId: Integer;
  const AMessage: string): string;
begin
  PrepareRESTRequest;

  FRESTRequest.Resource := 'wall.post';
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Params.AddItem('owner_id', IntToStr(AOwnerId), pkGETorPOST, [poDoNotEncode]);
  FRESTRequest.Params.AddItem('friends_only', '0', pkGETorPOST, [poDoNotEncode]);
  FRESTRequest.Params.AddItem('from_group', '1', pkGETorPOST, [poDoNotEncode]);
  FRESTRequest.Params.AddItem('message', AMessage, pkGETorPOST, [poDoNotEncode]);
  FRESTRequest.Execute;

  if FRESTRequest.Response.StatusCode = 200 then
    Result := FRESTResponse.JSONText
  else
    Result := FRESTResponse.ErrorMessage;
end;

function TVkApi.WallPostPhoto(const AOwnerId: Integer; const AAttachments,
  AMessage: string): string;
begin
  PrepareRESTRequest;

  FRESTRequest.Resource := 'wall.post';
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Params.AddItem('owner_id', IntToStr(AOwnerId), pkGETorPOST, [
     poDoNotEncode]);
  FRESTRequest.Params.AddItem('friends_only', '0', pkGETorPOST, [
     poDoNotEncode]);
  FRESTRequest.Params.AddItem('from_group', '1', pkGETorPOST, [poDoNotEncode]);
  FRESTRequest.Params.AddItem('message', AMessage, pkGETorPOST, [
     TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.Params.AddItem('attachments', AAttachments, pkGETorPOST, [
     TRESTRequestParameterOption.poDoNotEncode]);

  FRESTRequest.Execute;

  if FRESTRequest.Response.StatusCode = 200 then
    Result := FRESTResponse.JSONText
  else
    Result := FRESTResponse.ErrorMessage;
end;

end.
