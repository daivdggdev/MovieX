#ifndef __PPS_H__
#define __PPS_H__

#ifdef __cplusplus
extern "C" {
#endif

typedef char               char8;
typedef unsigned char      uchar8;
typedef short              int16;
typedef unsigned short     uint16;	
typedef int                int32;
typedef unsigned int       uint32;
typedef long long          int64;
typedef unsigned long long uint64;

typedef struct ems_event
{
    uint32         event_id;
    uint32         param;
    uint32         param_extra;
    uchar8         payload[8];
} ems_event;

typedef struct ems_task_info
{
    uint32          down_speed;      // download speed (B/s)
    uint32          up_speed;        // upload speed (B/s)
    uint64          file_size;       // total file size
#ifdef ANDROID
    float           percent;
#else
    uint32          percent;         // download percent 
#endif
} ems_task_info;

typedef int32 (*ems_event_listener)(int32 index, ems_event event); 

#if (defined __IOS__) || (defined MACOSX)
int32 ems_init(const char8 *manufacturer, 
               const char8 *model_number, 
               const char8 *unique_id,
	       const char8 *root_dir);
#elif defined ANDROID	
int32 ems_init(const char8 *manufacturer,
		const char8 *model_number,
		const char8 *unique_id,
		const char8 *unique_id_new,
		const char8 *configFile);
#else
int32 ems_init(const char8 *manufacturer, 
               const char8 *model_number, 
               const char8 *unique_id);
#endif

int32 ems_uninit(void);

int32 ems_event_listener_func(ems_event_listener listener);

int32 ems_get_event(ems_event *pevent);

/*
 * task_mode = 0, VOD mode
 * 	     = 1, Download mode
 * 	     = 2, VOD + Download at the same time
 *
 */
typedef enum _EMS_TASK_MODE
{
	EMS_TASK_VOD = 0,
	EMS_TASK_DOWNLOAD,  //1
	EMS_TASK_VOD_DOWN,  //2
} EMS_TASK_MODE;

int32 ems_add_task(char8 *url, int32 task_mode, char8 *save_path);

int32 ems_del_task(int32 index);

#ifdef ANDROID
int32 ems_start_task(int32 index, const char8 *paycode,int32 start_secs);
#elif defined __IOS__
int32 ems_start_task(int32 index, const char8 * paycode, char8 * user_id);
#else
int32 ems_start_task(int32 index, const char8 *paycode);
#endif
    
#ifdef ANDROID
    int32 ems_start_task2(int32 index, const char8 * paycode, int32 start_secs, uint64 filepos);
#elif defined __IOS__
    int32 ems_start_task2(int32 index, const char8 * paycode, char8 * user_id, uint64 filepos);
#else
    int32 ems_start_task2(int32 index, const char8 * paycode, uint64 filepos);
#endif
    
int32 ems_get_downloaded_data_size(char const* filepath, uint64* filepos);

int32 ems_stop_task(int32 index);

int32 ems_readdata(int32 index, uchar8 *buffer, uint32 length, uint64 position, struct timeval* time_out);

#ifdef FOR_QIYI
int32 ems_is_url_can_p2p(int32 index, char8 * url);

typedef struct _f4v_info_t
{
	unsigned int    meta_offset;
	unsigned int    meta_length;
	__int64         data_offset;
	unsigned int    data_length;
} f4v_info_t;

//QiYi F4V read API
int32 ems_f4v_readdata(int32 index, char8 fid_size, uchar8* fid_buf,uint64 off_set, uchar8 *buffer, uint32 length, f4v_info_t * f4v_info);
#endif

//New API for P2P 2.0
int32 ems_pause_task(int32 index);

int32 ems_resume_task(int32 index);

int32 ems_pfv_timestamp2offset(int32 index, int64 timestamp, int64 *offset);

//int32 ems_pfv_get_keyframesSize(int32 index, int32 * keyFrameSize, uint32 * last_seg_duration);
int32 ems_pfv_get_keyframesSize(int32 index, int32 * keyFrameSize, uint32 * last_seg_duration, uint32 * flv_file_length);
 
//int32 ems_pfv_get_keyframesInfos(int32 index, uint64 * pIframesPos, uint64 * pIframesPTS);
int32 ems_pfv_get_keyframesInfos(int32 index, uint32 * pIframesPos, uint32 * pIframesPTS); 

int32 ems_pfv_get_frameNum(int32 index, uint32 * frameNum);

int32 ems_pfv_get_framesCtsInfos(int32 index, uint16 * pframeCts, uint32 * pIframesIndex);

int32 ems_drop_read(int32 index);

int32 ems_get_task_status(int32 index, ems_task_info *info);

const char *ems_get_err_string(void);

int32 ems_network_act(int32 is_start);

//set 0xFFFFFFFF as unlimited 
int32 ems_set_limit_speed(uint32 download_speed, uint32 uplpad_speed);

int32 ems_set_enter_backgroud(int is_backgroud);

int32 ems_get_task_num(void);

// [wangrunqing]: 启用调试日志文件输出
FILE* ems_enable_debug_log_file(char const* filepath);

#if 1	//FOR DEBUG

typedef enum pps_event_id
{
	EPPS_SERVER_TIMEOUT,            // 0,  连接服务器超时,停止播放
	EPPS_NO_SERVER,                 // 1,  找不到服务器,停止播放
	EPPS_SERVER_NO_RESPONSE,        // 2,  服务器未响应,停止播放
	EPPS_SERVER_INVALID,            // 3,  解析服务器域名失败.
	EPPS_VERSION_LOW,               // 4,  客户端版本号太低,退出网络
	EPPS_CLIENT_NAME,               // 5,  客户端名称或引用页不正确,退出播放
	EPPS_URL_INVALID,               // 6,  播放的文件不存在或网址错误
	EPPS_NO_SERVICE,                // 7,  服务不存在,停止播放
	EPPS_OUT_OF_SERVICE,            // 8,  不在服务区.    
	EPPS_MEDIA_INFO_ERROR,          // 9,  媒体信息加载时错误..
	EPPS_INDEX_INFO_ERROR,          // 10, 媒体索引信息错误
	EPPS_NO_INDEX,                  // 11, 没有获取到媒体索引信息,不能拖动播放位置
	EPPS_NO_MEIDIA,                 // 12, 找不到媒体
	EPPS_MULTI_INSTANCE,            // 13, 请确定是否有另一个实例正在播放此文件
	EPPS_PREPARE_MEDIA_INFO,        // 14, 正在准备媒体信息
	EPPS_GETTING_MEDIA_INFO,        // 15, 正在获取媒体信息
	EPPS_GETTING_INDEX_INFO,        // 16, 正在获取媒体索引信息
	EPPS_PLAYING,                   // 17, 正在播放
	EPPS_BUFFERING,                 // 18, 正在缓冲数据
	EPPS_CONNECTING,                // 19, 正在连入网络
	EPPS_MEDIA_READY,               // 20, 准备媒体就绪
	EPPS_PARSING_SERVER,            // 21, 正在解析服务器域名..
	EPPS_GET_MEDIA_INFO,            // 22, 已成功获取到媒体信息.
	EPPS_BUFFERED,                  // 23, 数据缓冲完毕.
	EPPS_PREPARE_MEDIA,             // 24, 准备媒体
	EPPS_STORAGE_ERROR,             // 25. 访问存储器失败
	EPPS_QUIT,                      // 26. 程序退出

	EPPS_DATA_TIMEOUT,              // 27, 等待数据超时

	EPPS_UPDATING,                  // 28, 正在升级
	EPPS_UPDATE_FAILED,             // 29, 升级失败
	EPPS_UPDATE_OK,                 // 30, 升级成功
	EPPS_AUTH_UNPASSED,             // 31, 验证成功，非付费用户
	EPPS_AUTH_PASSED,               // 32, 验证成功，付费用户
	EPPS_AUTH_INVALID,              // 33, 单部点播，验证未通过
	EPPS_AUTH_FAILED,               // 34, 验证失败
	EPPS_ALLOCATE_PGF,              // 35, 预先分配缓存文件空间失败
	EPPS_BUFFERED_SECS,             // 36, buffered seconds
#ifdef ANDROID
	EPPS_MP4HEADER_PARSED_FAILD,    // 37, MP4头数据解析出错
	EPPS_BIP_PARSED_OK,		// 38,BIP have parsed ok
	EPPS_MP4HEADER_PARSED_OK,	// 39,MP4 header parsed ok
	EPPS_DOWNLOAD_SPEED,            // 40, download speed
	EPPS_GET_BIP_FAILED,		// 41, get bip file failed
	EPPS_GET_BIP_CRC_ERROR,		// 42, bip file crc check failed
#else
	EPPS_DOWNLOAD_SPEED,            // 37, download speed
	EPPS_UNAUTH,			// 38, unauth
	EPPS_GET_BIP_FAILED,		// 39, get bip file failed
	EPPS_GET_BIP_CRC_ERROR,		// 40, bip file crc check failed
	EPPS_FILE_LENGTH,		// 41, download file full length
	EPPS_FILE_DOWNLOADED,		// 42, download file downloaded length
	EPPS_FILE_RENAME_FAILD,		// 43, download file rename faild, can't remove ".pmv" ext. 
#endif

	EPPS_CDN_PARSE_REQUEST_FAILD,   // cdn加速解析请求失败
	EPPS_CDN_PARSE_REQUEST_RETCODE_ERROR,   // cdn加速解析请求返回值错误

	EPPS_VIP_VERIFY_LIMITED = 27788,  //27788, 文件验证受限制 
	EPPS_VIP_LIMITED_ACTIVED_PLAYER,  //27789, 文件被限制, 但是播放器已经激活, 继续播放.
	EPPS_VIP_PLAYER_UNACTIVED,        //27790, 
	EPPS_VIP_UNMATCH_LIMITED,         //27791, 版本不匹配，文件被限制，停止网络下载服务. 
	EPPS_VIP_LIMITED_RESEND,          //27792, 错误信息超过3秒,网络没有被停止，再发一次.
	EPPS_VIP_ONLY_CONTENT,            //27793, 本内容只允许VIP用户观看, 请用VIP帐户登录之后再重新播放.
	EPPS_VIP_LEVEL_LOW_SLIVER,        //27794, 用户等级不够, 需要白银VIP用户才能观看
	EPPS_VIP_LEVEL_LOW_GOLD,          //27795, 用户等级不够, 需要黄金VIP用户才能观看
	EPPS_VIP_VERIFIED_FAILED,         //27796, 用户身份信息验证失败 


	EPPS_HCDN_CST_CDNOK = 97788,	  //97788, cdnok=(0-CDN下载过的数据小于2m;1-CDN下载过的数据>=2M)
	EPPS_HCDN_CST_CDNTY,		  //97789, cdnty=(0-空;1-qiyi cdn;2-pps cdn)
	EPPS_HCDN_CST_CDNCA,		  //97790, cdnca=(0-播放前缓存没有使用cdn;1-播放前缓存使用cdn)
	EPPS_HCDN_CST_CDNUR,		  //97791, cdnur=(紧急数据使用cdn的次数-分配cdn加速的块个数)
	EPPS_HCDN_CST_CDNDR,		  //97792, cdndr=(拖动导致的使用cdn加速的次数)
	EPPS_HCDN_CST_P2PLI,		  //97793, p2pli=(0-p2p正常;1-p2p受限)
	EPPS_HCDN_CST_CDNDL,		  //97794, cdndl=(0-cdn地址无效或cdn下载数据失败;1-CDN下载过的数据大于0)
	EPPS_HCDN_CST_TL,		  //97795, tl=(0-tracker没有限制，1-tracker有限制)
	EPPS_HCDN_CST_TDF,		  //97796, 这次任务下载的数据 单位KB

} pps_event_id;

#define	ERR_PPS_SUCCESS	0	        // No error
#define	ERR_PPS_COMMON	-1	        // common error
#define	ERR_PPS_SERVER_FAILED	-2	// server timeout or transmit error
#define	ERR_PPS_AUTH_UNPASSED	-3	// auth unpassed
#define	ERR_PPS_AUTH_INVALID	-4	// auth invalid


#define PPS_EXTRA_MSG_LEN  64
#define PPS_MAX_MAP_SIZE   65536

/**************************************************/
/*************TVOD Film Searching API***************/
/**************************************************/
/* search type */
#define PPS_SEARCH_NAME      0x00000001
#define PPS_SEARCH_ACTOR     0x00000002
#define PPS_SEARCH_DIRECTOR  0x00000003
#define PPS_SEARCH_AREA      0x00000004
#define PPS_SEARCH_ALL       0x00000005

/* search order */
#define PPS_SEARCH_BITRATE_DOWN 0x00000001
#define PPS_SEARCH_BITRATE_UP   0x00000002
#define PPS_SEARCH_SCORE_DOWN   0x00000003
#define PPS_SEARCH_SCORE_UP     0x00000004
#define PPS_SEARCH_DATE_DOWN    0x00000005
#define PPS_SEARCH_DATE_UP      0x00000006
#define PPS_SEARCH_PINYIN_DOWN  0x00000007
#define PPS_SEARCH_PINYIN_UP    0x00000008
#define PPS_SEARCH_HOT_DOWN     0x00000009
#define PPS_SEARCH_HOT_UP       0x0000000A
#endif	//DEBUG

typedef struct __emscategory
{
	int    id;                       /* category or subcategory id */
	char  *name;                     /* category or subcategory num */
	int    type;                     /* subcategory type. 0: movie, 1: teleplay */
	int    subcatnum;                /* subcategory number under this category */
	struct __emscategory *psubcat;   /* subcategory array */

	struct __emscategory *next;
} emscategory;

typedef	struct __emsitem
{
	int    id;                       /* Item id */
	int    index;                    /* Item index */
	int    size;                     /* Item size (MB) */
	int    duration;                 /* Item duration (Minute)*/
	char  *format;                   /* file format (rm/rmvb/wmv) */
	int    bitrate;                  /* bitrate */
	char  *emsurl;                   /* ems vod url */
	int    vipflag;                  /* vip flags */
	int    points;		   /* charge points*/
	struct __emsitem *next;
} emsitem;

typedef struct __emschannel
{
	char *name;                     /* channel name */
	char *director;
	char *actor;
	char *area;
	int   size;                     /* all items' total size under this channel (MB) */
	char *pubtime;                  /* publish time */
	int   duration;                 /* all items' total duration time under this channel (Min) */
	char *lang;                     /* channel language */
	char *desc;                     /* channel description */
	char *BImgUrl;                  /* Big Image Url */
	char *SImgUrl;                  /* Small Image Url */
	int   itemnum;                  /* num of items */
	struct __emsitem *pitems;       /* point to items list */
	
	struct __emschannel *next;
}emschannel;

int32 ems_plist_init(void);
int32 ems_plist_uninit(void);
emscategory *ems_plist_category(int *catnum);
emschannel *ems_plist_channel(int catid, int subcatid, int page_size, int page_num);
emschannel *ems_plist_search(char *keyword, int search_type, int search_order, 
		int page_size, int page_index, int* search_filmtotal_ret);

#ifndef ANDROID
int ems_get_lib_version(int* major, int* minor, int* rel);
#endif

#ifdef __cplusplus
}
#endif
#endif /* __PPS_H__ */
