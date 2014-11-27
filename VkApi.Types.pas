unit VkApi.Types;

interface

{ display parameter }
type
  TVkDisplayType = (dtPage, dtPopup, dtMobile);

{ versions }
type
  TVkApiVersion = (av4_0, av4_1, av4_2, av4_3, av4_4, av4_5, av4_6, av4_7,
     av4_8, av4_9, av4_91, av4_92, av4_93, av4_94, av4_95, av4_96, av4_97,
     av4_98, av4_99, av4_100, av4_101, av4_102, av4_103, av4_104, av5_0, av5_1,
     av5_2, av5_3, av5_4, av5_5, av5_6, av5_7, av5_8, av5_9, av5_10, av5_11,
     av5_12, av5_13, av5_14, av5_15, av5_16, av5_17, av5_18, av5_19, av5_20,
     av5_21, av5_22, av5_23, av5_24, av5_25, av5_26, av5_27);

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

implementation

end.
