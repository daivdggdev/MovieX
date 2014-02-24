#ifndef EMS_H
#define EMS_H

#ifdef __cplusplus
extern "C" {
#endif

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
	EPPS_DOWNLOAD_SPEED,            // 37, download speed
	EPPS_UNAUTH,                    // 38, unauth
	EPPS_GET_BIP_FAILED,            // 39, get bip file failed
	EPPS_GET_BIP_CRC_ERROR,         // 40, bip file crc error
	EPPS_FILE_LENGTH,               // 41, download file full length
	EPPS_FILE_DOWNLOADED,           // 42, download file downloaded length
	EPPS_ERROR_NO_BIP,              // 43, download file no bip

	EPPS_READ_TS_BUFFERING = 88,    //88, TS read buffering
	EPPS_READ_TS_BUFFERED,          //89, TS read buffer done
	EPPS_PFV2TS_FAILED,             //90, pfv2ts failed
	EPPS_START_TASK_FAILED,         //91, start_task failed
	EPPS_GEN_M3U8_FAILED,           //92, gen m3u8 failed
	EPPS_BIND_EORROR,               //93, bind port error
	EPPS_ERROR_FLV_TAG,		//94, parsing flv tag error
	EPPS_LOCAL_FILE_NO_EXIST,	//95, downloaded local file no exist
	
	EPPS_LIVE_BUFFERING = 200,      //200, PPS Live buffering
	EPPS_LIVE_BUFFERED_DONE,
	EPPS_LIVE_TIMEOUT,
	EPPS_LIVE_SPEED,

	EPPS_GOT_META_DATA = 7788,

	EPPS_CDN_ACCEL_SUCCEED = 9090,

} pps_event_id;


typedef enum cplayer_event_id
{
    ECPLAYER_OPEN_FAILED  = 0x77880000,        // 0,  打开文件失败
    ECPLAYER_START_FAILED,        //1,  启动失败
    ECPLAYER_SEEK_FAILED,         //2,
    ECPLAYER_GET_WIDTH_FAILED,    //3,  获取影片宽度失败
    ECPLAYER_GET_HEIGHT_FAILED,   //4,  获取影片高度失败
    ECPLAYER_DECODE_VIDEO_FAILED, //5,  视频解码失败
    ECPLAYER_RENDER_VIDEO_FAILED, //6,  视频渲染失败
    ECPLAYER_AUDIO_QUEUE_FAILED,  //7,  音频输出失败
    
} cplayer_event_id;    

    
    

typedef char               char8;
typedef unsigned char      uchar8;
typedef short     int16;
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
    uint32          percent;         // download percent 
} ems_task_info;

/***********************
 *  Playback API       *
 ***********************/
typedef int32 (*ems_event_listener)(int32 index, ems_event event); 

/*
 * Description: Init ems library.
 * param:       Datatype            Param name      In/Out     Comment
 *              const char8*        manufacturer    In         manufacturer name
 *              const char8*        model_number    In         platform model name
 *              const char8*        unique_id       In         unique id
 *
 * return:      int32    
 *              return  0    if success; 
 *                      <0   if failed.
 */
int32 emscore_init(const char8 *manufacturer,
            const char8 *model_number,
            const char8 *unique_id,
	    const char8 *root_dir);


/*
 * Description: Uninit ems library.
 * param:       Datatype     Param name      In/Out     Comment
 *              none
 *
 * return:      int32    
 *              return  0    if success; 
 *                      <0   if failed.
 */
int32 emscore_uninit(void);


/*
 * Description: Registe ems library event listener
 * param:       Datatype              Param name      In/Out     Comment
 *              ems_event_listener    listener        In         Function to deal with ems event
 *
 * return:      int32    
 *              return  0     if success; 
 *                      <0    if failed.
 */
int32 emscore_event_listener_func(ems_event_listener listener);


int32 emscore_get_event(ems_event *pevent);

/*
 * Description: Add a url as a task 
 * param:       Datatype         Param name      In/Out     Comment
 *              char8*           url             In         Url add as task 
 *              int32            task_mode       In         0: VOD mode, 1: Download mode, 2: VOD + Download
 *              char8*           save_path       In         When in Download mode, it's the path to save file.
 *
 * return:      int32    
 *              return the task index, which can be use by ems_del_task, ems_start_task, ems_stop_task... 
 *                     <0  failed
 */
int32 emscore_add_task(char8 *url, int32 task_mode, char8 *save_path);



/*
 * Description: Del  a task by index
 * param:       Datatype         Param name      In/Out     Comment
 *              int32            index           In         task index 
 *
 * return:      int32    
 *              return  0    if success; 
 *                      <0   if failed.
 */
int32 emscore_del_task(int32 index);


/*
 * Description: Start play the index's task.
 * param:       Datatype           Param name      In/Out     Comment
 *              int32              index           In         task index
 *              const char8*       paycode         In         pay valid code 
 *
 * return:      int32
 *              return  0    if success; 
 *                      -1   generic error
 *                      -2   can not access to server
 *                      -3   authentication failed
 */
int32 emscore_start_task(int32 index, const char8 *paycode);


/*
 * Description: Stop the playing the index's task. 
 * param:       Datatype     Param name      In/Out     Comment
 *              int32        index           In         task index 
 *
 * return:      int32
 *              return  0    if success; 
 *                      <0   if failed.
 */
int32 emscore_stop_task(int32 index);


/*
 * Description: read data.
 * param:       Datatype         Param name      In/Out     Comment
 *              int32            index             In       task index
 *              uchar *          buffer            Out      buffer to store data
 *              uint32           length            In       data length
 *              uint64           position          In       from where to read.
 *              struct timeval*  time_out          In       time length that read() can block
 *
 * return:      int32    
 *              return length of data if success; 
 *                      0: EOF;
 *                     -1: read failed(errno is set to EAGAIN if data is temporarily unavailable; 
 *                     etherwise, some error happens or EOF reaches). 
 */
int32 emscore_readdata(int32 index, 
                uchar8 *buffer, 
                uint32 length, 
                uint64 position, 
                struct timeval *time_out);

//int32 emscore_pfv_get_keyframesSize(int32 index, int32 * keyFrameSize, uint32 * last_seg_duration);
int32 emscore_pfv_get_keyframesSize(int32 index, int32 * keyFrameSize, uint32 * last_seg_duration, uint32 * flv_file_length);
	
	
//int32 emscore_pfv_get_keyframesInfos(int32 index, uint64 * pIframesPos, uint64 * pIframesPTS);
int32 emscore_pfv_get_keyframesInfos(int32 index, uint32 * pIframesPos, uint32 * pIframesPTS);
	
int32 emscore_pfv_get_frameNum(int32 index, uint32 * frameNum);
	
int32 emscore_pfv_get_framesCtsInfos(int32 index, uint16 * pframeCts, uint32 * pIframesIndex);
	
	
	
/*
 * Description: Use to quit readdata function immediately. 
 * param:       Datatype     Param name      In/Out     Comment
 *              int32        index           In         task index 
 *
 * return:      int32
 *              return  0    if success; 
 *                     -1     if failed.
 */
int32 emscore_drop_read(int32 index);


/*
 * Description: Get information for a task.
 * param:       Datatype         Param name      In/Out     Comment
 *              int32            index           In         task index 
 *              ems_task_info*   info            Out        task info [memory should alloced by caller]
 *
 * return:      int32 
 *              return  0    if success; 
 *                     -1    if failed.
 */
int32 emscore_get_task_status(int32 index, ems_task_info *info);

/*
 * Description: Get error string. This API is used when ems_start_task returns -8.
 * param:       Datatype         Param name      In/Out     Comment
 *              none
 *
 * return:      const char*
 *              return  error string if there is error; 
 *                      empty string if everything is OK
 *                      NULL if failed
 */
const char *emscore_get_err_string(void);

int32 emscore_network_act(int32 is_start);

#ifdef __cplusplus
}
#endif

#endif /* ifndef EMS_H */

