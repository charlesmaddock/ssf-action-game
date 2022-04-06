import { WebSocket, WebSocketServer } from "ws";
import isValidUTF8 from "utf-8-validate";
import { IncomingMessage } from "http";

const port = 9001;
const wss = new WebSocketServer({ port: port });

enum PacketTypes {
  CONNECTED,
  HOST_ROOM,
  ROOM_HOSTED,
  JOIN_ROOM,
  ROOM_JOINED,
  START_GAME,
  GAME_STARTED,
  SET_INPUT,
  SET_PLAYER_POS,
  FREE_NODE,
  NODE_FREED,
}

type PacketType = PacketTypes;

interface Room {
  code: string;
  hostId: string;
  clients: Array<Client>;
}

interface Client {
  id: string;
  name: string;
  socket: WebSocket;
}

let rooms: Array<Room> = [];
let clients: Array<Client> = [];

console.log(`Running on ws://127.0.0.1:${port}`);

const clientHasNotConnected = (id: string): boolean => {
  return clients.filter((c) => c.id == id).length == 0;
};

const getClientsRoom = (c: Client): Room => {
  for (let i = 0; i < rooms.length; i++) {
    const room = rooms[i];
    if (room.clients.includes(c)) {
      return room;
    }
  }
  return null;
};

const getRoomsClient = (room: Room): Client => {
  return room.clients.filter((c) => c.id == room.hostId)[0];
};

const getRoomWithCode = (code: string): Room => {
  return rooms.filter((r) => r.code == code)[0];
};

const getClientFromWs = (socket: WebSocket): Client => {
  for (let i = 0; i < clients.length; i++) {
    if (clients[i].socket === socket) return clients[i];
  }
  return null;
};

wss.on("connection", (ws: WebSocket, req: IncomingMessage) => {
  console.log("ws connection from IP: ", req.socket.remoteAddress);

  ws.on("message", (buff: Buffer) => {
    if (isValidUTF8(buff)) {
      let data = JSON.parse(buff.toString());
      let type: PacketType = data.type;

      if (type !== undefined) {
        switch (type) {
          case PacketTypes.CONNECTED:
            handleConnected(ws);
            break;
          case PacketTypes.HOST_ROOM:
            handleHostRoom(ws, getClientFromWs(ws));
            break;
          case PacketTypes.JOIN_ROOM:
            handleJoinRoom(ws, data);
            break;
          case PacketTypes.START_GAME:
            handleStartGame(ws);
            break;
          case PacketTypes.SET_INPUT:
            handleSetInput(ws, data);
            break;
          case PacketTypes.SET_PLAYER_POS:
            handleSetPos(ws, data);
            break;
          case PacketTypes.FREE_NODE:
            handleFreeNode(ws, data);
            break;
          default:
            console.error("Unhandled packet type.");
        }
      } else {
        console.error("Undefined packet type.");
      }
    }
  });

  ws.on("close", (code, reason) => {
    let client: Client = getClientFromWs(ws);
    if (client !== null) {
      var removeAt = clients.indexOf(client);
      clients.splice(removeAt, 1);
      var room;
      console.log(
        `player ${client.id} disconnected. Clients.length: ${clients.length}`
      );
    } else {
      console.warn("Couldn't find disconnecting client.");
    }
  });
});

const handleConnected = (ws: WebSocket) => {
  let id: string = Math.random().toString(16).slice(2);
  let names = ["Charles", "Sigge", "Isac"];
  let name = names[Math.floor(Math.random())];
  let newClient: Client = {
    id: id,
    name: name + Math.floor(Math.random() * 100),
    socket: ws,
  };

  console.log(`New player, id: ${id}`);

  clients.push(newClient);

  let payload = {
    type: PacketTypes.CONNECTED,
    id: id,
  };
  ws.send(JSON.stringify(payload));
};

const handleHostRoom = (ws: WebSocket, client: Client) => {
  if (client !== null) {
    let time = new Date().getTime();
    let code = time
      .toString(16)
      .slice(String(time).length - 5, String(time).length);

    let newRoom: Room = {
      code: code,
      hostId: client.id,
      clients: [client],
    };
    rooms.push(newRoom);

    ws.send(JSON.stringify({ type: PacketTypes.ROOM_HOSTED }));
    sendJoined(ws, newRoom);
  } else {
    console.error("Client that wants to host a room was null.");
  }
};

const handleJoinRoom = (
  ws: WebSocket,
  packet: { type: number; code: string }
) => {
  let room = getRoomWithCode(packet.code);
  let joiningClient = getClientFromWs(ws);
  if (room !== undefined && joiningClient !== null) {
    room.clients.push(joiningClient);
    room.clients.forEach((client) => {
      sendJoined(client.socket, room);
    });
  }
};

const handleStartGame = (ws: WebSocket) => {
  let startingClient = getClientFromWs(ws);
  if (startingClient !== null) {
    rooms.forEach((room: Room) => {
      if (room.hostId === startingClient.id) {
        let payload = {
          type: PacketTypes.GAME_STARTED,
          players: room.clients.map((c) => ({
            id: c.id,
            pos: { x: -164, y: 351 },
          })),
        };
        broadcastToRoom(room, payload);
      }
    });
  }
};

const handleSetInput = (
  ws: WebSocket,
  packet: { type: number; x: number; y: number }
) => {
  let client = getClientFromWs(ws);
  let room: Room = getClientsRoom(client);
  let hostClient = getRoomsClient(room);
  if (hostClient != undefined) {
    let payload = {
      ...packet,
      id: client.id,
    };
    hostClient.socket.send(JSON.stringify(payload));
  }
};

const handleSetPos = (
  ws: WebSocket,
  packet: { type: number; id: string; x: number; y: number }
) => {
  let client = getClientFromWs(ws);
  let room: Room = getClientsRoom(client);

  broadcastToRoom(room, packet);
};

const handleFreeNode = (
  ws: WebSocket,
  packet: { type: number; id: string }
) => {
  let client = getClientFromWs(ws);
  let room: Room = getClientsRoom(client);

  let payload = {
    type: PacketTypes.NODE_FREED,
    id: packet.id,
  };

  broadcastToRoom(room, payload);
};

const broadcastToRoom = (
  room: Room,
  payload: object,
  excludeId: string = ""
) => {
  room.clients.forEach((client) => {
    if (client.id !== excludeId) {
      client.socket.send(JSON.stringify(payload));
    }
  });
};

const sendJoined = (ws: WebSocket, room: Room) => {
  let payload = {
    type: PacketTypes.ROOM_JOINED,
    client_info: room.clients.map((c) => ({
      id: c.id,
      name: c.name,
      className: "Bob",
    })),
    code: room.code,
  };
  ws.send(JSON.stringify(payload));
};
