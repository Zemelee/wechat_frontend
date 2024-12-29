<template>
    <div class="chat-container">
        <div class="msg-list-container" style="border:1px solid #333;">
            <MsgList></MsgList>
        </div>
        <div class="chat-content" v-show="curGid">
            <div class="chat-history" ref="chatHistory">
                <div v-for="item in useWs.curHistory.value" :key="item.id" class="message-bubble">
                    <SingleMsg :message="item.content" :avatar="item.avatar" :nickname="item.nickname"
                        :time="item.send_at" :isSelf="item.isSelf" :hasBack="item.hasBack" @delete="deleteMsg(item)"
                        @back="backMsg(item)" />
                </div>
            </div>
            <div class="chat-input">
                <a-textarea v-model:value="currentMsg" @keyup.enter.prevent="sendMsg" placeholder="输入聊天消息..." :rows="4"
                    class="textarea" />
                <div style="text-align: center;margin-top: 10px;">
                    <a-popover placement="topRight">
                        <template #content>
                            <div class="emoji-items">
                                <span style="margin: 5px; cursor: pointer;" class="emoji" v-for="item in emojis"
                                    :key="item" @click="() => { currentMsg += item }">{{ item
                                    }}</span>
                            </div>
                        </template>
                        <UpSquareTwoTone />
                    </a-popover>
                    <br>
                    <br>
                    <a-button @click="sendMsg" :disabled="currentMsg.length <= 0" type="primary">发送</a-button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { onMounted, onUnmounted, nextTick, ref, watch, computed, toRef, toRaw } from 'vue'
import { UpSquareTwoTone } from '@ant-design/icons-vue';
import SingleMsg from './SingleMsg'
import MsgList from './MsgList'
import { storeToRefs } from 'pinia';
import { getMsgs } from '@/request/api'
import { myFriends, useUser } from '@/store/index'
import { useWsStore } from '@/store/wsStore'
import { useRoute } from 'vue-router';
const router = useRoute()
// 朋友列表
const friendStore = myFriends()
const useFriendStore = storeToRefs(friendStore)
// 个人信息
const userStore = useUser()
const useUserStore = storeToRefs(userStore)
// ws
const wsStore = useWsStore()
const useWs = storeToRefs(wsStore)

const uid = localStorage.getItem('uid')

// history存储格式: {uid: [{mid, sender, gid, content ,time},{}..], uid:[{},{}]]...}
let histories;
let curGid = ref(useWs.gid.value);
watch(() => useWs.gid.value, async () => {
    curGid.value = useWs.gid.value;
    try {
        const GidMsgs = await getMsgs({ uid: Number(uid), groupId: curGid.value });
        GidMsgs.forEach(item => {
            item.isSelf = item.uid == uid;
            item.nickname = item.senderNickname;
            item.avatar = item.senderAvatar;
            item.send_at = item.sendAt;
            item.hasBack = item.back == 1; //等于1表示撤回
        });
        wsStore.setCurHistory(GidMsgs);
    } catch (error) {
        console.error('获取历史记录失败，调用本地记录:', error);
    }
});
onMounted(() => {
    histories = computed(() => wsStore.getHistory);
    wsStore.watchHistory()
    if (!useWs.ws) wsStore.connectWs(uid)
    if (router.params.uid) {
        wsStore.setCurGid(router.params.uid)
    }
})
onUnmounted(() => {
    wsStore.setCurGid(0);
    userStore.setCurNickname("");
})
//全剧组件存在对histories的深度监听，无需手动存储
const deleteMsg = (e) => {
    // 调用接口删除
    const index = histories.value[curGid.value].findIndex(item => item.content == e.content)
    if (index !== -1) {
        wsStore.spliceCurHistory(index)
    }
}
//撤回消息
const backMsg = async (e) => {
    let backMsg1 = toRaw(e)
    let newMsg = {
        back: 1, //撤回字段
        mid: backMsg1.mid,
        groupId: backMsg1.groupId,
        uid: backMsg1.uid,
        content: backMsg1.content,
        send_at: backMsg1.send_at
    };
    try {
        await wsStore.wsSend(newMsg);
        // 更新UI
        const GidMsgs = await getMsgs({ uid: Number(uid), groupId: curGid.value });
        GidMsgs.forEach(item => {
            item.isSelf = item.uid == uid;
            item.nickname = item.senderNickname;
            item.avatar = item.senderAvatar;
            item.send_at = item.sendAt;
            item.hasBack = item.back == 1; //等于1表示撤回
        });
        wsStore.setCurHistory(GidMsgs);
    } catch (error) {
        console.error("消息发送失败:", error);
    }
}

let currentMsg = ref("")
const sendMsg = async (event) => {
    event.preventDefault()
    let newMsg = {
        back: 0,//非撤回字段
        groupId: curGid.value,
        uid: Number(uid),
        content: currentMsg.value,
        send_at: new Date().toISOString()
    };
    try {
        // 等待 wsSend 完成
        await wsStore.wsSend(newMsg);
        // 给 newMsg 设置发送者昵称和头像(我)
        newMsg.nickname = useUserStore.userInfo.value.nickname;
        newMsg.avatar = useUserStore.userInfo.value.avatar;
        newMsg.isSelf = true;
        // 更新当前好友聊天记录
        wsStore.pushCurHistory(newMsg)
        scrollToBottom();// 滚动到底部
        currentMsg.value = "";// 清空输入框
    } catch (error) {
        // 处理发送失败的情况
        console.error("消息发送失败:", error);
    }
}

let chatHistory = ref(null)
const scrollToBottom = async () => {
    if (chatHistory.value) {
        await nextTick(); // 等待 DOM 更新
        chatHistory.value.scrollTop = chatHistory.value.scrollHeight;
    }
};
let emojis = ["🥰", "🥳", "🥺", "🥵", "🥴", "🥶", "🧐", "🤪", "🤫", "🤬",
    "🤭", "🤮", "🤯", "🤨", "🤩", "🤣", "🤤", "🤢", "🤧", "🤠", "🤥", "😳",
    "😊", "😘", "😡", "😭", "😈", "🤡", "👉", "👈", "💩"]
</script>

<style scoped>
.chat-container {
    display: flex;
    height: 100%;
    border: 1px solid black;
}

.msg-list-container {
    width: 20vw;
    border-right: 1px solid #e6e6e6;
}

.chat-content {
    height: 100%;
    flex: 1;
    display: flex;
    flex-direction: column;
}

.chat-history {
    flex: 1;
    padding: 10px;
    overflow-y: auto;
    background-color: #f5f5f5;
}

.message-bubble {
    margin-bottom: 10px;
}

.chat-input {
    display: flex;
    padding: 10px;
    border-top: 1px solid #e6e6e6;
}

.textarea {
    flex: 1;
    margin-right: 10px;
    resize: none;
    border-radius: 4px;
    border: 1px solid #d9d9d9;
}

.chat-history::-webkit-scrollbar {
    width: 8px;
}

.chat-history::-webkit-scrollbar-thumb {
    background-color: #ccc;
    border-radius: 4px;
}

.chat-history::-webkit-scrollbar-thumb:hover {
    background-color: #b3b3b3;
}

.emoji-items {
    /* margin: 3px; */
    width: 300px;
    /* display: inline-block */
}

.emoji :hover {
    cursor: pointer;
    color: #1890ff;
    transition: color0.3s ease;
}
</style>
