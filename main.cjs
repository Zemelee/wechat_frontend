const { app, BrowserWindow, Menu } = require('electron')
const path = require('path')

function createWindow() {
    const win = new BrowserWindow({
        width: 800,
        height: 600,
        webPreferences: {
            nodeIntegration: false,  // 确保渲染进程没有 Node.js API 访问权限（默认）
            contextIsolation: true, // 保持上下文隔离，保证 Web 内容与 Electron API 隔离
        }
    })
    icon: path.join(__dirname, 'assets', './src/assets/vue.svg')
    // 开发模式下加载本地开发服务器
    win.loadURL('http://localhost:5173')
    Menu.setApplicationMenu(null)
}

app.whenReady().then(() => {
    createWindow()

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createWindow()
        }
    })
})

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit()
    }
})
