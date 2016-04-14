/**
 * Created by Ruben on 27-03-2016.
 */
function NetEvent () {}
NetEvent.SOCKET_OPEN = "socket_open";
NetEvent.SOCKET_CLOSE = "socket_close";
NetEvent.LOGIN = "login";

function Net (url) {
    this.url = url;
    this.socketEvent = {};

    this.addListener = function (event,handler) {
        if (this.socketEvent.hasOwnProperty(event)) {
            var listeners = this.socketEvent[event];
            var index = listeners.indexOf(handler);
            if (index === -1) listeners.push(handler);
        } else {
            this.socketEvent[event] = [handler];
        }
        return this.socketEvent[event].length;
    };
    this.removeListener = function (event,handler) {
        if (this.socketEvent.hasOwnProperty(event)) {
            if (handler==null) {
                delete this.socketEvent[event];
            } else {
                var listeners = this.socketEvent[event];
                var index = listeners.indexOf(handler);
                if (index !== -1) listeners.splice(index,1);
            }
            var _listeners = this.socketEvent[event];
            if (_listeners.length===0)
                delete this.socketEvent[event];
        }
    };
    this.removeListeners = function (event) {
        if (this.socketEvent.hasOwnProperty(event)) {
            delete this.socketEvent[event];
            return true;
        }
        return false;
    };
    this.dispatchListener = function (event,data) {
        if (this.socketEvent.hasOwnProperty(event)) {
            var listeners = this.socketEvent[event];
            for (var i = 0; i < listeners.length; i++) {
                listeners[i].call(this,event,data);
            }
            return i;
        }
        return 0;
    };

    this.connect = function () {
        this.socket = new WebSocket(this.url);
        var m = this;
        this.socket.onopen = function () {
            m.dispatchListener(NetEvent.SOCKET_OPEN)
        };
        this.socket.onmessage = function (message) {
            var o = JSON.parse(message.data.replace(/[\u0000\u00ff]/g, ''));
            m.dispatchListener(o.command,o.data)
        };
        this.socket.onclose = function () {
            m.dispatchListener(NetEvent.SOCKET_CLOSE,false);
        };
    };
    this.close = function () {
        this.dispatchListener(NetEvent.SOCKET_CLOSE,true);
        this.socket.close();
        this.socketEvent = {}
    };
    this.sendMessage = function (command,data) {
        if(this.socket != null) {
            var message = {
                command: command,
                data: data
            };
            this.socket.send(JSON.stringify(message));
        }
    }
}