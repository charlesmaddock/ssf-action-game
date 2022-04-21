"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const ws_1 = require("ws");
const utf_8_validate_1 = __importDefault(require("utf-8-validate"));
const port = 9001;
const wss = new ws_1.WebSocketServer({ port: port });
var PacketTypes;
(function (PacketTypes) {
    PacketTypes[PacketTypes["SERVER_MESSAGE"] = 0] = "SERVER_MESSAGE";
    PacketTypes[PacketTypes["CONNECTED"] = 1] = "CONNECTED";
    PacketTypes[PacketTypes["UPDATE_CLIENT_DATA"] = 2] = "UPDATE_CLIENT_DATA";
    PacketTypes[PacketTypes["HOST_ROOM"] = 3] = "HOST_ROOM";
    PacketTypes[PacketTypes["ROOM_HOSTED"] = 4] = "ROOM_HOSTED";
    PacketTypes[PacketTypes["JOIN_ROOM"] = 5] = "JOIN_ROOM";
    PacketTypes[PacketTypes["ROOM_JOINED"] = 6] = "ROOM_JOINED";
    PacketTypes[PacketTypes["LEAVE_ROOM"] = 7] = "LEAVE_ROOM";
    PacketTypes[PacketTypes["ROOM_LEFT"] = 8] = "ROOM_LEFT";
    PacketTypes[PacketTypes["START_GAME"] = 9] = "START_GAME";
    PacketTypes[PacketTypes["GAME_STARTED"] = 10] = "GAME_STARTED";
    PacketTypes[PacketTypes["SET_INPUT"] = 11] = "SET_INPUT";
    PacketTypes[PacketTypes["SET_PLAYER_POS"] = 12] = "SET_PLAYER_POS";
    PacketTypes[PacketTypes["FREE_NODE"] = 13] = "FREE_NODE";
    PacketTypes[PacketTypes["NODE_FREED"] = 14] = "NODE_FREED";
    PacketTypes[PacketTypes["USE_ABILITY"] = 15] = "USE_ABILITY";
    PacketTypes[PacketTypes["ABILITY_USED"] = 16] = "ABILITY_USED";
    PacketTypes[PacketTypes["SET_HEALTH"] = 17] = "SET_HEALTH";
    PacketTypes[PacketTypes["SHOOT_PROJECTILE"] = 18] = "SHOOT_PROJECTILE";
    PacketTypes[PacketTypes["START_DOORS"] = 19] = "START_DOORS";
})(PacketTypes || (PacketTypes = {}));
let rooms = [];
let clients = [];
console.log(`Running on ws://127.0.0.1:${port}`);
const clientHasNotConnected = (id) => {
    return clients.filter((c) => c.id == id).length == 0;
};
const getClientsRoom = (c) => {
    for (let i = 0; i < rooms.length; i++) {
        const room = rooms[i];
        if (room.clients.includes(c)) {
            return room;
        }
    }
    return null;
};
const getRoomsClient = (room) => {
    if (room !== null) {
        for (let i = 0; i < room.clients.length; i++) {
            if (room.clients[i].id == room.hostId)
                return room.clients[i];
        }
        return null;
    }
    return null;
};
const getRoomWithCode = (code) => {
    for (let i = 0; i < rooms.length; i++) {
        if (rooms[i].code == code)
            return rooms[i];
    }
    return null;
};
const getClientFromWs = (socket) => {
    for (let i = 0; i < clients.length; i++) {
        if (clients[i].socket === socket)
            return clients[i];
    }
    return null;
};
wss.on("connection", (ws, req) => {
    console.log("ws connection from IP: ", req.socket.remoteAddress);
    ws.on("message", (buff) => {
        if ((0, utf_8_validate_1.default)(buff)) {
            let data = JSON.parse(buff.toString());
            let type = data.type;
            if (type !== undefined) {
                switch (type) {
                    case PacketTypes.CONNECTED:
                        handleConnected(ws);
                        break;
                    case PacketTypes.UPDATE_CLIENT_DATA:
                        handleUpdateClientData(ws, data);
                        break;
                    case PacketTypes.HOST_ROOM:
                        handleHostRoom(ws, getClientFromWs(ws));
                        break;
                    case PacketTypes.JOIN_ROOM:
                        handleJoinRoom(ws, data);
                        break;
                    case PacketTypes.LEAVE_ROOM:
                        handleLeaveRoom(ws);
                        break;
                    case PacketTypes.START_GAME:
                        handleStartGame(ws);
                        break;
                    case PacketTypes.SET_INPUT:
                        handleSetInput(ws, data);
                        break;
                    case PacketTypes.USE_ABILITY:
                        handleUseAbility(ws, data.key);
                        break;
                    case PacketTypes.SET_PLAYER_POS:
                        handleSetPos(ws, data);
                        break;
                    case PacketTypes.FREE_NODE:
                        handleFreeNode(ws, data);
                        break;
                    case PacketTypes.SET_HEALTH:
                        handleSetHealth(ws, data);
                        break;
                    case PacketTypes.SHOOT_PROJECTILE:
                        handleShootProjectile(ws, data);
                        break;
                    default:
                        console.error("Unhandled packet type.");
                }
            }
            else {
                console.error("Undefined packet type.");
            }
        }
    });
    ws.on("close", (code, reason) => {
        let client = getClientFromWs(ws);
        if (client !== null) {
            let clientsRoom = getClientsRoom(client);
            if (clientsRoom !== null) {
                handleLeaveRoom(client.socket);
            }
            var removeAt = clients.indexOf(client);
            clients.splice(removeAt, 1);
            console.log(`player ${client.id} disconnected. Clients.length: ${clients.length}`);
        }
        else {
            console.warn("Couldn't find disconnecting client.");
        }
    });
});
const handleConnected = (ws) => {
    let id = Math.random().toString(16).slice(2);
    let names = ["Charles", "Sigge", "Isac", "Johan", "Paul"];
    let name = names[Math.floor(Math.random() * names.length)];
    let newClient = {
        id: id,
        name: name + Math.floor(Math.random() * 100),
        socket: ws,
        class: "Sam the Sniper",
    };
    console.log(`New player, id: ${id}`);
    clients.push(newClient);
    let payload = {
        type: PacketTypes.CONNECTED,
        clientData: {
            id: newClient.id,
            class: newClient.class,
            name: newClient.name,
        },
    };
    ws.send(JSON.stringify(payload));
};
const handleUpdateClientData = (ws, packet) => {
    let client = getClientFromWs(ws);
    let room = getClientsRoom(client);
    client.class = packet.clientData.class;
    client.name = packet.clientData.name;
    broadcastToRoom(room, packet);
};
const handleHostRoom = (ws, client) => {
    if (client !== null) {
        let time = new Date().getTime();
        let code = time
            .toString(16)
            .slice(String(time).length - 5, String(time).length);
        let newRoom = {
            code: code,
            hostId: client.id,
            clients: [client],
        };
        rooms.push(newRoom);
        ws.send(JSON.stringify({ type: PacketTypes.ROOM_HOSTED }));
        sendJoined(ws, newRoom);
    }
    else {
        console.error("Client that wants to host a room was null.");
    }
};
const handleJoinRoom = (ws, packet) => {
    let room = null;
    if (packet.code === "random") {
        if (rooms.length > 0) {
            room = rooms[0];
        }
        else {
            sendError(ws, "No rooms available, host one yourself!");
        }
    }
    else {
        room = getRoomWithCode(packet.code);
        if (room === null)
            sendError(ws, "Invalid code.");
    }
    if (room !== null) {
        let joiningClient = getClientFromWs(ws);
        if (joiningClient !== null) {
            room.clients.push(joiningClient);
            room.clients.forEach((client) => {
                sendJoined(client.socket, room);
                // For speeding up development
                if (packet.code === "random") {
                    handleStartGame(client.socket);
                }
            });
        }
    }
};
const handleLeaveRoom = (ws) => {
    let leavingClient = getClientFromWs(ws);
    if (leavingClient !== null) {
        let clientsRoom = getClientsRoom(leavingClient);
        if (clientsRoom !== null) {
            console.log("Client with id ", leavingClient.id, " left the room ", clientsRoom.code);
            // Remove room if we are the host
            if (clientsRoom.hostId == leavingClient.id) {
                broadcastError(clientsRoom, "Host disconnected, room closed.", true);
                for (let i = clientsRoom.clients.length - 1; i >= 0; i--) {
                    leaveRoom(clientsRoom, clientsRoom.clients[i]);
                }
                var removeAt = rooms.indexOf(clientsRoom);
                rooms.splice(removeAt, 1);
                console.log(`Room ${clientsRoom.code} was removed. Rooms length: ${rooms.length}`);
            }
            else {
                leaveRoom(clientsRoom, leavingClient);
            }
        }
    }
};
const leaveRoom = (room, client) => {
    let payload = {
        type: PacketTypes.ROOM_LEFT,
        id: client.id,
    };
    broadcastToRoom(room, payload);
    var removeAt = clients.indexOf(client);
    if (removeAt !== -1) {
        room.clients.splice(removeAt, 1);
    }
};
const handleStartGame = (ws) => {
    let startingClient = getClientFromWs(ws);
    if (startingClient !== null) {
        let playerSpawnPoints = [
            {
                x: 266 + (Math.random() - 0.5 * 2),
                y: 410 + (Math.random() - 0.5 * 2),
            },
            {
                x: 974 + (Math.random() - 0.5 * 2),
                y: -27 + (Math.random() - 0.5 * 2),
            },
            {
                x: -437 + (Math.random() - 0.5 * 2),
                y: 146 + (Math.random() - 0.5 * 2),
            },
        ];
        let spawnPosPlayer = playerSpawnPoints[Math.floor(Math.random() * playerSpawnPoints.length)];
        rooms.forEach((room) => {
            if (room.hostId === startingClient.id) {
                let spawnPosScammer = {
                    x: 128 + (Math.random() - 0.5 * 4),
                    y: -265 + (Math.random() - 0.5 * 4),
                };
                let payload = {
                    type: PacketTypes.GAME_STARTED,
                    players: room.clients.map((c) => ({
                        id: c.id,
                        name: c.name,
                        class: c.class,
                        pos: c.class == "Romance Scammer" ? spawnPosScammer : spawnPosPlayer,
                    })),
                };
                broadcastToRoom(room, payload);
                // Sync doors for all clients, temporary
                setTimeout(() => {
                    let doorPayload = {
                        type: PacketTypes.START_DOORS,
                    };
                    broadcastToRoom(room, doorPayload);
                }, 3000);
            }
        });
    }
};
const handleSetInput = (ws, packet) => {
    let client = getClientFromWs(ws);
    let room = getClientsRoom(client);
    let hostClient = getRoomsClient(room);
    if (hostClient !== null) {
        let payload = Object.assign(Object.assign({}, packet), { id: client.id });
        hostClient.socket.send(JSON.stringify(payload));
    }
};
const handleUseAbility = (ws, key) => {
    let client = getClientFromWs(ws);
    let room = getClientsRoom(client);
    let payload = {
        type: PacketTypes.ABILITY_USED,
        key: key,
        id: client.id,
    };
    broadcastToRoom(room, payload);
};
const handleSetPos = (ws, packet) => {
    let client = getClientFromWs(ws);
    let room = getClientsRoom(client);
    broadcastToRoom(room, packet);
};
const handleFreeNode = (ws, packet) => {
    let client = getClientFromWs(ws);
    let room = getClientsRoom(client);
    let payload = {
        type: PacketTypes.NODE_FREED,
        id: packet.id,
    };
    broadcastToRoom(room, payload);
};
const handleSetHealth = (ws, packet) => {
    let client = getClientFromWs(ws);
    let room = getClientsRoom(client);
    broadcastToRoom(room, packet);
};
const handleShootProjectile = (ws, packet) => {
    let client = getClientFromWs(ws);
    let room = getClientsRoom(client);
    broadcastToRoom(room, packet);
};
const broadcastToRoom = (room, payload, excludeId = "") => {
    if (room !== null) {
        room.clients.forEach((client) => {
            if (client.id !== excludeId) {
                client.socket.send(JSON.stringify(payload));
            }
        });
    }
};
const sendJoined = (ws, room) => {
    let payload = {
        type: PacketTypes.ROOM_JOINED,
        clientData: room.clients.map((c) => ({
            id: c.id,
            name: c.name,
            class: c.class,
        })),
        code: room.code,
    };
    ws.send(JSON.stringify(payload));
};
const broadcastError = (room, text, excludeHost) => {
    let payload = {
        type: PacketTypes.SERVER_MESSAGE,
        msgType: "error",
        text: text,
    };
    broadcastToRoom(room, payload, excludeHost ? room.hostId : "");
};
const sendError = (ws, text) => {
    let payload = {
        type: PacketTypes.SERVER_MESSAGE,
        msgType: "error",
        text: text,
    };
    ws.send(JSON.stringify(payload));
};
//# sourceMappingURL=app.js.map