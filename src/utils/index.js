export const formatTime = (timestamp) => {
    const now = new Date();
    const date = new Date(timestamp);
    const diffInMs = now - date; // 时间差，单位为毫秒

    const diffInHours = diffInMs / (1000 * 60 * 60);
    const diffInDays = diffInHours / 24;

    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');

    if (diffInHours < 24) {
        return `${hours}:${minutes}`;
    } else if (diffInHours < 48) {
        return '昨天';
    } else if (diffInDays < 7) {
        const daysOfWeek = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
        return daysOfWeek[date.getDay()];
    } else {
        const year = date.getFullYear();
        const month = (date.getMonth() + 1).toString().padStart(2, '0');
        const day = date.getDate().toString().padStart(2, '0');
        return `${year}-${month}-${day}`;
    }
};

//修改local storage
export const pushStorage = (key, value) => {
    let prev = JSON.parse(localStorage.getItem(key)) || []
    let newValue = [...prev, value]
    return localStorage.setItem(key, newValue)
}


// 防抖函数
export const debounce = (func, wait) => {
    let timeout;
    return function (...args) {
        const context = this;
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(context, args), wait);
    };
};