import { defineStore } from 'pinia';
import { onMounted, ref } from 'vue';

export const useChatListStore = defineStore('chatList', {
    state: () => ({
        list: []
    }),

    getters: {
        getChatList() {
            return this.list;
        }
    },
    actions: {
        // 初始化聊天列表
        updateChatList(friendList, histories) {
            let chatList = JSON.parse(localStorage.getItem('chatList')) || [];
            let chatIds = chatList.map(item => item.uid);
            // 在聊天页面的好友信息列表
            let curChatList = friendList.filter(item => chatIds.includes(item.uid));
            curChatList.forEach(outer => {
                outer.lastTime = chatList.find(inner => inner.uid == outer.uid).lastTime;
                if (histories[outer.uid]) {
                    let lastMsg = histories[outer.uid][histories[outer.uid].length - 1];
                    if (lastMsg) {
                        outer.lastMsg = lastMsg.content;
                    }
                }
            });
            curChatList.sort((a, b) => b.lastTime - a.lastTime);
            this.list = curChatList;
        },
        // 持久化存储聊天列表
        persistChatList() {
            localStorage.setItem('chatList', JSON.stringify(this.list));
        }
    }
});
