import { watch } from 'vue';
import { defineStore, storeToRefs } from 'pinia';
import { myFriends } from '@/store/index'
import { getMsgs } from "@/request/api.js"
import notificationSound from '@/assets/notification.mp3';

const wsurl = import.meta.env.VITE_WS_URL;
const myUid = localStorage.getItem('uid')
// 好友列表相关store
const friendStore = myFriends()
const useFriendStore = storeToRefs(friendStore)


export const useWsStore = defineStore('ws', {
    state: () => ({
        ws: null,
        gid: 0, // 当前消息列表页面应展示的群 id ,搭配 histories 控制 curHistory
        curHistory: [],
        histories: JSON.parse(localStorage.getItem('histories')) || {}
    }),
    getters: {
        getHistory() {
            return this.histories;
        }
    },
    actions: {
        async getMessages(gid, uid) {
            try {
                const response = await getMsgs({ groupId: gid, uid: uid })
                console.log(response)
                return response
            } catch (e) {
                console.log(e)
            }
        },

        setCurGid(gid) {
            this.gid = gid
            // this.curHistory = this.getMessages(gid, myUid)
            this.curHistory = this.histories[this.gid] || []
        },

        watchHistory() {
            // 在 store 初始化时设置 watch
            watch(this.getHistory, (newVal, oldVal) => {
                localStorage.setItem('histories', JSON.stringify(newVal));
            }, { deep: true });
        },
        setCurHistory(newCurHistory) {
            this.curHistory = newCurHistory
        },
        pushCurHistory(newMsg) {
            // 参数: {sender, gid, content ,time,isSelf...}
            this.curHistory.push(newMsg)
            this.histories[this.gid] = this.curHistory
        },
        spliceCurHistory(index) {
            this.curHistory.splice(index, 1)
            this.histories[this.gid] = this.curHistory
        },
        setHistories(newHistories) {
            this.histories = newHistories;
            localStorage.setItem('histories', JSON.stringify(newHistories));
        },
        async wsConnect(uid) {
            return new Promise((resolve, reject) => {
                this.ws = new WebSocket(`${wsurl}/ws/${uid}`);
                const audio = new Audio(notificationSound);
                audio.volume = 0;
                audio.play().then(() => {// 静音播放
                    audio.volume = 1; // 恢复音量
                }).catch((e) => {
                    console.log(e);
                });

                this.ws.onopen = () => {
                    console.log('ws连接成功');
                    this.startHeartBeat(); // 启动心跳
                    resolve();
                };
                this.ws.onclose = () => {
                    console.log('ws连接关闭');
                    this.ws = new WebSocket(`${wsurl}/ws/${uid}`);
                };
                this.ws.onerror = (error) => {
                    console.log('链接错误!');
                    reject(error); // 如果发生错误，则拒绝Promise
                };
                this.ws.onmessage = (e) => {
                    let newMsg;
                    try {
                        newMsg = JSON.parse(e.data);
                    } catch {
                        newMsg = e.data; //撤回消息是字符串
                    }

                    if (typeof newMsg == "string") {
                        console.log(newMsg)
                        if (newMsg == "refresh") {
                            location.reload();
                        }
                        return
                    }
                    //私聊
                    if (newMsg.groupId == myUid) {
                        // 给 newMsg 设置 发送者 昵称和头像
                        // {"group_id":"?","uid":"?","content":"?","send_at":"?"}
                        let sender = useFriendStore.friends.value.find(item => item.uid == newMsg.uid);
                        newMsg.isSelf = false;
                        newMsg.nickname = sender.nickname; // 发送者的昵称
                        newMsg.avatar = sender.avatar;
                        if (this.histories[sender.uid]) {
                            this.histories[sender.uid].push(newMsg);
                        } else {
                            this.histories[sender.uid] = [newMsg]; // 未聊过天的好友
                        }
                    } else {
                        //群聊逻辑
                        newMsg.isSelf = false;
                        newMsg.nickname = newMsg.nickname[0]; // 发送者的昵称
                        newMsg.avatar = newMsg.avatar[0];
                        if (this.histories[newMsg.groupId]) {
                            this.histories[newMsg.groupId].push(newMsg);
                        } else {
                            this.histories[newMsg.groupId] = [newMsg]; // 未聊过天的好友
                        }
                    }
                    audio.play().catch((e) => { console.log(e) });
                };
            });
        },
        startHeartBeat() {
            this.heartBeatTimer = setInterval(() => {
                if (this.ws.readyState === WebSocket.OPEN) {
                    this.ws.send(`ping-${myUid}`); // 发送ping消息
                } else {
                    console.log('WebSocket disconnected. Attempting to reconnect...');
                    this.reconnectWebSocket();
                }
            }, 20000); // 每20秒发送一次心跳
        },
        stopHeartBeat() {
            if (this.heartBeatTimer) {
                clearInterval(this.heartBeatTimer);
                this.heartBeatTimer = null;
            }
        },

        reconnectWebSocket() {
            this.stopHeartBeat(); // 停止心跳
            if (this.ws) {
                this.ws.close();
            }
            this.wsConnect(myUid); // 重新连接WebSocket
        },
        wsSend(data) {
            if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
                this.wsConnect(data.uid).then(() => {
                    this.ws.send(typeof data === "string" ? data : JSON.stringify(data));
                }).catch(error => {
                    console.error('WebSocket连接失败:', error);
                });
            } else {
                this.ws.send(typeof data === "string" ? data : JSON.stringify(data));
            }
            // if (!this.histories[data.group_id]){
            //     this.histories[data.group_id] = [data];
            // }else{
            //     this.histories[data.group_id].push(data);
            // }
        },

        disconnectWs() {
            this.stopHeartBeat();
            if (this.ws) {
                this.ws.close();
                this.ws = null;
            }
        },
    },
});

