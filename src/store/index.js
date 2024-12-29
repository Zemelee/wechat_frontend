import { defineStore } from 'pinia';

export const useUser = defineStore('user', {
    state: () => ({
        searchWord: "",
        curNickname: "",
        userInfo: {
            uid: 0,
            email: "admin@163.com",
            password: "",
            nickname: "111",
            avatar: "",
            createAt: "",
            sign: "undefiend",
            address: "unknown"
        }

    }),
    actions: {
        setUserInfo(user) {
            this.userInfo = user
            localStorage.setItem("userinfo", JSON.stringify(user))
        },
        setSearchWord(sw) {
            this.searchWord = sw
        },
        setCurNickname(nickname) {
            this.curNickname = nickname
        }

    }
});


export const myFriends = defineStore('friend', {
    state: () => ({
        friends: [],
    }),
    actions: {
        setFriends(list) {
            this.friends = list
            localStorage.setItem("friendList", JSON.stringify(list))
        },
        pushFriend(friend) {
            let temp = JSON.parse(localStorage.getItem("friendList"))
            temp.push(friend)
            this.friends.push(friend)
            localStorage.setItem("friendList", JSON.stringify(temp))
        },
        delFriend(friend) {
            let temp = JSON.parse(localStorage.getItem("friendList"))
            temp.splice(temp.indexOf(friend), 1)
            this.friends.splice(this.friends.indexOf(friend), 1)
            localStorage.setItem("friendList", temp)
            // 从聊天记录中剔除
            let chatList = JSON.parse(localStorage.getItem("chatList"))
            chatList = chatList.filter(item => item.uid != friend.uid)
            localStorage.setItem("chatList", JSON.stringify(chatList))
        }
    }
});