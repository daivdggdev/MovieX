#ifndef EMS_SERVER_H
#define EMS_SERVER_H

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus
    
    //Common Interface
    int start_ems_server(const char *manufacturer,
                         const char *model_number,
                         const char *unique_id,
                         int port);
    
    int stop_ems_server();
    
    int restart_ems_server();
    
    int stop_ems_task(const char * emsurl);
    //:~
    
    //For Srt Subtitle
    int init_srt_url(char *srt_url);
    
    int add_srt_url(const char * srt_url);
    
    /*正数 往前调整, 负数往后调整*/
    int adjust_vtt_time(int msec);
    
    /*1-100 percent, adjust for position*/
    int adjust_vtt_pos(int percent);
    
    //For VOD, online playing
    int add_ems_url(const char * emsurl, const char * user_id);
	
    //For Download, call to start
    int start_ems_download(const char * emsurl, const char * dir_to_save, const char * user_id);
    
    //For Live playing
    int add_ems_live_url(const char * emsurl);
    
    /*
     *  According to request url, to set different mode
     *  http://localhost:8080/fake_vod_url.pfv.m3u8
     *
     *  http://localhost:8080/fake_pb_url.pfv.m3u8
     *
     *  http://localhost:8080/fake_live_url.pfv.m3u8
     *
     */
    
    //For Playback url
    //int playback_ems_url(const char * file_fid, const char *file_dir);
    //add is_unfinished: 0, finished download pfv file(as default); 1, unfinished download pfv file
    int playback_ems_url(const char * file_fid, const char *file_dir, int is_unfinished);
    
    int is_can_pfv2ts(char *file_path);
    
    //For set ems p2p library post udp request, is_start = 0, don't post udp request;
    //	is_start = 1, post udp request. Default is_start = 1.
    int set_ems_network(int is_start);
    
    int set_ems_seekflag();
    
    int set_buffer_done_flag();
    
    int set_preseek_position(int64_t time, int64_t * offset);
    
    /*
     * Get ems local server running stauts
     *
     * typedef enum server_status_type_
     {
     STATUS_NULL = 0,
     STATUS_REQ_M3U8,
     STATUS_REQ_TS,
     STATUS_GEN_M3U8,
     STATUS_GEN_TS,
     STATUS_SEND_M3U8,
     STATUS_SEND_TS,
     STATUS_END,
     } server_status_type;
     * */
    int get_ems_server_status(int * status);
    
#ifdef __cplusplus
}
#endif // __cplusplus

#endif //EMS_SERVER_H

