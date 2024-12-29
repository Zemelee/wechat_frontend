import axios from "axios";

const service = axios.create({
    baseURL: import.meta.env.VITE_BASE_URL,
    timeout: 5000,
    withCredentials: true
});

service.interceptors.request.use(
    (config) => {
        //链接加上?apifoxToken=3kePlDAnGzZ2IXIIRwEKD后缀
        // config.url = config.url + '?apifoxToken=3kePlDAnGzZ2IXIIRwEKD';
        return config;
    },
    error => Promise.reject(error)
);


service.interceptors.response.use(
    response => response.data,
    error => Promise.reject(error)
);

export default service;
