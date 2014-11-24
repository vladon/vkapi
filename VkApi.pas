unit VkApi;

interface

uses
  System.SysUtils, REST.Authenticator.OAuth, REST.Client, REST.Types,
  REST.Utils, System.Math, System.Types, System.StrUtils, System.JSON,
  System.Variants, SynCommons;

// VK API constants
const
  VKAPI_BASE_URL = 'https://api.vk.com/method';
  VKAPI_ACCESS_TOKEN_PARAM_NAME = 'access_token';
  VKAPI_RESPONSE_TYPE = TOAuth2ResponseType.rtTOKEN;
  VKAPI_TOKEN_TYPE = TOAuth2TokenType.ttNONE;
  VKAPI_ACCEPT = 'text/html,application/xhtml+xml,application/' +
    'xml;q=0.9,*/*;q=0.8';
  VKAPI_FALLBACK_CHARSET_ENCODING = 'UTF-8';
  VKAPI_USERAGENT = 'Embarcadero RESTClient/1.0';
  VKAPI_ACCEPT_CHARSET = 'UTF-8, *;q=0.8';
  VKAPI_TIMEOUT = 30000;
  VKAPI_AUTHORIZATION_ENDPOINT = 'https://oauth.vk.com/authorize';
  VKAPI_REDIRECTION_ENDPOINT = 'https://oauth.vk.com/blank.html';

{ display parameter }
type
  TVkDisplayType = (dtPage, dtPopup, dtMobile);

function VkDisplayTypeToString(const ADisplayType: TVkDisplayType): string;

{ versions }
type
  TVkApiVersion = (av4_0, av4_1, av4_2, av4_3, av4_4, av4_5, av4_6, av4_7,
     av4_8, av4_9, av4_91, av4_92, av4_93, av4_94, av4_95, av4_96, av4_97,
     av4_98, av4_99, av4_100, av4_101, av4_102, av4_103, av4_104, av5_0, av5_1,
     av5_2, av5_3, av5_4, av5_5, av5_6, av5_7, av5_8, av5_9, av5_10, av5_11,
     av5_12, av5_13, av5_14, av5_15, av5_16, av5_17, av5_18, av5_19, av5_20,
     av5_21, av5_22, av5_23, av5_24, av5_25, av5_26);

const
  VKAPI_LAST_API_VERSION: TVkApiVersion = TVkApiVersion.av5_26;

const
  VKAPI_DEFAULT_API_VERSION: TVkApiVersion = TVkApiVersion.av5_26;

function VkApiVersionToString(const AApiVersion: TVkApiVersion): string;

type
  TVkAuthenticator = class(TOAuth2Authenticator)
    private
      FDisplay: TVkDisplayType;
      FApiVersion: TVkApiVersion;

      procedure SetDisplay(const Value: TVkDisplayType);
      procedure SetApiVersion(const Value: TVkApiVersion);
    public
      property Display: TVkDisplayType read FDisplay write SetDisplay;
      property ApiVersion: TVkApiVersion read FApiVersion write SetApiVersion;

      function AuthorizationRequestURI: string;
  end;

{ TVkPermissions }

const
  VKAPI_PERMISSION_NOTIFY         = $000001; //  0     1
  VKAPI_PERMISSION_FRIENDS        = $000002; //  1     2
  VKAPI_PERMISSION_PHOTOS         = $000004; //  2     4
  VKAPI_PERMISSION_AUDIO          = $000008; //  3     8
  VKAPI_PERMISSION_VIDEO          = $000010; //  4    16
  VKAPI_PERMISSION_OFFERS         = $000020; //  5    32, obsolete
  VKAPI_PERMISSION_QUESTIONS      = $000040; //  6    64, obsolete
  VKAPI_PERMISSION_PAGES          = $000080; //  7   128
  VKAPI_PERMISSION_LEFTMENULINK   = $000100; //  8   256
                                             //  9   512 - none
  VKAPI_PERMISSION_STATUS         = $000400; // 10   1024
  VKAPI_PERMISSION_NOTES          = $000800; // 11   2048
  VKAPI_PERMISSION_MESSAGES       = $001000; // 12   4096
  VKAPI_PERMISSION_WALL           = $002000; // 13   8192
                                             // 14  16384 - none
  VKAPI_PERMISSION_ADS            = $008000; // 15  32768
  VKAPI_PERMISSION_OFFLINE        = $010000; // 16  65536
  VKAPI_PERMISSION_DOCS           = $020000; // 17 131072
  VKAPI_PERMISSION_GROUPS         = $040000; // 18 262144
  VKAPI_PERMISSION_NOTIFICATIONS  = $080000; // 19 524288
  VKAPI_PERMISSION_STATS          = $100000; // 20 1048576
                                             // 21 2097152 - none
  VKAPI_PERMISSION_EMAIL          = $400000; // 22 4194304

// VKAPI_PERMISSION_NOHTTPS - ?

type
  TVkPermission = (
    vkpNotify,
    vkpFriends,
    vkpPhotos,
    vkpAudio,
    vkpVideo,
    vkpOffers,
    vkpQuestions,
    vkpPages,
    vkpLeftMenuLink,
    vkpStatus,
    vkpNotes,
    vkpMessages,
    vkpWall,
    vkpAds,
    vkpOffline,
    vkpDocs,
    vkpGroups,
    vkpNotifications,
    vkpStats,
    vkpEmail,
    vkpNoHttps
  );

  TVkPermissions = set of TVkPermission;

function VkPermissionsToStr(const AVkPermissions: TVkPermissions): string;
function VkPermissionsToInt(const AVkPermissions: TVkPermissions): Integer;
function StrToVkPermissions(const AStr: string): TVkPermissions;
function IntToVkPermissions(const AInt: Integer): TVkPermissions;

{ helpers }
type
  TVkPhotosGetWallUploadServerResponse = record
    UploadUrl: string;
    AlbumId: Integer;
    UserId: Integer;
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

      // photos methods
      function PhotosGetWallUploadServer(const GroupId: Integer):
        TVkPhotosGetWallUploadServerResponse;
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
    v := _JsonFast(FRESTResponse.Content);
    Result.UploadUrl := v.response.upload_url;
    Result.AlbumId := v.response.album_id;
    Result.UserId := v.response.user_id;
  end else begin

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

{ TVkAuthenticator }

function TVkAuthenticator.AuthorizationRequestURI: string;
begin
  Result := inherited AuthorizationRequestURI;

  Result := Result + '&display=' + URIEncode(VkDisplayTypeToString(
     FDisplay));

  Result := Result + '&v=' + URIEncode(VkApiVersionToString(FApiVersion));
end;

procedure TVkAuthenticator.SetApiVersion(const Value: TVkApiVersion);
begin
  if (Value <> FApiVersion) then
  begin
    FApiVersion := Value;
    PropertyValueChanged;
  end;
end;

procedure TVkAuthenticator.SetDisplay(const Value: TVkDisplayType);
begin
  if (Value <> FDisplay) then
  begin
    FDisplay := Value;
    PropertyValueChanged;
  end;
end;

{ functions }

function VkDisplayTypeToString(const ADisplayType: TVkDisplayType): string;
begin
  case ADisplayType of
    dtPage:
      Result := 'page'; // do not localize
    dtPopup:
      Result := 'popup'; // do not localize
    dtMobile:
      Result := 'mobile'; // do not localize
  else
    Result := ''; // do not localize
  end;
end;

function VkApiVersionToString(const AApiVersion: TVkApiVersion): string;
begin
  case AApiVersion of
    av4_0: Result := '4.0';
    av4_1: Result := '4.1';
    av4_2: Result := '4.2';
    av4_3: Result := '4.3';
    av4_4: Result := '4.4';
    av4_5: Result := '4.5';
    av4_6: Result := '4.6';
    av4_7: Result := '4.7';
    av4_8: Result := '4.8';
    av4_9: Result := '4.9';
    av4_91: Result := '4.91';
    av4_92: Result := '4.92';
    av4_93: Result := '4.93';
    av4_94: Result := '4.94';
    av4_95: Result := '4.95';
    av4_96: Result := '4.96';
    av4_97: Result := '4.97';
    av4_98: Result := '4.98';
    av4_99: Result := '4.99';
    av4_100: Result := '4.100';
    av4_101: Result := '4.101';
    av4_102: Result := '4.102';
    av4_103: Result := '4.103';
    av4_104: Result := '4.104';
    av5_0: Result := '5.0';
    av5_1: Result := '5.1';
    av5_2: Result := '5.2';
    av5_3: Result := '5.3';
    av5_4: Result := '5.4';
    av5_5: Result := '5.5';
    av5_6: Result := '5.6';
    av5_7: Result := '5.7';
    av5_8: Result := '5.8';
    av5_9: Result := '5.9';
    av5_10: Result := '5.10';
    av5_11: Result := '5.11';
    av5_12: Result := '5.12';
    av5_13: Result := '5.13';
    av5_14: Result := '5.14';
    av5_15: Result := '5.15';
    av5_16: Result := '5.16';
    av5_17: Result := '5.17';
    av5_18: Result := '5.18';
    av5_19: Result := '5.19';
    av5_20: Result := '5.20';
    av5_21: Result := '5.21';
    av5_22: Result := '5.22';
    av5_23: Result := '5.23';
    av5_24: Result := '5.24';
    av5_25: Result := '5.25';
    av5_26: Result := '5.26';
  else
    Result := '';
  end;
end;

function VkPermissionsToStr(const AVkPermissions: TVkPermissions): string;
begin
  Result := '';

  if vkpNotify in AVkPermissions then
    Result := Result + 'notify,';

  if vkpFriends in AVkPermissions then
    Result := Result + 'friends,';

  if vkpPhotos in AVkPermissions then
    Result := Result + 'photos,';

  if vkpAudio in AVkPermissions then
    Result := Result + 'audio,';

  if vkpVideo in AVkPermissions then
    Result := Result + 'video,';

  if vkpOffers in AVkPermissions then
    Result := Result + 'offers,';

  if vkpQuestions in AVkPermissions then
    Result := Result + 'questions,';

  if vkpPages in AVkPermissions then
    Result := Result + 'pages,';

  if vkpLeftMenuLink in AVkPermissions then
  begin
    // no string for this
  end;

  if vkpStatus in AVkPermissions then
    Result := Result + 'status,';

  if vkpNotes in AVkPermissions then
    Result := Result + 'notes,';

  if vkpMessages in AVkPermissions then
    Result := Result + 'messages,';

  if vkpWall in AVkPermissions then
    Result := Result + 'wall,';

  if vkpAds in AVkPermissions then
    Result := Result + 'ads,';

  if vkpOffline in AVkPermissions then
    Result := Result + 'offline,';

  if vkpDocs in AVkPermissions then
    Result := Result + 'docs,';

  if vkpGroups in AVkPermissions then
    Result := Result + 'groups,';

  if vkpNotifications in AVkPermissions then
    Result := Result + 'notifications,';

  if vkpStats in AVkPermissions then
    Result := Result + 'stats,';

  if vkpEmail in AVkPermissions then
    Result := Result + 'email,';

  if vkpNoHttps in AVkPermissions then
    Result := Result + 'nohttps';

  // remove first and last commas
  Result := Result.Trim([',']);

end;

function VkPermissionsToInt(const AVkPermissions: TVkPermissions): Integer;
begin
  Result := 0;

  if vkpNotify in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_NOTIFY;

  if vkpFriends in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_FRIENDS;

  if vkpPhotos in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_PHOTOS;

  if vkpAudio in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_AUDIO;

  if vkpVideo in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_VIDEO;

  if vkpOffers in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_OFFERS;

  if vkpQuestions in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_QUESTIONS;

  if vkpPages in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_PAGES;

  if vkpLeftMenuLink in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_LEFTMENULINK;

  if vkpStatus in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_STATUS;

  if vkpNotes in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_NOTES;

  if vkpMessages in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_MESSAGES;

  if vkpWall in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_WALL;

  if vkpAds in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_ADS;

  if vkpOffline in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_OFFLINE;

  if vkpDocs in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_DOCS;

  if vkpGroups in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_GROUPS;

  if vkpNotifications in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_NOTIFICATIONS;

  if vkpStats in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_STATS;

  if vkpEmail in AVkPermissions then
    Result := Result or VKAPI_PERMISSION_EMAIL;

  if vkpNoHttps in AVkPermissions then
  begin
    // value not defined
    // Result := Result or VKAPI_PERMISSION_NOHTTPS;
  end;
end;

function StrToVkPermissions(const AStr: string): TVkPermissions;
var
  sda: System.Types.TStringDynArray;
  i: Integer;
begin
  Result := [];

  sda := SplitString(AStr, ',');
  for i := Low(sda) to High(sda) do
  begin
    if SameText(sda[i], 'NOTIFY') then
      Include(Result, vkpNotify);

    if SameText(sda[i], 'FRIENDS') then
      Include(Result, vkpFriends);

    if SameText(sda[i], 'PHOTOS') then
      Include(Result, vkpPhotos);

    if SameText(sda[i], 'AUDIO') then
      Include(Result, vkpAudio);

    if SameText(sda[i], 'VIDEO') then
      Include(Result, vkpVideo);

    if SameText(sda[i], 'OFFERS') then
      Include(Result, vkpOffers);

    if SameText(sda[i], 'QUESTIONS') then
      Include(Result, vkpQuestions);

    if SameText(sda[i], 'PAGES') then
      Include(Result, vkpPages);

    if SameText(sda[i], 'LEFTMENULINK') then
      Include(Result, vkpLeftMenuLink);

    if SameText(sda[i], 'STATUS') then
      Include(Result, vkpStatus);

    if SameText(sda[i], 'NOTES') then
      Include(Result, vkpNotes);

    if SameText(sda[i], 'MESSAGES') then
      Include(Result, vkpMessages);

    if SameText(sda[i], 'WALL') then
      Include(Result, vkpWall);

    if SameText(sda[i], 'ADS') then
      Include(Result, vkpAds);

    if SameText(sda[i], 'OFFLINE') then
      Include(Result, vkpOffline);

    if SameText(sda[i], 'DOCS') then
      Include(Result, vkpDocs);

    if SameText(sda[i], 'GROUPS') then
      Include(Result, vkpGroups);

    if SameText(sda[i], 'NOTIFICATIONS') then
      Include(Result, vkpNotifications);

    if SameText(sda[i], 'STATS') then
      Include(Result, vkpStats);

    if SameText(sda[i], 'EMAIL') then
      Include(Result, vkpEmail);

    if SameText(sda[i], 'NOHTTPS') then
      Include(Result, vkpNoHttps);
  end;
end;

function IntToVkPermissions(const AInt: Integer): TVkPermissions;
begin
  Result := [];

  if (AInt and VKAPI_PERMISSION_NOTIFY) <> 0 then
    Include(Result, vkpNotify);

  if (AInt and VKAPI_PERMISSION_FRIENDS) <> 0 then
    Include(Result, vkpFriends);

  if (AInt and VKAPI_PERMISSION_PHOTOS) <> 0 then
    Include(Result, vkpPhotos);

  if (AInt and VKAPI_PERMISSION_AUDIO) <> 0 then
    Include(Result, vkpAudio);

  if (AInt and VKAPI_PERMISSION_VIDEO) <> 0 then
    Include(Result, vkpVideo);

  if (AInt and VKAPI_PERMISSION_OFFERS) <> 0 then
    Include(Result, vkpOffers);

  if (AInt and VKAPI_PERMISSION_QUESTIONS) <> 0 then
    Include(Result, vkpQuestions);

  if (AInt and VKAPI_PERMISSION_PAGES) <> 0 then
    Include(Result, vkpPages);

  if (AInt and VKAPI_PERMISSION_LEFTMENULINK) <> 0 then
    Include(Result, vkpLeftMenuLink);

  if (AInt and VKAPI_PERMISSION_STATUS) <> 0 then
    Include(Result, vkpStatus);

  if (AInt and VKAPI_PERMISSION_NOTES) <> 0 then
    Include(Result, vkpNotes);

  if (AInt and VKAPI_PERMISSION_MESSAGES) <> 0 then
    Include(Result, vkpMessages);

  if (AInt and VKAPI_PERMISSION_WALL) <> 0 then
    Include(Result, vkpWall);

  if (AInt and VKAPI_PERMISSION_ADS) <> 0 then
    Include(Result, vkpAds);

  if (AInt and VKAPI_PERMISSION_OFFLINE) <> 0 then
    Include(Result, vkpOffline);

  if (AInt and VKAPI_PERMISSION_DOCS) <> 0 then
    Include(Result, vkpDocs);

  if (AInt and VKAPI_PERMISSION_GROUPS) <> 0 then
    Include(Result, vkpGroups);

  if (AInt and VKAPI_PERMISSION_NOTIFICATIONS) <> 0 then
    Include(Result, vkpNotifications);

  if (AInt and VKAPI_PERMISSION_STATS) <> 0 then
    Include(Result, vkpStats);

  if (AInt and VKAPI_PERMISSION_EMAIL) <> 0 then
    Include(Result, vkpEmail);

  // nohttps value is not defined
//  if (AInt and VKAPI_PERMISSION_NOHTTPS) <> 0 then
//    Include(Result, vkpNoHttps);
end;

end.
