unit VkApi.Photo;

interface

// https://vk.com/dev/photo
type
  TVkPhoto = record
    Id: Cardinal;
    AlbumId: Integer;
    OwnerId: Integer;
    UserId: Cardinal;
    Photo75: string;
    Photo130: string;
    Photo604: string;
    Photo807: string;
    Photo1280: string;
    Photo2560: string;
    Width: Cardinal;
    Height: Cardinal;
    Text: string;
    Date: TDateTime;
  end;

implementation

end.
