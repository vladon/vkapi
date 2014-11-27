unit VkApi.Constants;

interface

uses
  REST.Authenticator.OAuth, VkApi.Types;

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

const
  VKAPI_LAST_API_VERSION: TVkApiVersion = TVkApiVersion.av5_27;

const
  VKAPI_DEFAULT_API_VERSION: TVkApiVersion = TVkApiVersion.av5_27;

implementation

end.
