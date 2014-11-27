unit VkApi.Authenticator;

interface

uses
  REST.Authenticator.OAuth, REST.Utils, VkApi.Types, VkApi.Utils;

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

implementation

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

end.
