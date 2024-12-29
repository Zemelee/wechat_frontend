import service from './index';

// 发送验证码
export function getCode(email) {
    return service({
        method: 'post',
        url: `/code/send/${email}`,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}

//检查验证码
export function checkCode(email, code) {
    return service({
        method: 'post',
        url: '/code/check',
        data: {
            email: email,
            code: code
        },
        headers: {
            'Content-Type': 'application/json',
        },
    })
}

export function userRegister(user) {
    return service({
        method: 'post',
        url: '/user/register',
        data: user,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}

export function userLogin(user) {
    return service({
        method: 'post',
        url: '/user/login',
        data: user,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}

export function searchFriend(keyword) {
    // 判断keyword是否为邮箱格式
    let type = "email"
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(keyword)) {
        type = "nickname"
    }
    return service({
        method: 'get',
        url: `/user/search`,
        params: {
            type: type,
            keyword: keyword
        },
        headers: {
            'Content-Type': 'application/json',
        },
    })
}

// 添加好友
export function addFriend(request_id, receive_id) {
    return service({
        method: 'get',
        url: `/friend/add/${request_id}/${receive_id}`,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}

// 添加好友
export function delFriend(request_id, receive_id) {
    return service({
        method: 'get',
        url: `/friend/del/${request_id}/${receive_id}`,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}

// 好友列表
export function getFriendList(request_id) {
    return service({
        method: 'get',
        url: `/friend/list/${request_id}`,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}


export function getGroupList(uid) {
    return service({
        method: 'get',
        url: '/group/list/' + uid,
    })
}

// 创建多人群聊
export function addGroup(groupParams) {
    return service({
        method: 'post',
        url: '/group/add',
        data: groupParams,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}

//邀请加入群聊
export function joinGroup(gid, uids) {
    return service({
        method: 'post',
        url: `/group/join/${gid}`,
        data: uids,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}


//踢人
export function delGroupUser(gid, uids) {
    return service({
        method: 'post',
        url: `/group/del_user/${gid}`,
        data: uids,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}
//解散群聊
export function delGroup(gid) {
    return service({
        method: 'get',
        url: `/group/disband/${gid}`,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}


export function translate(origin) {
    return service({
        method: 'get',
        url: `/translate?origin=${origin}`,
        headers: {
            'Content-Type': 'application/json',
        },
    })
}
// {groupId,uid}
export function getMsgs(body) {
    return service({
        method: 'post',
        data: body,
        url: `/messages/user`,
    })
}


export function updateInfo(user) {
    return service({
        method: 'post',
        url: '/user/update',
        data: user,
        headers: {
            'Content-Type': 'application/json',
        },

    })
}