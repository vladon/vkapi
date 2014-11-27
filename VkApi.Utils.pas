unit VkApi.Utils;

interface

uses
  System.SysUtils, System.StrUtils, System.Types, VkApi.Types, System.Variants;


function UserIdToOwnerId(const UserId: Cardinal): Integer;

function GroupIdToOwnerId(const GroupId: Cardinal): Integer;

function OwnerIdToUserId(const OwnerId: Integer): Cardinal;

function OwnerIdToGroupId(const OwnerId: Integer): Cardinal;

function VkDisplayTypeToString(const ADisplayType: TVkDisplayType): string;

function VkApiVersionToString(const AApiVersion: TVkApiVersion): string;

function VkPermissionsToStr(const AVkPermissions: TVkPermissions): string;
function VkPermissionsToInt(const AVkPermissions: TVkPermissions): Integer;
function StrToVkPermissions(const AStr: string): TVkPermissions;
function IntToVkPermissions(const AInt: Integer): TVkPermissions;

function VarIsOk(const V: Variant): Boolean;
function VarValue(const V: Variant; const DefaultValue: Variant):
  Variant; overload;
function VarValue(const V: Variant): Variant; overload;

implementation

function UserIdToOwnerId(const UserId: Cardinal): Integer;
begin
  Result := Abs(UserId);
end;

function GroupIdToOwnerId(const GroupId: Cardinal): Integer;
begin
  Result := -Abs(GroupId);
end;

function OwnerIdToUserId(const OwnerId: Integer): Cardinal;
begin
  Result := Abs(OwnerId);
end;

function OwnerIdToGroupId(const OwnerId: Integer): Cardinal;
begin
  Result := -Abs(OwnerId);
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
    av5_27: Result := '5.27';
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

// variant helper
function VarIsOk(const V: Variant): Boolean;
begin
  Result := not (VarIsNull(V) or VarIsEmpty(V) or VarIsError(V) or (VarToStr(V) =
     EmptyStr) or VarIsClear(V));
end;

function VarValue(const V: Variant; const DefaultValue: Variant):
  Variant;
begin
  if VarIsOk(V) then
    Result := V
  else
    Result := DefaultValue;
end;

function VarValue(const V: Variant): Variant; overload;
var
  DefaultValue: Variant;
begin
  case VarType(Result) of
    varSmallInt,
    varInteger,
    varShortInt,
    varByte,
    varWord,
    varLongWord,
    varInt64: DefaultValue := 0;

    varSingle,
    varDouble: DefaultValue := 0.0;

    varCurrency: DefaultValue := 0;

    varDate: DefaultValue := 0;

    varOleStr,
    varStrArg,
    varString: DefaultValue := EmptyStr;

    varBoolean: DefaultValue := False;
  end;

  Result := VarValue(V, DefaultValue);
end;

end.
